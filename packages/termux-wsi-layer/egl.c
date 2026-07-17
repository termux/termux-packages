#include <stdio.h>
#include <dlfcn.h>
#include <stdlib.h>
#include <EGL/egl.h>
#include <glvnd/libeglabi.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

#include "common.h"

typedef struct {
	EGLDisplay egldpy;
	Display *x11dpy;
} EGLDisplay_t;

struct ANativeWindow* TermuxNativeWindow_create(Display* dpy, Window win);
void TermuxNativeWindow_init(void);

static const char* eglStrError(EGLint err) {
	switch(err) {
#define ERR(e) case e: return #e
	ERR(EGL_SUCCESS);
	ERR(EGL_NOT_INITIALIZED);
	ERR(EGL_BAD_ACCESS);
	ERR(EGL_BAD_ALLOC);
	ERR(EGL_BAD_ATTRIBUTE);
	ERR(EGL_BAD_CONTEXT);
	ERR(EGL_BAD_CONFIG);
	ERR(EGL_BAD_CURRENT_SURFACE);
	ERR(EGL_BAD_DISPLAY);
	ERR(EGL_BAD_SURFACE);
	ERR(EGL_BAD_MATCH);
	ERR(EGL_BAD_PARAMETER);
	ERR(EGL_BAD_NATIVE_PIXMAP);
	ERR(EGL_BAD_NATIVE_WINDOW);
	ERR(EGL_CONTEXT_LOST);
#undef ERR
		default: return "EGL_UNKNOWN_ERROR";
	}
}

