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
#include <pulsecore/sink.h>
#include <pulsecore/module.h>
#include <pulsecore/core-util.h>
#include <pulsecore/modargs.h>
#include <pulsecore/log.h>
#include <pulsecore/thread.h>
#include <pulsecore/thread-mq.h>
#include <pulsecore/rtpoll.h>

#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>

PA_MODULE_AUTHOR("Lennart Poettering, Nathan Martynov");
PA_MODULE_DESCRIPTION("Android OpenSL ES sink");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
    "sink_name=<name for the sink> "
    "sink_properties=<properties for the sink> "
    "rate=<sampling rate> "
    "latency=<buffer length> "
);

#define DEFAULT_SINK_NAME "OpenSL ES sink"
#define BLOCK_USEC (PA_USEC_PER_MSEC * 125)

enum {
    SINK_MESSAGE_RENDER = PA_SINK_MESSAGE_MAX
};

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

    SLObjectItf engineObject;
    SLObjectItf outputMixObject;
    SLObjectItf bqPlayerObject;

    SLEngineItf engineEngine;
    SLPlayItf bqPlayerPlay;
    SLBufferQueueItf bqPlayerBufferQueue;
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
    (*u->bqPlayerBufferQueue)->Enqueue(u->bqPlayerBufferQueue, u->buf, u->memchunk.length);
}

static int sink_process_msg(pa_msgobject *o, int code, void *data, int64_t offset, pa_memchunk *memchunk) {
    switch (code) {
        case SINK_MESSAGE_RENDER:
            process_render(data);
            return 0;
    }

    return pa_sink_process_msg(o, code, data, offset, memchunk);
};

static void sles_callback(SLBufferQueueItf bqPlayerBufferQueue, void *userdata) {
    struct userdata* u = userdata;

    pa_assert(u);

    pa_assert_se(pa_asyncmsgq_send(u->sles_msgq, PA_MSGOBJECT(u->sink), SINK_MESSAGE_RENDER, u, 0, NULL) == 0);
}

#define CHK(stmt) { \
    SLresult res = stmt; \
    if (res != SL_RESULT_SUCCESS) { \
        fprintf(stderr, "error %d at %s:%d\n", res, __FILE__, __LINE__); \
        goto fail; \
    } \
}

static int pa_init_sles_player(struct userdata *u, pa_sample_spec *ss) {
    CHK(slCreateEngine(&(u->engineObject), 0, NULL, 0, NULL, NULL));
    CHK((*u->engineObject)->Realize(u->engineObject, SL_BOOLEAN_FALSE));

    CHK((*u->engineObject)->GetInterface(u->engineObject, SL_IID_ENGINE, &(u->engineEngine)));

    CHK((*u->engineEngine)->CreateOutputMix(u->engineEngine, &(u->outputMixObject), 0, NULL, NULL));
    CHK((*u->outputMixObject)->Realize(u->outputMixObject, SL_BOOLEAN_FALSE));

    SLDataLocator_BufferQueue locator_bufferqueue;
    locator_bufferqueue.locatorType = SL_DATALOCATOR_BUFFERQUEUE;
    locator_bufferqueue.numBuffers = 8;

    SLAndroidDataFormat_PCM_EX pcm;
    if (ss->format == PA_SAMPLE_FLOAT32LE) {
        pcm.formatType = SL_ANDROID_DATAFORMAT_PCM_EX;
        pcm.representation = SL_ANDROID_PCM_REPRESENTATION_FLOAT;
    } else {
        pcm.formatType = SL_DATAFORMAT_PCM;
    }
    pcm.numChannels = ss->channels;
    pcm.sampleRate = ss->rate * 1000;
    pcm.bitsPerSample = pcm.containerSize = pa_sample_size(ss) * 8;
    pcm.channelMask = SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT;
    pcm.endianness = SL_BYTEORDER_LITTLEENDIAN;

    SLDataSource audiosrc;
    audiosrc.pLocator = &locator_bufferqueue;
    audiosrc.pFormat = &pcm;

    SLDataLocator_OutputMix locator_outputmix;
    locator_outputmix.locatorType = SL_DATALOCATOR_OUTPUTMIX;
    locator_outputmix.outputMix = u->outputMixObject;

    SLDataSink audiosnk;
    audiosnk.pLocator = &locator_outputmix;
    audiosnk.pFormat = NULL;

    SLInterfaceID ids[1] = {SL_IID_BUFFERQUEUE};
    SLboolean flags[1] = {SL_BOOLEAN_TRUE};

    CHK((*u->engineEngine)->CreateAudioPlayer(u->engineEngine, &u->bqPlayerObject, &audiosrc, &audiosnk, 1, ids, flags));
    CHK((*u->bqPlayerObject)->Realize(u->bqPlayerObject, SL_BOOLEAN_FALSE));

    CHK((*u->bqPlayerObject)->GetInterface(u->bqPlayerObject, SL_IID_PLAY, &u->bqPlayerPlay));

    CHK((*u->bqPlayerObject)->GetInterface(u->bqPlayerObject, SL_IID_BUFFERQUEUE, &u->bqPlayerBufferQueue));
    CHK((*u->bqPlayerBufferQueue)->RegisterCallback(u->bqPlayerBufferQueue, sles_callback, u));

    return 0;

fail:
    return -1;
}

#undef CHK

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
    /* If this was no regular exit from the loop we have to continue
     * processing messages until we received PA_MESSAGE_SHUTDOWN */
    pa_asyncmsgq_post(u->thread_mq.outq, PA_MSGOBJECT(u->core), PA_CORE_MESSAGE_UNLOAD_MODULE, u->module, 0, NULL, NULL);
    pa_asyncmsgq_wait_for(u->thread_mq.inq, PA_MESSAGE_SHUTDOWN);

