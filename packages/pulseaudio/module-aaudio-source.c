/***
  This file is part of PulseAudio.

  Copyright 2026 Tom Yan, ferrumclaudepilgrim

  PulseAudio is free software; you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as published
  by the Free Software Foundation; either version 2.1 of the License,
  or (at your option) any later version.

  PulseAudio is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with PulseAudio; if not, see <http://www.gnu.org/licenses/>.
***/

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <dlfcn.h>
#include <inttypes.h>
#include <limits.h>
#include <stdint.h>
#include <string.h>

#include <pulse/timeval.h>
#include <pulse/util.h>
#include <pulse/xmalloc.h>

#include <pulsecore/atomic.h>
#include <pulsecore/core-util.h>
#include <pulsecore/i18n.h>
#include <pulsecore/log.h>
#include <pulsecore/macro.h>
#include <pulsecore/modargs.h>
#include <pulsecore/module.h>
#include <pulsecore/rtpoll.h>
#include <pulsecore/source.h>
#include <pulsecore/thread.h>
#include <pulsecore/thread-mq.h>

#include <android/api-level.h>
#include <android/versioning.h>
#undef __INTRODUCED_IN
#define __INTRODUCED_IN(api_level)
#include <aaudio/AAudio.h>

PA_MODULE_AUTHOR("Tom Yan, ferrumclaudepilgrim");
PA_MODULE_DESCRIPTION("Android AAudio source");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
    "source_name=<name for the source> "
    "source_properties=<properties for the source> "
    "format=<s16le|float32le> "
    "channels=<1|2> "
    "channel_map=<channel map> "
    "rate=<sampling rate; omit to use the AAudio default> "
    "latency=<requested active buffer size in ms; AAudio may clamp or ignore "
    "the request; 0 uses the AAudio default> "
    "pm=<performance mode index: 0=none, 1=power-saving, 2=low-latency> "
    "input_preset=<preset index: 0=generic, 1=camcorder, "
    "2=voice-recognition, 3=voice-communication, 4=unprocessed, "
    "5=voice-performance (API 29+); omit for the AAudio platform default>"
);

#define DEFAULT_SOURCE_NAME "AAudio source"
#define RING_SLOT_COUNT 9
#define RING_USABLE_SLOTS (RING_SLOT_COUNT - 1)
#define MAX_RING_BYTES (64U * 1024U * 1024U)
#define MAX_LATENCY_MSEC 2000U
#define MIN_POLL_USEC (1 * PA_USEC_PER_MSEC)
#define MAX_POLL_USEC (20 * PA_USEC_PER_MSEC)
#define INACTIVE_ERROR_POLL_USEC (500 * PA_USEC_PER_MSEC)
#define STATE_WAIT_ATTEMPTS 4
#define STATE_WAIT_NSEC (500 * PA_NSEC_PER_MSEC)

enum callback_failure {
    CALLBACK_FAILURE_NONE = 0,
    CALLBACK_FAILURE_INVALID_BUFFER = 1,
    CALLBACK_FAILURE_OVERSIZED_BUFFER = 2,
    CALLBACK_FAILURE_STREAM_STATE = 3,
};

struct ring_slot {
    uint8_t *data;
    int32_t frames;
};

struct userdata {
    pa_core *core;
    pa_module *module;
    pa_source *source;

    pa_thread *thread;
    pa_thread_mq thread_mq;
    bool thread_mq_initialized;
    pa_rtpoll *rtpoll;

    pa_sample_spec ss;
    uint32_t requested_rate;
    uint32_t requested_latency_msec;
    aaudio_performance_mode_t performance_mode;
    aaudio_input_preset_t input_preset;
    bool input_preset_set;

    AAudioStream *stream;
    size_t frame_size;
    size_t slot_frames;
    size_t slot_bytes;
    size_t max_post_bytes;
    pa_usec_t base_latency;
    pa_usec_t poll_interval;

    uint8_t *ring_storage;
    struct ring_slot ring[RING_SLOT_COUNT];
    pa_atomic_t read_index;
    pa_atomic_t write_index;
    pa_atomic_t accepting;
    pa_atomic_t callback_failure;
    pa_atomic_t dropped_buffers;
    pa_atomic_t queued_frames;
    int reported_dropped_buffers;
};

