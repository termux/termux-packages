/***
  This file is part of PulseAudio.

  Copyright 2004-2008 Lennart Poettering

  PulseAudio is free software; you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as published
  by the Free Software Foundation; either version 2.1 of the License,
  or (at your option) any later version.

  PulseAudio is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with PulseAudio; if not, see <http://www.gnu.org/licenses/>.
***/

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>

#include <pulse/rtclock.h>
#include <pulse/timeval.h>
#include <pulse/xmalloc.h>

#include <pulsecore/i18n.h>
#include <pulsecore/macro.h>
#include <pulsecore/source.h>
#include <pulsecore/module.h>
#include <pulsecore/core-util.h>
#include <pulsecore/modargs.h>
#include <pulsecore/log.h>
#include <pulsecore/thread.h>
#include <pulsecore/thread-mq.h>
#include <pulsecore/rtpoll.h>

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
    "format=<sample format> "
    "channels=<number of channels> "
    "channel_map=<channel map> "
    "rate=<sampling rate> "
    "latency=<buffer length> "
    "pm=<performance mode> "
    "input_preset=<AAudio input preset index> "
    "no_close_hack=<avoid segfault caused by AAudioStream_close()> "
);

#define DEFAULT_SOURCE_NAME "AAudio source"

enum {
    SOURCE_MESSAGE_POST = PA_SOURCE_MESSAGE_MAX,
    SOURCE_MESSAGE_OPEN_STREAM
};

struct userdata {
    pa_core *core;
    pa_module *module;
    pa_source *source;

    pa_thread *thread;
    pa_thread_mq thread_mq;
    pa_rtpoll *rtpoll;
    pa_rtpoll_item *rtpoll_item;
    pa_asyncmsgq *aaudio_msgq;

    uint32_t rate;
    uint32_t latency;
    uint32_t pm;
    uint32_t input_preset;
    bool no_close;

    size_t frame_size;

    AAudioStreamBuilder *builder;
    AAudioStream *stream;
    pa_sample_spec ss;
};

static const char* const valid_modargs[] = {
    "source_name",
    "source_properties",
    "format",
    "channels",
    "channel_map",
    "rate",
    "latency",
    "pm",
    "input_preset",
    "no_close_hack",
    NULL
};

static int process_post(struct userdata *u, pa_memchunk *chunk) {
    pa_assert(u->source->thread_info.state != PA_SOURCE_INIT);

    if (!PA_SOURCE_IS_LINKED(u->source->thread_info.state))
        return 0;

    pa_source_post(u->source, chunk);

    return 0;
}

static aaudio_data_callback_result_t data_callback(AAudioStream *stream, void *userdata, void *audioData, int32_t numFrames) {
    struct userdata *u = userdata;
    pa_memchunk chunk;
    void *dst;
    size_t nbytes;

    pa_assert(u);

    nbytes = u->frame_size * (size_t)numFrames;

    chunk.memblock = pa_memblock_new(u->core->mempool, nbytes);
    chunk.index = 0;
    chunk.length = nbytes;

    dst = pa_memblock_acquire(chunk.memblock);
    memcpy(dst, audioData, nbytes);
    pa_memblock_release(chunk.memblock);

    pa_asyncmsgq_post(u->aaudio_msgq,
                      PA_MSGOBJECT(u->source),
                      SOURCE_MESSAGE_POST,
                      NULL, 0, &chunk, NULL);

    pa_memblock_unref(chunk.memblock);

    return AAUDIO_CALLBACK_RESULT_CONTINUE;
}

static void error_callback(AAudioStream *stream, void *userdata, aaudio_result_t error) {
    struct userdata *u = userdata;

    pa_assert(u);

    while (u->source->state == PA_SOURCE_INIT);

    if (error != AAUDIO_ERROR_DISCONNECTED)
        pa_log_debug("AAudio error: %d", error);

    pa_source_suspend(u->source, true, PA_SUSPEND_UNAVAILABLE);
    pa_source_suspend(u->source, false, PA_SUSPEND_UNAVAILABLE);
}

