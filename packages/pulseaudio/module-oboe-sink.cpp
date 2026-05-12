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
#include <pulsecore/sink.h>
#include <pulsecore/module.h>
#include <pulsecore/core-util.h>
#include <pulsecore/modargs.h>
#include <pulsecore/log.h>
#include <pulsecore/thread.h>
#include <pulsecore/thread-mq.h>
#include <pulsecore/rtpoll.h>

PA_MODULE_AUTHOR("Termux");
PA_MODULE_DESCRIPTION("Android Oboe sink");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
    "sink_name=<name for the sink> "
    "sink_properties=<properties for the sink> "
    "rate=<sampling rate> "
    "latency=<buffer length in ms> "
);

#define DEFAULT_SINK_NAME "Oboe sink"

enum {
    SINK_MESSAGE_RENDER = PA_SINK_MESSAGE_MAX,
    SINK_MESSAGE_OPEN_STREAM
};

struct userdata;

} // extern "C"

/* C++ callback class. Lives outside extern "C" because it uses C++ inheritance.
 * The callback methods are called by Oboe's RT thread; they dispatch into PA
 * via pa_asyncmsgq_send, which is the same pattern module-aaudio-sink.c uses. */
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
    pa_sink *sink;

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

    /* Shutdown coordination. Set true at the top of pa__done, before any
     * stream close. The Oboe RT callback checks this and returns Stop
     * immediately without calling pa_asyncmsgq_send. This breaks the
     * close()/callback deadlock: Oboe's close() waits for current callback
     * to finish; callback would otherwise block in asyncmsgq_send waiting
     * for the same PA IO thread that is itself blocked in close(). */
    std::atomic<bool> shutting_down{false};
};

static const char* const valid_modargs[] = {
    "sink_name",
    "sink_properties",
    "rate",
    "latency",
    NULL
};

static int process_render(struct userdata *u, void *audioData, int64_t numFrames) {
    pa_assert(u->sink->thread_info.state != PA_SINK_INIT);

    /* a render message could be queued after a set state message */
    if (!PA_SINK_IS_LINKED(u->sink->thread_info.state))
        return (int) oboe::DataCallbackResult::Stop;

    u->memchunk.memblock = pa_memblock_new_fixed(u->core->mempool, audioData, u->frame_size * numFrames, false);
    u->memchunk.length = pa_memblock_get_length(u->memchunk.memblock);
    pa_sink_render_into_full(u->sink, &u->memchunk);
    pa_memblock_unref_fixed(u->memchunk.memblock);

    return (int) oboe::DataCallbackResult::Continue;
}

} // extern "C"

oboe::DataCallbackResult OboeCallback::onAudioReady(oboe::AudioStream *stream,
                                                    void *audioData,
                                                    int32_t numFrames) {
    pa_assert(u_);
    /* Bail out fast if the module is shutting down. This must happen BEFORE
     * pa_asyncmsgq_send to break the close()/callback deadlock. */
    if (u_->shutting_down.load(std::memory_order_acquire))
        return oboe::DataCallbackResult::Stop;

    int result = pa_asyncmsgq_send(u_->oboe_msgq, PA_MSGOBJECT(u_->sink),
                                    SINK_MESSAGE_RENDER, audioData, numFrames, NULL);
    return (oboe::DataCallbackResult) result;
}