static const char *const valid_modargs[] = {
    "source_name",
    "source_properties",
    "format",
    "channels",
    "channel_map",
    "rate",
    "latency",
    "pm",
    "input_preset",
    NULL
};

static const aaudio_performance_mode_t performance_modes[] = {
    AAUDIO_PERFORMANCE_MODE_NONE,
    AAUDIO_PERFORMANCE_MODE_POWER_SAVING,
    AAUDIO_PERFORMANCE_MODE_LOW_LATENCY,
};

static const aaudio_input_preset_t input_presets[] = {
    AAUDIO_INPUT_PRESET_GENERIC,
    AAUDIO_INPUT_PRESET_CAMCORDER,
    AAUDIO_INPUT_PRESET_VOICE_RECOGNITION,
    AAUDIO_INPUT_PRESET_VOICE_COMMUNICATION,
    AAUDIO_INPUT_PRESET_UNPROCESSED,
    AAUDIO_INPUT_PRESET_VOICE_PERFORMANCE,
};

typedef void (*set_input_preset_t)(AAudioStreamBuilder *builder,
                                   aaudio_input_preset_t input_preset);

static void log_aaudio_error(const char *operation, aaudio_result_t result) {
    pa_log_error("%s failed: %s (%d)", operation,
                 AAudio_convertResultToText(result), result);
}

static set_input_preset_t resolve_set_input_preset(void) {
    union {
        void *object;
        set_input_preset_t function;
    } symbol;

    dlerror();
    symbol.object = dlsym(RTLD_DEFAULT, "AAudioStreamBuilder_setInputPreset");
    return symbol.function;
}

static void record_callback_failure(struct userdata *u, int failure) {
    pa_atomic_cmpxchg(&u->callback_failure, CALLBACK_FAILURE_NONE, failure);
}

static void record_dropped_buffer(struct userdata *u) {
    int dropped = pa_atomic_load(&u->dropped_buffers);

    if (dropped < INT_MAX)
        pa_atomic_store(&u->dropped_buffers, dropped + 1);
}

static aaudio_data_callback_result_t data_callback(AAudioStream *stream, void *userdata,
                                                    void *audio_data, int32_t num_frames) {
    struct userdata *u = userdata;
    int read_index;
    int write_index;
    int next_index;
    size_t nbytes;

    (void) stream;

    if (!pa_atomic_load(&u->accepting))
        return AAUDIO_CALLBACK_RESULT_CONTINUE;

    if (!audio_data || num_frames <= 0) {
        record_callback_failure(u, CALLBACK_FAILURE_INVALID_BUFFER);
        return AAUDIO_CALLBACK_RESULT_STOP;
    }

    if ((size_t) num_frames > u->slot_frames) {
        record_callback_failure(u, CALLBACK_FAILURE_OVERSIZED_BUFFER);
        return AAUDIO_CALLBACK_RESULT_STOP;
    }

    write_index = pa_atomic_load(&u->write_index);
    next_index = write_index + 1;
    if (next_index == RING_SLOT_COUNT)
        next_index = 0;

    read_index = pa_atomic_load(&u->read_index);
    if (next_index == read_index) {
        record_dropped_buffer(u);
        return AAUDIO_CALLBACK_RESULT_CONTINUE;
    }

    nbytes = (size_t) num_frames * u->frame_size;
    memcpy(u->ring[write_index].data, audio_data, nbytes);
    u->ring[write_index].frames = num_frames;
    pa_atomic_add(&u->queued_frames, num_frames);
    pa_atomic_store(&u->write_index, next_index);

    return AAUDIO_CALLBACK_RESULT_CONTINUE;
}

static void error_callback(AAudioStream *stream, void *userdata, aaudio_result_t error) {
    struct userdata *u = userdata;

    (void) stream;

    if (error != AAUDIO_OK)
        record_callback_failure(u, error);
}

static int close_stream(struct userdata *u, const char *context) {
    AAudioStream *stream;
    aaudio_result_t result;

    if (!u->stream)
        return 0;

    pa_atomic_store(&u->accepting, 0);
    stream = u->stream;
    u->stream = NULL;
    result = AAudioStream_close(stream);
    if (result != AAUDIO_OK) {
        log_aaudio_error(context, result);
        record_callback_failure(u, result);
        return -1;
    }

    return 0;
}

