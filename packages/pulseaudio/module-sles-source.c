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

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>

#include <pulse/rtclock.h>
#include <pulse/timeval.h>
#include <pulse/xmalloc.h>

#include <pulsecore/source.h>
#include <pulsecore/module.h>
#include <pulsecore/core-util.h>
#include <pulsecore/modargs.h>
#include <pulsecore/log.h>
#include <pulsecore/thread.h>
#include <pulsecore/thread-mq.h>
#include <pulsecore/rtpoll.h>
#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>
#include <SLES/OpenSLES_AndroidConfiguration.h>


PA_MODULE_AUTHOR("Lennart Poettering");
PA_MODULE_DESCRIPTION("Android OpenSL ES source");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
        "source_name=<name for the source> "
        "source_properties=<properties for the source> "
        "rate=<sample rate> "
	"channel_map=<channel map>"
	"latency=<buffer length>"

);
#define CHK(stmt) { \
    SLresult res = stmt; \
    if (res != SL_RESULT_SUCCESS) { \
        fprintf(stderr, "error %d at %s:%d\n", res, __FILE__, __LINE__); \
        goto fail; \
    } \
}

#define DEFAULT_SOURCE_NAME "OpenSL ES source"
#define BLOCK_USEC (PA_USEC_PER_MSEC * 125)

enum {
	    SOURCE_MESSAGE_RENDER = PA_SOURCE_MESSAGE_MAX
};                                

struct userdata {
    pa_core *core;
    pa_module *module;
    pa_source *source;
    pa_thread *thread;
    pa_thread_mq thread_mq;
    pa_rtpoll *rtpoll;
    pa_rtpoll_item *rtpoll_item;

    pa_memchunk memchunk;
    
    pa_usec_t block_usec; /* how much to push at once */
    pa_usec_t timestamp;  /* when to push next */
    SLObjectItf engineObject;
    SLObjectItf RecorderObject;
    SLEngineItf EngineItf;
    SLRecordItf recordItf;
    SLAndroidSimpleBufferQueueItf recBuffQueueItf; 
    pa_asyncmsgq *sles_msgq;
    void *buf;
    size_t nbytes;
};

static const char* const valid_modargs[] = {
    "source_name",
    "source_properties",
    "rate",
    "latency",
    NULL
};
static void thread_func(void *userdata) {
    struct userdata *u = userdata;

    pa_assert(u);

    pa_log_debug("Thread starting up");
    pa_thread_mq_install(&u->thread_mq);

    for (;;) {
        int ret;

        if ((ret = pa_rtpoll_run(u->rtpoll)) < 0)
            goto fail;

        if (ret == 0)                                                                                                                                                                                               goto finish;
    }

fail:
    /* If this was no regular exit from the loop we have to continue
     * processing messages until we received PA_MESSAGE_SHUTDOWN */
    pa_asyncmsgq_post(u->thread_mq.outq, PA_MSGOBJECT(u->core), PA_CORE_MESSAGE_UNLOAD_MODULE, u->module, 0, NULL, NULL);
    pa_asyncmsgq_wait_for(u->thread_mq.inq, PA_MESSAGE_SHUTDOWN);

finish:
    pa_log_debug("Thread shutting down");
}

static int state_func(pa_source *s, pa_source_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = s->userdata;
    if (PA_SOURCE_IS_OPENED(s->state) &&
        (state == PA_SOURCE_SUSPENDED || state == PA_SOURCE_UNLINKED))
	(*u->recordItf)->SetRecordState(u->recordItf, SL_RECORDSTATE_STOPPED);
    else if ((s->state == PA_SOURCE_SUSPENDED || s->state == PA_SOURCE_INIT) &&
             PA_SOURCE_IS_OPENED(state))
    	(*u->recordItf)->SetRecordState(u->recordItf, SL_RECORDSTATE_RECORDING);
    return 0;
}
static void process_render(void *userdata) {
    struct userdata* u = userdata;
    pa_assert(u);
    (*u->recordItf)->SetRecordState(u->recordItf, SL_RECORDSTATE_RECORDING);
    if (!PA_SOURCE_IS_LINKED(u->source->thread_info.state))
        return;

    u->memchunk.length = u->nbytes;
	(*u->recBuffQueueItf)->Enqueue(u->recBuffQueueItf, u->buf, u->memchunk.length);
	pa_source_post(u->source, &u->memchunk);
}

