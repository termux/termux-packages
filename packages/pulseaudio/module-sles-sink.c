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

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <pulse/rtclock.h>
#include <pulse/timeval.h>
#include <pulse/xmalloc.h>

#include <pulsecore/core-util.h>
#include <pulsecore/log.h>
#include <pulsecore/macro.h>
#include <pulsecore/modargs.h>
#include <pulsecore/module.h>
#include <pulsecore/rtpoll.h>
#include <pulsecore/sink.h>
#include <pulsecore/thread-mq.h>
#include <pulsecore/thread.h>

#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>

PA_MODULE_AUTHOR("Lennart Poettering, Nathan Martynov");
PA_MODULE_DESCRIPTION("Android OpenSL ES sink");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
    "sink_name=<name for the sink> "
    "sink_properties=<properties for the sink> "
    "rate=<sample rate> "
    "channel_map=<channel map> "
    "latency=<buffer length> "
);

#define DEFAULT_SINK_NAME "OpenSL ES sink"

enum { SINK_MESSAGE_RENDER = PA_SINK_MESSAGE_MAX };

struct userdata {
    pa_core *core;
    pa_module *module;
    pa_sink *sink;

    pa_thread *thread;
    pa_thread_mq thread_mq;
    pa_rtpoll *rtpoll;
    pa_rtpoll_item *rtpoll_item;
    pa_asyncmsgq *sles_msgq;

    pa_usec_t block_usec;

    pa_memchunk memchunk;
    void *buf;
    size_t nbytes;

    SLObjectItf EngineObject;
    SLObjectItf OutputMixObject;
    SLObjectItf PlayerObject;

    SLEngineItf EngineItf;
    SLPlayItf PlayItf;
    SLBufferQueueItf BufferQueueItf;
};

static const char* const valid_modargs[] = {
    "sink_name",
    "sink_properties",
    "rate",
    "latency",
    NULL
};

static void process_render(void *userdata) {
    struct userdata* u = userdata;
    pa_assert(u);

    /* a render message could be queued after a set state message */
    if (!PA_SINK_IS_LINKED(u->sink->thread_info.state))
        return;

    u->memchunk.length = u->nbytes;
    pa_sink_render_into(u->sink, &u->memchunk);
    (*u->BufferQueueItf)->Enqueue(u->BufferQueueItf, u->buf, u->memchunk.length);
}

static int sink_process_msg(pa_msgobject *o, int code, void *data, int64_t offset, pa_memchunk *memchunk) {
    switch (code) {
        case SINK_MESSAGE_RENDER:
            process_render(data);
            return 0;
        case PA_SINK_MESSAGE_GET_LATENCY:
            code = PA_SINK_MESSAGE_GET_FIXED_LATENCY; // FIXME: is there a way to get the real latency?
            break;
    }

    return pa_sink_process_msg(o, code, data, offset, memchunk);
};

static void sles_callback(SLBufferQueueItf bqPlayerBufferQueue, void *userdata) {
    struct userdata* u = userdata;
    pa_assert(u);
    pa_assert_se(pa_asyncmsgq_send(u->sles_msgq, PA_MSGOBJECT(u->sink), SINK_MESSAGE_RENDER, u, 0, NULL) == 0);
}

static int pa_sample_spec_to_sl_format(pa_sample_spec *ss, SLAndroidDataFormat_PCM_EX *sl) {
    pa_assert(ss);
    pa_assert(sl);

    *sl = (SLAndroidDataFormat_PCM_EX){0};

    switch ((sl->numChannels = ss->channels)) {
        case 1:
            sl->channelMask = SL_SPEAKER_FRONT_CENTER;
            break;
        case 2:
            sl->channelMask = SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT;
            break;
        default:
            pa_log_error("Unsupported sample format: only stereo or mono channels are supported.");
            return 1;
    }
    sl->sampleRate = ss->rate * 1000; // Hz to mHz

    switch (ss->format) {
        case PA_SAMPLE_S16LE: // fallthrough
        case PA_SAMPLE_S24LE: // fallthrough
        case PA_SAMPLE_S32LE: // fallthrough
        case PA_SAMPLE_S16BE: // fallthrough
        case PA_SAMPLE_S24BE: // fallthrough
        case PA_SAMPLE_S32BE:
            sl->formatType     = SL_DATAFORMAT_PCM;
            sl->representation = SL_ANDROID_PCM_REPRESENTATION_SIGNED_INT;
            break;
        case PA_SAMPLE_FLOAT32LE: // fallthrough
        case PA_SAMPLE_FLOAT32BE:
            sl->formatType     = SL_ANDROID_DATAFORMAT_PCM_EX;
            sl->representation = SL_ANDROID_PCM_REPRESENTATION_FLOAT;
            break;
        default:
            pa_log_error("Unsupported sample format: only s16/24/32 and f32 formats are supported.");
            return 1;
    }
    sl->endianness = pa_sample_format_is_le(ss->format)
        ? SL_BYTEORDER_LITTLEENDIAN
        : SL_BYTEORDER_BIGENDIAN;
    sl->bitsPerSample = sl->containerSize = pa_sample_size(ss) * 8;

    return 0;
}

