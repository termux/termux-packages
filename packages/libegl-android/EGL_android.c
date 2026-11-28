#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <glvnd/libeglabi.h>

#define PUBLIC __attribute__((visibility("default")))

#ifdef __LP64__
#define SYSTEM_EGL "/system/lib64/libEGL.so"
#else
#define SYSTEM_EGL "/system/lib/libEGL.so"
#endif

#define CLIENT_EXTENSIONS "EGL_KHR_platform_android"

static const __EGLapiExports *exports;
static void *system_egl;
static __eglMustCastToProperFunctionPointerType (*system_get_proc)(const char *);
static EGLDisplay (*system_get_display)(EGLNativeDisplayType);

#define DEBUG_ATTRIB_MAX 16

static EGLDEBUGPROCKHR saved_debug_callback;
static EGLAttrib saved_debug_attribs[DEBUG_ATTRIB_MAX + 1] = { EGL_NONE };
static int debug_saved;

static void apply_saved_debug(void)
{
	EGLint (*func)(EGLDEBUGPROCKHR, const EGLAttrib *);
	if (!debug_saved)
		return;
	func = (void *) dlsym(system_egl, "eglDebugMessageControlKHR");
	if (func)
		func(saved_debug_callback, saved_debug_attribs);
}

static int load_system_egl(void)
{
	if (system_egl)
		return 1;
	void *lib = dlopen(SYSTEM_EGL, RTLD_NOW | RTLD_LOCAL);
	if (!lib)
		return 0;
	system_get_proc = dlsym(lib, "eglGetProcAddress");
	system_get_display = dlsym(lib, "eglGetDisplay");
	if (!system_get_proc || !system_get_display) {
		dlclose(lib);
		return 0;
	}
	system_egl = lib;
	apply_saved_debug();
	return 1;
}

