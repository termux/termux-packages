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

__attribute__((weak)) const struct wlr_ahb_native_handle *
	AHardwareBuffer_getNativeHandle(const AHardwareBuffer *buffer);

struct wlr_ahb_buffer {
	struct wlr_buffer base;
	AHardwareBuffer *handle;
	AHardwareBuffer_Desc desc;
	struct wlr_dmabuf_attributes dmabuf;
	void *data;
	uint32_t format;
};

bool wlr_ahb_available(void);

bool wlr_ahb_get_dmabuf_attributes(AHardwareBuffer *handle,
	const AHardwareBuffer_Desc *desc, uint32_t drm_format, int32_t width,
	struct wlr_dmabuf_attributes *attribs);

AHardwareBuffer *wlr_dmabuf_v1_buffer_get_ahb(struct wlr_buffer *buffer);
uint32_t wlr_dmabuf_v1_buffer_get_ahb_format(struct wlr_buffer *buffer);
bool wlr_dmabuf_v1_buffer_get_ahb_dmabuf(struct wlr_buffer *buffer,
	struct wlr_dmabuf_attributes *attribs);

bool wlr_buffer_is_ahb(struct wlr_buffer *buffer);
struct wlr_ahb_buffer *wlr_ahb_buffer_from_buffer(struct wlr_buffer *buffer);
bool wlr_ahb_buffer_send_handle(struct wlr_ahb_buffer *buffer, int socket);

struct wlr_allocator *wlr_ahb_allocator_create(void);

#endif