void OboeCallback::onErrorAfterClose(oboe::AudioStream *stream, oboe::Result error) {
    pa_assert(u_);

    /* Wait until the sink is fully initialized before suspending it. */
    while (u_->sink->state == PA_SINK_INIT)
        ;

    if (error != oboe::Result::ErrorDisconnected)
        pa_log_debug("Oboe error: %d", (int) error);

    /* Suspend then unsuspend triggers stream reopen via the pa__init path. */
    pa_sink_suspend(u_->sink, true, PA_SUSPEND_UNAVAILABLE);
    pa_sink_suspend(u_->sink, false, PA_SUSPEND_UNAVAILABLE);
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
    builder.setDirection(oboe::Direction::Output)
           ->setSharingMode(oboe::SharingMode::Shared)
           ->setPerformanceMode(oboe::PerformanceMode::LowLatency)
           ->setFormat(format)
           ->setChannelCount(ss->channels)
           ->setDataCallback(u->callback)
           ->setErrorCallback(u->callback);

    if (u->rate)
        builder.setSampleRate(u->rate);

    oboe::Result result = builder.openStream(u->stream);
    if (result != oboe::Result::OK) {
        pa_log("Oboe openStream failed: %d", (int) result);
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

static int sink_process_msg(pa_msgobject *o, int code, void *data, int64_t offset, pa_memchunk *memchunk) {
    struct userdata* u = (struct userdata*) PA_SINK(o)->userdata;

    pa_assert(u);

    switch (code) {
        case SINK_MESSAGE_RENDER:
            return process_render(u, data, offset);
        case SINK_MESSAGE_OPEN_STREAM:
            if (pa_open_oboe_stream(u) < 0) {
                pa_log("pa_open_oboe_stream() failed.");
                return -1;
            }
            code = PA_SINK_MESSAGE_SET_FIXED_LATENCY;
            offset = get_latency(u);
            break;
    }

    return pa_sink_process_msg(o, code, data, offset, memchunk);
}

static int state_func_main(pa_sink *s, pa_sink_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = (struct userdata*) s->userdata;
    uint32_t idx;
    pa_sink_input *i;
    pa_idxset *inputs;

    if (s->state == PA_SINK_SUSPENDED && PA_SINK_IS_OPENED(state)) {
        if (pa_asyncmsgq_send(u->oboe_msgq, PA_MSGOBJECT(u->sink), SINK_MESSAGE_OPEN_STREAM, NULL, 0, NULL) < 0)
            return -1;

        inputs = pa_idxset_copy(s->inputs, NULL);
        /* PA_IDXSET_FOREACH assigns void* to typed pointer, which C allows
         * but C++ does not. Expand manually with explicit casts. */
        for (i = (pa_sink_input*) pa_idxset_first(inputs, &idx); i;
             i = (pa_sink_input*) pa_idxset_next(inputs, &idx)) {
            if (i->state == PA_SINK_INPUT_RUNNING) {
                pa_sink_input_cork(i, true);
            } else {
                pa_idxset_remove_by_index(inputs, idx);
            }
        }

        s->alternate_sample_rate = u->ss.rate;
        pa_sink_reconfigure(s, &u->ss, false);
        s->default_sample_rate = u->ss.rate;

        /* Avoid infinite loop triggered if uncork in this case */
        if (s->suspend_cause == PA_SUSPEND_IDLE)
            pa_sink_suspend(u->sink, true, PA_SUSPEND_UNAVAILABLE);

        for (i = (pa_sink_input*) pa_idxset_first(inputs, &idx); i;
             i = (pa_sink_input*) pa_idxset_next(inputs, &idx))
            pa_sink_input_cork(i, false);
        pa_idxset_free(inputs, NULL);
    }
    return 0;
}

static int state_func_io(pa_sink *s, pa_sink_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = (struct userdata*) s->userdata;

    /* Use requestStop here, NOT close. close() blocks waiting for callback
     * completion; callback can be blocked in asyncmsgq_send waiting for THIS
     * IO thread → deadlock. Defer the actual close to pa__done where the
     * shutting_down flag lets the callback bail without sending. This mirrors
     * the AAudio module's no_close_hack=1 mode, which exists for the same
     * reason (AAudio NDK has a related but milder version of the issue). */
    if (PA_SINK_IS_OPENED(s->thread_info.state) &&
        (state == PA_SINK_SUSPENDED || state == PA_SINK_UNLINKED)) {
        if (u->stream->requestStop() != oboe::Result::OK)
            pa_log_debug("Oboe requestStop() returned non-OK during state transition");
    } else if (s->thread_info.state == PA_SINK_SUSPENDED && PA_SINK_IS_OPENED(state)) {
        if (u->stream->requestStart() != oboe::Result::OK)
            pa_log("Oboe requestStart() failed.");
    } else if (s->thread_info.state == PA_SINK_INIT && PA_SINK_IS_LINKED(state)) {
        if (PA_SINK_IS_OPENED(state)) {
            if (u->stream->requestStart() != oboe::Result::OK)
                pa_log("Oboe requestStart() failed.");
        } else {
            u->stream->requestStop();
        }
    }
    return 0;
}

static void reconfigure_func(pa_sink *s, pa_sample_spec *ss, bool passthrough) {
    s->sample_spec.rate = ss->rate;
}

static void thread_func(void *userdata) {
    struct userdata *u = (struct userdata*) userdata;

    pa_assert(u);

    pa_log_debug("Thread starting up");
    pa_thread_mq_install(&u->thread_mq);

    for (;;) {
        int ret;

        if (PA_UNLIKELY(u->sink->thread_info.rewind_requested))
            pa_sink_process_rewind(u->sink, 0);

        if ((ret = pa_rtpoll_run(u->rtpoll)) < 0)
            goto fail;

        if (ret == 0)
            goto finish;
    }

fail:
    /* If this was no regular exit from the loop we have to continue
     * processing messages until we received PA_MESSAGE_SHUTDOWN */
    pa_asyncmsgq_post(u->thread_mq.outq, PA_MSGOBJECT(u->core), PA_CORE_MESSAGE_UNLOAD_MODULE, u->module, 0, NULL, NULL);
    pa_asyncmsgq_wait_for(u->thread_mq.inq, PA_MESSAGE_SHUTDOWN);

finish:
    pa_log_debug("Thread shutting down");
}

int pa__init(pa_module *m) {
    struct userdata *u = NULL;
    pa_channel_map map;
    pa_modargs *ma = NULL;
    pa_sink_new_data data;

    pa_assert(m);

    /* Use placement new for non-trivial C++ members in struct userdata */
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

    /* The queue linking the Oboe RT callback thread and our PA thread */
    u->oboe_msgq = pa_asyncmsgq_new(0);
    if (!u->oboe_msgq) {
        pa_log("pa_asyncmsgq_new() failed.");
        goto fail;
    }

    /* The msgq from the Oboe RT thread should have an even higher
     * priority than the normal message queues, to match the guarantee
     * all other drivers make: supplying the audio device with data is
     * the top priority. */
    u->rtpoll_item = pa_rtpoll_item_new_asyncmsgq_read(u->rtpoll, (pa_rtpoll_priority_t)(PA_RTPOLL_EARLY-1), u->oboe_msgq);

    if (!(ma = pa_modargs_new(m->argument, valid_modargs))) {
        pa_log("Failed to parse module arguments.");
        goto fail;
    }

    u->ss = m->core->default_sample_spec;
    map = m->core->default_channel_map;
    pa_modargs_get_sample_rate(ma, &u->rate);
    pa_modargs_get_value_u32(ma, "latency", &u->latency);

    /* Construct the callback object now so the stream can reference it */
    u->callback = std::make_shared<OboeCallback>(u);

    if (pa_open_oboe_stream(u) < 0)
        goto fail;

    pa_sink_new_data_init(&data);
    data.driver = __FILE__;
    data.module = m;
    pa_sink_new_data_set_name(&data, pa_modargs_get_value(ma, "sink_name", DEFAULT_SINK_NAME));
    pa_sink_new_data_set_sample_spec(&data, &u->ss);
    pa_sink_new_data_set_alternate_sample_rate(&data, u->ss.rate);
    pa_sink_new_data_set_channel_map(&data, &map);
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_DESCRIPTION, _("Oboe Output"));
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_CLASS, "abstract");

    if (pa_modargs_get_proplist(ma, "sink_properties", data.proplist, PA_UPDATE_REPLACE) < 0) {
        pa_log("Invalid properties");
        pa_sink_new_data_done(&data);
        goto fail;
    }

    u->sink = pa_sink_new(m->core, &data, (pa_sink_flags_t) 0);
    pa_sink_new_data_done(&data);

    if (!u->sink) {
        pa_log("Failed to create sink object.");
        goto fail;
    }

    u->sink->parent.process_msg = sink_process_msg;
    u->sink->set_state_in_main_thread = state_func_main;
    u->sink->set_state_in_io_thread = state_func_io;
    u->sink->reconfigure = reconfigure_func;
    u->sink->userdata = u;

    pa_sink_set_asyncmsgq(u->sink, u->thread_mq.inq);
    pa_sink_set_rtpoll(u->sink, u->rtpoll);
    pa_sink_set_fixed_latency(u->sink, get_latency(u));

    if (!(u->thread = pa_thread_new("oboe-sink", thread_func, u))) {
        pa_log("Failed to create thread.");
        goto fail;
    }

    pa_sink_put(u->sink);

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

    return pa_sink_linked_by(u->sink);
}

void pa__done(pa_module *m) {
    struct userdata *u;

    pa_assert(m);

    if (!(u = (struct userdata*) m->userdata))
        return;

    /* CRITICAL: Set shutting_down BEFORE any close/unlink. The Oboe RT
     * callback checks this flag and returns Stop immediately, allowing
     * Oboe's close() (which waits for callback completion) to proceed
     * without blocking on a pa_asyncmsgq_send that would itself block
     * on this thread. */
    u->shutting_down.store(true, std::memory_order_release);

    if (u->sink)
        pa_sink_unlink(u->sink);

    if (u->thread) {
        pa_asyncmsgq_send(u->thread_mq.inq, NULL, PA_MESSAGE_SHUTDOWN, NULL, 0, NULL);
        pa_thread_free(u->thread);
    }

    pa_thread_mq_done(&u->thread_mq);

    /* Close the Oboe stream explicitly now that the PA thread is gone and
     * the shutting_down flag protects us from callback deadlock. Doing this
     * before delete u (which would run the shared_ptr destructor) makes the
     * close ordering explicit and gives us a chance to log if anything
     * unexpected happens. */
    if (u->stream) {
        u->stream->close();
        u->stream.reset();
    }

    if (u->sink)
        pa_sink_unref(u->sink);

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
