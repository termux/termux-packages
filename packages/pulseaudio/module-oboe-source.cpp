/***
  This file is part of PulseAudio.

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

#include <atomic>
#include <memory>
#include <oboe/Oboe.h>

extern "C" {

#include <stdlib.h>
#include <stdio.h>

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

PA_MODULE_AUTHOR("Termux");
PA_MODULE_DESCRIPTION("Android Oboe source");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
    "source_name=<name for the source> "
    "source_properties=<properties for the source> "
    "rate=<sampling rate> "
    "latency=<buffer length in ms> "
);

#define DEFAULT_SOURCE_NAME "Oboe source"

enum {
    SOURCE_MESSAGE_RENDER = PA_SOURCE_MESSAGE_MAX,
    SOURCE_MESSAGE_OPEN_STREAM
};

struct userdata;

} // extern "C"

class OboeCallback : public oboe::AudioStreamDataCallback,
                     public oboe::AudioStreamErrorCallback {
public:
    explicit OboeCallback(struct userdata *u) : u_(u) {}

    oboe::DataCallbackResult onAudioReady(oboe::AudioStream *stream,
                                          void *audioData,
                                          int32_t numFrames) override;

    void onErrorAfterClose(oboe::AudioStream *stream,
                           oboe::Result error) override;

private:
    struct userdata *u_;
};

extern "C" {

struct userdata {
    pa_core *core;
    pa_module *module;
    pa_source *source;

    pa_thread *thread;
    pa_thread_mq thread_mq;
    pa_rtpoll *rtpoll;
    pa_rtpoll_item *rtpoll_item;
    pa_asyncmsgq *oboe_msgq;

    uint32_t rate;
    uint32_t latency;

    pa_memchunk memchunk;
    size_t frame_size;

    std::shared_ptr<oboe::AudioStream> stream;
    std::shared_ptr<OboeCallback> callback;
    pa_sample_spec ss;

    /* Shutdown coordination — see module-oboe-sink.cpp comment.
     * Same close()/callback deadlock applies to source: Oboe's close
     * waits for callback completion, callback would block in
     * pa_asyncmsgq_send waiting for the same PA IO thread that called
     * close. shutting_down lets the callback bail without sending. */
    std::atomic<bool> shutting_down{false};
};

static const char* const valid_modargs[] = {
    "source_name",
    "source_properties",
    "rate",
    "latency",
    NULL
};

static int process_render(struct userdata *u, void *audioData, int64_t numFrames) {
    pa_assert(u->source->thread_info.state != PA_SOURCE_INIT);

    /* a render message could be queued after a set state message */
    if (!PA_SOURCE_IS_LINKED(u->source->thread_info.state))
        return (int) oboe::DataCallbackResult::Stop;

    /* Wrap Oboe's pre-filled buffer in a memchunk and post to PA core.
     * pa_memblock_new_fixed avoids a copy: it references the buffer
     * in place. The memblock is released before we return, so Oboe
     * is free to reuse the buffer for the next callback. */
    u->memchunk.memblock = pa_memblock_new_fixed(u->core->mempool, audioData, u->frame_size * numFrames, false);
    u->memchunk.length = pa_memblock_get_length(u->memchunk.memblock);
    u->memchunk.index = 0;
    pa_source_post(u->source, &u->memchunk);
    pa_memblock_unref_fixed(u->memchunk.memblock);

    return (int) oboe::DataCallbackResult::Continue;
}

} // extern "C"

oboe::DataCallbackResult OboeCallback::onAudioReady(oboe::AudioStream *stream,
                                                    void *audioData,
                                                    int32_t numFrames) {
    pa_assert(u_);
    /* Bail fast on shutdown — see Lesson 9. */
    if (u_->shutting_down.load(std::memory_order_acquire))
        return oboe::DataCallbackResult::Stop;

    int result = pa_asyncmsgq_send(u_->oboe_msgq, PA_MSGOBJECT(u_->source),
                                    SOURCE_MESSAGE_RENDER, audioData, numFrames, NULL);
    return (oboe::DataCallbackResult) result;
}

void OboeCallback::onErrorAfterClose(oboe::AudioStream *stream, oboe::Result error) {
    pa_assert(u_);

    while (u_->source->state == PA_SOURCE_INIT)
        ;

    if (error != oboe::Result::ErrorDisconnected)
        pa_log_debug("Oboe error: %d", (int) error);

    pa_source_suspend(u_->source, true, PA_SUSPEND_UNAVAILABLE);
    pa_source_suspend(u_->source, false, PA_SUSPEND_UNAVAILABLE);
}