static int pa_init_sles_player(struct userdata *u, pa_sample_spec *ss) {
    pa_assert(u);

    // check and convert the sample spec
    SLAndroidDataFormat_PCM_EX pcm;
    if (pa_sample_spec_to_sl_format(ss, &pcm))
        return 1;

    // common sles error handling
    #define CHK(stmt) {                                                        \
        SLresult res = (stmt);                                                 \
        if (res != SL_RESULT_SUCCESS) {                                        \
            pa_log_error("Failed to initialize OpenSL ES: error %d at %s:%d",  \
                res, __FILE__, __LINE__);                                      \
            return 1;                                                          \
        }                                                                      \
    }

    // create the engine
    CHK(slCreateEngine(&u->EngineObject, 0, NULL, 0, NULL, NULL));
    CHK((*u->EngineObject)->Realize(u->EngineObject, SL_BOOLEAN_FALSE));

    // create the outputmix
    CHK((*u->EngineObject)->GetInterface(u->EngineObject, SL_IID_ENGINE, &(u->EngineItf)));
    CHK((*u->EngineItf)->CreateOutputMix(u->EngineItf, &u->OutputMixObject, 0, NULL, NULL));
    CHK((*u->OutputMixObject)->Realize(u->OutputMixObject, SL_BOOLEAN_FALSE));

    // create the player
    CHK(({
        SLresult r = (*u->EngineItf)->CreateAudioPlayer(u->EngineItf,
            &u->PlayerObject,
            &(SLDataSource){
                .pLocator = &(SLDataLocator_BufferQueue){
                    .locatorType = SL_DATALOCATOR_BUFFERQUEUE,
                    .numBuffers  = 8,
                },
                .pFormat = &pcm,
            },
            &(SLDataSink){
                .pLocator = &(SLDataLocator_OutputMix){
                    .locatorType = SL_DATALOCATOR_OUTPUTMIX,
                    .outputMix   = u->OutputMixObject,
                },
                .pFormat = NULL,
            },
            1,
            (SLInterfaceID[]){SL_IID_BUFFERQUEUE},
            (SLboolean[]){SL_BOOLEAN_TRUE}
        );
        if (r == SL_RESULT_CONTENT_UNSUPPORTED)
            pa_log(
                "Failed to initialize OpenSL ES; try checking logcat and "
                "searching for messages with 'libOpenSLES:'"
            );
        r;
    }));

    // realize the player
    CHK((*u->PlayerObject)->Realize(u->PlayerObject, SL_BOOLEAN_FALSE));
    CHK((*u->PlayerObject)->GetInterface(u->PlayerObject, SL_IID_PLAY, &u->PlayItf));

    // register the callback
    CHK((*u->PlayerObject)->GetInterface(u->PlayerObject, SL_IID_BUFFERQUEUE, &u->BufferQueueItf));
    CHK((*u->BufferQueueItf)->RegisterCallback(u->BufferQueueItf, sles_callback, u));

    // cleanup
    #undef CHK

    return 0;
}

static void thread_func(void *userdata) {
    struct userdata *u = userdata;
    pa_assert(u);

    pa_thread_mq_install(&u->thread_mq);
    for (;;) {
        int ret;
        if ((ret = pa_rtpoll_run(u->rtpoll)) < 0) {
            pa_asyncmsgq_post(u->thread_mq.outq, PA_MSGOBJECT(u->core), PA_CORE_MESSAGE_UNLOAD_MODULE, u->module, 0, NULL, NULL);
            pa_asyncmsgq_wait_for(u->thread_mq.inq, PA_MESSAGE_SHUTDOWN);
            break;
        }
        if (ret == 0) {
            break;
        }
    }
}

static int state_func(pa_sink *s, pa_sink_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = s->userdata;
    pa_assert(u);

    if (PA_SINK_IS_OPENED(s->state) && (state == PA_SINK_SUSPENDED || state == PA_SINK_UNLINKED))
        (*u->PlayItf)->SetPlayState(u->PlayItf, SL_PLAYSTATE_STOPPED);
    else if ((s->state == PA_SINK_SUSPENDED || s->state == PA_SINK_INIT) && PA_SINK_IS_OPENED(state))
        (*u->PlayItf)->SetPlayState(u->PlayItf, SL_PLAYSTATE_PLAYING);
    return 0;
}

static void process_rewind(pa_sink *s) {
    pa_sink_process_rewind(s, 0);
}