#define CHK(stmt) { \
    aaudio_result_t res = stmt; \
    if (res != AAUDIO_OK) { \
        fprintf(stderr, "error %d at %s:%d\n", res, __FILE__, __LINE__); \
        goto fail; \
    } \
}

static int pa_open_aaudio_stream(struct userdata *u) {
    bool want_float;
    aaudio_format_t format;
    aaudio_result_t res;
    pa_sample_spec *ss = &u->ss;

    CHK(AAudio_createStreamBuilder(&u->builder));

    AAudioStreamBuilder_setDirection(u->builder, AAUDIO_DIRECTION_INPUT);
#if __ANDROID_API__ >= 28
    AAudioStreamBuilder_setInputPreset(u->builder,
        AAUDIO_INPUT_PRESET_GENERIC + (aaudio_input_preset_t)u->input_preset);
#endif
    AAudioStreamBuilder_setPerformanceMode(u->builder, AAUDIO_PERFORMANCE_MODE_NONE + u->pm);
    AAudioStreamBuilder_setDataCallback(u->builder, data_callback, u);
    AAudioStreamBuilder_setErrorCallback(u->builder, error_callback, u);

    want_float = ss->format > PA_SAMPLE_S16BE;
    ss->format = want_float ? PA_SAMPLE_FLOAT32LE : PA_SAMPLE_S16LE;
    format = want_float ? AAUDIO_FORMAT_PCM_FLOAT : AAUDIO_FORMAT_PCM_I16;
    AAudioStreamBuilder_setFormat(u->builder, format);

    if (u->rate)
        AAudioStreamBuilder_setSampleRate(u->builder, u->rate);

    AAudioStreamBuilder_setChannelCount(u->builder, ss->channels);

    res = AAudioStreamBuilder_openStream(u->builder, &u->stream);
    if (res != AAUDIO_OK) {
        if (res == AAUDIO_ERROR_UNAVAILABLE || res == AAUDIO_ERROR_NO_SERVICE)
            pa_log_error("AAudio stream open failed (%d). "
                   "RECORD_AUDIO permission may not be granted to Termux. "
                   "Grant via: Android Settings > Apps > Termux > Permissions > Microphone.",
                   res);
        else
            pa_log_error("AAudio openStream error %d at %s:%d", res, __FILE__, __LINE__);
        goto fail;
    }

    CHK(AAudioStreamBuilder_delete(u->builder));
    u->builder = NULL;

    ss->rate = (uint32_t)AAudioStream_getSampleRate(u->stream);
    u->frame_size = pa_frame_size(ss);

    return 0;

fail:
    if (u->builder) {
        AAudioStreamBuilder_delete(u->builder);
        u->builder = NULL;
    }
    return -1;
}

#undef CHK

static pa_usec_t get_latency(struct userdata *u) {
    if (!u->latency)
        return PA_USEC_PER_SEC * AAudioStream_getBufferSizeInFrames(u->stream) / u->ss.rate / 2;
    else
        return PA_USEC_PER_MSEC * u->latency;
}

static int source_process_msg(pa_msgobject *o, int code, void *data, int64_t offset, pa_memchunk *memchunk) {
    struct userdata *u = PA_SOURCE(o)->userdata;

    pa_assert(u);

    switch (code) {
        case SOURCE_MESSAGE_POST:
            return process_post(u, memchunk);
        case SOURCE_MESSAGE_OPEN_STREAM:
            if (pa_open_aaudio_stream(u) < 0) {
                pa_log_error("pa_open_aaudio_stream() failed.");
                return -1;
            }
            code = PA_SOURCE_MESSAGE_SET_FIXED_LATENCY;
            offset = get_latency(u);
            break;
        case PA_SOURCE_MESSAGE_GET_LATENCY:
            *((int64_t *) data) = 0;
            return 0;
    }

    return pa_source_process_msg(o, code, data, offset, memchunk);
}

