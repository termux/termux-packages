#include <assert.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <inttypes.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <drm_fourcc.h>
#include <wlr/util/log.h>

#include "render/allocator/ahb.h"
#include "render/drm_format_set.h"
#include "render/pixel_format.h"

static const struct wlr_buffer_impl buffer_impl;
static const struct wlr_allocator_interface allocator_impl;

static struct wlr_ahb_api api;
static bool api_loaded;
static pthread_once_t api_once = PTHREAD_ONCE_INIT;

static void api_load(void) {
	void *library = dlopen("libandroid.so", RTLD_NOW);
	if (library == NULL) {
		wlr_log(WLR_DEBUG, "Failed to load libandroid.so: %s", dlerror());
		return;
	}

#define LOAD(field, symbol) \
	if ((api.field = dlsym(library, symbol)) == NULL) { \
		wlr_log(WLR_DEBUG, "libandroid.so has no %s", symbol); \
		return; \
	}
	LOAD(allocate, "AHardwareBuffer_allocate")
	LOAD(release, "AHardwareBuffer_release")
	LOAD(describe, "AHardwareBuffer_describe")
	LOAD(lock, "AHardwareBuffer_lock")
	LOAD(unlock, "AHardwareBuffer_unlock")
	LOAD(send_handle_to_unix_socket, "AHardwareBuffer_sendHandleToUnixSocket")
	LOAD(get_native_handle, "AHardwareBuffer_getNativeHandle")
#undef LOAD
	api_loaded = true;
}

const struct wlr_ahb_api *wlr_ahb_api_get(void) {
	pthread_once(&api_once, api_load);
	return api_loaded ? &api : NULL;
}

bool wlr_ahb_get_dmabuf_attributes(AHardwareBuffer *handle,
		const AHardwareBuffer_Desc *desc, uint32_t drm_format, int32_t width,
		struct wlr_dmabuf_attributes *attribs) {
	const struct wlr_ahb_api *ahb = wlr_ahb_api_get();
	const struct wlr_ahb_native_handle *native = ahb->get_native_handle(handle);
	if (native == NULL)
		return false;

	size_t min_size = (size_t)desc->stride * desc->height * 4;
	int fd = -1;
	for (int i = 0; i < native->numFds; i++) {
		off_t size = lseek(native->data[i], 0, SEEK_END);
		if (size < 0 || (size_t)size < min_size)
			continue;
		fd = fcntl(native->data[i], F_DUPFD_CLOEXEC, 0);
		break;
	}
	if (fd < 0)
		return false;

	*attribs = (struct wlr_dmabuf_attributes){
		.width = width,
		.height = desc->height,
		.format = drm_format,
		.modifier = DRM_FORMAT_MOD_LINEAR,
		.n_planes = 1,
		.offset[0] = 0,
		.stride[0] = desc->stride * 4,
		.fd[0] = fd,
	};
	return true;
}

bool wlr_buffer_is_ahb(struct wlr_buffer *buffer) {
	return buffer->impl == &buffer_impl;
}

struct wlr_ahb_buffer *wlr_ahb_buffer_from_buffer(struct wlr_buffer *wlr_buffer) {
	assert(wlr_buffer->impl == &buffer_impl);
	struct wlr_ahb_buffer *buffer = wl_container_of(wlr_buffer, buffer, base);
	return buffer;
}

bool wlr_ahb_buffer_send_handle(struct wlr_ahb_buffer *buffer, int socket) {
	return wlr_ahb_api_get()->send_handle_to_unix_socket(buffer->handle, socket) == 0;
}

static void buffer_destroy(struct wlr_buffer *wlr_buffer) {
	struct wlr_ahb_buffer *buffer = wlr_ahb_buffer_from_buffer(wlr_buffer);
	const struct wlr_ahb_api *ahb = wlr_ahb_api_get();
	if (buffer->data != NULL)
		ahb->unlock(buffer->handle, NULL);
	wlr_dmabuf_attributes_finish(&buffer->dmabuf);
	ahb->release(buffer->handle);
	free(buffer);
}

static bool buffer_get_dmabuf(struct wlr_buffer *wlr_buffer,
		struct wlr_dmabuf_attributes *dmabuf) {
	struct wlr_ahb_buffer *buffer = wlr_ahb_buffer_from_buffer(wlr_buffer);
	*dmabuf = buffer->dmabuf;
	return true;
}

