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

//Only certain interfaces are supported by the fast mixer. These are:
//SL_IID_ANDROIDSIMPLEBUFFERQUEUE
//SL_IID_VOLUME
//SL_IID_MUTESOLO
#define USE_ANDROID_SIMPLE_BUFFER_QUEUE

#ifdef USE_ANDROID_SIMPLE_BUFFER_QUEUE
	#include <SLES/OpenSLES_Android.h>
	#define DATALOCATOR_BUFFERQUEUE SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE
	#define IID_BUFFERQUEUE SL_IID_ANDROIDSIMPLEBUFFERQUEUE
	#define BufferQueueItf SLAndroidSimpleBufferQueueItf
	#define BufferQueueState SLAndroidSimpleBufferQueueState
	#define IID_BUFFERQUEUE_USED SL_IID_ANDROIDSIMPLEBUFFERQUEUE
	#define INDEX index
#else
	#define DATALOCATOR_BUFFERQUEUE SL_DATALOCATOR_BUFFERQUEUE
	#define IID_BUFFERQUEUE SL_IID_BUFFERQUEUE
	#define BufferQueueItf SLBufferQueueItf
	#define BufferQueueState SLBufferQueueState
	#define IID_BUFFERQUEUE_USED IID_BUFFERQUEUE
	#define INDEX playIndex
#endif

#define checkResult(r) do { \
	if ((r) != SL_RESULT_SUCCESS) { \
		if ((r) == SL_RESULT_PARAMETER_INVALID) fprintf(stderr, "error SL_RESULT_PARAMETER_INVALID at %s:%d\n", __FILE__, __LINE__); \
		else if ((r) == SL_RESULT_PRECONDITIONS_VIOLATED ) fprintf(stderr, "error SL_RESULT_PRECONDITIONS_VIOLATED at %s:%d\n", __FILE__, __LINE__); \
		else fprintf(stderr, "error %d at %s:%d\n", (int) r, __FILE__, __LINE__); \
		} \
	} while (0)

PA_MODULE_AUTHOR("Lennart Poettering, Nathan Martynov");
PA_MODULE_DESCRIPTION("Android OpenSL ES sink");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
        "sink_name=<name for the sink> "
        "sink_properties=<properties for the sink> "
        "rate=<sampling rate> ");

#define DEFAULT_SINK_NAME "OpenSL ES sink"
#define BLOCK_USEC (PA_USEC_PER_SEC * 2)

typedef struct pa_memblock_queue_t {
	pa_memblock *memblock;
	struct pa_memblock_queue_t* next;
} pa_memblock_queue;

struct userdata {
    pa_core *core;
    pa_module *module;
    pa_sink *sink;

    pa_thread *thread;
    pa_thread_mq thread_mq;
    pa_rtpoll *rtpoll;

    pa_usec_t block_usec;
    pa_usec_t timestamp;
    
    pa_memchunk memchunk;
    
	SLObjectItf engineObject;
	SLEngineItf engineEngine;
 
	// output mix interfaces
	SLObjectItf outputMixObject;
 
	// buffer queue player interfaces
	SLObjectItf bqPlayerObject;
	SLPlayItf bqPlayerPlay;
	BufferQueueItf bqPlayerBufferQueue;
	
	pa_memblock_queue* current;
	pa_memblock_queue* last;
};

static const char* const valid_modargs[] = {
    "sink_name",
    "sink_properties",
    "rate",
    NULL
};

static int sink_process_msg(
        pa_msgobject *o,
        int code,
        void *data,
        int64_t offset,
        pa_memchunk *chunk) {

    struct userdata *u = PA_SINK(o)->userdata;

    switch (code) {
        case PA_SINK_MESSAGE_SET_STATE:

            if (pa_sink_get_state(u->sink) == PA_SINK_SUSPENDED || pa_sink_get_state(u->sink) == PA_SINK_INIT) {
                if (PA_PTR_TO_UINT(data) == PA_SINK_RUNNING || PA_PTR_TO_UINT(data) == PA_SINK_IDLE)
                    u->timestamp = pa_rtclock_now();
            }

            break;

        case PA_SINK_MESSAGE_GET_LATENCY: {
            pa_usec_t now;

            now = pa_rtclock_now();
            *((pa_usec_t*) data) = u->timestamp > now ? u->timestamp - now : 0ULL;

            return 0;
        }
    }

    return pa_sink_process_msg(o, code, data, offset, chunk);
}