static int source_process_msg(pa_msgobject *o, int code, void *data, int64_t offset, pa_memchunk *memchunk) {
    switch (code) {
        case SOURCE_MESSAGE_RENDER:
            process_render(data);
            return 0;                                                                                                                                                                                       }
                                                                                                                                                                                                            return pa_source_process_msg(o, code, data, offset, memchunk);
};



static void sles_callback(SLAndroidSimpleBufferQueueItf recBuffQueueItf , void *userdata) {
    struct userdata* u = userdata;
    pa_assert(u);
    pa_assert_se(pa_asyncmsgq_send(u->sles_msgq, PA_MSGOBJECT(u->source), SOURCE_MESSAGE_RENDER, u, 0, NULL) == 0); 
}


static int pa_init_sles_record(struct userdata *u, pa_sample_spec *ss) {
    pa_assert(u); 
    SLboolean	 required[2];
    SLInterfaceID  iidArray[2];
   
    required[0] = SL_BOOLEAN_FALSE;
    iidArray[0] = SL_IID_ANDROIDSIMPLEBUFFERQUEUE;
    required[1] = SL_BOOLEAN_FALSE;
    iidArray[1] = SL_IID_ANDROIDCONFIGURATION;

    SLAndroidConfigurationItf configItf;    
    SLDataSource           recSource;
    SLDataLocator_IODevice ioDevice = {SL_DATALOCATOR_IODEVICE,
    SL_IODEVICE_AUDIOINPUT,
    SL_DEFAULTDEVICEID_AUDIOINPUT, NULL};
    SLDataSink                recDest;
    SLDataLocator_AndroidSimpleBufferQueue recBuffQueue;
    
    ioDevice.locatorType = SL_DATALOCATOR_IODEVICE; 
    ioDevice.deviceType = SL_IODEVICE_AUDIOINPUT; 
    ioDevice.deviceID = SL_DEFAULTDEVICEID_AUDIOINPUT;
    ioDevice.device = NULL;
    recSource.pLocator = (void *) &ioDevice; 
    recBuffQueue.locatorType = SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE;
    recBuffQueue.numBuffers = 8; 
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
    pcm.channelMask = SL_SPEAKER_FRONT_LEFT;
    pcm.endianness = SL_BYTEORDER_LITTLEENDIAN; 
    
    recDest.pLocator = (void *) &recBuffQueue; 
    recDest.pFormat = (void * ) &pcm;
    
    CHK(slCreateEngine( &u->engineObject, 0, NULL, 0, NULL, NULL));
    CHK((*u->engineObject)->Realize(u->engineObject, SL_BOOLEAN_FALSE)); 
    CHK((*u->engineObject)->GetInterface(u->engineObject, SL_IID_ENGINE, (void*)&u->EngineItf));
    CHK((*u->EngineItf)->CreateAudioRecorder(u->EngineItf, &u->RecorderObject, &recSource, &recDest,
		    2, iidArray, required));
    CHK((*u->engineObject)->GetInterface(u->RecorderObject, SL_IID_ANDROIDCONFIGURATION, (void*)&configItf));
    SLuint32 presetValue = SL_ANDROID_RECORDING_PRESET_VOICE_RECOGNITION;
    CHK((*configItf)->SetConfiguration(configItf, SL_ANDROID_KEY_RECORDING_PRESET,
		    &presetValue, sizeof(SLuint32)));

    presetValue = SL_ANDROID_RECORDING_PRESET_NONE; 
    SLuint32 presetSize = 2*sizeof(SLuint32); // intentionally too big       
    CHK((*configItf)->GetConfiguration(configItf, SL_ANDROID_KEY_RECORDING_PRESET,
		    &presetSize, (void*)&presetValue)); 
if (presetValue != SL_ANDROID_RECORDING_PRESET_VOICE_RECOGNITION) {
	fprintf(stderr, "Error retrieved recording preset\n");
}

    CHK((*u->engineObject)->Realize(u->RecorderObject, SL_BOOLEAN_FALSE)); 
    CHK((*u->RecorderObject)->GetInterface(u->RecorderObject, SL_IID_RECORD, (void*)&u->recordItf));
    CHK((*u->RecorderObject)->GetInterface(u->RecorderObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE,  
		(void*)&u->recBuffQueueItf));
    CHK((*u->recBuffQueueItf)->RegisterCallback(u->recBuffQueueItf, sles_callback, u));
    
     return 0;

fail:
     return -1;
}