static bool buffer_begin_data_ptr_access(struct wlr_buffer *wlr_buffer,
		uint32_t flags, void **data, uint32_t *format, size_t *stride) {
	struct wlr_ahb_buffer *buffer = wlr_ahb_buffer_from_buffer(wlr_buffer);
	if (buffer->data == NULL) {
		wlr_ahb_api_get()->lock(buffer->handle,
			AHARDWAREBUFFER_USAGE_CPU_READ_RARELY |
			AHARDWAREBUFFER_USAGE_CPU_WRITE_RARELY, -1, NULL, &buffer->data);
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

static void buffer_end_data_ptr_access(struct wlr_buffer *wlr_buffer) {
	struct wlr_ahb_buffer *buffer = wlr_ahb_buffer_from_buffer(wlr_buffer);
	if (buffer->data != NULL) {
		wlr_ahb_api_get()->unlock(buffer->handle, NULL);
		buffer->data = NULL;
	}
}

static const struct wlr_buffer_impl buffer_impl = {
	.destroy = buffer_destroy,
	.get_dmabuf = buffer_get_dmabuf,
	.begin_data_ptr_access = buffer_begin_data_ptr_access,
	.end_data_ptr_access = buffer_end_data_ptr_access,
};

static struct wlr_buffer *allocator_create_buffer(struct wlr_allocator *alloc,
		int width, int height, const struct wlr_drm_format *format) {
	const struct wlr_ahb_api *ahb = wlr_ahb_api_get();

	if (!wlr_drm_format_has(format, DRM_FORMAT_MOD_INVALID) &&
			!wlr_drm_format_has(format, DRM_FORMAT_MOD_LINEAR)) {
		wlr_log(WLR_ERROR, "AHardwareBuffer allocator only supports INVALID and "
			"LINEAR modifiers");
		return NULL;
	}

	const struct wlr_pixel_format_info *info = drm_get_pixel_format_info(format->format);
	if (info == NULL || info->bytes_per_block != 4) {
		wlr_log(WLR_ERROR, "Unsupported pixel format 0x%" PRIX32, format->format);
		return NULL;
	}

	struct wlr_ahb_buffer *buffer = calloc(1, sizeof(*buffer));
	if (buffer == NULL)
		return NULL;
	wlr_buffer_init(&buffer->base, &buffer_impl, width, height);

	AHardwareBuffer_Desc desc = {
		.width = width,
		.height = height,
		.layers = 1,
		.format = AHARDWAREBUFFER_FORMAT_R8G8B8A8_UNORM,
		.usage = AHARDWAREBUFFER_USAGE_GPU_FRAMEBUFFER |
			AHARDWAREBUFFER_USAGE_GPU_SAMPLED_IMAGE |
			AHARDWAREBUFFER_USAGE_CPU_READ_OFTEN |
			AHARDWAREBUFFER_USAGE_CPU_WRITE_OFTEN,
	};
	if (ahb->allocate(&desc, &buffer->handle) != 0 || buffer->handle == NULL) {
		wlr_log(WLR_ERROR, "AHardwareBuffer_allocate failed");
		free(buffer);
		return NULL;
	}
	ahb->describe(buffer->handle, &buffer->desc);

	if (!wlr_ahb_get_dmabuf_attributes(buffer->handle, &buffer->desc,
			format->format, width, &buffer->dmabuf)) {
		wlr_log(WLR_ERROR, "Failed to get a dma-buf of the AHardwareBuffer");
		ahb->release(buffer->handle);
		free(buffer);
		return NULL;
	}

	buffer->format = format->format;
	return &buffer->base;
}

static void allocator_destroy(struct wlr_allocator *alloc) {
	free(alloc);
}

static const struct wlr_allocator_interface allocator_impl = {
	.destroy = allocator_destroy,
	.create_buffer = allocator_create_buffer,
};

struct wlr_allocator *wlr_ahb_allocator_create(void) {
	if (wlr_ahb_api_get() == NULL)
		return NULL;
	struct wlr_allocator *alloc = calloc(1, sizeof(*alloc));
	if (alloc == NULL)
		return NULL;
	wlr_allocator_init(alloc, &allocator_impl,
		WLR_BUFFER_CAP_DMABUF | WLR_BUFFER_CAP_DATA_PTR);
	return alloc;
}
