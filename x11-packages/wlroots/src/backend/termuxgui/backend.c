#include <assert.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/eventfd.h>
#include <unistd.h>

#include "backend/termuxgui.h"

struct wlr_tgui_backend *tgui_backend_from_backend(struct wlr_backend *wlr_backend) {
    assert(wlr_backend_is_tgui(wlr_backend));
    return (struct wlr_tgui_backend *) wlr_backend;
}

static bool backend_start(struct wlr_backend *wlr_backend) {
    struct wlr_tgui_backend *backend = tgui_backend_from_backend(wlr_backend);
    backend->started = true;
    wlr_log(WLR_INFO, "Starting Termux:GUI backend");

    wl_signal_emit_mutable(&backend->backend.events.new_input, &backend->keyboard.base);
    wl_signal_emit_mutable(&backend->backend.events.new_input, &backend->pointer.base);

    for (uint32_t i = 0; i < backend->requested_outputs; i++) {
        wlr_tgui_output_create(&backend->backend);
    }
    return true;
}

static void backend_destroy(struct wlr_backend *wlr_backend) {
    struct wlr_tgui_backend *backend = tgui_backend_from_backend(wlr_backend);
    if (!wlr_backend) {
        return;
    }

    wl_list_remove(&backend->display_destroy.link);
    wl_event_source_remove(backend->tgui_event_source);

    struct wlr_tgui_output *output, *output_tmp;
    wl_list_for_each_safe(output, output_tmp, &backend->outputs, link) {
        wlr_output_destroy(&output->wlr_output);
    }

    wlr_allocator_destroy(backend->allocator);
    wlr_pointer_finish(&backend->pointer);
    wlr_keyboard_finish(&backend->keyboard);
    wlr_backend_finish(wlr_backend);

    tgui_connection_destroy(backend->conn);
    pthread_join(backend->tgui_event_thread, NULL);
    wlr_queue_destroy(&backend->event_queue);

    close(backend->tgui_event_fd);
    free(backend);
}

static uint32_t get_buffer_caps(struct wlr_backend *wlr_backend) {
    return WLR_BUFFER_CAP_DATA_PTR | WLR_BUFFER_CAP_DMABUF;
}

static const struct wlr_backend_impl backend_impl = {
    .start = backend_start,
    .destroy = backend_destroy,
    .get_buffer_caps = get_buffer_caps,
};

static void handle_display_destroy(struct wl_listener *listener, void *data) {
    struct wlr_tgui_backend *backend = wl_container_of(listener, backend, display_destroy);
    backend_destroy(&backend->backend);
}

static int handle_tgui_event(int fd, uint32_t mask, void *data) {
    struct wlr_tgui_backend *backend = data;

    if ((mask & WL_EVENT_HANGUP) || (mask & WL_EVENT_ERROR)) {
        if (mask & WL_EVENT_ERROR) {
            wlr_log(WLR_ERROR, "Failed to read from tgui event");
            wlr_backend_destroy(&backend->backend);
        }
        return 0;
    }

    eventfd_t event_count = 0;
    if (eventfd_read(backend->tgui_event_fd, &event_count) < 0) {
        return 0;
    }

    struct wl_list *elm = wlr_queue_pull(&backend->event_queue, true);
    if (elm == NULL) {
        wlr_log(WLR_ERROR, "tgui event queue is empty");
        return 0;
    }
    struct wlr_tgui_event *event = wl_container_of(elm, event, link);

    struct wlr_tgui_output *output, *output_tmp;
    wl_list_for_each_safe(output, output_tmp, &backend->outputs, link) {
        if (event->e.activity == output->activity) {
            handle_activity_event(&event->e, output);
        }
    }
    tgui_event_destroy(&event->e);
    free(event);

    return 0;
}

static void *tgui_event_thread(void *data) {
    struct wlr_tgui_backend *backend = data;

    tgui_event event;
    while (tgui_wait_event(backend->conn, &event) == TGUI_ERR_OK) {
        struct wlr_tgui_event *wlr_event = calloc(1, sizeof(*wlr_event));
        if (wlr_event) {
            memcpy(&wlr_event->e, &event, sizeof(tgui_event));

            wlr_queue_push(&backend->event_queue, &wlr_event->link);

            eventfd_write(backend->tgui_event_fd, 1);
        } else {
            wlr_log(WLR_ERROR, "tgui event loss: out of memory");
            tgui_event_destroy(&event);
        }
    }

    return 0;
}

const struct wlr_pointer_impl tgui_pointer_impl = {
    .name = "tgui-pointer",
};

const struct wlr_keyboard_impl tgui_keyboard_impl = {
    .name = "tgui-keyboard",
};

struct wlr_backend *wlr_tgui_backend_create(struct wl_display *display) {
    wlr_log(WLR_INFO, "Creating Termux:GUI backend");

    struct wlr_tgui_backend *backend = calloc(1, sizeof(*backend));
    if (!backend) {
        wlr_log(WLR_ERROR, "Failed to allocate wlr_tgui_backend");
        return NULL;
    }
    wlr_backend_init(&backend->backend, &backend_impl);

    backend->display = display;
    backend->loop = wl_display_get_event_loop(display);
    backend->tgui_event_fd = eventfd(0, EFD_CLOEXEC | EFD_NONBLOCK | EFD_SEMAPHORE);

    if (tgui_connection_create(&backend->conn)) {
        wlr_log(WLR_ERROR, "Failed to create tgui_connection");
        wlr_backend_finish(&backend->backend);
        free(backend);
        return NULL;
    }
    backend->allocator = wlr_tgui_allocator_create(backend);

    wlr_pointer_init(&backend->pointer, &tgui_pointer_impl, "tgui-pointer");
    wlr_keyboard_init(&backend->keyboard, &tgui_keyboard_impl, "tgui-keyboard");

    wl_list_init(&backend->outputs);

    backend->display_destroy.notify = handle_display_destroy;
    wl_display_add_destroy_listener(display, &backend->display_destroy);

    uint32_t events = WL_EVENT_READABLE | WL_EVENT_ERROR | WL_EVENT_HANGUP;
    backend->tgui_event_source = wl_event_loop_add_fd(backend->loop, backend->tgui_event_fd,
                                                      events, handle_tgui_event, backend);

    wlr_queue_init(&backend->event_queue);
    pthread_create(&backend->tgui_event_thread, NULL, tgui_event_thread, backend);

    return &backend->backend;
}

struct wlr_allocator *wlr_tgui_backend_get_allocator(struct wlr_tgui_backend *backend) {
    return backend->allocator;
}

bool wlr_backend_is_tgui(struct wlr_backend *backend) { return backend->impl == &backend_impl; }