extern "C" {

static int pa_open_oboe_stream(struct userdata *u) {
    bool want_float;
    oboe::AudioFormat format;
    pa_sample_spec *ss = &u->ss;

    want_float = ss->format > PA_SAMPLE_S16BE;
    ss->format = want_float ? PA_SAMPLE_FLOAT32LE : PA_SAMPLE_S16LE;
    format = want_float ? oboe::AudioFormat::Float : oboe::AudioFormat::I16;

    oboe::AudioStreamBuilder builder;
    builder.setDirection(oboe::Direction::Input)
           ->setSharingMode(oboe::SharingMode::Shared)
           ->setPerformanceMode(oboe::PerformanceMode::LowLatency)
           ->setFormat(format)
           ->setChannelCount(ss->channels)
           ->setDataCallback(u->callback)
           ->setErrorCallback(u->callback)
           /* DR 064: disable Oboe auto-conversion. The original prototype's
            * source bug came from Oboe converting samples in ways PA did not
            * expect. Force pass-through so PA negotiates with us, not Oboe. */
           ->setSampleRateConversionQuality(oboe::SampleRateConversionQuality::None)
           ->setChannelConversionAllowed(false)
           ->setFormatConversionAllowed(false);

    if (u->rate)
        builder.setSampleRate(u->rate);

    oboe::Result result = builder.openStream(u->stream);
    if (result != oboe::Result::OK) {
        pa_log("Oboe openStream failed: %d (check Termux RECORD_AUDIO permission)", (int) result);
        return -1;
    }

    ss->rate = u->stream->getSampleRate();
    u->frame_size = pa_frame_size(ss);

    return 0;
}

static pa_usec_t get_latency(struct userdata *u) {
    if (!u->latency) {
        return PA_USEC_PER_SEC * u->stream->getBufferSizeInFrames() / u->ss.rate / 2;
    } else {
        return PA_USEC_PER_MSEC * u->latency;
    }
}

static int source_process_msg(pa_msgobject *o, int code, void *data, int64_t offset, pa_memchunk *memchunk) {
    struct userdata* u = (struct userdata*) PA_SOURCE(o)->userdata;

    pa_assert(u);

    switch (code) {
        case SOURCE_MESSAGE_RENDER:
            return process_render(u, data, offset);
        case SOURCE_MESSAGE_OPEN_STREAM:
            if (pa_open_oboe_stream(u) < 0) {
                pa_log("pa_open_oboe_stream() failed.");
                return -1;
            }
            code = PA_SOURCE_MESSAGE_SET_FIXED_LATENCY;
            offset = get_latency(u);
            break;
    }

    return pa_source_process_msg(o, code, data, offset, memchunk);
}

/* Source state function. ARCHITECTURAL NOTE: this MUST be wired via
 * set_state_in_main_thread (NOT set_state_in_io_thread) for source modules.
 *
 * Why source-specific: input callbacks fire continuously (mic always produces
 * data) regardless of PA consumers. If we call stream->requestStop() from the
 * IO thread, Oboe's requestStop blocks waiting for the current callback to
 * finish, while the callback is blocked in pa_asyncmsgq_send waiting for the
 * SAME IO thread → deadlock.
 *
 * Running this on the main thread instead leaves the IO thread free to
 * process callback messages, so requestStop completes cleanly. This matches
 * the pattern in module-sles-source.c which uses SetRecordState from
 * set_state_in_main_thread for the same reason. */
static int state_func(pa_source *s, pa_source_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = (struct userdata*) s->userdata;

    if (PA_SOURCE_IS_OPENED(s->state) && (state == PA_SOURCE_SUSPENDED || state == PA_SOURCE_UNLINKED)) {
        /* Close the stream entirely. Stopped-but-open Oboe streams are
         * disconnected by AudioFlinger as a system resource reclamation;
         * AAudio refuses to restart a Disconnected stream. The only stable
         * lifecycle is full close + fresh open. Matches module-aaudio-sink.c
         * which also closes (not stops) on suspend. */
        if (u->stream) {
            u->stream->close();
            u->stream.reset();
        }
    } else if (s->state == PA_SOURCE_SUSPENDED && PA_SOURCE_IS_OPENED(state)) {
        /* Resume from suspend: open a fresh stream. The previous one was
         * closed when we suspended. */
        if (pa_open_oboe_stream(u) < 0) {
            pa_log("Failed to reopen Oboe stream on resume.");
            return -1;
        }
        if (u->stream->requestStart() != oboe::Result::OK)
            pa_log("Oboe requestStart() failed on resume.");
    } else if (s->state == PA_SOURCE_INIT && PA_SOURCE_IS_OPENED(state)) {
        /* Initial open after pa_source_put: stream was opened in pa__init,
         * just needs to be started. */
        if (u->stream && u->stream->requestStart() != oboe::Result::OK)
            pa_log("Oboe requestStart() failed on initial open.");
    }
    return 0;
}

static void thread_func(void *userdata) {
    struct userdata *u = (struct userdata*) userdata;

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

int pa__init(pa_module *m) {
    struct userdata *u = NULL;
    pa_channel_map map;
    pa_modargs *ma = NULL;
    pa_source_new_data data;

    pa_assert(m);

    m->userdata = u = new struct userdata();
    if (!u) {
        pa_log("Failed to allocate userdata.");
        return -1;
    }

    u->core = m->core;
    u->module = m;
    u->rtpoll = pa_rtpoll_new();

    if (pa_thread_mq_init(&u->thread_mq, m->core->mainloop, u->rtpoll) < 0) {
        pa_log("pa_thread_mq_init() failed.");
        goto fail;
    }

    u->oboe_msgq = pa_asyncmsgq_new(0);
    if (!u->oboe_msgq) {
        pa_log("pa_asyncmsgq_new() failed.");
        goto fail;
    }

    u->rtpoll_item = pa_rtpoll_item_new_asyncmsgq_read(u->rtpoll, (pa_rtpoll_priority_t)(PA_RTPOLL_EARLY-1), u->oboe_msgq);

    if (!(ma = pa_modargs_new(m->argument, valid_modargs))) {
        pa_log("Failed to parse module arguments.");
        goto fail;
    }

    u->ss = m->core->default_sample_spec;
    map = m->core->default_channel_map;
    pa_modargs_get_sample_rate(ma, &u->rate);
    pa_modargs_get_value_u32(ma, "latency", &u->latency);

    u->callback = std::make_shared<OboeCallback>(u);

    if (pa_open_oboe_stream(u) < 0)
        goto fail;

    pa_source_new_data_init(&data);
    data.driver = __FILE__;
    data.module = m;
    pa_source_new_data_set_name(&data, pa_modargs_get_value(ma, "source_name", DEFAULT_SOURCE_NAME));
    pa_source_new_data_set_sample_spec(&data, &u->ss);
    pa_source_new_data_set_channel_map(&data, &map);
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_DESCRIPTION, _("Oboe Input"));
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_CLASS, "abstract");

    if (pa_modargs_get_proplist(ma, "source_properties", data.proplist, PA_UPDATE_REPLACE) < 0) {
        pa_log("Invalid properties");
        pa_source_new_data_done(&data);
        goto fail;
    }

    u->source = pa_source_new(m->core, &data, (pa_source_flags_t) 0);
    pa_source_new_data_done(&data);

    if (!u->source) {
        pa_log("Failed to create source object.");
        goto fail;
    }

    u->source->parent.process_msg = source_process_msg;
    u->source->set_state_in_main_thread = state_func;
    u->source->userdata = u;

    pa_source_set_asyncmsgq(u->source, u->thread_mq.inq);
    pa_source_set_rtpoll(u->source, u->rtpoll);
    pa_source_set_fixed_latency(u->source, get_latency(u));

    if (!(u->thread = pa_thread_new("oboe-source", thread_func, u))) {
        pa_log("Failed to create thread.");
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
    pa_assert_se(u = (struct userdata*) m->userdata);

    return pa_source_linked_by(u->source);
}

void pa__done(pa_module *m) {
    struct userdata *u;

    pa_assert(m);

    if (!(u = (struct userdata*) m->userdata))
        return;

    /* See module-oboe-sink.cpp pa__done. Same shutdown coordination. */
    u->shutting_down.store(true, std::memory_order_release);

    if (u->source)
        pa_source_unlink(u->source);

    if (u->thread) {
        pa_asyncmsgq_send(u->thread_mq.inq, NULL, PA_MESSAGE_SHUTDOWN, NULL, 0, NULL);
        pa_thread_free(u->thread);
    }

    pa_thread_mq_done(&u->thread_mq);

    if (u->stream) {
        u->stream->close();
        u->stream.reset();
    }

    if (u->source)
        pa_source_unref(u->source);

    if (u->rtpoll_item)
        pa_rtpoll_item_free(u->rtpoll_item);

    if (u->oboe_msgq)
        pa_asyncmsgq_unref(u->oboe_msgq);

    if (u->rtpoll)
        pa_rtpoll_free(u->rtpoll);

    delete u;
    m->userdata = NULL;
}

} // extern "C"