#define CORE_FUNCS(X) \
	X(EGLBoolean, eglInitialize, (EGLDisplay dpy, EGLint *major, EGLint *minor), (dpy, major, minor), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglTerminate, (EGLDisplay dpy), (dpy), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglChooseConfig, (EGLDisplay dpy, const EGLint *attrib_list, EGLConfig *configs, EGLint config_size, EGLint *num_config), (dpy, attrib_list, configs, config_size, num_config), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglGetConfigs, (EGLDisplay dpy, EGLConfig *configs, EGLint config_size, EGLint *num_config), (dpy, configs, config_size, num_config), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglGetConfigAttrib, (EGLDisplay dpy, EGLConfig config, EGLint attribute, EGLint *value), (dpy, config, attribute, value), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglCopyBuffers, (EGLDisplay dpy, EGLSurface surface, EGLNativePixmapType target), (dpy, surface, target), EGL_FALSE, EGL_FALSE) \
	X(EGLContext, eglCreateContext, (EGLDisplay dpy, EGLConfig config, EGLContext share_context, const EGLint *attrib_list), (dpy, config, share_context, attrib_list), EGL_NO_CONTEXT, EGL_NO_CONTEXT) \
	X(EGLBoolean, eglDestroyContext, (EGLDisplay dpy, EGLContext ctx), (dpy, ctx), EGL_FALSE, EGL_FALSE) \
	X(EGLSurface, eglCreatePbufferSurface, (EGLDisplay dpy, EGLConfig config, const EGLint *attrib_list), (dpy, config, attrib_list), EGL_NO_SURFACE, EGL_NO_SURFACE) \
	X(EGLSurface, eglCreatePixmapSurface, (EGLDisplay dpy, EGLConfig config, EGLNativePixmapType pixmap, const EGLint *attrib_list), (dpy, config, pixmap, attrib_list), EGL_NO_SURFACE, EGL_NO_SURFACE) \
	X(EGLSurface, eglCreateWindowSurface, (EGLDisplay dpy, EGLConfig config, EGLNativeWindowType win, const EGLint *attrib_list), (dpy, config, win, attrib_list), EGL_NO_SURFACE, EGL_NO_SURFACE) \
	X(EGLSurface, eglCreatePbufferFromClientBuffer, (EGLDisplay dpy, EGLenum buftype, EGLClientBuffer buffer, EGLConfig config, const EGLint *attrib_list), (dpy, buftype, buffer, config, attrib_list), EGL_NO_SURFACE, EGL_NO_SURFACE) \
	X(EGLBoolean, eglDestroySurface, (EGLDisplay dpy, EGLSurface surface), (dpy, surface), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglMakeCurrent, (EGLDisplay dpy, EGLSurface draw, EGLSurface read, EGLContext ctx), (dpy, draw, read, ctx), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglQueryContext, (EGLDisplay dpy, EGLContext ctx, EGLint attribute, EGLint *value), (dpy, ctx, attribute, value), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglQuerySurface, (EGLDisplay dpy, EGLSurface surface, EGLint attribute, EGLint *value), (dpy, surface, attribute, value), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglSwapBuffers, (EGLDisplay dpy, EGLSurface surface), (dpy, surface), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglSwapInterval, (EGLDisplay dpy, EGLint interval), (dpy, interval), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglSurfaceAttrib, (EGLDisplay dpy, EGLSurface surface, EGLint attribute, EGLint value), (dpy, surface, attribute, value), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglBindTexImage, (EGLDisplay dpy, EGLSurface surface, EGLint buffer), (dpy, surface, buffer), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglReleaseTexImage, (EGLDisplay dpy, EGLSurface surface, EGLint buffer), (dpy, surface, buffer), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglWaitGL, (void), (), EGL_TRUE, EGL_FALSE) \
	X(EGLBoolean, eglWaitNative, (EGLint engine), (engine), EGL_TRUE, EGL_FALSE) \
	X(EGLBoolean, eglWaitClient, (void), (), EGL_TRUE, EGL_FALSE) \
	X(EGLBoolean, eglReleaseThread, (void), (), EGL_TRUE, EGL_FALSE) \
	X(EGLBoolean, eglBindAPI, (EGLenum api), (api), EGL_TRUE, EGL_FALSE) \
	X(EGLSync, eglCreateSync, (EGLDisplay dpy, EGLenum type, const EGLAttrib *attrib_list), (dpy, type, attrib_list), EGL_NO_SYNC, EGL_NO_SYNC) \
	X(EGLBoolean, eglDestroySync, (EGLDisplay dpy, EGLSync sync), (dpy, sync), EGL_FALSE, EGL_FALSE) \
	X(EGLint, eglClientWaitSync, (EGLDisplay dpy, EGLSync sync, EGLint flags, EGLTime timeout), (dpy, sync, flags, timeout), EGL_FALSE, EGL_FALSE) \
	X(EGLBoolean, eglGetSyncAttrib, (EGLDisplay dpy, EGLSync sync, EGLint attribute, EGLAttrib *value), (dpy, sync, attribute, value), EGL_FALSE, EGL_FALSE) \
	X(EGLImage, eglCreateImage, (EGLDisplay dpy, EGLContext ctx, EGLenum target, EGLClientBuffer buffer, const EGLAttrib *attrib_list), (dpy, ctx, target, buffer, attrib_list), EGL_NO_IMAGE, EGL_NO_IMAGE) \
	X(EGLBoolean, eglDestroyImage, (EGLDisplay dpy, EGLImage image), (dpy, image), EGL_FALSE, EGL_FALSE) \
	X(EGLSurface, eglCreatePlatformWindowSurface, (EGLDisplay dpy, EGLConfig config, void *native_window, const EGLAttrib *attrib_list), (dpy, config, native_window, attrib_list), EGL_NO_SURFACE, EGL_NO_SURFACE)