static void sink_update_requested_latency_cb(pa_sink *s) {
    struct userdata *u;
    size_t nbytes;

    pa_sink_assert_ref(s);
    pa_assert_se(u = s->userdata);

    u->block_usec = pa_sink_get_requested_latency_within_thread(s);

    if (u->block_usec == (pa_usec_t) -1)
        u->block_usec = s->thread_info.max_latency;

    nbytes = pa_usec_to_bytes(u->block_usec, &s->sample_spec);
    pa_sink_set_max_rewind_within_thread(s, nbytes);
    pa_sink_set_max_request_within_thread(s, nbytes);
}

static void pa_sles_callback(BufferQueueItf bq, void *context){
	struct userdata* s = (struct userdata*) context;
	pa_memblock_queue* next;
	if (s->current != NULL){
		if (s->current->memblock != NULL) pa_memblock_unref(s->current->memblock);
		next = s->current->next;
		free(s->current);
		s->current = next;
	}
}

static int pa_init_sles_player(struct userdata *s, SLint32 sl_rate)
{
	if (s == NULL) return -1;
	SLresult result;
	
	// create engine
	result = slCreateEngine(&(s->engineObject), 0, NULL, 0, NULL, NULL); checkResult(result);
	result = (*s->engineObject)->Realize(s->engineObject, SL_BOOLEAN_FALSE); checkResult(result);
	
	result = (*s->engineObject)->GetInterface(s->engineObject, SL_IID_ENGINE, &(s->engineEngine)); checkResult(result);
	
	// create output mix
	result = (*s->engineEngine)->CreateOutputMix(s->engineEngine, &(s->outputMixObject), 0, NULL, NULL);  checkResult(result);
	result = (*s->outputMixObject)->Realize(s->outputMixObject, SL_BOOLEAN_FALSE); checkResult(result);
	
	// create audio player
		
	SLDataLocator_OutputMix locator_outputmix;
	locator_outputmix.locatorType = SL_DATALOCATOR_OUTPUTMIX;
	locator_outputmix.outputMix = s->outputMixObject;
	
	SLDataLocator_BufferQueue locator_bufferqueue;
	locator_bufferqueue.locatorType = DATALOCATOR_BUFFERQUEUE;
	locator_bufferqueue.numBuffers = 50;
	
	if (sl_rate < SL_SAMPLINGRATE_8 || sl_rate > SL_SAMPLINGRATE_192) {
		pa_log("Incompatible sample rate");
		return -1;
	}
	
	SLDataFormat_PCM pcm;
	pcm.formatType = SL_DATAFORMAT_PCM;
	pcm.numChannels = 2;
	pcm.samplesPerSec = sl_rate;
	pcm.bitsPerSample = SL_PCMSAMPLEFORMAT_FIXED_16;
	pcm.containerSize = 16;
	pcm.channelMask = SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT;
	pcm.endianness = SL_BYTEORDER_LITTLEENDIAN;
	
	SLDataSource audiosrc;
	audiosrc.pLocator = &locator_bufferqueue;
	audiosrc.pFormat = &pcm;
	
	SLDataSink audiosnk;
	audiosnk.pLocator = &locator_outputmix;
	audiosnk.pFormat = NULL;
	
	SLInterfaceID ids[1] = {IID_BUFFERQUEUE};
	SLboolean flags[1] = {SL_BOOLEAN_TRUE};
	result = (*s->engineEngine)->CreateAudioPlayer(s->engineEngine, &s->bqPlayerObject, &audiosrc, &audiosnk, 1, ids, flags);  checkResult(result);
	result = (*s->bqPlayerObject)->Realize(s->bqPlayerObject, SL_BOOLEAN_FALSE); checkResult(result);
	
	result = (*s->bqPlayerObject)->GetInterface(s->bqPlayerObject, SL_IID_PLAY, &s->bqPlayerPlay); checkResult(result);
	result = (*s->bqPlayerObject)->GetInterface(s->bqPlayerObject, IID_BUFFERQUEUE_USED, &s->bqPlayerBufferQueue); checkResult(result);
	
    result = (*s->bqPlayerBufferQueue)->RegisterCallback(s->bqPlayerBufferQueue, pa_sles_callback, s); checkResult(result);
	
	result = (*s->bqPlayerPlay)->SetPlayState(s->bqPlayerPlay, SL_PLAYSTATE_PLAYING); checkResult(result);
	
	return 0;
}