// Both OVERRIDE and NO_OVERRIDE are macros like N(required, return type, name, args definition in parentheses, args in parentheses).
// OVERRIDE is for functions we override, NO_OVERRIDE for functions we dlopen from Android implementation and use as is.
#define EGL_FUNCS(OVERRIDE, NO_OVERRIDE) \
	/* EGL_VERSION_1_0 */ \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, ChooseConfig, (EGLDisplay _dpy, const EGLint *attrib_list, EGLConfig *configs, EGLint config_size, EGLint *num_config), (dpy, attrib_list, configs, config_size, num_config)) \
	OVERRIDE(EGL_TRUE, EGLBoolean, CopyBuffers, (EGLDisplay _dpy, EGLSurface surface, EGLNativePixmapType target), (dpy, surface, target)) \
	NO_OVERRIDE(EGL_TRUE, EGLContext, CreateContext, (EGLDisplay _dpy, EGLConfig config, EGLContext share_context, const EGLint *attrib_list), (dpy, config, share_context, attrib_list)) \
	NO_OVERRIDE(EGL_TRUE, EGLSurface, CreatePbufferSurface, (EGLDisplay _dpy, EGLConfig config, const EGLint *attrib_list), (dpy, config, attrib_list)) \
	OVERRIDE(EGL_TRUE, EGLSurface, CreatePixmapSurface, (EGLDisplay _dpy, EGLConfig config, EGLNativePixmapType pixmap, const EGLint *attrib_list), (dpy, config, pixmap, attrib_list)) \
	OVERRIDE(EGL_TRUE, EGLSurface, CreateWindowSurface, (EGLDisplay _dpy, EGLConfig config, EGLNativeWindowType win, const EGLint *attrib_list), (dpy, config, win, attrib_list)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, DestroyContext, (EGLDisplay _dpy, EGLContext ctx), (dpy, ctx)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, DestroySurface, (EGLDisplay _dpy, EGLSurface surface), (dpy, surface)) \
	OVERRIDE(EGL_TRUE, EGLBoolean, GetConfigAttrib, (EGLDisplay _dpy, EGLConfig config, EGLint attribute, EGLint *value), (dpy, config, attribute, value)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, GetConfigs, (EGLDisplay _dpy, EGLConfig *configs, EGLint config_size, EGLint *num_config), (dpy, configs, config_size, num_config)) \
	NO_OVERRIDE(EGL_TRUE, EGLDisplay, GetCurrentDisplay, (void), ()) \
	NO_OVERRIDE(EGL_TRUE, EGLSurface, GetCurrentSurface, (EGLint readdraw), (readdraw)) \
	OVERRIDE(EGL_TRUE, EGLDisplay, GetDisplay, (EGLNativeDisplayType display_id), (display_id)) \
	NO_OVERRIDE(EGL_TRUE, EGLint, GetError, (void), ()) \
	OVERRIDE(EGL_TRUE, __eglMustCastToProperFunctionPointerType, GetProcAddress, (const char *procname), (procname)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, Initialize, (EGLDisplay _dpy, EGLint *major, EGLint *minor), (dpy, major, minor)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, MakeCurrent, (EGLDisplay _dpy, EGLSurface draw, EGLSurface read, EGLContext ctx), (dpy, draw, read, ctx)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, QueryContext, (EGLDisplay _dpy, EGLContext ctx, EGLint attribute, EGLint *value), (dpy, ctx, attribute, value)) \
	OVERRIDE(EGL_TRUE, const char *, QueryString, (EGLDisplay _dpy, EGLint name), (dpy, name)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, QuerySurface, (EGLDisplay _dpy, EGLSurface surface, EGLint attribute, EGLint *value), (dpy, surface, attribute, value)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, SwapBuffers, (EGLDisplay _dpy, EGLSurface surface), (dpy, surface)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, Terminate, (EGLDisplay _dpy), (dpy)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, WaitGL, (void), ()) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, WaitNative, (EGLint engine), (engine)) \
	/* EGL_VERSION_1_0 */ \
	/* EGL_VERSION_1_1 */ \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, BindTexImage, (EGLDisplay _dpy, EGLSurface surface, EGLint buffer), (dpy, surface, buffer)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, ReleaseTexImage, (EGLDisplay _dpy, EGLSurface surface, EGLint buffer), (dpy, surface, buffer)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, SurfaceAttrib, (EGLDisplay _dpy, EGLSurface surface, EGLint attribute, EGLint value), (dpy, surface, attribute, value)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, SwapInterval, (EGLDisplay _dpy, EGLint interval), (dpy, interval)) \
	/* EGL_VERSION_1_1 */ \
	/* EGL_VERSION_1_2 */ \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, BindAPI, (EGLenum api), (api)) \
	NO_OVERRIDE(EGL_TRUE, EGLenum, QueryAPI, (void), ()) \
	NO_OVERRIDE(EGL_TRUE, EGLSurface, CreatePbufferFromClientBuffer, (EGLDisplay _dpy, EGLenum buftype, EGLClientBuffer buffer, EGLConfig config, const EGLint *attrib_list), (dpy, buftype, buffer, config, attrib_list)) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, ReleaseThread, (void), ()) \
	NO_OVERRIDE(EGL_TRUE, EGLBoolean, WaitClient, (void), ()) \
	/* EGL_VERSION_1_2 */ \
	/* EGL_VERSION_1_4 */ \
	NO_OVERRIDE(EGL_TRUE, EGLContext, GetCurrentContext, (void), ()) \
	/* EGL_VERSION_1_4 */ \
	/* EGL_VERSION_1_5 */ \
	NO_OVERRIDE(EGL_FALSE, EGLSync, CreateSync, (EGLDisplay _dpy, EGLenum type, const EGLAttrib *attrib_list), (dpy, type, attrib_list)) \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, DestroySync, (EGLDisplay _dpy, EGLSync sync), (dpy, sync)) \
	NO_OVERRIDE(EGL_FALSE, EGLint, ClientWaitSync, (EGLDisplay _dpy, EGLSync sync, EGLint flags, EGLTime timeout), (dpy, sync, flags, timeout)) \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, GetSyncAttrib, (EGLDisplay _dpy, EGLSync sync, EGLint attribute, EGLAttrib *value), (dpy, sync, attribute, value)) \
	NO_OVERRIDE(EGL_FALSE, EGLImage, CreateImage, (EGLDisplay _dpy, EGLContext ctx, EGLenum target, EGLClientBuffer buffer, const EGLAttrib *attrib_list), (dpy, ctx, target, buffer, attrib_list)) \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, DestroyImage, (EGLDisplay _dpy, EGLImage image), (dpy, image)) \
	OVERRIDE(EGL_FALSE, EGLDisplay, GetPlatformDisplay, (EGLenum platform, void *native_display, const EGLAttrib *attrib_list), (platform, native_display, attrib_list)) \
	NO_OVERRIDE(EGL_FALSE, EGLSurface, CreatePlatformWindowSurface, (EGLDisplay _dpy, EGLConfig config, void *native_window, const EGLAttrib *attrib_list), (dpy, config, native_window, attrib_list)) \
	NO_OVERRIDE(EGL_FALSE, EGLSurface, CreatePlatformPixmapSurface, (EGLDisplay _dpy, EGLConfig config, void *native_pixmap, const EGLAttrib *attrib_list), (dpy, config, native_pixmap, attrib_list)) \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, WaitSync, (EGLDisplay _dpy, EGLSync sync, EGLint flags), (dpy, sync, flags)) \
	/* EGL_VERSION_1_5 */ \
	/* EGL_KHR_debug */ \
	NO_OVERRIDE(EGL_FALSE, EGLint, DebugMessageControlKHR, (void* callback, const EGLAttrib *attrib_list), (callback, attrib_list)) \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDebugKHR, (EGLint attribute, EGLAttrib *value),  (attribute, value)) \
	NO_OVERRIDE(EGL_FALSE, EGLint, LabelObjectKHR, (EGLDisplay _dpy, EGLenum objectType, EGLObjectKHR object, EGLLabelKHR label), (dpy, objectType, object, label)) \
	/* EGL_KHR_debug */ \
	/* EGL_KHR_display_reference */ \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDisplayAttribKHR, (EGLDisplay _dpy, EGLint name, EGLAttrib *value), (dpy, name, value)) \
	/* EGL_KHR_display_reference */ \
	/* EGL_EXT_device_base */ \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDeviceAttribEXT, (EGLDeviceEXT device, EGLint attribute, EGLAttrib *value), (device, attribute, value)) \
	NO_OVERRIDE(EGL_FALSE, const char *, QueryDeviceStringEXT, (EGLDeviceEXT device, EGLint name), (device, name)) \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDevicesEXT, (EGLint max_devices, EGLDeviceEXT *devices, EGLint *num_devices), (max_devices, devices, num_devices)) \
	NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDisplayAttribEXT, (EGLDisplay _dpy, EGLint attribute, EGLAttrib *value), (dpy, attribute, value)) \
	/* EGL_EXT_device_base */