static int validate_and_prepare_stream(struct userdata *u, AAudioStream *stream,
                                       aaudio_format_t requested_format) {
    aaudio_format_t actual_format;
    aaudio_performance_mode_t actual_performance_mode;
    int32_t actual_channels;
    int32_t actual_rate;
    int32_t buffer_capacity;
    int32_t buffer_size;
    int32_t callback_frames;
    int32_t frames_per_burst;
    int32_t poll_frames;
    aaudio_result_t result;
    uint64_t requested_buffer_size;
    size_t total_ring_bytes;
    unsigned i;

    actual_rate = AAudioStream_getSampleRate(stream);
    actual_channels = AAudioStream_getChannelCount(stream);
    actual_format = AAudioStream_getFormat(stream);
    buffer_capacity = AAudioStream_getBufferCapacityInFrames(stream);
    buffer_size = AAudioStream_getBufferSizeInFrames(stream);
    frames_per_burst = AAudioStream_getFramesPerBurst(stream);
    callback_frames = AAudioStream_getFramesPerDataCallback(stream);
    actual_performance_mode = AAudioStream_getPerformanceMode(stream);

    if (actual_rate <= 0 || !pa_sample_rate_valid((uint32_t) actual_rate)) {
        pa_log_error("AAudio returned invalid sample rate %d", actual_rate);
        return -1;
    }
    if (u->requested_rate && actual_rate != (int32_t) u->requested_rate) {
        pa_log_error("AAudio opened at %d Hz instead of requested rate %u Hz",
                     actual_rate, u->requested_rate);
        return -1;
    }
    if (actual_channels != u->ss.channels) {
        pa_log_error("AAudio opened with %d channels instead of requested %u",
                     actual_channels, u->ss.channels);
        return -1;
    }
    if (actual_format != requested_format) {
        pa_log_error("AAudio opened with format %d instead of requested format %d",
                     actual_format, requested_format);
        return -1;
    }
    if (buffer_capacity <= 0) {
        pa_log_error("AAudio returned invalid buffer capacity %d frames", buffer_capacity);
        return -1;
    }
    if (buffer_capacity > INT_MAX / RING_USABLE_SLOTS) {
        pa_log_error("AAudio buffer capacity %d is too large for backlog accounting",
                     buffer_capacity);
        return -1;
    }

    if (u->requested_latency_msec) {
        requested_buffer_size = ((uint64_t) actual_rate * u->requested_latency_msec + 999U) / 1000U;
        if (requested_buffer_size == 0 || requested_buffer_size > INT32_MAX) {
            pa_log_error("Requested AAudio active buffer size is out of range");
            return -1;
        }

        result = AAudioStream_setBufferSizeInFrames(stream, (int32_t) requested_buffer_size);
        if (result < 0) {
            log_aaudio_error("AAudioStream_setBufferSizeInFrames", result);
            return -1;
        }
        buffer_size = AAudioStream_getBufferSizeInFrames(stream);
        if (buffer_size != result)
            pa_log_info("AAudio reports active buffer size %d after setting it to %d frames",
                        buffer_size, result);
        if (buffer_size != (int32_t) requested_buffer_size)
            pa_log_info("AAudio selected active buffer size %d instead of requested size %" PRIu64 " frames",
                        buffer_size, requested_buffer_size);
    }

    if (buffer_size <= 0 || buffer_size > buffer_capacity) {
        pa_log_error("AAudio returned invalid active buffer size %d for capacity %d frames",
                     buffer_size, buffer_capacity);
        return -1;
    }
    if (frames_per_burst <= 0 || frames_per_burst > buffer_capacity) {
        pa_log_error("AAudio returned invalid burst size %d for capacity %d frames",
                     frames_per_burst, buffer_capacity);
        return -1;
    }
    if (callback_frames < 0 || callback_frames > buffer_capacity) {
        pa_log_error("AAudio returned callback size %d for capacity %d frames",
                     callback_frames, buffer_capacity);
        return -1;
    }

    u->ss.rate = (uint32_t) actual_rate;
    u->frame_size = pa_frame_size(&u->ss);
    u->slot_frames = (size_t) buffer_capacity;

    if (u->slot_frames > SIZE_MAX / u->frame_size) {
        pa_log_error("AAudio buffer capacity overflows the ring slot size");
        return -1;
    }
    u->slot_bytes = u->slot_frames * u->frame_size;
    if (u->slot_bytes > MAX_RING_BYTES / RING_SLOT_COUNT) {
        pa_log_error("AAudio buffer capacity requires more than %u bytes of ring storage",
                     MAX_RING_BYTES);
        return -1;
    }

    total_ring_bytes = u->slot_bytes * RING_SLOT_COUNT;
    u->ring_storage = pa_xmalloc0(total_ring_bytes);
    for (i = 0; i < RING_SLOT_COUNT; i++)
        u->ring[i].data = u->ring_storage + i * u->slot_bytes;

    u->max_post_bytes = pa_frame_align(pa_mempool_block_size_max(u->core->mempool), &u->ss);
    if (u->max_post_bytes == 0) {
        pa_log_error("PulseAudio mempool cannot hold one AAudio frame");
        return -1;
    }

    /* Buffer-based estimate; this does not measure hardware capture latency. */
    u->base_latency = (pa_usec_t) ((((uint64_t) buffer_size * PA_USEC_PER_SEC)
                                     + (uint32_t) actual_rate - 1U)
                                    / (uint32_t) actual_rate);
    if (u->base_latency == 0)
        u->base_latency = 1;

    poll_frames = callback_frames > 0 ? callback_frames : frames_per_burst;
    u->poll_interval = (pa_usec_t) ((((uint64_t) poll_frames * PA_USEC_PER_SEC)
                                     + (uint32_t) actual_rate - 1U)
                                    / (uint32_t) actual_rate);
    u->poll_interval = PA_CLAMP_UNLIKELY(u->poll_interval,
                                         MIN_POLL_USEC, MAX_POLL_USEC);

    pa_log_info("AAudio input opened: rate=%d, channels=%d, format=%d, "
                "capacity=%d frames, active-buffer=%d frames, burst=%d frames, "
                "callback=%d frames, performance-mode=%d, buffer-latency-estimate=%" PRIu64
                " usec, poll-interval=%" PRIu64 " usec",
                actual_rate, actual_channels, actual_format, buffer_capacity,
                buffer_size, frames_per_burst, callback_frames,
                actual_performance_mode, (uint64_t) u->base_latency,
                (uint64_t) u->poll_interval);

    if (actual_performance_mode != u->performance_mode)
        pa_log_info("AAudio selected performance mode %d instead of requested mode %d",
                    actual_performance_mode, u->performance_mode);

    return 0;
}

