/***
  This file is part of PulseAudio.

  Copyright 2008 Lennart Poettering

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
#include <pulsecore/modargs.h>
#include <pulsecore/module.h>
#include <pulsecore/rtpoll.h>
#include <pulsecore/source.h>
#include <pulsecore/thread-mq.h>
#include <pulsecore/thread.h>

#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>
#include <SLES/OpenSLES_AndroidConfiguration.h>

PA_MODULE_AUTHOR("Lennart Poettering, Patrick Gaskin");
PA_MODULE_DESCRIPTION("Android OpenSL ES source");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
    "source_name=<name for the source> "
    "source_properties=<properties for the source> "
    "latency=<buffer length> "
    "format=<sample format> "
    "channels=<number of channels> "
    "rate=<sample rate> "
    "channel_map=<channel map> "
);

#define DEFAULT_SOURCE_NAME "OpenSL ES source"

enum { SOURCE_MESSAGE_RENDER = PA_SOURCE_MESSAGE_MAX };

struct userdata {
    pa_core *core;
    pa_module *module;
    pa_source *source;

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
    SLObjectItf RecorderObject;
    SLEngineItf EngineItf;
    SLRecordItf RecordItf;
    SLAndroidConfigurationItf ConfigurationItf;
    SLAndroidSimpleBufferQueueItf BufferQueueItf;
};

static const char *const valid_modargs[] = {
    "source_name",
    "source_properties",
    "latency",
    "format",
    "channels",
    "rate",
    "channel_map",
    NULL
};

static void process_render(void *userdata) {
    struct userdata *u = userdata;
    pa_assert(u);

    (*u->RecordItf)->SetRecordState(u->RecordItf, SL_RECORDSTATE_RECORDING);
    if (!PA_SOURCE_IS_LINKED(u->source->thread_info.state))
        return;

    u->memchunk.length = u->nbytes;
    (*u->BufferQueueItf)->Enqueue(u->BufferQueueItf, u->buf, u->memchunk.length);
    pa_source_post(u->source, &u->memchunk);
}

static int source_process_msg(pa_msgobject *o, int code, void *data, int64_t offset, pa_memchunk *memchunk) {
    switch (code) {
        case SOURCE_MESSAGE_RENDER:
            process_render(data);
            return 0;
        case PA_SINK_MESSAGE_GET_LATENCY:
            code = PA_SINK_MESSAGE_GET_FIXED_LATENCY;  // FIXME: is there a way to get the real latency?
            break;
    }
    return pa_source_process_msg(o, code, data, offset, memchunk);
};

static void sles_callback(SLAndroidSimpleBufferQueueItf recBuffQueueItf, void *userdata) {
    struct userdata *u = userdata;
    pa_assert(u);
    pa_assert_se(pa_asyncmsgq_send(u->sles_msgq, PA_MSGOBJECT(u->source), SOURCE_MESSAGE_RENDER, u, 0, NULL) == 0);
}

static int pa_sample_spec_to_sl_format(pa_sample_spec *ss, SLAndroidDataFormat_PCM_EX *sl) {
    pa_assert(ss);
    pa_assert(sl);

    *sl = (SLAndroidDataFormat_PCM_EX){0};

    switch ((sl->numChannels = ss->channels)) {
        case 1:
            sl->channelMask = SL_SPEAKER_FRONT_LEFT;
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

static int pa_init_sles_record(struct userdata *u, pa_sample_spec *ss) {
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
    CHK(({
        SLresult r = (*u->EngineObject)->Realize(u->EngineObject, SL_BOOLEAN_FALSE);
        if (r == SL_RESULT_CONTENT_UNSUPPORTED)
            pa_log(
                "Failed to initialize OpenSL ES; did you grant Termux the "
                "RECORD_AUDIO permission (you can use termux-microphone-record "
                "from Termux:API for this)?"
            );
        r;
    }));

    // create the recorder
    CHK((*u->EngineObject)->GetInterface(u->EngineObject, SL_IID_ENGINE, &u->EngineItf));
    CHK(({
        SLresult r = (*u->EngineItf)->CreateAudioRecorder(u->EngineItf,
            &u->RecorderObject,

            // source/sink
            &(SLDataSource){
                .pLocator = &(SLDataLocator_IODevice){
                    .locatorType = SL_DATALOCATOR_IODEVICE,
                    .deviceType  = SL_IODEVICE_AUDIOINPUT,
                    .deviceID    = SL_DEFAULTDEVICEID_AUDIOINPUT,
                    .device      = NULL,
                },
                .pFormat = NULL,
            },
            &(SLDataSink){
                .pLocator = &(SLDataLocator_AndroidSimpleBufferQueue){
                    .locatorType = SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE,
                    .numBuffers  = 8,
                },
                .pFormat  = &pcm,
            },

            // required interfaces
            2,
            (SLInterfaceID[]){SL_IID_ANDROIDSIMPLEBUFFERQUEUE, SL_IID_ANDROIDCONFIGURATION}, 
            (SLboolean[])    {SL_BOOLEAN_TRUE,                 SL_BOOLEAN_TRUE}
        );
        if (r == SL_RESULT_CONTENT_UNSUPPORTED)
            pa_log(
                "Failed to initialize OpenSL ES; try checking logcat and "
                "searching for messages with 'libOpenSLES:'"
            );
        r;
    }));

    // update the configuration
    CHK((*u->RecorderObject)->GetInterface(u->RecorderObject, SL_IID_ANDROIDCONFIGURATION, &u->ConfigurationItf));
    CHK((*u->ConfigurationItf)->SetConfiguration(u->ConfigurationItf, SL_ANDROID_KEY_RECORDING_PRESET, &(SLuint32){SL_ANDROID_RECORDING_PRESET_VOICE_RECOGNITION}, sizeof(SLuint32)));

    // realize the recorder
    CHK((*u->RecorderObject)->Realize(u->RecorderObject, SL_BOOLEAN_FALSE));
    CHK((*u->RecorderObject)->GetInterface(u->RecorderObject, SL_IID_RECORD, &u->RecordItf));

    // register the callback
    CHK((*u->RecorderObject)->GetInterface(u->RecorderObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE, &u->BufferQueueItf));
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

static int state_func(pa_source *s, pa_source_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = s->userdata;
    pa_assert(u);

    if (PA_SOURCE_IS_OPENED(s->state) && (state == PA_SOURCE_SUSPENDED || state == PA_SOURCE_UNLINKED))
        (*u->RecordItf)->SetRecordState(u->RecordItf, SL_RECORDSTATE_STOPPED);
    else if ((s->state == PA_SOURCE_SUSPENDED || s->state == PA_SOURCE_INIT) && PA_SOURCE_IS_OPENED(state))
        (*u->RecordItf)->SetRecordState(u->RecordItf, SL_RECORDSTATE_RECORDING);
    return 0;
}

int pa__init(pa_module *m) {
    struct userdata *u = NULL;
    pa_modargs *ma = NULL;
    pa_source_new_data source_data;
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
    u->rtpoll_item = pa_rtpoll_item_new_asyncmsgq_read(u->rtpoll, PA_RTPOLL_EARLY - 1, u->sles_msgq);

    pa_source_new_data_init(&source_data);
    source_data.driver = __FILE__;
    source_data.module = m;

    ss  = m->core->default_sample_spec;
    map = m->core->default_channel_map;
    if (pa_modargs_get_sample_spec_and_channel_map(ma, &ss, &map, PA_CHANNEL_MAP_DEFAULT) < 0) {
        pa_log("Invalid sample format specification or channel map.");
        goto fail;
    }

    if (pa_init_sles_record(u, &ss))
        goto fail;

    pa_source_new_data_set_name(&source_data, pa_modargs_get_value(ma, "source_name", DEFAULT_SOURCE_NAME));
    pa_source_new_data_set_sample_spec(&source_data, &ss);
    pa_proplist_sets(source_data.proplist, PA_PROP_DEVICE_DESCRIPTION, "OpenSL ES Input");
    pa_proplist_sets(source_data.proplist, PA_PROP_DEVICE_CLASS,       "abstract");

    if (pa_modargs_get_proplist(ma, "source_properties", source_data.proplist, PA_UPDATE_REPLACE) < 0) {
        pa_log("Invalid properties.");
        pa_source_new_data_done(&source_data);
        goto fail;
    }

    if (!(u->source = pa_source_new(m->core, &source_data, PA_SOURCE_LATENCY))) {
        pa_log("Failed to create source.");
        pa_source_new_data_done(&source_data);
        goto fail;
    }
    pa_source_new_data_done(&source_data);

    u->source->userdata = u;
    u->source->parent.process_msg = source_process_msg;
    u->source->set_state_in_main_thread = state_func;

    pa_source_set_asyncmsgq(u->source, u->thread_mq.inq);
    pa_source_set_rtpoll(u->source, u->rtpoll);

    pa_modargs_get_value_u32(ma, "latency", &latency);
    u->block_usec = latency
        ? PA_USEC_PER_MSEC * latency
        : PA_USEC_PER_MSEC * 125;
    pa_source_set_fixed_latency(u->source, u->block_usec);

    u->nbytes = pa_usec_to_bytes(u->block_usec, &u->source->sample_spec);
    u->buf = calloc(1, u->nbytes);
    u->memchunk.memblock = pa_memblock_new_fixed(m->core->mempool, u->buf, u->nbytes, false);

    if (!(u->thread = pa_thread_new("sles-source", thread_func, u))) {
        pa_log("Failed to create thread.");
        goto fail;
    }
    pa_source_put(u->source);
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

    return pa_source_linked_by(u->source);
}

void pa__done(pa_module *m) {
    struct userdata *u;

    pa_assert(m);

    if (!(u = m->userdata))
        return;

    if (u->source)
        pa_source_unlink(u->source);

    if (u->RecorderObject)
        (*u->RecorderObject)->Destroy(u->RecorderObject);
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

    if (u->source)
        pa_source_unref(u->source);
    if (u->rtpoll_item)
        pa_rtpoll_item_free(u->rtpoll_item);
    if (u->sles_msgq)
        pa_asyncmsgq_unref(u->sles_msgq);
    if (u->rtpoll)
        pa_rtpoll_free(u->rtpoll);

    pa_xfree(u);
}