static struct {
#define FUNC(required, ret, name, argsdef, args) ret (*egl ## name) argsdef;
	EGL_FUNCS(FUNC, FUNC) // NOLINT(*-reserved-identifier)
#undef FUNC
} android;
static void* GLESv2 = NULL;
static const char* extensions = NULL;

static const __EGLapiExports *apiExports = NULL;
static EGLDisplay _dpy = EGL_NO_DISPLAY; // It will be shadowed by local function argument definition

#define WRAP(required, ret, name, argsdef, args) \
	EGLAPI ret termuxEGL_ ## name argsdef { \
		apiExports->threadInit();	\
		EGLDisplay dpy = (_dpy != EGL_NO_DISPLAY) ? ((EGLDisplay_t*) _dpy)->egldpy : EGL_NO_DISPLAY; \
		ret r = android.egl ## name args;	\
		EGLint err = android.eglGetError(); \
		apiExports->setEGLError(err);	\
		if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking " #name " ended with error %s (0x%X)\n", eglStrError(err), err);	\
		return r; \
	}
#define NOWRAP(required, ret, name, argsdef, args)
EGL_FUNCS(NOWRAP, WRAP)
#undef WRAP
#undef NOWRAP

EGLAPI EGLBoolean termuxEGL_CopyBuffers(EGLDisplay __unused dpy, EGLSurface __unused surface, EGLNativePixmapType __unused target) {
	// eglCopyBuffers is not implemented on Android
	apiExports->threadInit();
	apiExports->setEGLError(EGL_BAD_NATIVE_PIXMAP);
	return EGL_FALSE;
}