static void pa_destroy_sles_player(struct userdata *s){
	if (s == NULL) return;
	(*s->bqPlayerPlay)->SetPlayState(s->bqPlayerPlay, SL_PLAYSTATE_STOPPED);
	(*s->bqPlayerObject)->Destroy(s->bqPlayerObject);
	(*s->outputMixObject)->Destroy(s->outputMixObject);
	(*s->engineObject)->Destroy(s->engineObject);
}

static void process_render(struct userdata *u, pa_usec_t now) {
	pa_memblock_queue* current_block;
    size_t ate = 0;

    pa_assert(u);

    /* This is the configured latency. Sink inputs connected to us
    might not have a single frame more than the maxrequest value
    queued. Hence: at maximum read this many bytes from the sink
    inputs. */

    /* Fill the buffer up the latency size */
    while (u->timestamp < now + u->block_usec) {
        void *p;
		
        pa_sink_render(u->sink, u->sink->thread_info.max_request, &u->memchunk);
        p = pa_memblock_acquire(u->memchunk.memblock);
        (*u->bqPlayerBufferQueue)->Enqueue(u->bqPlayerBufferQueue, (uint8_t*) p + u->memchunk.index, u->memchunk.length);
        pa_memblock_release(u->memchunk.memblock);

        u->timestamp += pa_bytes_to_usec(u->memchunk.length, &u->sink->sample_spec);
        ate += u->memchunk.length;
        
        current_block = malloc(sizeof(pa_memblock_queue));
        memset(current_block, 0, sizeof(pa_memblock_queue));
        
        current_block->memblock = u->memchunk.memblock;
        if (u->current == NULL) { u->current = current_block; }
        if (u->last == NULL) { u->last = current_block; }
        else {
			u->last->next = current_block;
			u->last = current_block;
		}
        
        //pa_memblock_unref(u->memchunk.memblock);
        pa_memchunk_reset(&u->memchunk);
        if (ate >= u->sink->thread_info.max_request) break;
    }
}