static int state_func_main(pa_source *s, pa_source_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = s->userdata;
    uint32_t idx;
    pa_source_output *o;
    pa_idxset *outputs;

    if (s->state == PA_SOURCE_SUSPENDED && PA_SOURCE_IS_OPENED(state)) {
        if (pa_asyncmsgq_send(u->aaudio_msgq, PA_MSGOBJECT(u->source), SOURCE_MESSAGE_OPEN_STREAM, NULL, 0, NULL) < 0)
            return -1;

        outputs = pa_idxset_copy(s->outputs, NULL);
        PA_IDXSET_FOREACH(o, outputs, idx) {
            if (o->state == PA_SOURCE_OUTPUT_RUNNING)
                pa_source_output_cork(o, true);
            else
                pa_idxset_remove_by_index(outputs, idx);
        }

        s->alternate_sample_rate = u->ss.rate;
        pa_source_reconfigure(s, &u->ss, false);
        s->default_sample_rate = u->ss.rate;

        if (s->suspend_cause == PA_SUSPEND_IDLE)
            pa_source_suspend(u->source, true, PA_SUSPEND_UNAVAILABLE);

        PA_IDXSET_FOREACH(o, outputs, idx)
            pa_source_output_cork(o, false);
        pa_idxset_free(outputs, NULL);
    }

    return 0;
}

static int state_func_io(pa_source *s, pa_source_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = s->userdata;

    if (PA_SOURCE_IS_OPENED(s->thread_info.state) &&
        (state == PA_SOURCE_SUSPENDED || state == PA_SOURCE_UNLINKED)) {
        if (!u->no_close) {
            AAudioStream_close(u->stream);
            u->stream = NULL;
        } else {
            AAudioStream_requestStop(u->stream);
        }
    } else if (s->thread_info.state == PA_SOURCE_SUSPENDED && PA_SOURCE_IS_OPENED(state)) {
        if (AAudioStream_requestStart(u->stream) < 0)
            pa_log_error("AAudioStream_requestStart() failed.");
    } else if (s->thread_info.state == PA_SOURCE_INIT && PA_SOURCE_IS_LINKED(state)) {
        if (PA_SOURCE_IS_OPENED(state)) {
            if (AAudioStream_requestStart(u->stream) < 0)
                pa_log_error("AAudioStream_requestStart() failed.");
        } else {
            if (!u->no_close) {
                AAudioStream_close(u->stream);
                u->stream = NULL;
            }
        }
    }

    return 0;
}

static void reconfigure_func(pa_source *s, pa_sample_spec *ss, bool passthrough) {
    s->sample_spec.rate = ss->rate;
}

static void thread_func(void *userdata) {
    struct userdata *u = userdata;

    pa_assert(u);

    pa_log_debug("Thread starting up");
    pa_thread_mq_install(&u->thread_mq);

    for (;;) {
        int ret;

        if ((ret = pa_rtpoll_run(u->rtpoll)) < 0)
            goto fail;

        if (ret == 0)
            goto finish;
    }

fail:
    pa_asyncmsgq_post(u->thread_mq.outq, PA_MSGOBJECT(u->core), PA_CORE_MESSAGE_UNLOAD_MODULE, u->module, 0, NULL, NULL);
    pa_asyncmsgq_wait_for(u->thread_mq.inq, PA_MESSAGE_SHUTDOWN);

finish:
    pa_log_debug("Thread shutting down");
}

void pa__done(pa_module *m) {
    struct userdata *u;

    pa_assert(m);

    if (!(u = m->userdata))
        return;

    if (u->source)
        pa_source_unlink(u->source);

    if (u->thread) {
        pa_asyncmsgq_send(u->thread_mq.inq, NULL, PA_MESSAGE_SHUTDOWN, NULL, 0, NULL);
        pa_thread_free(u->thread);
    }

    pa_thread_mq_done(&u->thread_mq);

    if (u->source)
        pa_source_unref(u->source);

    if (u->rtpoll_item)
        pa_rtpoll_item_free(u->rtpoll_item);

    if (u->aaudio_msgq)
        pa_asyncmsgq_unref(u->aaudio_msgq);

    if (u->rtpoll)
        pa_rtpoll_free(u->rtpoll);

    if (u->stream)
        AAudioStream_close(u->stream);

    if (u->builder)
        AAudioStreamBuilder_delete(u->builder);

    pa_xfree(u);
}