EGLAPI EGLSurface termuxEGL_CreatePixmapSurface(EGLDisplay __unused dpy, EGLSurface __unused surface, EGLNativePixmapType __unused target) {
	// eglCreatePixmapSurface is not implemented on Android
	apiExports->threadInit();
	apiExports->setEGLError(EGL_BAD_ALLOC);
	return EGL_NO_SURFACE;
}

EGLAPI EGLSurface termuxEGL_CreateWindowSurface (EGLDisplay dpy, EGLConfig config, EGLNativeWindowType win, const EGLint *attrib_list) {
	apiExports->threadInit();
	EGLDisplay_t* _dpy = dpy;
	if (_dpy == NULL || _dpy->egldpy == EGL_NO_DISPLAY || _dpy->x11dpy == NULL) {
		apiExports->setEGLError(EGL_BAD_DISPLAY);
		return EGL_NO_SURFACE;
	}

	EGLSurface r = android.eglCreateWindowSurface(_dpy->egldpy, config, (EGLNativeWindowType) TermuxNativeWindow_create(_dpy->x11dpy, win), attrib_list);
	EGLint err = android.eglGetError();
	if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking eglCreateWindowSurface ended with error %s (0x%X)\n", eglStrError(err), err);
	apiExports->setEGLError(err);
	return r;
}

EGLAPI EGLBoolean termuxEGL_GetConfigAttrib(EGLDisplay dpy, EGLConfig config, EGLint attribute, EGLint *value) {
	apiExports->threadInit();
	EGLDisplay_t* _dpy = dpy;
	if (attribute == EGL_NATIVE_VISUAL_ID) {
		if (_dpy == EGL_NO_DISPLAY || _dpy->x11dpy == NULL) {
			*value = 0;
			apiExports->setEGLError(EGL_SUCCESS);
			return EGL_TRUE;
		}

		int count = 0;
		XVisualInfo t = { .depth = 24 }, *info = XGetVisualInfo (_dpy->x11dpy, VisualDepthMask, &t, &count);

		if (count) {
			*value = (EGLint) info->visualid;
			apiExports->setEGLError(EGL_SUCCESS);
			return EGL_TRUE;
		}

		apiExports->setEGLError(EGL_BAD_ATTRIBUTE);
		return EGL_FALSE;
	}

	EGLBoolean r = android.eglGetConfigAttrib(_dpy == EGL_NO_DISPLAY ? EGL_NO_DISPLAY : _dpy->egldpy, config, attribute, value);
	EGLint err = android.eglGetError();
	if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking GetConfigAttrib ended with error %s (0x%X)\n", eglStrError(err), err);
	apiExports->setEGLError(err);
	return r;
}

EGLAPI const char * termuxEGL_QueryString(EGLDisplay dpy, EGLint name) {
	apiExports->threadInit();
	EGLDisplay_t* _dpy = dpy;
	if (name == EGL_EXTENSIONS) {
		apiExports->setEGLError(EGL_SUCCESS);
		return extensions;
	}
	if (name == EGL_CLIENT_APIS) {
		apiExports->setEGLError(EGL_SUCCESS);
		return "OpenGL_ES";
	}

	const char *r = android.eglQueryString(_dpy == EGL_NO_DISPLAY ? EGL_NO_DISPLAY : _dpy->egldpy, name);
	EGLint err = android.eglGetError();
	apiExports->setEGLError(err);
	if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking eglQueryString ended with error %s (0x%X)\n", eglStrError(err), err);
	return r;
}