#define X(ret, name, params, args, idle, fail) \
	static ret lazy_##name params \
	{ \
		ret (*func) params; \
		if (!system_egl) \
			return idle; \
		func = (void *) dlsym(system_egl, #name); \
		return func ? func args : fail; \
	}
CORE_FUNCS(X)
#undef X

static EGLint lazy_eglGetError(void)
{
	EGLint (*func)(void);
	if (!system_egl)
		return EGL_SUCCESS;
	func = (void *) dlsym(system_egl, "eglGetError");
	return func ? func() : EGL_SUCCESS;
}

static EGLint forward_eglDebugMessageControlKHR(EGLDEBUGPROCKHR callback, const EGLAttrib *attrib_list)
{
	EGLint (*func)(EGLDEBUGPROCKHR, const EGLAttrib *);
	int n = 0;

	saved_debug_callback = callback;
	while (attrib_list && attrib_list[n] != EGL_NONE && n < DEBUG_ATTRIB_MAX - 1) {
		saved_debug_attribs[n] = attrib_list[n];
		saved_debug_attribs[n + 1] = attrib_list[n + 1];
		n += 2;
	}
	saved_debug_attribs[n] = EGL_NONE;
	debug_saved = 1;

	if (!system_egl)
		return EGL_SUCCESS;
	func = (void *) dlsym(system_egl, "eglDebugMessageControlKHR");
	return func ? func(callback, attrib_list) : EGL_SUCCESS;
}

static EGLBoolean forward_eglQueryDebugKHR(EGLint attribute, EGLAttrib *value)
{
	EGLBoolean (*func)(EGLint, EGLAttrib *);
	if (!system_egl)
		return EGL_FALSE;
	func = (void *) dlsym(system_egl, "eglQueryDebugKHR");
	return func ? func(attribute, value) : EGL_FALSE;
}

static EGLint forward_eglLabelObjectKHR(EGLDisplay dpy, EGLenum objectType, EGLObjectKHR object, EGLLabelKHR label)
{
	EGLint (*func)(EGLDisplay, EGLenum, EGLObjectKHR, EGLLabelKHR);
	if (!system_egl)
		return EGL_SUCCESS;
	func = (void *) dlsym(system_egl, "eglLabelObjectKHR");
	return func ? func(dpy, objectType, object, label) : EGL_SUCCESS;
}

static const char *lazy_eglQueryString(EGLDisplay dpy, EGLint name)
{
	const char *(*func)(EGLDisplay, EGLint);
	if (dpy == EGL_NO_DISPLAY)
		return name == EGL_EXTENSIONS ? CLIENT_EXTENSIONS : NULL;
	if (!system_egl)
		return NULL;
	func = (void *) dlsym(system_egl, "eglQueryString");
	return func ? func(dpy, name) : NULL;
}

#define DISPLAY_FUNCS(X) \
	X(EGLImageKHR, eglCreateImageKHR, (EGLDisplay dpy, EGLContext ctx, EGLenum target, EGLClientBuffer buffer, const EGLint *attrib_list), (dpy, ctx, target, buffer, attrib_list), EGL_NO_IMAGE_KHR) \
	X(EGLBoolean, eglDestroyImageKHR, (EGLDisplay dpy, EGLImageKHR image), (dpy, image), EGL_FALSE) \
	X(EGLSyncKHR, eglCreateSyncKHR, (EGLDisplay dpy, EGLenum type, const EGLint *attrib_list), (dpy, type, attrib_list), EGL_NO_SYNC_KHR) \
	X(EGLBoolean, eglDestroySyncKHR, (EGLDisplay dpy, EGLSyncKHR sync), (dpy, sync), EGL_FALSE) \
	X(EGLint, eglClientWaitSyncKHR, (EGLDisplay dpy, EGLSyncKHR sync, EGLint flags, EGLTimeKHR timeout), (dpy, sync, flags, timeout), EGL_FALSE) \
	X(EGLint, eglWaitSyncKHR, (EGLDisplay dpy, EGLSyncKHR sync, EGLint flags), (dpy, sync, flags), EGL_FALSE) \
	X(EGLBoolean, eglGetSyncAttribKHR, (EGLDisplay dpy, EGLSyncKHR sync, EGLint attribute, EGLint *value), (dpy, sync, attribute, value), EGL_FALSE) \
	X(EGLint, eglDupNativeFenceFDANDROID, (EGLDisplay dpy, EGLSyncKHR sync), (dpy, sync), EGL_NO_NATIVE_FENCE_FD_ANDROID) \
	X(EGLBoolean, eglSwapBuffersWithDamageKHR, (EGLDisplay dpy, EGLSurface surface, const EGLint *rects, EGLint n_rects), (dpy, surface, rects, n_rects), EGL_FALSE) \
	X(EGLBoolean, eglSetDamageRegionKHR, (EGLDisplay dpy, EGLSurface surface, EGLint *rects, EGLint n_rects), (dpy, surface, rects, n_rects), EGL_FALSE) \
	X(EGLBoolean, eglPresentationTimeANDROID, (EGLDisplay dpy, EGLSurface surface, EGLnsecsANDROID time), (dpy, surface, time), EGL_FALSE) \
	X(EGLBoolean, eglGetFrameTimestampsANDROID, (EGLDisplay dpy, EGLSurface surface, EGLuint64KHR frameId, EGLint numTimestamps, const EGLint *timestamps, EGLnsecsANDROID *values), (dpy, surface, frameId, numTimestamps, timestamps, values), EGL_FALSE)

enum {
#define X(ret, name, params, args, fail) DI_##name,
	DISPLAY_FUNCS(X)
#undef X
	DI_COUNT
};

static int dispatch_index[DI_COUNT];

#define X(ret, name, params, args, fail) \
	static ret dispatch_##name params \
	{ \
		__EGLvendorInfo *vendor; \
		ret (*func) params = NULL; \
		exports->threadInit(); \
		vendor = exports->getVendorFromDisplay(dpy); \
		if (vendor) \
			func = (void *) exports->fetchDispatchEntry(vendor, dispatch_index[DI_##name]); \
		if (!func) { \
			exports->setEGLError(EGL_BAD_DISPLAY); \
			return fail; \
		} \
		exports->setLastVendor(vendor); \
		return func args; \
	}
DISPLAY_FUNCS(X)
#undef X

static EGLClientBuffer dispatch_eglGetNativeClientBufferANDROID(const struct AHardwareBuffer *buffer)
{
	EGLClientBuffer (*func)(const struct AHardwareBuffer *);
	if (!system_egl)
		return NULL;
	func = (void *) system_get_proc("eglGetNativeClientBufferANDROID");
	return func ? func(buffer) : NULL;
}

static const struct {
	const char *name;
	void *addr;
} core_table[] = {
#define X(ret, name, params, args, idle, fail) { #name, lazy_##name },
	CORE_FUNCS(X)
#undef X
	{ "eglGetError", lazy_eglGetError },
	{ "eglQueryString", lazy_eglQueryString },
	{ "eglDebugMessageControlKHR", forward_eglDebugMessageControlKHR },
	{ "eglQueryDebugKHR", forward_eglQueryDebugKHR },
	{ "eglLabelObjectKHR", forward_eglLabelObjectKHR },
};

static const struct {
	const char *name;
	void *dispatch;
} dispatch_table[] = {
#define X(ret, name, params, args, fail) { #name, dispatch_##name },
	DISPLAY_FUNCS(X)
#undef X
	{ "eglGetNativeClientBufferANDROID", dispatch_eglGetNativeClientBufferANDROID },
};

static void *android_get_dispatch_address(const char *name)
{
	for (size_t i = 0; i < sizeof(dispatch_table) / sizeof(dispatch_table[0]); i++)
		if (!strcmp(name, dispatch_table[i].name))
			return dispatch_table[i].dispatch;
	return NULL;
}

static void android_set_dispatch_index(const char *name, int index)
{
#define X(ret, fname, params, args, fail) if (!strcmp(name, #fname)) dispatch_index[DI_##fname] = index;
	DISPLAY_FUNCS(X)
#undef X
}

static void *android_get_proc_address(const char *name)
{
	for (size_t i = 0; i < sizeof(core_table) / sizeof(core_table[0]); i++)
		if (!strcmp(name, core_table[i].name))
			return core_table[i].addr;
	if (!system_egl)
		return NULL;
	if (!strncmp(name, "egl", 3)) {
		void *addr = dlsym(system_egl, name);
		if (addr)
			return addr;
	}
	return (void *) system_get_proc(name);
}

static EGLDisplay android_get_platform_display(EGLenum platform, void *native_display, const EGLAttrib *attrib_list)
{
	if (platform != EGL_PLATFORM_ANDROID_KHR || !load_system_egl())
		return EGL_NO_DISPLAY;
	return system_get_display(EGL_DEFAULT_DISPLAY);
}

static EGLBoolean android_get_supports_api(EGLenum api)
{
	return api == EGL_OPENGL_ES_API;
}

static const char *android_get_vendor_string(int name)
{
	return name == __EGL_VENDOR_STRING_PLATFORM_EXTENSIONS ? CLIENT_EXTENSIONS : NULL;
}

PUBLIC EGLBoolean __egl_Main(uint32_t version, const __EGLapiExports *api_exports,
		__EGLvendorInfo *vendor, __EGLapiImports *imports)
{
	if (EGL_VENDOR_ABI_GET_MAJOR_VERSION(version) != EGL_VENDOR_ABI_MAJOR_VERSION)
		return EGL_FALSE;
	exports = api_exports;
	imports->getPlatformDisplay = android_get_platform_display;
	imports->getSupportsAPI = android_get_supports_api;
	imports->getVendorString = android_get_vendor_string;
	imports->getProcAddress = android_get_proc_address;
	imports->getDispatchAddress = android_get_dispatch_address;
	imports->setDispatchIndex = android_set_dispatch_index;
	return EGL_TRUE;
}