int pa__init(pa_module*m) {
    struct userdata *u = NULL;
    pa_modargs *ma;
    pa_source_new_data data;
    pa_sample_spec ss;
    uint32_t latency = 0;
    pa_assert(m);
    m->userdata = u = pa_xnew0(struct userdata, 1);
    if (!(ma = pa_modargs_new(m->argument, valid_modargs))) {
        pa_log("failed to parse module arguments.");
        goto fail;
    }
    ss = m->core->default_sample_spec;

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
	ss.channels = 1;

    if (pa_modargs_get_sample_rate(ma, &ss.rate) < 0) {
        pa_log("Invalid rate specification");
        goto fail;
    }

    u->core = m->core;
    u->module = m;
    u->rtpoll = pa_rtpoll_new();


    if (pa_thread_mq_init(&u->thread_mq, m->core->mainloop, u->rtpoll) < 0) {
        pa_log("pa_thread_mq_init() failed.");
        goto fail;
    }
    
    u->sles_msgq = pa_asyncmsgq_new(0);
    if (!u->sles_msgq) {
        pa_log("pa_asyncmsgq_new() failed.");
        goto fail;
    }
	u->rtpoll_item = pa_rtpoll_item_new_asyncmsgq_read(u->rtpoll, PA_RTPOLL_EARLY-1, u->sles_msgq);
	
    pa_source_new_data_init(&data);
    data.driver = __FILE__;
    data.module = m;
    pa_source_new_data_set_name(&data, pa_modargs_get_value(ma, "source_name", DEFAULT_SOURCE_NAME));
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_DESCRIPTION, _("OpenSL ES Input"));
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_CLASS, "abstract");
    
    pa_source_new_data_set_sample_spec(&data, &ss);

    if (pa_modargs_get_proplist(ma, "source_properties", data.proplist, PA_UPDATE_REPLACE) < 0) {
        pa_log("Invalid properties");
        pa_source_new_data_done(&data);
        goto fail;
    }
	
    u->source = pa_source_new(m->core, &data, PA_SOURCE_LATENCY);
    pa_source_new_data_done(&data);

    if (!u->source) {
        pa_log("Failed to create source.");
        goto fail;
    }

    u->source->parent.process_msg = source_process_msg;
    u->source->set_state_in_main_thread = state_func;
    u->source->userdata = u;

    u->block_usec = BLOCK_USEC;

    pa_source_set_asyncmsgq(u->source, u->thread_mq.inq);
    pa_source_set_rtpoll(u->source, u->rtpoll);

    pa_modargs_get_value_u32(ma, "latency", &latency);
    if (latency)
        u->block_usec = latency * PA_USEC_PER_MSEC;
    else
        u->block_usec = BLOCK_USEC;
    pa_source_set_fixed_latency(u->source, u->block_usec);

    u->nbytes = pa_usec_to_bytes(u->block_usec, &u->source->sample_spec);
    u->buf = calloc(8, u->nbytes);
    u->memchunk.memblock = pa_memblock_new_fixed(m->core->mempool, u->buf, u->nbytes, false);
    if (pa_init_sles_record(u, &ss) < 0)
	goto fail;         
    if (!(u->thread = pa_thread_new("sles_source", thread_func, u))) {
        pa_log("Failed to create thread.");
        goto fail;
    }
    pa_source_put(u->source);
    sles_callback(u->recBuffQueueItf, u);
    pa_modargs_free(ma);

    return 0;

fail:
    if (ma)
        pa_modargs_free(ma);

    pa__done(m);

    return -1;
}

#undef CHK

int pa__get_n_used(pa_module *m) {
    struct userdata *u;

    pa_assert(m);
    pa_assert_se(u = m->userdata);

    return pa_source_linked_by(u->source);
}
#define DESTROY(object) if (u->object) (*u->object)->Destroy(u->object);

void pa__done(pa_module*m) {
    struct userdata *u;

    pa_assert(m);

    if (!(u = m->userdata))
        return;

    if (u->source)
        pa_source_unlink(u->source);

    DESTROY(RecorderObject);
    DESTROY(engineObject);

    if (u->thread) {
        pa_asyncmsgq_send(u->thread_mq.inq, NULL, PA_MESSAGE_SHUTDOWN, NULL, 0, NULL);
        pa_thread_free(u->thread);
    }

    pa_thread_mq_done(&u->thread_mq);

    if (u->source)
        pa_source_unref(u->source);

    if (u->memchunk.memblock)
        pa_memblock_unref(u->memchunk.memblock);

    if (u->rtpoll)
        pa_rtpoll_free(u->rtpoll);

    pa_xfree(u);
}
