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
#include <cerrno>
#include <cstring>
#include <memory>
#include <new>
#include <sys/eventfd.h>
#include <unistd.h>
#include <oboe/Oboe.h>
#include "oboe-pcm-bridge.h"

extern "C" {
#include <pulse/timeval.h>
#include <pulsecore/core-util.h>
#include <pulsecore/i18n.h>
#include <pulsecore/modargs.h>
#include <pulsecore/module.h>
#include <pulsecore/sink.h>
#include <pulsecore/thread.h>
#include <pulsecore/thread-mq.h>
#include <pulsecore/rtpoll.h>

PA_MODULE_AUTHOR("Termux");
PA_MODULE_DESCRIPTION("Android Oboe sink");
PA_MODULE_VERSION(PACKAGE_VERSION);
PA_MODULE_LOAD_ONCE(false);
PA_MODULE_USAGE("sink_name=<name> sink_properties=<properties> "
                "rate=<sampling rate> latency=<buffer length in ms>");
}

namespace {
struct userdata;
enum { MESSAGE_SET_GENERATION = PA_SINK_MESSAGE_MAX };

class Callback final : public oboe::AudioStreamDataCallback,
                       public oboe::AudioStreamErrorCallback {
public:
    explicit Callback(uint32_t frame_size) : pcm(frame_size), fd(eventfd(0, EFD_CLOEXEC | EFD_NONBLOCK)) {}
    ~Callback() override { if (fd >= 0) close(fd); }
    oboe::DataCallbackResult onAudioReady(oboe::AudioStream *, void *, int32_t) override;
    bool onError(oboe::AudioStream *, oboe::Result error) override {
        /* No PulseAudio objects are accessed from Oboe's detached worker.
         * Main owns close/reopen. Each generation has its own notification. */
        pending.store(static_cast<int>(error), std::memory_order_release);
        uint64_t one = 1;
        ssize_t result;
        do { result = write(fd, &one, sizeof(one)); } while (result < 0 && errno == EINTR);
        return true;
    }
    PcmBridge pcm;
    const int fd;
    std::atomic<int> pending{0};
};

struct userdata {
    pa_module *module = nullptr;
    pa_sink *endpoint = nullptr;
    pa_thread *thread = nullptr;
    pa_thread_mq mq{};
    bool mq_initialized = false;
    pa_rtpoll *rtpoll = nullptr;
    pa_io_event *error_event = nullptr;
    pa_sample_spec ss{};
    uint32_t rate = 0, latency = 0;
    size_t frame_size = 0;
    pa_usec_t fixed_latency = 0;
    std::shared_ptr<oboe::AudioStream> stream;
    std::shared_ptr<Callback> callback; // Main only
    std::shared_ptr<Callback> io_callback; // IO only; transferred through inq
};

const char *const valid_modargs[] = { "sink_name", "sink_properties", "rate", "latency", nullptr };

oboe::DataCallbackResult Callback::onAudioReady(oboe::AudioStream *, void *audio, int32_t frames) {
    pcm.playback(audio, frames);
    return oboe::DataCallbackResult::Continue;
}

void transfer_generation(userdata *u, const std::shared_ptr<Callback> *generation) {
    /* Control context only. IO copies this ownership before acknowledging; the
     * native data callback never accesses PA, userdata, or a shared_ptr. */
    pa_assert_se(pa_asyncmsgq_send(u->mq.inq, PA_MSGOBJECT(u->endpoint),
        MESSAGE_SET_GENERATION, const_cast<std::shared_ptr<Callback> *>(generation), 0, nullptr) == 0);
}

void close_stream(userdata *u) {
    if (u->error_event) {
        u->module->core->mainloop->io_free(u->error_event);
        u->error_event = nullptr;
    }
    if (u->callback)
        u->callback->pcm.close();
    if (u->stream) {
        const auto result = u->stream->closeAndWaitForCallbacks();
        if (result != oboe::Result::OK && result != oboe::Result::ErrorClosed)
            pa_log("Oboe close failed: %s", oboe::convertToText(result));
        /* Explicit completion joins library workers before module code can be
         * unmapped. IO and main retain the generation until it finishes. */
        u->stream.reset();
    }
    if (u->thread && u->endpoint)
        transfer_generation(u, nullptr);
    u->callback.reset();
}

void error_ready(pa_mainloop_api *, pa_io_event *, int, pa_io_event_flags_t, void *);

int open_stream(userdata *u) {
    close_stream(u);
    u->callback = std::make_shared<Callback>(pa_frame_size(&u->ss));
    if (u->callback->fd < 0)
        return -1;
    oboe::AudioStreamBuilder builder;
    builder.setDirection(oboe::Direction::Output)
        ->setSharingMode(oboe::SharingMode::Shared)
        ->setPerformanceMode(oboe::PerformanceMode::LowLatency)
        ->setFormat(u->ss.format == PA_SAMPLE_FLOAT32LE ? oboe::AudioFormat::Float : oboe::AudioFormat::I16)
        ->setChannelCount(u->ss.channels)
        ->setSampleRate(u->endpoint ? u->ss.rate : u->rate)
        ->setFormatConversionAllowed(false)
        ->setChannelConversionAllowed(false)
        ->setSampleRateConversionQuality(oboe::SampleRateConversionQuality::None)
        ->setDataCallback(u->callback)
        ->setErrorCallback(u->callback);
    const auto result = builder.openStream(u->stream);
    if (result != oboe::Result::OK) {
        pa_log("Oboe open failed: %s", oboe::convertToText(result));
        close_stream(u);
        return -1;
    }
    const auto rate = u->stream->getSampleRate();
    const auto format = u->ss.format == PA_SAMPLE_FLOAT32LE ? oboe::AudioFormat::Float : oboe::AudioFormat::I16;
    if (rate <= 0 || !pa_sample_rate_valid(rate) ||
        u->stream->getChannelCount() != u->ss.channels || u->stream->getFormat() != format ||
        (u->endpoint && rate != static_cast<int32_t>(u->ss.rate)) ||
        (u->rate && rate != static_cast<int32_t>(u->rate))) {
        pa_log("Oboe negotiated incompatible sample properties");
        close_stream(u);
        return -1;
    }
    u->ss.rate = rate;
    u->frame_size = pa_frame_size(&u->ss);
    if (!u->callback->pcm.configure(u->ss.rate, u->stream->getFramesPerBurst(),
            u->stream->getBufferSizeInFrames(), u->latency)) {
        pa_log("Oboe PCM buffering exceeds supported bounds or has no valid burst");
        close_stream(u);
        return -1;
    }
    u->fixed_latency = u->callback->pcm.configured_latency(true);
    u->error_event = u->module->core->mainloop->io_new(u->module->core->mainloop,
        u->callback->fd, PA_IO_EVENT_INPUT, error_ready, u);
    return 0;
}

void error_ready(pa_mainloop_api *, pa_io_event *, int fd, pa_io_event_flags_t, void *arg) {
    auto *u = static_cast<userdata *>(arg);
    uint64_t value;
    while (read(fd, &value, sizeof(value)) < 0 && errno == EINTR) {}
    const int error = u->callback->pending.exchange(0, std::memory_order_acq_rel);
    if (!error || !u->endpoint || !PA_SINK_IS_LINKED(u->endpoint->state))
        return;
    pa_log_debug("Oboe stream error: %s", oboe::convertToText(static_cast<oboe::Result>(error)));
    pa_sink_suspend(u->endpoint, true, PA_SUSPEND_UNAVAILABLE);
    if (pa_sink_suspend(u->endpoint, false, PA_SUSPEND_UNAVAILABLE) < 0)
        pa_log("Oboe stream could not be reopened");
}

void service_pcm(userdata *u, unsigned max_chunks) {
    if (!u->io_callback || !PA_SINK_IS_OPENED(u->endpoint->thread_info.state))
        return;
    auto &pcm = u->io_callback->pcm;
    for (unsigned pass = 0; pass < max_chunks && !pcm.closing(); ++pass) {
        // SET_STATE and rendering clients can request a rewind. Service it
        // before every render, including priming inside state acknowledgement.
        if (u->endpoint->thread_info.rewind_requested)
            pa_sink_process_rewind(u->endpoint, 0);
        const auto occupied = pcm.fifo->getFullFramesAvailable();
        if (occupied >= pcm.target) break;
        const auto frames = std::min(pcm.quantum, pcm.target - occupied);
        pa_memchunk data{};
        data.length = size_t(frames) * pcm.frame_size;
        data.memblock = pa_memblock_new_fixed(u->module->core->mempool,
            pcm.scratch.data(), data.length, false);
        pa_sink_render_into_full(u->endpoint, &data);
        pcm.fifo->write(pcm.scratch.data(), frames);
        /* PA can retain a rendered/posted block. Convert those references to
         * owned storage before the next scratch reuse. */
        pa_memblock_unref_fixed(data.memblock);
    }
}

void activate_generation(userdata *u) {
    if (u->io_callback && PA_SINK_IS_OPENED(u->endpoint->thread_info.state) &&
            u->io_callback->pcm.state.load(std::memory_order_acquire) == PcmBridge::Prepared) {
        service_pcm(u, 2);
        u->io_callback->pcm.activate();
    }
}

int process_msg(pa_msgobject *object, int code, void *data, int64_t offset, pa_memchunk *chunk) {
    auto *u = static_cast<userdata *>(PA_SINK(object)->userdata);
    if (code == MESSAGE_SET_GENERATION) {
        u->io_callback = data ? *static_cast<std::shared_ptr<Callback> *>(data) : nullptr;
        pa_rtpoll_set_timer_disabled(u->rtpoll);
        if (u->io_callback) {
            const auto &pcm = u->io_callback->pcm;
            pa_sink_set_fixed_latency_within_thread(u->endpoint, pcm.configured_latency(true));
            pa_sink_set_max_request_within_thread(u->endpoint, size_t(pcm.quantum) * pcm.frame_size);
        }
        return 0;
    }
    if (code == PA_SINK_MESSAGE_GET_LATENCY) {
        *static_cast<int64_t *>(data) = u->io_callback ? u->io_callback->pcm.latency() : 0;
        return 0;
    }
    const int result = pa_sink_process_msg(object, code, data, offset, chunk);
    /* Publication/resume is acknowledged only after this generation is ready.
     * Input arriving before the state transition remains deliberately gated. */
    if (result == 0 && code == PA_SINK_MESSAGE_SET_STATE)
        activate_generation(u);
    return result;
}

int state_main(pa_sink *endpoint, pa_sink_state_t state, pa_suspend_cause_t) {
    auto *u = static_cast<userdata *>(endpoint->userdata);
    if (state == PA_SINK_SUSPENDED || state == PA_SINK_UNLINKED)
        close_stream(u);
    else if (endpoint->state == PA_SINK_SUSPENDED && PA_SINK_IS_OPENED(state)) {
        if (open_stream(u) < 0)
            return -1;
        transfer_generation(u, &u->callback);
        if (u->stream->requestStart() != oboe::Result::OK) {
            close_stream(u);
            return -1;
        }
        pa_sink_set_fixed_latency(endpoint, u->fixed_latency);
    }
    return 0;
}

void thread_func(void *arg) {
    auto *u = static_cast<userdata *>(arg);
    pa_thread_mq_install(&u->mq);
    for (;;) {
        if (u->endpoint->thread_info.rewind_requested)
            pa_sink_process_rewind(u->endpoint, 0);
        activate_generation(u);
        service_pcm(u, 4);
        if (u->io_callback && u->io_callback->pcm.running())
            pa_rtpoll_set_timer_relative(u->rtpoll, u->io_callback->pcm.interval_usec);
        else
            pa_rtpoll_set_timer_disabled(u->rtpoll);
        const int result = pa_rtpoll_run(u->rtpoll);
        if (result == 0)
            return;
        if (result < 0)
            break;
    }
    pa_asyncmsgq_post(u->mq.outq, PA_MSGOBJECT(u->module->core), PA_CORE_MESSAGE_UNLOAD_MODULE,
        u->module, 0, nullptr, nullptr);
    /* Continue processing control detachment until main sends SHUTDOWN. */
    pa_asyncmsgq_wait_for(u->mq.inq, PA_MESSAGE_SHUTDOWN);
}
} // namespace

