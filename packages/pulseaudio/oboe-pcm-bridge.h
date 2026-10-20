// SPDX-License-Identifier: LGPL-2.1-or-later
#ifndef PA_OBOE_PCM_BRIDGE_H
#define PA_OBOE_PCM_BRIDGE_H

#include <algorithm>
#include <atomic>
#include <climits>
#include <cstdint>
#include <cstring>
#include <memory>
#include <vector>
#include <oboe/FifoBuffer.h>

// One generation, one FIFO producer, one FIFO consumer. All allocation and
// configuration happen before publication; native data callbacks only copy PCM
// and update lock-free counters. PA IO owns scratch and lifecycle activation.
struct PcmBridge {
    static_assert(std::atomic<uint32_t>::is_always_lock_free);
    static_assert(std::atomic<uint64_t>::is_always_lock_free);
    enum : uint32_t { Prepared, Running, Closing };
    const uint32_t frame_size;
    std::atomic<uint32_t> state{Prepared};
    std::atomic<uint64_t> lost_frames{0};
    uint32_t rate{0}, quantum{0}, target{0}, native_frames{0};
    uint64_t interval_usec{0};
    uint64_t logged_loss{0}; // IO only
    std::unique_ptr<oboe::FifoBuffer> fifo;
    std::vector<uint8_t> scratch;

    explicit PcmBridge(uint32_t bytes_per_frame) : frame_size{bytes_per_frame} {}

    bool configure(uint32_t sample_rate, int32_t burst, int32_t native_buffer,
                   uint32_t latency_ms) {
        if (state.load(std::memory_order_acquire) != Prepared || fifo ||
            !sample_rate || burst <= 0 || !frame_size) return false;
        rate = sample_rate;
        interval_usec = std::clamp<uint64_t>(
            (uint64_t(burst) * 1000000 + 2 * uint64_t(rate) - 1) / (2 * uint64_t(rate)),
            1000, 5000);
        const uint64_t q = std::max<uint64_t>(burst,
            (uint64_t(rate) * interval_usec + 999999) / 1000000);
        const uint64_t w = std::max<uint64_t>(2 * q,
            (uint64_t(rate) * latency_ms + 999) / 1000);
        const uint64_t capacity = std::max<uint64_t>(4 * q, w + 2 * q);
        if (capacity > UINT32_MAX / 4 || capacity > INT32_MAX ||
            capacity * frame_size > INT32_MAX || capacity * frame_size > 4 * 1024 * 1024)
            return false;
        quantum = static_cast<uint32_t>(q);
        target = static_cast<uint32_t>(w);
        native_frames = native_buffer > 0 ? static_cast<uint32_t>(native_buffer)
                                         : static_cast<uint32_t>(burst);
        fifo = std::make_unique<oboe::FifoBuffer>(frame_size, static_cast<uint32_t>(capacity));
        scratch.resize(size_t(quantum) * frame_size);
        return true;
    }

    bool activate() {
        if (!fifo) return false;
        uint32_t expected = Prepared;
        return state.compare_exchange_strong(expected, Running,
            std::memory_order_acq_rel, std::memory_order_acquire);
    }
    void close() { state.store(Closing, std::memory_order_release); }
    bool running() const { return state.load(std::memory_order_acquire) == Running; }
    bool closing() const { return state.load(std::memory_order_acquire) == Closing; }

    uint64_t frames_to_usec(uint64_t frames) const {
        return (frames * 1000000 + rate - 1) / rate;
    }
    uint64_t configured_latency(bool playback) const {
        return playback ? frames_to_usec(uint64_t(native_frames) + target)
                        : frames_to_usec(native_frames) + interval_usec;
    }
    uint64_t latency() const {
        if (!running()) return 0;
        const auto occupied = std::min(fifo->getFullFramesAvailable(),
                                       fifo->getBufferCapacityInFrames());
        // A configured native-buffer estimate plus a bounded FIFO snapshot;
        // this is not a hardware presentation timestamp.
        return frames_to_usec(uint64_t(native_frames) + occupied);
    }

    void playback(void *audio, int32_t frames) {
        if (frames <= 0 || !frame_size || uint64_t(frames) * frame_size > INT32_MAX) return;
        if (!running()) {
            std::memset(audio, 0, size_t(frames) * frame_size);
            return;
        }
        const auto copied = fifo->readNow(audio, frames);
        lost_frames.fetch_add(static_cast<uint64_t>(frames - copied), std::memory_order_relaxed);
    }
    void capture(const void *audio, int32_t frames) {
        if (frames <= 0 || !frame_size || uint64_t(frames) * frame_size > INT32_MAX || !running())
            return;
        const auto copied = fifo->write(audio, frames);
        // Drop newest input when full; preserve every already queued frame.
        lost_frames.fetch_add(static_cast<uint64_t>(frames - copied), std::memory_order_relaxed);
    }
};

#endif