EGLAPI EGLDisplay termuxEGL_GetPlatformDisplay(EGLenum platform, void *nativeDisplay, const EGLAttrib *attrib_list) {
	apiExports->threadInit();

	if (platform == EGL_PLATFORM_GBM_KHR) {
		dprintf(2, "GBM is not supported.\n");
		return EGL_NO_DISPLAY;
	}

	if (platform == EGL_PLATFORM_WAYLAND_KHR) {
		dprintf(2, "Wayland is not supported.\n");
		return EGL_NO_DISPLAY;
	}

	if (platform == EGL_PLATFORM_DEVICE_EXT) {
		dprintf(2, "Device surface extension is not supported.\n");
		return EGL_NO_DISPLAY;
	}

	if (platform == EGL_PLATFORM_SURFACELESS_MESA) {
		dprintf(2, "Surfaceless mesa extension is not supported.\n");
		return EGL_NO_DISPLAY;
	}

	EGLDisplay_t *dpy = NULL;
	EGLDisplay r = android.eglGetDisplay(EGL_DEFAULT_DISPLAY);
	apiExports->setEGLError(android.eglGetError());

	if (r != EGL_NO_DISPLAY) {
		// ReSharper disable once CppDFAMemoryLeak
		dpy = calloc(1, sizeof(*dpy));
		dpy->egldpy = r;
		dpy->x11dpy = nativeDisplay;
	}

	return (EGLDisplay) dpy;
}

EGLAPI EGLDisplay termuxEGL_GetDisplay (EGLNativeDisplayType display_id) {
	apiExports->threadInit();
	dprintf(2, "Error: termuxEGL_GetDisplay is not implemented by design. Report bug if you see this message\n");
	apiExports->setEGLError(EGL_BAD_ALLOC);
	return EGL_NO_DISPLAY;
}

EGLAPI void * termuxEGL_GetProcAddress(const char *procName) {
	if (!strncmp("egl", procName, 3)) {
		if (0) {}
#define FUNC(required, ret, name, argsdef, args) else if (!strcmp("egl" #name, procName)) return termuxEGL_ ## name;
		EGL_FUNCS(FUNC, FUNC)
#undef FUNC
		dprintf(2, "Error: failed to locate %s symbol using GetProcAddress since it is not implemented\n", procName);
		return NULL;
	}
	if (!strncmp("gl", procName, 2)) {
		void* f = dlsym(GLESv2, procName);
		// if (!f)
			// dprintf(2, "Error: failed to locate %s symbol due to linker error: %s\n", procName, dlerror());
		return f;
	}

	dprintf(2, "Error: failed to locate %s symbol because it does not start with `gl` or `egl`\n", procName);
	return NULL;
}

EGLAPI EGLBoolean termuxEGL_GetSupportsAPI(EGLenum api) {
	return api == EGL_OPENGL_ES_API ? EGL_TRUE : EGL_FALSE;
}

EGLAPI const char * termuxEGL_GetVendorString(int name) {
	if (name == __EGL_VENDOR_STRING_PLATFORM_EXTENSIONS)
		return "EGL_KHR_platform_android EGL_KHR_platform_x11 EGL_EXT_platform_x11 EGL_EXT_platform_xcb";
	return NULL;
}

EGLAPI void *termuxEGL_GetDispatchAddress(const char *procName) {
	dprintf(2, "Error: %s is not implemented yet, call with arg \"%s\" is not effective\n", __FUNCTION__, procName); // TODO: implement me
	return NULL;
}

EGLAPI void termuxEGL_SetDispatchIndex(const char * __unused procName, int __unused index) {
	// Not necessary to be implemented
}

