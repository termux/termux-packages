#include <assert.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <malloc.h>
#include <pthread.h>
#include <unistd.h>

#include <drm_fourcc.h>

#include "backend/termuxgui.h"
#include "render/drm_format_set.h"
#include "render/pixel_format.h"

static const struct wlr_buffer_impl buffer_impl;
static const struct wlr_allocator_interface allocator_impl;

struct wlr_tgui_buffer *tgui_buffer_from_buffer(struct wlr_buffer *wlr_buffer) {
    assert(wlr_buffer->impl == &buffer_impl);
    struct wlr_tgui_buffer *buffer = wl_container_of(wlr_buffer, buffer, wlr_buffer);
    return buffer;
}

static struct wlr_tgui_allocator *
tgui_allocator_from_allocator(struct wlr_allocator *wlr_allocator) {
    assert(wlr_allocator->impl == &allocator_impl);
    struct wlr_tgui_allocator *alloc = wl_container_of(wlr_allocator, alloc, wlr_allocator);
    return alloc;
}

static void buffer_destroy(struct wlr_buffer *wlr_buffer) {
    struct wlr_tgui_buffer *buffer = tgui_buffer_from_buffer(wlr_buffer);
    if (buffer->data) {
        buffer->unlock(buffer->buffer.buffer, NULL);
    }

    wlr_dmabuf_attributes_finish(&buffer->dmabuf);
    tgui_hardware_buffer_destroy(buffer->conn, &buffer->buffer);
    dlclose(buffer->dlhandle);
    free(buffer);
}

static bool buffer_get_dmabuf(struct wlr_buffer *wlr_buffer,
                              struct wlr_dmabuf_attributes *dmabuf) {
    struct wlr_tgui_buffer *buffer = tgui_buffer_from_buffer(wlr_buffer);
    memcpy(dmabuf, &buffer->dmabuf, sizeof(*dmabuf));
    return true;
}

static bool begin_data_ptr_access(struct wlr_buffer *wlr_buffer,
                                  uint32_t flags,
                                  void **data,
                                  uint32_t *format,
                                  size_t *stride) {
    struct wlr_tgui_buffer *buffer = tgui_buffer_from_buffer(wlr_buffer);

    if (buffer->data == NULL) {
        buffer->lock(buffer->buffer.buffer,
                     AHARDWAREBUFFER_USAGE_CPU_READ_RARELY |
                         AHARDWAREBUFFER_USAGE_CPU_WRITE_RARELY,
                     -1, NULL, &buffer->data);
        if (buffer->data == NULL) {
            wlr_log(WLR_ERROR, "AHardwareBuffer_lock failed");
            return false;
        }
    }

    *data = buffer->data;
    *format = buffer->format;
    *stride = buffer->desc.stride * 4;
    return true;
}

static void end_data_ptr_access(struct wlr_buffer *wlr_buffer) {
    struct wlr_tgui_buffer *buffer = tgui_buffer_from_buffer(wlr_buffer);
    if (buffer->data) {
        buffer->unlock(buffer->buffer.buffer, NULL);
        buffer->data = NULL;
    }
}

static const struct wlr_buffer_impl buffer_impl = {
    .destroy = buffer_destroy,
    .get_dmabuf = buffer_get_dmabuf,
    .begin_data_ptr_access = begin_data_ptr_access,
    .end_data_ptr_access = end_data_ptr_access,
};