static int open_stream(struct userdata *u) {
    AAudioStreamBuilder *builder = NULL;
    AAudioStream *stream = NULL;
    aaudio_format_t requested_format;
    aaudio_result_t result;
    set_input_preset_t set_input_preset;
    int ret = -1;

    requested_format = u->ss.format == PA_SAMPLE_FLOAT32LE
        ? AAUDIO_FORMAT_PCM_FLOAT
        : AAUDIO_FORMAT_PCM_I16;

    result = AAudio_createStreamBuilder(&builder);
    if (result != AAUDIO_OK) {
        log_aaudio_error("AAudio_createStreamBuilder", result);
        goto finish;
    }

    AAudioStreamBuilder_setDirection(builder, AAUDIO_DIRECTION_INPUT);
    AAudioStreamBuilder_setPerformanceMode(builder, u->performance_mode);
    AAudioStreamBuilder_setDataCallback(builder, data_callback, u);
    AAudioStreamBuilder_setErrorCallback(builder, error_callback, u);
    AAudioStreamBuilder_setFormat(builder, requested_format);
    AAudioStreamBuilder_setChannelCount(builder, u->ss.channels);

    if (u->requested_rate)
        AAudioStreamBuilder_setSampleRate(builder, (int32_t) u->requested_rate);

    if (u->input_preset_set) {
        if (u->input_preset == AAUDIO_INPUT_PRESET_VOICE_PERFORMANCE) {
            int device_api_level = android_get_device_api_level();

            if (device_api_level < 0) {
                pa_log_error("Could not determine the Android API level required for the voice-performance input preset");
                goto finish;
            }
            if (device_api_level < 29) {
                pa_log_error("The voice-performance input preset requires Android 10 (API 29) or later");
                goto finish;
            }
        }

        set_input_preset = resolve_set_input_preset();
        if (set_input_preset)
            set_input_preset(builder, u->input_preset);
        else if (u->input_preset != AAUDIO_INPUT_PRESET_VOICE_RECOGNITION) {
            pa_log_error("The requested AAudio input preset requires Android 9 (API 28) or later");
            goto finish;
        }
    }

    result = AAudioStreamBuilder_openStream(builder, &stream);
    if (result != AAUDIO_OK) {
        log_aaudio_error("AAudioStreamBuilder_openStream", result);
        if (result == AAUDIO_ERROR_UNAVAILABLE || result == AAUDIO_ERROR_NO_SERVICE)
            pa_log_error("Make sure Termux has Android microphone permission before loading module-aaudio-source");
        goto finish;
    }

    {
        AAudioStreamBuilder *owned_builder = builder;
        builder = NULL;
        result = AAudioStreamBuilder_delete(owned_builder);
    }
    if (result != AAUDIO_OK) {
        log_aaudio_error("AAudioStreamBuilder_delete", result);
        goto finish;
    }

    if (validate_and_prepare_stream(u, stream, requested_format) < 0)
        goto finish;

    u->stream = stream;
    stream = NULL;
    ret = 0;

finish:
    if (builder) {
        AAudioStreamBuilder *owned_builder = builder;
        builder = NULL;
        result = AAudioStreamBuilder_delete(owned_builder);
        if (result != AAUDIO_OK)
            log_aaudio_error("AAudioStreamBuilder_delete during cleanup", result);
    }
    if (stream) {
        AAudioStream *owned_stream = stream;
        stream = NULL;
        result = AAudioStream_close(owned_stream);
        if (result != AAUDIO_OK)
            log_aaudio_error("AAudioStream_close during open cleanup", result);
    }
    return ret;
}