EGLAPI EGLBoolean __egl_Main(uint32_t version, const __EGLapiExports *exports, __EGLvendorInfo __unused *vendor, __EGLapiImports *imports) {
	const char* useAngle = getenv("USE_ANGLE");
	void *EGL = NULL;
	char eglpath[128] = {0}, gles2path[128] = {0};
	if (EGL_VENDOR_ABI_GET_MAJOR_VERSION(version) != EGL_VENDOR_ABI_MAJOR_VERSION) {
		dprintf(2, "Error: GLVND abi version mismatch");
		return EGL_FALSE;
	}

	if (apiExports != NULL)
		return EGL_TRUE; // Already initialized.

	if (!AHardwareBuffer_allocate || !AHardwareBuffer_release || !AHardwareBuffer_describe || !AHardwareBuffer_sendHandleToUnixSocket
			|| (!AHardwareBuffer_to_ANativeWindowBuffer && !GraphicBuffer_getNativeBuffer)) {
		dprintf(2, "Error: Required symbols not found. termux-wsi-layer is not being used.\n");
		dprintf(2, "AHardwareBuffer_allocate: %p\n", AHardwareBuffer_allocate);
		dprintf(2, "AHardwareBuffer_release: %p\n", AHardwareBuffer_release);
		dprintf(2, "AHardwareBuffer_describe: %p\n", AHardwareBuffer_describe);
		dprintf(2, "AHardwareBuffer_sendHandleToUnixSocket: %p\n", AHardwareBuffer_sendHandleToUnixSocket);
		dprintf(2, "AHardwareBuffer_to_ANativeWindowBuffer: %p\n", AHardwareBuffer_to_ANativeWindowBuffer);
		dprintf(2, "GraphicBuffer_getNativeBuffer: %p\n", GraphicBuffer_getNativeBuffer);
		return EGL_FALSE;
	}

	if (useAngle) {
		if (strcmp("gl", useAngle) != 0 && strcmp("vulkan", useAngle) != 0 && strcmp("vulkan-null", useAngle) != 0) {
			dprintf(2, "Error: wrong USE_ANGLE variable, must be one of: gl, vulkan, vulkan-null.\n");
			dprintf(2, "Falling back to Android EGL/GLESv2.\n");
			useAngle = NULL;
		} else {
			snprintf(eglpath, sizeof(eglpath), "%s/opt/angle-android/%s/libEGL_angle.so", getenv("PREFIX"), useAngle);
			snprintf(gles2path, sizeof(gles2path), "%s/opt/angle-android/%s/libGLESv2_angle.so", getenv("PREFIX"), useAngle);
		}
	}

	if (!useAngle) {
#ifndef __LP64__
		snprintf(eglpath, sizeof(eglpath), "/system/lib/libEGL.so");
		snprintf(gles2path, sizeof(gles2path), "/system/lib/libGLESv2.so");
#else
		snprintf(eglpath, sizeof(eglpath), "/system/lib64/libEGL.so");
		snprintf(gles2path, sizeof(gles2path), "/system/lib64/libGLESv2.so");
#endif
	}

	EGL = dlopen(eglpath, RTLD_NOW | RTLD_GLOBAL);
	if (!EGL) {
		char* error;
		while ((error = dlerror()))
			dprintf(2, "Error: EGL linking: %s\n", error);
		return EGL_FALSE;
	}

	GLESv2 = dlopen(gles2path, RTLD_NOW | RTLD_GLOBAL);
	if (!GLESv2) {
		char* error;
		while ((error = dlerror()))
			dprintf(2, "Error: GLESv2 linking: %s\n", error);
		return EGL_FALSE;
	}

#define FUNC(required, ret, name, argsdef, args) \
		android.egl ## name = dlsym(EGL, "egl" #name); \
		if (!android.egl ## name && required) { \
			dprintf(2, "Error: EGL symbol resolution: %s\n", dlerror()); \
			return EGL_FALSE; \
		}
EGL_FUNCS(FUNC, FUNC)
#undef FUNC

	asprintf((char**) &extensions, "%s %s", termuxEGL_GetVendorString(__EGL_VENDOR_STRING_PLATFORM_EXTENSIONS), android.eglQueryString(EGL_NO_DISPLAY, EGL_EXTENSIONS));

	TermuxNativeWindow_init();

	apiExports = exports;

	imports->getPlatformDisplay = termuxEGL_GetPlatformDisplay;
	imports->getSupportsAPI = termuxEGL_GetSupportsAPI;
	imports->getVendorString = termuxEGL_GetVendorString;
	imports->getProcAddress = termuxEGL_GetProcAddress;
	imports->getDispatchAddress = termuxEGL_GetDispatchAddress;
	imports->setDispatchIndex = termuxEGL_SetDispatchIndex;

	return EGL_TRUE;
}