static void thread_func(void *userdata) {
    struct userdata *u = userdata;

    pa_assert(u);

    pa_log_debug("Thread starting up");

    pa_thread_mq_install(&u->thread_mq);

    u->timestamp = pa_rtclock_now();

    for (;;) {
        pa_usec_t now = 0;
        int ret;

        if (PA_SINK_IS_OPENED(u->sink->thread_info.state))
            now = pa_rtclock_now();

        if (PA_UNLIKELY(u->sink->thread_info.rewind_requested))
              pa_sink_process_rewind(u->sink, 0);

        /* Render some data and drop it immediately */
        if (PA_SINK_IS_OPENED(u->sink->thread_info.state)) {
            if (u->timestamp <= now)
                process_render(u, now);

            pa_rtpoll_set_timer_absolute(u->rtpoll, u->timestamp);
        } else
            pa_rtpoll_set_timer_disabled(u->rtpoll);

        /* Hmm, nothing to do. Let's sleep */
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

static int getenv_int(const char * env, size_t min_len){
    char * got_env = getenv(env);
    int ret = 0;
    if (got_env != NULL && strlen(got_env) >= min_len) ret = atoi(got_env); //"8000" is 4 symbols
    return ret;
}

int pa__init(pa_module*m) {
    struct userdata *u = NULL;
    pa_sample_spec ss;
    pa_channel_map map;
    pa_modargs *ma = NULL;
    pa_sink_new_data data;
    size_t nbytes;

    pa_assert(m);

    if (!(ma = pa_modargs_new(m->argument, valid_modargs))) {
        pa_log("Failed to parse module arguments.");
        goto fail;
    }

    // High rate causes glitches on some devices, this is needed to prevent it
    //ss.rate = 32000;
    //ss.channels = 2;
    //ss.format = PA_SAMPLE_S16LE;
    
    //OK. That will allow users to define sampling rate under his responsibility
    ss = m->core->default_sample_spec;
    map = m->core->default_channel_map;
    if (pa_modargs_get_sample_spec_and_channel_map(ma, &ss, &map, PA_CHANNEL_MAP_DEFAULT) < 0) {
        pa_log("Invalid sample format specification or channel map");
        goto fail;
    }

	//Needed. Don't touch
    ss.channels = 2; 
    ss.format = PA_SAMPLE_S16LE;
    
    m->userdata = u = pa_xnew0(struct userdata, 1);
    
    int forceFormat = getenv_int("PROPERTY_OUTPUT_SAMPLE_RATE", 4); //"8000" is 4 symbols
    if (forceFormat >= 8000 && forceFormat <= 192000)  {
		ss.rate = forceFormat;
		pa_log_info("Sample rate was forced to be %u\n", ss.rate);
	}
	
    u->core = m->core;
    u->module = m;
    u->rtpoll = pa_rtpoll_new();
    pa_thread_mq_init(&u->thread_mq, m->core->mainloop, u->rtpoll);
	
	//Pulseaudio uses samples per sec but OpenSL ES uses samples per ms
	if (pa_init_sles_player(u, ss.rate * 1000) < 0)
		goto fail;
	//int buff[2] = {0, 0};
	//(*u->bqPlayerBufferQueue)->Enqueue(u->bqPlayerBufferQueue, buff, 1);

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

    u->sink = pa_sink_new(m->core, &data, PA_SINK_LATENCY|PA_SINK_DYNAMIC_LATENCY);
    pa_sink_new_data_done(&data);

    if (!u->sink) {
        pa_log("Failed to create sink object.");
        goto fail;
    }

    u->sink->parent.process_msg = sink_process_msg;
    u->sink->update_requested_latency = sink_update_requested_latency_cb;
    u->sink->userdata = u;

    pa_sink_set_asyncmsgq(u->sink, u->thread_mq.inq);
    pa_sink_set_rtpoll(u->sink, u->rtpoll);

    u->block_usec = BLOCK_USEC;
    nbytes = pa_usec_to_bytes(u->block_usec, &u->sink->sample_spec);
    pa_sink_set_max_rewind(u->sink, nbytes);
    pa_sink_set_max_request(u->sink, nbytes);

    if (!(u->thread = pa_thread_new("sles-sink", thread_func, u))) {
        pa_log("Failed to create thread.");
        goto fail;
    }

    pa_sink_set_latency_range(u->sink, 0, BLOCK_USEC);

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

    if (u->thread) {
        pa_asyncmsgq_send(u->thread_mq.inq, NULL, PA_MESSAGE_SHUTDOWN, NULL, 0, NULL);
        pa_thread_free(u->thread);
    }
    
    if (u->engineObject){
		pa_destroy_sles_player(u);
	}

    pa_thread_mq_done(&u->thread_mq);

    if (u->sink)
        pa_sink_unref(u->sink);

    if (u->rtpoll)
        pa_rtpoll_free(u->rtpoll);

    pa_xfree(u);
}