int pa__init(pa_module *m) {
    struct userdata *u = NULL;
    pa_channel_map map;
    pa_modargs *ma = NULL;
    pa_source_new_data data;

    pa_assert(m);

    m->userdata = u = pa_xnew0(struct userdata, 1);
    u->core = m->core;
    u->module = m;
    u->rtpoll = pa_rtpoll_new();

    if (pa_thread_mq_init(&u->thread_mq, m->core->mainloop, u->rtpoll) < 0) {
        pa_log_error("pa_thread_mq_init() failed.");
        goto fail;
    }

    u->aaudio_msgq = pa_asyncmsgq_new(0);
    if (!u->aaudio_msgq) {
        pa_log_error("pa_asyncmsgq_new() failed.");
        goto fail;
    }
    u->rtpoll_item = pa_rtpoll_item_new_asyncmsgq_read(u->rtpoll, PA_RTPOLL_EARLY - 1, u->aaudio_msgq);

    if (!(ma = pa_modargs_new(m->argument, valid_modargs))) {
        pa_log_error("Failed to parse module arguments.");
        goto fail;
    }

    u->ss = m->core->default_sample_spec;
    map = m->core->default_channel_map;

    if (pa_modargs_get_sample_spec_and_channel_map(ma, &u->ss, &map, PA_CHANNEL_MAP_DEFAULT) < 0) {
        pa_log_error("Invalid sample format specification or channel map.");
        goto fail;
    }

    pa_modargs_get_sample_rate(ma, &u->rate);
    pa_modargs_get_value_u32(ma, "latency", &u->latency);

    u->pm = AAUDIO_PERFORMANCE_MODE_LOW_LATENCY - AAUDIO_PERFORMANCE_MODE_NONE;
    pa_modargs_get_value_u32(ma, "pm", &u->pm);

    u->input_preset = 0;
    pa_modargs_get_value_u32(ma, "input_preset", &u->input_preset);

    pa_modargs_get_value_boolean(ma, "no_close_hack", &u->no_close);

    if (pa_open_aaudio_stream(u) < 0)
        goto fail;

    pa_source_new_data_init(&data);
    data.driver = __FILE__;
    data.module = m;
    pa_source_new_data_set_name(&data, pa_modargs_get_value(ma, "source_name", DEFAULT_SOURCE_NAME));
    pa_source_new_data_set_sample_spec(&data, &u->ss);
    pa_source_new_data_set_alternate_sample_rate(&data, u->ss.rate);
    pa_source_new_data_set_channel_map(&data, &map);
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_DESCRIPTION, _("AAudio Input"));
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_CLASS, "abstract");

    if (pa_modargs_get_proplist(ma, "source_properties", data.proplist, PA_UPDATE_REPLACE) < 0) {
        pa_log_error("Invalid properties");
        pa_source_new_data_done(&data);
        goto fail;
    }

    u->source = pa_source_new(m->core, &data, PA_SOURCE_LATENCY);
    pa_source_new_data_done(&data);

    if (!u->source) {
        pa_log_error("Failed to create source object.");
        goto fail;
    }

    u->source->parent.process_msg = source_process_msg;
    u->source->set_state_in_main_thread = state_func_main;
    u->source->set_state_in_io_thread = state_func_io;
    u->source->reconfigure = reconfigure_func;
    u->source->userdata = u;

    pa_source_set_asyncmsgq(u->source, u->thread_mq.inq);
    pa_source_set_rtpoll(u->source, u->rtpoll);
    pa_source_set_fixed_latency(u->source, get_latency(u));

    if (!(u->thread = pa_thread_new("aaudio-source", thread_func, u))) {
        pa_log_error("Failed to create thread.");
        goto fail;
    }

    pa_source_put(u->source);
    pa_modargs_free(ma);

    return 0;

fail:
    if (ma)
        pa_modargs_free(ma);

    pa__done(m);

    return -1;
}

int pa__get_n_used(pa_module *m) {
    struct userdata *u;

    pa_assert(m);
    pa_assert_se(u = m->userdata);

    return pa_source_linked_by(u->source);
}