static void discard_ring(struct userdata *u) {
    int read_index = pa_atomic_load(&u->read_index);
    int write_index = pa_atomic_load(&u->write_index);

    /* STOPPED need not join an in-flight callback. Consume only published slots. */
    while (read_index != write_index) {
        pa_atomic_sub(&u->queued_frames, u->ring[read_index].frames);
        read_index++;
        if (read_index == RING_SLOT_COUNT)
            read_index = 0;
        pa_atomic_store(&u->read_index, read_index);
    }
}

static int wait_for_stream_state(struct userdata *u, aaudio_stream_state_t target,
                                 const char *operation) {
    aaudio_stream_state_t current;
    unsigned attempt;

    current = AAudioStream_getState(u->stream);
    for (attempt = 0; attempt < STATE_WAIT_ATTEMPTS; attempt++) {
        aaudio_stream_state_t next = current;
        aaudio_result_t result;

        if (current == target)
            return 0;
        if (current == AAUDIO_STREAM_STATE_CLOSING
                || current == AAUDIO_STREAM_STATE_CLOSED
                || current == AAUDIO_STREAM_STATE_DISCONNECTED) {
            pa_log_error("%s reached terminal AAudio state %d instead of %d",
                         operation, current, target);
            record_callback_failure(u, CALLBACK_FAILURE_STREAM_STATE);
            return -1;
        }

        result = AAudioStream_waitForStateChange(u->stream, current, &next,
                                                 STATE_WAIT_NSEC);
        if (result == AAUDIO_ERROR_TIMEOUT) {
            current = AAudioStream_getState(u->stream);
            continue;
        }
        if (result != AAUDIO_OK) {
            log_aaudio_error(operation, result);
            record_callback_failure(u, result);
            return -1;
        }
        current = next;
    }

    current = AAudioStream_getState(u->stream);
    if (current == target)
        return 0;

    pa_log_error("%s did not reach AAudio state %d; current state is %d",
                 operation, target, current);
    record_callback_failure(u, CALLBACK_FAILURE_STREAM_STATE);
    return -1;
}

static int request_start(struct userdata *u) {
    aaudio_result_t result;

    if (!u->stream) {
        pa_log_error("Cannot start AAudio input: stream is closed");
        record_callback_failure(u, CALLBACK_FAILURE_STREAM_STATE);
        return -1;
    }
    if (pa_atomic_load(&u->callback_failure) != CALLBACK_FAILURE_NONE) {
        pa_log_error("Cannot start AAudio input after a callback failure");
        return -1;
    }

    discard_ring(u);
    pa_atomic_store(&u->accepting, 1);
    result = AAudioStream_requestStart(u->stream);
    if (result != AAUDIO_OK) {
        pa_atomic_store(&u->accepting, 0);
        log_aaudio_error("AAudioStream_requestStart", result);
        record_callback_failure(u, result);
        return -1;
    }

    if (wait_for_stream_state(u, AAUDIO_STREAM_STATE_STARTED,
                              "Waiting for AAudio stream start") < 0) {
        pa_atomic_store(&u->accepting, 0);
        return -1;
    }

    return 0;
}