finish:
    pa_log_debug("Thread shutting down");
}

static int state_func(pa_sink *s, pa_sink_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = s->userdata;

    if (PA_SINK_IS_OPENED(s->state) &&
        (state == PA_SINK_SUSPENDED || state == PA_SINK_UNLINKED))
        (*u->bqPlayerPlay)->SetPlayState(u->bqPlayerPlay, SL_PLAYSTATE_STOPPED);
    else if ((s->state == PA_SINK_SUSPENDED || s->state == PA_SINK_INIT) &&
             PA_SINK_IS_OPENED(state))
        (*u->bqPlayerPlay)->SetPlayState(u->bqPlayerPlay, SL_PLAYSTATE_PLAYING);
    return 0;
}

static void process_rewind(pa_sink *s) {
    pa_sink_process_rewind(s, 0);
}

int pa__init(pa_module*m) {
    struct userdata *u = NULL;
    pa_sample_spec ss;
    pa_channel_map map;
    pa_modargs *ma = NULL;
    pa_sink_new_data data;
    uint32_t latency = 0;

    pa_assert(m);

    m->userdata = u = pa_xnew0(struct userdata, 1);

    u->core = m->core;
    u->module = m;
    u->rtpoll = pa_rtpoll_new();

    if (pa_thread_mq_init(&u->thread_mq, m->core->mainloop, u->rtpoll) < 0) {
        pa_log("pa_thread_mq_init() failed.");
        goto fail;
    }

    /* The queue linking the AudioTrack thread and our RT thread */
    u->sles_msgq = pa_asyncmsgq_new(0);
    if (!u->sles_msgq) {
        pa_log("pa_asyncmsgq_new() failed.");
        goto fail;
    }

    /* The msgq from the AudioTrack RT thread should have an even higher
     * priority than the normal message queues, to match the guarantee
     * all other drivers make: supplying the audio device with data is
     * the top priority -- and as long as that is possible we don't do
     * anything else */
    u->rtpoll_item = pa_rtpoll_item_new_asyncmsgq_read(u->rtpoll, PA_RTPOLL_EARLY-1, u->sles_msgq);

    if (!(ma = pa_modargs_new(m->argument, valid_modargs))) {
        pa_log("Failed to parse module arguments.");
        goto fail;
    }

    ss = m->core->default_sample_spec;
    pa_channel_map_init_stereo(&map);

    switch (ss.format) {
    case PA_SAMPLE_S16LE:
    case PA_SAMPLE_S24LE:
    case PA_SAMPLE_S32LE:
    case PA_SAMPLE_FLOAT32LE:
        break;
    default:
        pa_log("Sample format not supported");
        goto fail;
    }
    pa_modargs_get_sample_rate(ma, &ss.rate);
    ss.channels = map.channels;

    if (pa_init_sles_player(u, &ss) < 0)
        goto fail;

    pa_sink_new_data_init(&data);
    data.driver = __FILE__;
    data.module = m;
    pa_sink_new_data_set_name(&data, pa_modargs_get_value(ma, "sink_name", DEFAULT_SINK_NAME));
    pa_sink_new_data_set_sample_spec(&data, &ss);
    pa_sink_new_data_set_channel_map(&data, &map);
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_DESCRIPTION, _("OpenSL ES Output"));
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_CLASS, "abstract");

    if (pa_modargs_get_proplist(ma, "sink_properties", data.proplist, PA_UPDATE_REPLACE) < 0) {
        pa_log("Invalid properties");
        pa_sink_new_data_done(&data);
        goto fail;
    }

    u->sink = pa_sink_new(m->core, &data, 0);
    pa_sink_new_data_done(&data);

    if (!u->sink) {
        pa_log("Failed to create sink object.");
        goto fail;
    }

    u->sink->parent.process_msg = sink_process_msg;
    u->sink->set_state_in_main_thread = state_func;
    u->sink->request_rewind = process_rewind;
    u->sink->userdata = u;

    pa_sink_set_asyncmsgq(u->sink, u->thread_mq.inq);
    pa_sink_set_rtpoll(u->sink, u->rtpoll);

    pa_modargs_get_value_u32(ma, "latency", &latency);
    if (latency)
        u->block_usec = latency * PA_USEC_PER_MSEC;
    else
        u->block_usec = BLOCK_USEC;
    pa_sink_set_fixed_latency(u->sink, u->block_usec);

    u->nbytes = pa_usec_to_bytes(u->block_usec, &u->sink->sample_spec);
    u->buf = calloc(1, u->nbytes);
    u->memchunk.memblock = pa_memblock_new_fixed(m->core->mempool, u->buf, u->nbytes, false);

    if (!(u->thread = pa_thread_new("sles-sink", thread_func, u))) {
        pa_log("Failed to create thread.");
        goto fail;
    }

    pa_sink_put(u->sink);
    sles_callback(u->bqPlayerBufferQueue, u);

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

#define DESTROY(object) if (u->object) (*u->object)->Destroy(u->object);

void pa__done(pa_module*m) {
    struct userdata *u;

    pa_assert(m);

    if (!(u = m->userdata))
        return;

    if (u->sink)
        pa_sink_unlink(u->sink);

    DESTROY(bqPlayerObject);
    DESTROY(outputMixObject);
    DESTROY(engineObject);

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

#undef DESTROY
