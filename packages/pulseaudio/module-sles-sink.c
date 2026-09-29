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

PA_MODULE_AUTHOR("Lennart Poettering, Nathan Martynov, Patrick Gaskin");
PA_MODULE_DESCRIPTION("Android OpenSL ES sink");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE(
    "sink_name=<name for the sink> "
    "sink_properties=<properties for the sink> "
    "latency=<buffer length> "
    "format=<sample format> "
    "channels=<number of channels> "
    "rate=<sample rate> "
    "channel_map=<channel map> "
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
    "latency",
    "format",
    "channels",
    "rate",
    "channel_map",
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

// pa_channel_position_to_sl_speaker converts a PulseAudio channel position to
// the equivalent OpenSL ES speaker. If the channel does not have a OpenSL ES
// equivalent or is PA_CHANNEL_POSITION_INVALID, -1 is returned.
//
// https://freedesktop.org/software/pulseaudio/doxygen/channelmap_8h.html#af1cbe2738487c74f99e613779bd34bf2
// https://www.khronos.org/files/opensl_es_1_0_provisional_specs.pdf#9.2.47
static SLuint32 pa_channel_position_to_sl_speaker(enum pa_channel_position x) {
    static const SLuint32 pa_channel_position_sl_speaker[] = {
        // note: all SL_SPEAKER values != 0, and the empty array elements will be initialized to 0
        [PA_CHANNEL_POSITION_MONO]                  = SL_SPEAKER_FRONT_CENTER,
        [PA_CHANNEL_POSITION_FRONT_LEFT]            = SL_SPEAKER_FRONT_LEFT,
        [PA_CHANNEL_POSITION_FRONT_RIGHT]           = SL_SPEAKER_FRONT_RIGHT,
        [PA_CHANNEL_POSITION_FRONT_CENTER]          = SL_SPEAKER_FRONT_CENTER,
        [PA_CHANNEL_POSITION_REAR_CENTER]           = SL_SPEAKER_BACK_CENTER,
        [PA_CHANNEL_POSITION_REAR_LEFT]             = SL_SPEAKER_BACK_LEFT,
        [PA_CHANNEL_POSITION_REAR_RIGHT]            = SL_SPEAKER_BACK_RIGHT,
        [PA_CHANNEL_POSITION_LFE]                   = SL_SPEAKER_LOW_FREQUENCY,
        [PA_CHANNEL_POSITION_FRONT_LEFT_OF_CENTER]  = SL_SPEAKER_FRONT_LEFT_OF_CENTER,
        [PA_CHANNEL_POSITION_FRONT_RIGHT_OF_CENTER] = SL_SPEAKER_FRONT_RIGHT_OF_CENTER,
        [PA_CHANNEL_POSITION_SIDE_LEFT]             = SL_SPEAKER_SIDE_LEFT,
        [PA_CHANNEL_POSITION_SIDE_RIGHT]            = SL_SPEAKER_SIDE_RIGHT,
        [PA_CHANNEL_POSITION_TOP_CENTER]            = SL_SPEAKER_TOP_CENTER,
        [PA_CHANNEL_POSITION_TOP_FRONT_LEFT]        = SL_SPEAKER_TOP_FRONT_LEFT,
        [PA_CHANNEL_POSITION_TOP_FRONT_RIGHT]       = SL_SPEAKER_TOP_FRONT_RIGHT,
        [PA_CHANNEL_POSITION_TOP_FRONT_CENTER]      = SL_SPEAKER_TOP_FRONT_CENTER,
        [PA_CHANNEL_POSITION_TOP_REAR_LEFT]         = SL_SPEAKER_TOP_BACK_LEFT,
        [PA_CHANNEL_POSITION_TOP_REAR_RIGHT]        = SL_SPEAKER_TOP_BACK_RIGHT,
        [PA_CHANNEL_POSITION_TOP_REAR_CENTER]       = SL_SPEAKER_TOP_BACK_CENTER,
    };
    pa_assert(x < PA_CHANNEL_POSITION_MAX);
    return pa_channel_position_sl_speaker[x] ?: (SLuint32)(-1);
}

// sl_speaker_to_pa_channel_position converts an OpenSL ES speaker to the
// equivalent PulseAudio channel position. If the channel does not have a PA
// equivalent or is invalid, PA_CHANNEL_POSITION_INVALID is returned. Note that
// this function does not handle the edge case where (SL_SPEAKER_FRONT_CENTER &&
// channels == 1) is PA_CHANNEL_POSITION_MONO.
//
// https://freedesktop.org/software/pulseaudio/doxygen/channelmap_8h.html#af1cbe2738487c74f99e613779bd34bf2
// https://www.khronos.org/files/opensl_es_1_0_provisional_specs.pdf#9.2.47
static enum pa_channel_position sl_speaker_to_pa_channel_position(SLuint32 x) {
    for (enum pa_channel_position pa = 0; pa < PA_CHANNEL_POSITION_MAX; pa++) {
        if (pa != PA_CHANNEL_POSITION_MONO && pa_channel_position_to_sl_speaker(pa) == x) {
            return pa;
        }
    }
    return -1;
}

// pa_channel_map_to_sl_channel_mask converts a PulseAudio channel map to an
// OpenSL ES channel mask. If an unknown or unsupported channel position is
// found, -1 is returned. If map is NULL, 0 is returned.
//
// https://freedesktop.org/software/pulseaudio/doxygen/channelmap_8h.html#af1cbe2738487c74f99e613779bd34bf2
// https://www.khronos.org/files/opensl_es_1_0_provisional_specs.pdf#9.1.8
static SLuint32 pa_channel_map_to_sl_channel_mask(pa_channel_map *map) {
    SLuint32 mask = 0, cur = 0, last = 0;
    if (!map)
        return 0;
    for (int i = 0; i < map->channels; i++) {
        if (map->map[i] == PA_CHANNEL_POSITION_INVALID) {
            pa_log("Invalid channel found in channel map at position %d.", i);
            return -1;
        }
        if ((cur = pa_channel_position_to_sl_speaker(map->map[i])) == -1) {
            pa_log("No OpenSL ES equivalent for %s.", pa_channel_position_to_string(map->map[i]));;
            return -1;
        }
        if (cur < last)
            pa_log("Warning: Channel map does not match the OpenSL ES speaker order (%s should be before %s).", pa_channel_position_to_string(cur), pa_channel_position_to_string(last));
        mask |= last = cur;
    }
    return mask;
}

// sl_channel_mask_to_pa_channel_map converts an OpenSL ES channel mask to a
// PulseAudio channel map by sorting the channels in order. On success, a 0 is
// returned. If an unknown channel is present or there are too many channels, -1
// is returned and rmap is left untouched.
//
// https://www.khronos.org/files/opensl_es_1_0_provisional_specs.pdf#9.1.8
static int sl_channel_mask_to_pa_channel_map(SLuint32 mask, pa_channel_map *rmap) {
    static const SLuint32 speakers[] = {
        SL_SPEAKER_FRONT_LEFT, SL_SPEAKER_FRONT_RIGHT, SL_SPEAKER_FRONT_CENTER,
        SL_SPEAKER_LOW_FREQUENCY, SL_SPEAKER_BACK_LEFT, SL_SPEAKER_BACK_RIGHT,
        SL_SPEAKER_FRONT_LEFT_OF_CENTER, SL_SPEAKER_FRONT_RIGHT_OF_CENTER,
        SL_SPEAKER_BACK_CENTER, SL_SPEAKER_SIDE_LEFT, SL_SPEAKER_SIDE_RIGHT,
        SL_SPEAKER_TOP_CENTER, SL_SPEAKER_TOP_FRONT_LEFT,
        SL_SPEAKER_TOP_FRONT_CENTER, SL_SPEAKER_TOP_FRONT_RIGHT,
        SL_SPEAKER_TOP_BACK_LEFT, SL_SPEAKER_TOP_BACK_CENTER,
        SL_SPEAKER_TOP_BACK_RIGHT,
    };
    pa_channel_map map = {0};
    pa_assert(rmap);
    if (mask == SL_SPEAKER_FRONT_CENTER) {
        rmap->channels = 1;
        rmap->map[0] = PA_CHANNEL_POSITION_MONO;
        return 0;
    }
    for (size_t i = 0; i < sizeof(speakers)/sizeof(*speakers); i++) {
        pa_assert(i == 0 || speakers[i] > speakers[i-1]);
        if (mask & speakers[i]) {
            mask ^= speakers[i];
            pa_assert((map.map[map.channels] = sl_speaker_to_pa_channel_position(speakers[i])) != -1);
            if (++map.channels == PA_CHANNELS_MAX) {
                pa_log("Too many channels in sl mask");
                return -1;
            }
        }
    }
    if (mask) {
        pa_log("Unknown channel in sl mask (left: %u)", mask);
        return -1;
    }
    *rmap = map;
    return 0;
}

// sl_guess_channel_mask guesses the speakers used for a certain number of
// channels. It uses the same logic as Chromium and works correctly on most
// devices. If the number of channels is unsupported, -1 is returned.
//
// https://source.chromium.org/chromium/chromium/src/+/master:media/audio/android/opensles_util.cc;l=23-50;drc=6ae2127739229f68ed7cd466012db4c6e5e6bbcd
// https://github.com/google/oboe/blob/52e2163781c8f485f5e67b081c94043a6e8dff15/src/opensles/AudioOutputStreamOpenSLES.cpp#L69-L110
// https://www2.iis.fraunhofer.de/AAC/multichannel.html (for testing)
// https://www.youtube.com/watch?v=MkVyFZi8ClE (also good for testing)
static SLuint32 sl_guess_channel_mask(int channels) {
    #define SL_ANDROID_SPEAKER_QUAD (SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT | SL_SPEAKER_BACK_LEFT | SL_SPEAKER_BACK_RIGHT)
    #define SL_ANDROID_SPEAKER_5DOT1 (SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT | SL_SPEAKER_FRONT_CENTER | SL_SPEAKER_LOW_FREQUENCY | SL_SPEAKER_BACK_LEFT | SL_SPEAKER_BACK_RIGHT)
    #define SL_ANDROID_SPEAKER_7DOT1 (SL_ANDROID_SPEAKER_5DOT1 | SL_SPEAKER_SIDE_LEFT | SL_SPEAKER_SIDE_RIGHT)
    if (channels > 2)
        pa_log("Warning: Guessing channel layout for > 2 channels, order may be be incorrect.");
    switch (channels) {
        case 1: return SL_SPEAKER_FRONT_CENTER;
        case 2: return SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT;
        case 3: return SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT | SL_SPEAKER_FRONT_CENTER;
        case 4: return SL_ANDROID_SPEAKER_QUAD;
        case 5: return SL_ANDROID_SPEAKER_QUAD | SL_SPEAKER_FRONT_CENTER;
        case 6: return SL_ANDROID_SPEAKER_5DOT1;
        case 7: return SL_ANDROID_SPEAKER_5DOT1 | SL_SPEAKER_BACK_CENTER;
        case 8: return SL_ANDROID_SPEAKER_7DOT1;
        default:
            pa_log("No guess for %d channels.", channels);
            return -1;
    }
    #undef SL_ANDROID_SPEAKER_7DOT1
    #undef SL_ANDROID_SPEAKER_5DOT1
    #undef SL_ANDROID_SPEAKER_QUAD
}

static int pa_sample_spec_to_sl_format(pa_sample_spec *ss, pa_channel_map *map, SLAndroidDataFormat_PCM_EX *sl) {
    pa_assert(ss);
    pa_assert(sl);

    *sl = (SLAndroidDataFormat_PCM_EX){0};

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
    sl->sampleRate = ss->rate * 1000; // Hz to mHz

    if (map) {
        pa_assert((sl->numChannels = ss->channels) == map->channels);
        if ((sl->channelMask = pa_channel_map_to_sl_channel_mask(map)) == (SLuint32)(-1)) {
            pa_log_error("Unsupported sample format: no sl equivalent for channel map.");
            return 1;
        }
    } else {
        if ((sl->channelMask = sl_guess_channel_mask((sl->numChannels = ss->channels))) == (SLuint32)(-1)) {
            pa_log_error("Unsupported sample format: could not guess channel mask for provided number of channels.");
            return 1;
        }
    }

    return 0;
}

// pa_channel_map_init_sles is pa_channel_map_init from PulseAudio, but modified
// to use sl_guess_channel_mask.
//
// https://github.com/pulseaudio/pulseaudio/blob/7f4d7fcf5f6407913e50604c6195d0d5356195b1/src/pulse/channelmap.c#L165-L395
static pa_channel_map *pa_channel_map_init_sles(pa_channel_map *m, unsigned channels) {
    pa_assert(m);
    pa_assert(pa_channels_valid(channels));
    pa_channel_map_init(m);
    SLuint32 mask = sl_guess_channel_mask(channels);
    if (mask == (SLuint32)(-1))
        return NULL;
    pa_assert(sl_channel_mask_to_pa_channel_map(mask, m) != -1);
    pa_assert(m->channels == channels);
    return m;
}

// pa_channel_map_init_extend_sles is pa_channel_map_init_extend from
// PulseAudio, but modified to use pa_channel_map_init_sles.
//
// https://github.com/pulseaudio/pulseaudio/blob/7f4d7fcf5f6407913e50604c6195d0d5356195b1/src/pulse/channelmap.c#L397-L424
static pa_channel_map* pa_channel_map_init_extend_sles(pa_channel_map *m, unsigned channels) {
    unsigned c;
    pa_assert(m);
    pa_assert(pa_channels_valid(channels));
    pa_channel_map_init(m);
    for (c = channels; c > 0; c--) {
        if (pa_channel_map_init_sles(m, c)) {
            unsigned i = 0;
            for (; c < channels; c++) {
                m->map[c] = PA_CHANNEL_POSITION_AUX0 + i;
                i++;
            }
            m->channels = (uint8_t) channels;
            return m;
        }
    }
    return NULL;
}

// pa_modargs_get_sample_spec_and_channel_map_sles is
// pa_modargs_get_sample_spec_and_channel_map from PulseAudio, but modified
// to use the previous two functions.
//
// https://github.com/pulseaudio/pulseaudio/blob/7f4d7fcf5f6407913e50604c6195d0d5356195b1/src/pulsecore/modargs.c#L479-L515
static int pa_modargs_get_sample_spec_and_channel_map_sles(pa_modargs *ma, pa_sample_spec *rss, pa_channel_map *rmap) {
    pa_sample_spec ss;
    pa_channel_map map;
    pa_assert(rss);
    pa_assert(rmap);
    ss = *rss;
    if (pa_modargs_get_sample_spec(ma, &ss) < 0)
        return -1;
    map = *rmap;
    if (ss.channels != map.channels)
        pa_channel_map_init_extend_sles(&map, ss.channels);
    if (pa_modargs_get_channel_map(ma, NULL, &map) < 0)
        return -1;
    if (map.channels != ss.channels) {
        if (!pa_modargs_get_value(ma, "channels", NULL))
            ss.channels = map.channels;
        else
            return -1;
    }
    *rmap = map;
    *rss = ss;
    return 0;
}

static int pa_init_sles_player(struct userdata *u, pa_sample_spec *ss, pa_channel_map *map) {
    pa_assert(u);

    // check and convert the sample spec
    SLAndroidDataFormat_PCM_EX pcm;
    if (pa_sample_spec_to_sl_format(ss, map, &pcm))
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

static int state_func(pa_sink *s, pa_sink_state_t state, pa_suspend_cause_t suspend_cause) {
    struct userdata *u = s->userdata;
    pa_assert(u);

    if (PA_SINK_IS_OPENED(s->state) && (state == PA_SINK_SUSPENDED || state == PA_SINK_UNLINKED))
        (*u->PlayItf)->SetPlayState(u->PlayItf, SL_PLAYSTATE_STOPPED);
    else if ((s->state == PA_SINK_SUSPENDED || s->state == PA_SINK_INIT) && PA_SINK_IS_OPENED(state))
        (*u->PlayItf)->SetPlayState(u->PlayItf, SL_PLAYSTATE_PLAYING);
    return 0;
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

    ss  = m->core->default_sample_spec;
    map = m->core->default_channel_map;
    if (pa_modargs_get_sample_spec_and_channel_map_sles(ma, &ss, &map) < 0) {
        pa_log("Invalid sample format specification or channel map.");
        goto fail;
    }

    if (pa_init_sles_player(u, &ss, &map))
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

void pa__done(pa_module *m) {
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