static int request_stop(struct userdata *u) {
    aaudio_result_t result;

    pa_atomic_store(&u->accepting, 0);
    if (!u->stream)
        return 0;

    result = AAudioStream_requestStop(u->stream);
    if (result != AAUDIO_OK) {
        log_aaudio_error("AAudioStream_requestStop", result);
        record_callback_failure(u, result);
        return -1;
    }

    if (wait_for_stream_state(u, AAUDIO_STREAM_STATE_STOPPED,
                              "Waiting for AAudio stream stop") < 0)
        return -1;

    discard_ring(u);
    return 0;
}

static void post_slot(struct userdata *u, const struct ring_slot *slot) {
    const uint8_t *source = slot->data;
    size_t remaining = (size_t) slot->frames * u->frame_size;

    while (remaining > 0) {
        pa_memchunk chunk;
        void *destination;

        chunk.length = PA_MIN(remaining, u->max_post_bytes);
        chunk.index = 0;
        chunk.memblock = pa_memblock_new(u->core->mempool, chunk.length);
        destination = pa_memblock_acquire(chunk.memblock);
        memcpy(destination, source, chunk.length);
        pa_memblock_release(chunk.memblock);
        pa_source_post(u->source, &chunk);
        pa_memblock_unref(chunk.memblock);

        source += chunk.length;
        remaining -= chunk.length;
    }
}

static void drain_ring(struct userdata *u) {
    int read_index;
    int write_index = pa_atomic_load(&u->write_index);

    /* Yield to control messages even if callbacks keep the ring nonempty. */
    for (;;) {
        read_index = pa_atomic_load(&u->read_index);
        if (read_index == write_index)
            return;

        if (PA_SOURCE_IS_OPENED(u->source->thread_info.state))
            post_slot(u, &u->ring[read_index]);

        pa_atomic_sub(&u->queued_frames, u->ring[read_index].frames);

        read_index++;
        if (read_index == RING_SLOT_COUNT)
            read_index = 0;
        pa_atomic_store(&u->read_index, read_index);
    }
}

static void report_dropped_buffers(struct userdata *u) {
    int dropped = pa_atomic_load(&u->dropped_buffers);
    int reported = u->reported_dropped_buffers;

    if (dropped != reported
            && (reported == 0 || dropped == INT_MAX || dropped - reported >= reported)) {
        pa_log_warn("AAudio source ring full; dropped %d callback buffer(s) total",
                    dropped);
        u->reported_dropped_buffers = dropped;
    }
}

static int source_process_msg(pa_msgobject *object, int code, void *data,
                              int64_t offset, pa_memchunk *chunk) {
    struct userdata *u = PA_SOURCE(object)->userdata;

    switch (code) {
        case PA_SOURCE_MESSAGE_GET_LATENCY: {
            int queued_frames = pa_atomic_load(&u->queued_frames);
            pa_usec_t queued_latency = 0;

            if (queued_frames > 0)
                queued_latency = (pa_usec_t) ((((uint64_t) queued_frames * PA_USEC_PER_SEC)
                                                + u->ss.rate - 1U) / u->ss.rate);
            *((int64_t *) data) = (int64_t) (u->base_latency + queued_latency);
            return 0;
        }
    }

    return pa_source_process_msg(object, code, data, offset, chunk);
}

static int source_set_state_in_io_thread(pa_source *source, pa_source_state_t new_state,
                                         pa_suspend_cause_t new_suspend_cause) {
    struct userdata *u = source->userdata;
    pa_source_state_t old_state = source->thread_info.state;
    bool resume = old_state == PA_SOURCE_SUSPENDED && PA_SOURCE_IS_OPENED(new_state);
    int ret = 0;

    (void) new_suspend_cause;

    if (new_state == PA_SOURCE_UNLINKED) {
        if (PA_SOURCE_IS_OPENED(old_state) && request_stop(u) < 0)
            ret = -1;
        if (close_stream(u, "AAudioStream_close during unlink") < 0)
            ret = -1;
    } else if (PA_SOURCE_IS_OPENED(old_state) && new_state == PA_SOURCE_SUSPENDED)
        ret = request_stop(u);
    else if ((old_state == PA_SOURCE_INIT || old_state == PA_SOURCE_SUSPENDED)
             && PA_SOURCE_IS_OPENED(new_state))
        ret = request_start(u);

    if (ret < 0 && !resume) {
        pa_log_error("AAudio lifecycle failed; unloading after the source transition");
        return 0;
    }

    return ret;
}