static bool tgui_buffer_ahb_func_load(struct wlr_tgui_buffer *buffer) {
    buffer->dlhandle = dlopen("libandroid.so", RTLD_NOW);
    if (!buffer->dlhandle) {
        wlr_log(WLR_ERROR, "%s", dlerror());
        return false;
    }

#define LOAD_SYM(name)                                                                           \
    if ((buffer->name = dlsym(buffer->dlhandle, "AHardwareBuffer_" #name)) == NULL) {            \
        wlr_log(WLR_ERROR, "%s", dlerror());                                                     \
        dlclose(buffer->dlhandle);                                                               \
        return false;                                                                            \
    }

    LOAD_SYM(lock)
    LOAD_SYM(unlock)
    LOAD_SYM(describe)
    LOAD_SYM(getNativeHandle)
#undef LOAD_SYM
    return true;
}

static struct wlr_buffer *allocator_create_buffer(struct wlr_allocator *wlr_allocator,
                                                  int width,
                                                  int height,
                                                  const struct wlr_drm_format *format) {
    struct wlr_tgui_allocator *alloc = tgui_allocator_from_allocator(wlr_allocator);

    if (!wlr_drm_format_has(format, DRM_FORMAT_MOD_INVALID) &&
        !wlr_drm_format_has(format, DRM_FORMAT_MOD_LINEAR)) {
        wlr_log(WLR_ERROR, "TGUI allocator only supports INVALID and "
                           "LINEAR modifiers");
        return NULL;
    }

    const struct wlr_pixel_format_info *info = drm_get_pixel_format_info(format->format);
    if (info == NULL) {
        wlr_log(WLR_ERROR, "Unsupported pixel format 0x%" PRIX32, format->format);
        return NULL;
    }

    struct wlr_tgui_buffer *buffer = calloc(1, sizeof(*buffer));
    if (buffer == NULL) {
        return NULL;
    }
    wlr_buffer_init(&buffer->wlr_buffer, &buffer_impl, width, height);

    if (!tgui_buffer_ahb_func_load(buffer)) {
        free(buffer);
        return NULL;
    }

    tgui_err ret = tgui_hardware_buffer_create(
        alloc->conn, &buffer->buffer, TGUI_HARDWARE_BUFFER_FORMAT_RGBA8888, width, height,
        TGUI_HARDWARE_BUFFER_CPU_OFTEN, TGUI_HARDWARE_BUFFER_CPU_OFTEN);
    if (ret != TGUI_ERR_OK) {
        wlr_log(WLR_ERROR, "Failed to create tgui_hardware_buffer");
        goto fail;
    }
    wlr_log(WLR_DEBUG, "Created tgui_hardware_buffer %dx%d", width, height);

    buffer->describe(buffer->buffer.buffer, &buffer->desc);

    const native_handle_t *handle = buffer->getNativeHandle(buffer->buffer.buffer);

    int fd = -1;
    for (int i = 0; i < handle->numFds; i++) {
        size_t size = lseek(handle->data[i], 0, SEEK_END);
        if (size < (buffer->desc.stride * buffer->desc.height * 4))
            continue;

        fd = fcntl(handle->data[i], F_DUPFD_CLOEXEC, 0);
        break;
    }

    if (fd < 0) {
        wlr_log(WLR_ERROR, "Failed to get dmabuf");
        tgui_hardware_buffer_destroy(alloc->conn, &buffer->buffer);
        goto fail;
    }

    buffer->dmabuf = (struct wlr_dmabuf_attributes) {
        .width = buffer->desc.stride,
        .height = buffer->desc.height,
        .n_planes = 1,
        .format = format->format,
        .modifier = DRM_FORMAT_MOD_LINEAR,
        .offset[0] = 0,
        .stride[0] = buffer->desc.stride * 4,
        .fd[0] = fd,

    };

    buffer->format = format->format;
    buffer->conn = alloc->conn;
    return &buffer->wlr_buffer;

fail:
    dlclose(buffer->dlhandle);
    free(buffer);
    return NULL;
}

static void allocator_destroy(struct wlr_allocator *wlr_allocator) { free(wlr_allocator); }

static const struct wlr_allocator_interface allocator_impl = {
    .destroy = allocator_destroy,
    .create_buffer = allocator_create_buffer,
};

struct wlr_allocator *wlr_tgui_allocator_create(struct wlr_tgui_backend *backend) {
    struct wlr_tgui_allocator *allocator = calloc(1, sizeof(*allocator));
    if (allocator == NULL) {
        return NULL;
    }
    allocator->conn = backend->conn;

    wlr_allocator_init(&allocator->wlr_allocator, &allocator_impl,
                       WLR_BUFFER_CAP_DMABUF | WLR_BUFFER_CAP_DATA_PTR);

    return &allocator->wlr_allocator;
}