int pa__init(pa_module*m) {
    struct userdata *u = NULL;
    pa_modargs *ma = NULL;
    pa_sink_new_data sink_data;
    pa_sample_spec ss;
    pa_channel_map map;
    uint32_t latency = 0;

    pa_assert(m);

    m->userdata = u = pa_xnew0(struct userdata, 1);
    if (!(ma = pa_modargs_new(m->argument, valid_modargs))) {
        pa_log("Failed to parse module arguments.");
        goto fail;
    }

    u->core   = m->core;
    u->module = m;

    u->rtpoll = pa_rtpoll_new();
    if (pa_thread_mq_init(&u->thread_mq, m->core->mainloop, u->rtpoll) < 0) {
        pa_log("pa_thread_mq_init() failed.");
        goto fail;
    }
    if (!(u->sles_msgq = pa_asyncmsgq_new(0))) {
        pa_log("pa_asyncmsgq_new() failed.");
        goto fail;
    }
    u->rtpoll_item = pa_rtpoll_item_new_asyncmsgq_read(u->rtpoll, PA_RTPOLL_EARLY-1, u->sles_msgq);

    pa_sink_new_data_init(&sink_data);
    sink_data.driver = __FILE__;
    sink_data.module = m;

    ss = m->core->default_sample_spec;
    if (pa_modargs_get_sample_rate(ma, &ss.rate) < 0) {
        pa_log("Invalid rate specification.");
        goto fail;
    }

    pa_channel_map_init_stereo(&map);
    ss.channels = map.channels;

    if (pa_init_sles_player(u, &ss))
        goto fail;

    pa_sink_new_data_set_name(&sink_data, pa_modargs_get_value(ma, "sink_name", DEFAULT_SINK_NAME));
    pa_sink_new_data_set_sample_spec(&sink_data, &ss);
    pa_sink_new_data_set_channel_map(&sink_data, &map);
    pa_proplist_sets(sink_data.proplist, PA_PROP_DEVICE_DESCRIPTION, "OpenSL ES Output");
    pa_proplist_sets(sink_data.proplist, PA_PROP_DEVICE_CLASS, "abstract");

    if (pa_modargs_get_proplist(ma, "sink_properties", sink_data.proplist, PA_UPDATE_REPLACE) < 0) {
        pa_log("Invalid properties.");
        pa_sink_new_data_done(&sink_data);
        goto fail;
    }

    if (!(u->sink = pa_sink_new(m->core, &sink_data, 0))) {
        pa_log("Failed to create sink object.");
        pa_sink_new_data_done(&sink_data);
        goto fail;
    }
    pa_sink_new_data_done(&sink_data);

    u->sink->userdata = u;
    u->sink->parent.process_msg = sink_process_msg;
    u->sink->set_state_in_main_thread = state_func;
    u->sink->request_rewind = process_rewind;

    pa_sink_set_asyncmsgq(u->sink, u->thread_mq.inq);
    pa_sink_set_rtpoll(u->sink, u->rtpoll);

    pa_modargs_get_value_u32(ma, "latency", &latency);
    u->block_usec = latency
        ? PA_USEC_PER_MSEC * latency
        : PA_USEC_PER_MSEC * 125;
    pa_sink_set_fixed_latency(u->sink, u->block_usec);

    u->nbytes = pa_usec_to_bytes(u->block_usec, &u->sink->sample_spec);
    u->buf = calloc(1, u->nbytes);
    u->memchunk.memblock = pa_memblock_new_fixed(m->core->mempool, u->buf, u->nbytes, false);

    if (!(u->thread = pa_thread_new("sles-sink", thread_func, u))) {
        pa_log("Failed to create thread.");
        goto fail;
    }

    pa_sink_put(u->sink);
    sles_callback(u->BufferQueueItf, u);

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

    return pa_sink_linked_by(u->sink);
}

void pa__done(pa_module*m) {
    struct userdata *u;

    pa_assert(m);

    if (!(u = m->userdata))
        return;

    if (u->sink)
        pa_sink_unlink(u->sink);

    if (u->PlayerObject)
        (*u->PlayerObject)->Destroy(u->PlayerObject);
    if (u->OutputMixObject)
        (*u->OutputMixObject)->Destroy(u->OutputMixObject);
    if (u->EngineObject)
        (*u->EngineObject)->Destroy(u->EngineObject);

    if (u->memchunk.memblock)
        pa_memblock_unref_fixed(u->memchunk.memblock);
    free(u->buf);

    if (u->thread) {
        pa_asyncmsgq_send(u->thread_mq.inq, NULL, PA_MESSAGE_SHUTDOWN, NULL, 0, NULL);
        pa_thread_free(u->thread);
    }
    pa_thread_mq_done(&u->thread_mq);

    if (u->sink)
        pa_sink_unref(u->sink);
    if (u->rtpoll_item)
        pa_rtpoll_item_free(u->rtpoll_item);
    if (u->sles_msgq)
        pa_asyncmsgq_unref(u->sles_msgq);
    if (u->rtpoll)
        pa_rtpoll_free(u->rtpoll);

    pa_xfree(u);
}