static void log_callback_failure(int failure) {
    if (failure < 0)
        log_aaudio_error("AAudio error callback", failure);
    else if (failure == CALLBACK_FAILURE_INVALID_BUFFER)
        pa_log_error("AAudio data callback supplied an invalid buffer");
    else if (failure == CALLBACK_FAILURE_OVERSIZED_BUFFER)
        pa_log_error("AAudio data callback exceeded the validated stream capacity");
    else if (failure == CALLBACK_FAILURE_STREAM_STATE)
        pa_log_error("AAudio stream entered an invalid terminal or stalled state");
    else
        pa_log_error("AAudio callback failed with internal code %d", failure);
}

static void thread_func(void *userdata) {
    struct userdata *u = userdata;

    pa_log_debug("AAudio source thread starting");
    if (u->core->realtime_scheduling)
        pa_thread_make_realtime(u->core->realtime_priority);
    pa_thread_mq_install(&u->thread_mq);

    for (;;) {
        int failure;
        int ret;

        failure = pa_atomic_load(&u->callback_failure);
        if (failure != CALLBACK_FAILURE_NONE) {
            log_callback_failure(failure);
            goto fail;
        }

        report_dropped_buffers(u);
        drain_ring(u);

        if (PA_SOURCE_IS_OPENED(u->source->thread_info.state))
            pa_rtpoll_set_timer_relative(u->rtpoll, u->poll_interval);
        else if (u->stream)
            pa_rtpoll_set_timer_relative(u->rtpoll, INACTIVE_ERROR_POLL_USEC);
        else
            pa_rtpoll_set_timer_disabled(u->rtpoll);

        ret = pa_rtpoll_run(u->rtpoll);
        if (ret < 0)
            goto fail;
        if (ret == 0)
            goto finish;
    }

fail:
    pa_atomic_store(&u->accepting, 0);
    pa_asyncmsgq_post(u->thread_mq.outq, PA_MSGOBJECT(u->core),
                      PA_CORE_MESSAGE_UNLOAD_MODULE, u->module, 0, NULL, NULL);
    pa_asyncmsgq_wait_for(u->thread_mq.inq, PA_MESSAGE_SHUTDOWN);

finish:
    pa_log_debug("AAudio source thread shutting down");
}

void pa__done(pa_module *module) {
    struct userdata *u;

    pa_assert(module);

    if (!(u = module->userdata))
        return;

    pa_atomic_store(&u->accepting, 0);

    if (u->source)
        pa_source_unlink(u->source);

    if (u->thread) {
        pa_asyncmsgq_send(u->thread_mq.inq, NULL, PA_MESSAGE_SHUTDOWN,
                          NULL, 0, NULL);
        pa_thread_free(u->thread);
        u->thread = NULL;
    }

    close_stream(u, "AAudioStream_close during module cleanup");

    if (u->source) {
        pa_source_unref(u->source);
        u->source = NULL;
    }
    if (u->thread_mq_initialized) {
        pa_thread_mq_done(&u->thread_mq);
        u->thread_mq_initialized = false;
    }
    if (u->rtpoll) {
        pa_rtpoll_free(u->rtpoll);
        u->rtpoll = NULL;
    }

    pa_xfree(u->ring_storage);
    u->ring_storage = NULL;
    module->userdata = NULL;
    pa_xfree(u);
}