extern "C" {
int pa__init(pa_module *m) {
    auto *u = new (std::nothrow) userdata{};
    pa_modargs *args = nullptr;
    pa_sink_new_data data;
    if (!u)
        return -1;
    m->userdata = u;
    u->module = m;
    u->rtpoll = pa_rtpoll_new();
    if (pa_thread_mq_init(&u->mq, m->core->mainloop, u->rtpoll) < 0)
        goto fail;
    u->mq_initialized = true;
    args = pa_modargs_new(m->argument, valid_modargs);
    if (!args || pa_modargs_get_sample_rate(args, &u->rate) < 0 ||
        pa_modargs_get_value_u32(args, "latency", &u->latency) < 0) {
        pa_log("Invalid module arguments");
        goto fail;
    }
    u->ss = m->core->default_sample_spec;
    u->ss.format = u->ss.format > PA_SAMPLE_S16BE ? PA_SAMPLE_FLOAT32LE : PA_SAMPLE_S16LE;
    if (open_stream(u) < 0)
        goto fail;
    pa_sink_new_data_init(&data);
    data.driver = __FILE__;
    data.module = m;
    pa_sink_new_data_set_name(&data, pa_modargs_get_value(args, "sink_name", "Oboe sink"));
    pa_sink_new_data_set_sample_spec(&data, &u->ss);
    pa_sink_new_data_set_channel_map(&data, &m->core->default_channel_map);
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_DESCRIPTION, _("Oboe Output"));
    pa_proplist_sets(data.proplist, PA_PROP_DEVICE_CLASS, "abstract");
    if (pa_modargs_get_proplist(args, "sink_properties", data.proplist, PA_UPDATE_REPLACE) < 0) {
        pa_sink_new_data_done(&data);
        goto fail;
    }
    u->endpoint = pa_sink_new(m->core, &data, PA_SINK_LATENCY);
    pa_sink_new_data_done(&data);
    if (!u->endpoint)
        goto fail;
    u->endpoint->userdata = u;
    u->endpoint->parent.process_msg = process_msg;
    u->endpoint->set_state_in_main_thread = state_main;
    pa_sink_set_asyncmsgq(u->endpoint, u->mq.inq);
    pa_sink_set_rtpoll(u->endpoint, u->rtpoll);
    pa_sink_set_fixed_latency(u->endpoint, u->fixed_latency);
    u->thread = pa_thread_new("oboe-sink", thread_func, u);
    if (!u->thread)
        goto fail;
    transfer_generation(u, &u->callback);
    if (u->stream->requestStart() != oboe::Result::OK)
        goto fail;
    /* Verify initial start before publishing. Data remains gated until put
     * has synchronized the initial state with the IO thread. */
    pa_sink_put(u->endpoint);
    pa_modargs_free(args);
    return 0;
fail:
    if (args)
        pa_modargs_free(args);
    pa__done(m);
    return -1;
}

int pa__get_n_used(pa_module *m) {
    return pa_sink_linked_by(static_cast<userdata *>(m->userdata)->endpoint);
}

void pa__done(pa_module *m) {
    auto *u = static_cast<userdata *>(m->userdata);
    if (!u)
        return;
    close_stream(u);
    if (u->endpoint)
        pa_sink_unlink(u->endpoint);
    if (u->thread) {
        pa_asyncmsgq_send(u->mq.inq, nullptr, PA_MESSAGE_SHUTDOWN, nullptr, 0, nullptr);
        pa_thread_free(u->thread);
    }
    if (u->mq_initialized)
        pa_thread_mq_done(&u->mq);
    if (u->endpoint)
        pa_sink_unref(u->endpoint);
    if (u->rtpoll)
        pa_rtpoll_free(u->rtpoll);
    delete u;
    m->userdata = nullptr;
}
}
