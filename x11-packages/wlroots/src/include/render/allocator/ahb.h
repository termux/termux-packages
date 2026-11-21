#ifndef RENDER_ALLOCATOR_AHB_H
#define RENDER_ALLOCATOR_AHB_H

#include <android/hardware_buffer.h>
#include <stdbool.h>
#include <stdint.h>

#include <wlr/interfaces/wlr_buffer.h>
#include <wlr/render/allocator.h>
#include <wlr/render/dmabuf.h>

struct wlr_ahb_native_handle {
	int version;
	int numFds;
	int numInts;
	int data[];
};

struct wlr_ahb_api {
	int (*allocate)(const AHardwareBuffer_Desc *desc, AHardwareBuffer **out);
	void (*release)(AHardwareBuffer *buffer);
	void (*describe)(const AHardwareBuffer *buffer, AHardwareBuffer_Desc *out);
	int (*lock)(AHardwareBuffer *buffer, uint64_t usage, int32_t fence,
		const ARect *rect, void **out);
	int (*unlock)(AHardwareBuffer *buffer, int32_t *fence);
	int (*send_handle_to_unix_socket)(const AHardwareBuffer *buffer, int socket);
	const struct wlr_ahb_native_handle *(*get_native_handle)(const AHardwareBuffer *buffer);
};

struct wlr_ahb_buffer {
	struct wlr_buffer base;
	AHardwareBuffer *handle;
	AHardwareBuffer_Desc desc;
	struct wlr_dmabuf_attributes dmabuf;
	void *data;
	uint32_t format;
};

const struct wlr_ahb_api *wlr_ahb_api_get(void);

bool wlr_ahb_get_dmabuf_attributes(AHardwareBuffer *handle,
	const AHardwareBuffer_Desc *desc, uint32_t drm_format, int32_t width,
	struct wlr_dmabuf_attributes *attribs);

bool wlr_buffer_is_ahb(struct wlr_buffer *buffer);
struct wlr_ahb_buffer *wlr_ahb_buffer_from_buffer(struct wlr_buffer *buffer);
bool wlr_ahb_buffer_send_handle(struct wlr_ahb_buffer *buffer, int socket);

struct wlr_allocator *wlr_ahb_allocator_create(void);

#endif