int pa__init(pa_module *module) {
    struct userdata *u = NULL;
    pa_channel_map map;
    pa_modargs *modargs = NULL;
    pa_source_new_data data;
    uint32_t input_preset_index = 2;
    uint32_t performance_mode_index = 2;

    pa_assert(module);

    if (!(modargs = pa_modargs_new(module->argument, valid_modargs))) {
        pa_log_error("Failed to parse module arguments");
        goto fail;
    }

    module->userdata = u = pa_xnew0(struct userdata, 1);
    u->core = module->core;
    u->module = module;
    u->ss = module->core->default_sample_spec;
    map = module->core->default_channel_map;

    if (pa_modargs_get_sample_spec_and_channel_map(modargs, &u->ss, &map,
                                                   PA_CHANNEL_MAP_DEFAULT) < 0) {
        pa_log_error("Invalid sample format specification or channel map");
        goto fail;
    }
    if (u->ss.format != PA_SAMPLE_S16LE && u->ss.format != PA_SAMPLE_FLOAT32LE) {
        pa_log_error("module-aaudio-source supports only s16le and float32le formats");
        goto fail;
    }
    if (u->ss.channels != 1 && u->ss.channels != 2) {
        pa_log_error("module-aaudio-source supports only one or two channels");
        goto fail;
    }

    if (pa_modargs_get_value(modargs, "rate", NULL))
        u->requested_rate = u->ss.rate;
    if (pa_modargs_get_value_u32(modargs, "latency", &u->requested_latency_msec) < 0
            || u->requested_latency_msec > MAX_LATENCY_MSEC) {
        pa_log_error("Invalid latency argument; expected 0 through %u ms", MAX_LATENCY_MSEC);
        goto fail;
    }
    if (pa_modargs_get_value_u32(modargs, "pm", &performance_mode_index) < 0
            || performance_mode_index >= sizeof(performance_modes) / sizeof(performance_modes[0])) {
        pa_log_error("Invalid pm argument; expected 0, 1, or 2");
        goto fail;
    }
    u->performance_mode = performance_modes[performance_mode_index];
    u->input_preset_set = pa_modargs_get_value(modargs, "input_preset", NULL) != NULL;
    if (pa_modargs_get_value_u32(modargs, "input_preset", &input_preset_index) < 0
            || input_preset_index >= sizeof(input_presets) / sizeof(input_presets[0])) {
        pa_log_error("Invalid input_preset argument; expected 0 through 5 (5 requires API 29+)");
        goto fail;
    }
    u->input_preset = input_presets[input_preset_index];

    if (!(u->rtpoll = pa_rtpoll_new())) {
        pa_log_error("pa_rtpoll_new() failed");
        goto fail;
    }
    if (pa_thread_mq_init(&u->thread_mq, module->core->mainloop, u->rtpoll) < 0) {
        pa_log_error("pa_thread_mq_init() failed");
        goto fail;
    }
    u->thread_mq_initialized = true;

    if (open_stream(u) < 0)
        goto fail;

    pa_source_new_data_init(&data);
    data.driver = __FILE__;
    data.module = module;
    pa_source_new_data_set_name(&data,
        pa_modargs_get_value(modargs, "source_name", DEFAULT_SOURCE_NAME));
    pa_source_new_data_set_sample_spec(&data, &u->ss);
    pa_source_new_data_set_channel_map(&data, &map);
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_DESCRIPTION, _("AAudio Input"));
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_CLASS, "abstract");
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_API, "aaudio");

    if (pa_modargs_get_proplist(modargs, "source_properties", data.proplist,
                                PA_UPDATE_REPLACE) < 0) {
        pa_log_error("Invalid source_properties argument");
        pa_source_new_data_done(&data);
        goto fail;
    }

    u->source = pa_source_new(module->core, &data, PA_SOURCE_LATENCY);
    pa_source_new_data_done(&data);
    if (!u->source) {
        pa_log_error("Failed to create AAudio source object");
        goto fail;
    }

    u->source->userdata = u;
    u->source->parent.process_msg = source_process_msg;
    u->source->set_state_in_io_thread = source_set_state_in_io_thread;
    pa_source_set_asyncmsgq(u->source, u->thread_mq.inq);
    pa_source_set_rtpoll(u->source, u->rtpoll);
    pa_source_set_fixed_latency(u->source, u->base_latency);

    if (!(u->thread = pa_thread_new("aaudio-source", thread_func, u))) {
        pa_log_error("Failed to create AAudio source thread");
        goto fail;
    }

    pa_source_put(u->source);
    pa_modargs_free(modargs);
    return 0;

fail:
    if (modargs)
        pa_modargs_free(modargs);
    pa__done(module);
    return -1;
}

int pa__get_n_used(pa_module *module) {
    struct userdata *u;

    pa_assert(module);
    pa_assert_se(u = module->userdata);

    return pa_source_linked_by(u->source);
}
