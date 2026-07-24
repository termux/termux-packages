/*
 * Copyright (c) 2024 Twaik Yont <twaikyont@gmail.com>
 *
 * Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * https://www.gnu.org/licenses/gpl-3.0.en.html
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#pragma ide diagnostic ignored "OCUnusedGlobalDeclarationInspection"
#pragma ide diagnostic ignored "OCUnusedMacroInspection"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <dlfcn.h>
#include <errno.h>
#include <syscall.h>
#include <sys/socket.h>
#include <X11/Xlib.h>
#include <X11/Xlib-xcb.h>
#include <X11/Xutil.h>
#include <xcb/xcb.h>
#include <xcb/present.h>
#define GL_GLEXT_PROTOTYPES
#include <glvnd/libeglabi.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>

// Workaround for `error: 'AHardwareBuffer_describe' is unavailable: introduced in Android 26`
// We will explicitly mark these symbols as weak to avoid using `ANDROID_UNAVAILABLE_SYMBOLS_ARE_WEAK`
// These symbols will equal to NULL in the case if they were not linked and we can check this in __egl_Main
#undef __INTRODUCED_IN // NOLINT(*-reserved-identifier)
#define __INTRODUCED_IN(...) __attribute__((weak))
#include <android/hardware_buffer.h>
#undef __INTRODUCED_IN
#define __INTRODUCED_IN ERROR // This include must be the last included Android API header

#undef EGLAPI
#define EGLAPI KHRONOS_APICALL __used

#define glCheckError() do { GLenum _err_; if ((_err_ = glGetError()) != GL_NO_ERROR) dprintf(2, "%s:%d: GL error 0x%X\n", __FILE__, __LINE__, _err_); } while (0)

#include "list.h"

typedef union {
    xcb_generic_event_t generic;
    xcb_present_generic_event_t present;
    xcb_present_complete_notify_event_t complete;
    xcb_present_configure_notify_event_t config;
} xcb_event_t;

typedef struct {
    uint32_t magic[2];
} TEGLObjectBase_t;

typedef struct {
    TEGLObjectBase_t obj; // Must be initialized to { TERMUX_MAGIC_OBJ, TERMUX_MAGIC_DPY }
    EGLDisplay base; // Wrapped EGLDisplay of underlying implementation
    list link;

    Display *x11dpy;
    // TODO: store displays in double linked list for accessing them with eglGetCurrentDisplay();
} TEGLDisplay_t, *TEGLDisplay;

typedef struct {
    TEGLObjectBase_t obj; // Must be initialized to { TERMUX_MAGIC_OBJ, TERMUX_MAGIC_CTX }
    EGLContext base; // Wrapped EGLContext of underlying implementation
    list link;
    bool viewportInitialized; // mesa initializes viewport with window surface size when context created

    GLuint fb_id, rb_id[2]; // target framebuffer and renderbuffers for our EGLImages
} TEGLContext_t, *TEGLContext;

typedef struct {
    TEGLObjectBase_t obj; // Must be initialized to { TERMUX_MAGIC_OBJ, TERMUX_MAGIC_SFC }
    EGLSurface base; // Wrapped EGLSurface of underlying implementation
    list link;
    enum __attribute__ ((__packed__)) {
        TEGL_SURFACE_NATIVE = 0,
        TEGL_SURFACE_PBUFFER = 1,
        TEGL_SURFACE_PIXMAP = 2,
        TEGL_SURFACE_WINDOW = 3,
    } type;

    TEGLDisplay dpy;
    EGLContext ctx;

    xcb_connection_t *conn;
    xcb_special_event_t *special_event;
    xcb_gcontext_t gc;
    xcb_window_t win;
    int32_t width, height, usage;
    bool allocationNeeded;
    uint8_t swapInterval;
    struct {
        AHardwareBuffer* self;
        uint32_t pixmap, serial;
        uint32_t width, height;
        uint8_t busy;
        EGLImage img;
    } buffers[2], *front, *back;

    // TODO: store surfaces in double linked list for accessing them with eglGetCurrentSurface();
} TEGLSurface_t, *TEGLSurface;

list displays = { &displays, &displays };
list contexts = { &contexts, &contexts };
list surfaces = { &surfaces, &surfaces };

#define MAKE_CONSTANT(a,b,c,d) (((unsigned)(a)<<24)|((unsigned)(b)<<16)|((unsigned)(c)<<8)|(unsigned)(d))
#define TERMUX_MAGIC_OBJ MAKE_CONSTANT('T','R','M','X')
#define TERMUX_MAGIC_DPY MAKE_CONSTANT('_','d','p','y')
#define TERMUX_MAGIC_CTX MAKE_CONSTANT('_','c','t','x')
#define TERMUX_MAGIC_SFC MAKE_CONSTANT('_','s','f','c')

#define ASSERT_DPY(p, ret) ASSERT_OBJ(p, TERMUX_MAGIC_DPY, EGL_BAD_DISPLAY, ret)
#define ASSERT_CTX(p, ret) ASSERT_OBJ(p, TERMUX_MAGIC_CTX, EGL_BAD_CONTEXT, ret)
#define ASSERT_SFC(p, ret) ASSERT_OBJ(p, TERMUX_MAGIC_SFC, EGL_BAD_SURFACE, ret)
#define ASSERT_OBJ(p, _magic, err, ret) \
do { \
    TEGLDisplay _dpy_ = (p); \
    if (_dpy_ != NULL && (_dpy_->obj.magic[0] != TERMUX_MAGIC_OBJ || _dpy_->obj.magic[1] != _magic)) { \
        apiExports->setEGLError(err); \
        return ret; \
    } \
} while (0)

#define UNWRAP_DPY(obj) ((obj) == NULL ? NULL : ((TEGLDisplay) obj)->base)
#define UNWRAP_CTX(obj) ((obj) == NULL ? NULL : ((TEGLContext) obj)->base)
#define UNWRAP_SFC(obj) ((obj) == NULL ? NULL : ((TEGLSurface) obj)->base)

#define CAST_DPY(obj) ((TEGLDisplay) (obj))
#define CAST_CTX(obj) ((TEGLContext) (obj))
#define CAST_SFC(obj) ((TEGLSurface) (obj))

static __always_inline TEGLDisplay displayFromEGL(EGLDisplay dpy) {
    if (!dpy)
        return EGL_NO_DISPLAY;

    TEGLDisplay pos = NULL;
    list_for_each(pos, &displays, link) {
        if (pos->base == dpy)
            return pos;
    }

    return EGL_NO_DISPLAY;
}

static __always_inline TEGLContext contextFromEGL(EGLContext ctx) {
    if (!ctx)
        return EGL_NO_CONTEXT;

    TEGLContext pos = NULL;
    list_for_each(pos, &contexts, link) {
        if (pos->base == ctx)
            return pos;
    }

    return EGL_NO_CONTEXT;
}

static __always_inline TEGLSurface surfaceFromEGL(EGLSurface sfc) {
    if (!sfc)
        return EGL_NO_SURFACE;

    TEGLSurface pos = NULL;
    list_for_each(pos, &surfaces, link) {
        if (pos->base == sfc)
            return pos;
    }

    return EGL_NO_SURFACE;
}

static const char* eglStrError(EGLint err) {
    switch(err) {
        #define ERRORS(M) M(SUCCESS) M(NOT_INITIALIZED) M(BAD_ACCESS) M(BAD_ALLOC) M(BAD_ATTRIBUTE) M(BAD_CONTEXT) M(BAD_CONFIG) M(BAD_DISPLAY) \
        M(BAD_CURRENT_SURFACE) M(BAD_SURFACE) M(BAD_MATCH) M(BAD_PARAMETER) M(BAD_NATIVE_PIXMAP) M(BAD_NATIVE_WINDOW) M(CONTEXT_LOST)
        #define ERR(e) case EGL_##e: return "EGL_"#e;
        ERRORS(ERR)
        #undef ERR
        #undef ERRORS
        default: return "EGL_UNKNOWN_ERROR";
    }
}

// Both OVERRIDE and NO_OVERRIDE are macros like N(required, return type, name, args definition in parentheses, wrapper intro, args in parentheses).
// OVERRIDE is for functions we override, NO_OVERRIDE for functions we dlopen from Android implementation and use as is.
#define EGL_FUNCS(OVERRIDE, NO_OVERRIDE) \
/* EGL_VERSION_1_0 */ \
OVERRIDE(EGL_TRUE, EGLBoolean, ChooseConfig, (EGLDisplay dpy, const EGLint *attrib_list, EGLConfig *configs, EGLint config_size, EGLint *num_config), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), attrib_list, configs, config_size, num_config)) \
OVERRIDE(EGL_TRUE, EGLBoolean, CopyBuffers, (EGLDisplay dpy, EGLSurface sfc, EGLNativePixmapType target), ASSERT_DPY(dpy); ASSERT_SFC(sfc, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), target)) \
OVERRIDE(EGL_TRUE, EGLContext, CreateContext, (EGLDisplay dpy, EGLConfig config, EGLContext share_context, const EGLint *attrib_list), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_CTX(share_context, EGL_FALSE);, (UNWRAP_DPY(dpy), config, UNWRAP_CTX(share_context), attrib_list)) \
NO_OVERRIDE(EGL_TRUE, EGLSurface, CreatePbufferSurface, (EGLDisplay dpy, EGLConfig config, const EGLint *attrib_list), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), config, attrib_list)) \
OVERRIDE(EGL_TRUE, EGLSurface, CreatePixmapSurface, (EGLDisplay dpy, EGLConfig config, EGLNativePixmapType pixmap, const EGLint *attrib_list), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), config, pixmap, attrib_list)) \
OVERRIDE(EGL_TRUE, EGLSurface, CreateWindowSurface, (EGLDisplay dpy, EGLConfig config, EGLNativeWindowType win, const EGLint *attrib_list), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), config, win, attrib_list)) \
OVERRIDE(EGL_TRUE, EGLBoolean, DestroyContext, (EGLDisplay dpy, EGLContext ctx), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_CTX(ctx, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_CTX(ctx))) \
OVERRIDE(EGL_TRUE, EGLBoolean, DestroySurface, (EGLDisplay dpy, EGLSurface sfc), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_SFC(sfc, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_SFC(sfc))) \
OVERRIDE(EGL_TRUE, EGLBoolean, GetConfigAttrib, (EGLDisplay dpy, EGLConfig config, EGLint attribute, EGLint *value), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), config, attribute, value)) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, GetConfigs, (EGLDisplay dpy, EGLConfig *configs, EGLint config_size, EGLint *num_config), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), configs, config_size, num_config)) \
OVERRIDE(EGL_TRUE, EGLDisplay, GetCurrentDisplay, (void),, ()) \
OVERRIDE(EGL_TRUE, EGLSurface, GetCurrentSurface, (EGLint readdraw),, (readdraw)) \
OVERRIDE(EGL_TRUE, EGLDisplay, GetDisplay, (EGLNativeDisplayType display_id),, (display_id)) \
NO_OVERRIDE(EGL_TRUE, EGLint, GetError, (void),, ()) \
OVERRIDE(EGL_TRUE, void*, GetProcAddress, (const char *procname),, (procname)) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, Initialize, (EGLDisplay dpy, EGLint *major, EGLint *minor), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), major, minor)) \
OVERRIDE(EGL_TRUE, EGLBoolean, MakeCurrent, (EGLDisplay dpy, EGLSurface draw, EGLSurface read, EGLContext ctx), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_SFC(draw, EGL_FALSE); ASSERT_SFC(read, EGL_FALSE); ASSERT_CTX(ctx, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_SFC(draw), UNWRAP_SFC(read), UNWRAP_CTX(ctx))) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, QueryContext, (EGLDisplay dpy, EGLContext ctx, EGLint attribute, EGLint *value), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_CTX(ctx, EGL_FALSE), (UNWRAP_DPY(dpy), UNWRAP_CTX(ctx), attribute, value)) \
OVERRIDE(EGL_TRUE, const char *, QueryString, (EGLDisplay dpy, EGLint name), ASSERT_DPY(dpy, NULL);, (UNWRAP_DPY(dpy), name)) \
OVERRIDE(EGL_TRUE, EGLBoolean, QuerySurface, (EGLDisplay dpy, EGLSurface sfc, EGLint attribute, EGLint *value), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_SFC(sfc, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), attribute, value)) \
OVERRIDE(EGL_TRUE, EGLBoolean, SwapBuffers, (EGLDisplay dpy, EGLSurface sfc), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_SFC(sfc, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_SFC(sfc))) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, Terminate, (EGLDisplay dpy), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy))) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, WaitGL, (void),, ()) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, WaitNative, (EGLint engine),, (engine)) \
/* EGL_VERSION_1_0 */ \
/* EGL_VERSION_1_1 */ \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, BindTexImage, (EGLDisplay dpy, EGLSurface sfc, EGLint buffer), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_SFC(sfc, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), buffer)) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, ReleaseTexImage, (EGLDisplay dpy, EGLSurface sfc, EGLint buffer), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_SFC(sfc, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), buffer)) \
OVERRIDE(EGL_TRUE, EGLBoolean, SurfaceAttrib, (EGLDisplay dpy, EGLSurface sfc, EGLint attribute, EGLint value), ASSERT_DPY(dpy, EGL_FALSE); ASSERT_SFC(sfc, EGL_FALSE);, (UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), attribute, value)) \
OVERRIDE(EGL_TRUE, EGLBoolean, SwapInterval, (EGLDisplay dpy, EGLint interval), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), interval)) \
/* EGL_VERSION_1_1 */ \
/* EGL_VERSION_1_2 */ \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, BindAPI, (EGLenum api),, (api)) \
NO_OVERRIDE(EGL_TRUE, EGLenum, QueryAPI, (void),, ()) \
NO_OVERRIDE(EGL_TRUE, EGLSurface, CreatePbufferFromClientBuffer, (EGLDisplay dpy, EGLenum buftype, EGLClientBuffer buffer, EGLConfig config, const EGLint *attrib_list), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), buftype, buffer, config, attrib_list)) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, ReleaseThread, (void),, ()) \
NO_OVERRIDE(EGL_TRUE, EGLBoolean, WaitClient, (void),, ()) \
/* EGL_VERSION_1_2 */ \
/* EGL_VERSION_1_4 */ \
OVERRIDE(EGL_TRUE, EGLContext, GetCurrentContext, (void),, ()) \
/* EGL_VERSION_1_4 */ \
/* EGL_VERSION_1_5 */ \
NO_OVERRIDE(EGL_FALSE, EGLSync, CreateSync, (EGLDisplay dpy, EGLenum type, const EGLAttrib *attrib_list), ASSERT_DPY(dpy, EGL_NO_SYNC);, (UNWRAP_DPY(dpy), type, attrib_list)) \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, DestroySync, (EGLDisplay dpy, EGLSync sync), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), sync)) \
NO_OVERRIDE(EGL_FALSE, EGLint, ClientWaitSync, (EGLDisplay dpy, EGLSync sync, EGLint flags, EGLTime timeout), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), sync, flags, timeout)) \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, GetSyncAttrib, (EGLDisplay dpy, EGLSync sync, EGLint attribute, EGLAttrib *value), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), sync, attribute, value)) \
NO_OVERRIDE(EGL_FALSE, EGLImage, CreateImage, (EGLDisplay dpy, EGLContext ctx, EGLenum target, EGLClientBuffer buffer, const EGLAttrib *attrib_list), ASSERT_DPY(dpy, EGL_NO_IMAGE); ASSERT_CTX(ctx, EGL_NO_IMAGE), (UNWRAP_DPY(dpy), UNWRAP_CTX(ctx), target, buffer, attrib_list)) \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, DestroyImage, (EGLDisplay dpy, EGLImage image), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), image)) \
OVERRIDE(EGL_FALSE, EGLDisplay, GetPlatformDisplay, (EGLenum platform, void *native_display, const EGLAttrib *attrib_list),, (platform, native_display, attrib_list)) \
OVERRIDE(EGL_FALSE, EGLSurface, CreatePlatformWindowSurface, (EGLDisplay dpy, EGLConfig config, void *native_window, const EGLAttrib *attrib_list), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), config, native_window, attrib_list)) \
OVERRIDE(EGL_FALSE, EGLSurface, CreatePlatformPixmapSurface, (EGLDisplay dpy, EGLConfig config, void *native_pixmap, const EGLAttrib *attrib_list), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), config, native_pixmap, attrib_list)) \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, WaitSync, (EGLDisplay dpy, EGLSync sync, EGLint flags), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), sync, flags)) \
/* EGL_VERSION_1_5 */ \
/* EGL_KHR_debug */ \
NO_OVERRIDE(EGL_FALSE, EGLint, DebugMessageControlKHR, (void* callback, const EGLAttrib *attrib_list),, (callback, attrib_list)) \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDebugKHR, (EGLint attribute, EGLAttrib *value),,  (attribute, value)) \
NO_OVERRIDE(EGL_FALSE, EGLint, LabelObjectKHR, (EGLDisplay dpy, EGLenum objectType, EGLObjectKHR object, EGLLabelKHR label), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), objectType, object, label)) \
/* EGL_KHR_debug */ \
/* EGL_KHR_display_reference */ \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDisplayAttribKHR, (EGLDisplay dpy, EGLint name, EGLAttrib *value), ASSERT_DPY(dpy, EGL_BAD_DISPLAY);, (UNWRAP_DPY(dpy), name, value)) \
/* EGL_KHR_display_reference */ \
/* EGL_EXT_device_base */ \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDeviceAttribEXT, (EGLDeviceEXT device, EGLint attribute, EGLAttrib *value),, (device, attribute, value)) \
NO_OVERRIDE(EGL_FALSE, const char *, QueryDeviceStringEXT, (EGLDeviceEXT device, EGLint name),, (device, name)) \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDevicesEXT, (EGLint max_devices, EGLDeviceEXT *devices, EGLint *num_devices),, (max_devices, devices, num_devices)) \
NO_OVERRIDE(EGL_FALSE, EGLBoolean, QueryDisplayAttribEXT, (EGLDisplay dpy, EGLint attribute, EGLAttrib *value), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), attribute, value)) \
/* EGL_EXT_device_base */ \
/* EGL_KHR_IMAGE */ \
NO_OVERRIDE(EGL_TRUE, EGLImageKHR, CreateImageKHR, (EGLDisplay dpy, EGLContext ctx, EGLenum target, EGLClientBuffer buffer, const EGLint *attrib_list), ASSERT_DPY(dpy, EGL_NO_IMAGE); ASSERT_CTX(ctx, EGL_NO_IMAGE), (UNWRAP_DPY(dpy), UNWRAP_CTX(ctx), target, buffer, attrib_list)) \
NO_OVERRIDE(EGL_TRUE, EGLImageKHR, DestroyImageKHR, (EGLDisplay dpy, EGLImageKHR image), ASSERT_DPY(dpy, EGL_FALSE);, (UNWRAP_DPY(dpy), image)) \
/* EGL_KHR_IMAGE */ \
/* EGL_ANDROID_get_native_client_buffer */ \
NO_OVERRIDE(EGL_TRUE, EGLClientBuffer, GetNativeClientBufferANDROID, (const struct AHardwareBuffer *buffer),, (buffer)) \
/* EGL_ANDROID_get_native_client_buffer */

#define GL_FUNCS(F) F(glGetError) F(glFinish) F(glGetIntegerv) F(glGenRenderbuffers) F(glGenFramebuffers) F(glBindRenderbuffer) F(glFramebufferRenderbuffer) F(glRenderbufferStorage) F(glBindFramebuffer) F(glEGLImageTargetRenderbufferStorageOES) F(glDrawArrays) F(glDrawElements)

static const __EGLapiExports *apiExports = NULL;
static struct {
#define FUNC(required, ret, name, argsdef, intro, args) ret (*name) argsdef;
    EGL_FUNCS(FUNC, FUNC) // NOLINT(*-reserved-identifier)
#undef FUNC
#define WRAP_GL(f) __typeof__(f) *f;
    GL_FUNCS(WRAP_GL)
#undef WRAP_GL
} origin;
static void* GLESv2 = NULL;
static const char* extensions = NULL;

#define WRAP(required, ret, name, argsdef, intro, args) \
EGLAPI ret termuxEGL_ ## name argsdef { \
    apiExports->threadInit();	\
    intro; \
    ret r = origin.name args;	\
    EGLint err = origin.GetError(); \
    apiExports->setEGLError(err);	\
    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking " #name " ended with error %s (0x%X)\n", eglStrError(err), err);	\
    return r; \
}
#define NOWRAP(required, ret, name, argsdef, intro, args)
#define GEN_DECLARATION(required, ret, name, argsdef, intro, args) EGLAPI ret termuxEGL_ ## name argsdef;
EGL_FUNCS(GEN_DECLARATION, GEN_DECLARATION)
EGL_FUNCS(NOWRAP, WRAP)
#undef GEN_DECLARATION
#undef WRAP
#undef NOWRAP

/**
 * eglChooseConfig wrapper
 * @param dpy
 * @param attrib_list
 * @param configs
 * @param config_size
 * @param num_config
 * @return
 */
EGLAPI EGLBoolean termuxEGL_ChooseConfig(EGLDisplay dpy, const EGLint *attrib_list, EGLConfig *configs, EGLint config_size, EGLint *num_config) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);
    uint32_t attrib_size = 0;
    for (uint32_t i=0;; i++) {
        if (attrib_list[i] == EGL_NONE) {
            attrib_size = (i + 1) * sizeof(EGLint);
            break;
        }
    }

    EGLint *new_attrib_list = alloca(attrib_size);
    memset(new_attrib_list, 0, attrib_size);

    for (uint32_t i=0;; i+=2) {
        if (attrib_list[i] == EGL_NONE) {
            new_attrib_list[i] = EGL_NONE;
            break;
        }

        new_attrib_list[i] = attrib_list[i];
        new_attrib_list[i+1] = attrib_list[i+1];

        if (attrib_list[i] == EGL_SURFACE_TYPE && new_attrib_list[i+1] & EGL_WINDOW_BIT) {
            new_attrib_list[i + 1] |= EGL_PBUFFER_BIT;
            new_attrib_list[i + 1] &= ~EGL_WINDOW_BIT;
        }
    }

    EGLBoolean r = origin.ChooseConfig(UNWRAP_DPY(dpy), new_attrib_list, configs, config_size, num_config);
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);
    if (err != EGL_SUCCESS)
        dprintf(2, "Error: Invoking ChooseConfig ended with error %s (0x%X) %d\n", eglStrError(err), err, *num_config);
    return r;
}

/**
 * eglCopyBuffers stub
 * @param dpy
 * @param surface
 * @param target
 * @return
 */
EGLAPI EGLBoolean termuxEGL_CopyBuffers(EGLDisplay __unused dpy, EGLSurface __unused surface, EGLNativePixmapType __unused target) {
    // eglCopyBuffers is not implemented on Android
    apiExports->threadInit();
    apiExports->setEGLError(EGL_BAD_NATIVE_PIXMAP);
    return EGL_FALSE;
}

/**
 * eglCreateContext wrapper
 * @param dpy
 * @param config
 * @param share_context
 * @param attrib_list
 * @return
 */
EGLAPI EGLContext termuxEGL_CreateContext(EGLDisplay dpy, EGLConfig config, EGLContext share_context, const EGLint *attrib_list) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);
    ASSERT_CTX(share_context, EGL_FALSE);
    EGLContext r = origin.CreateContext(UNWRAP_DPY(dpy), config, UNWRAP_CTX(share_context), attrib_list);
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);

    TEGLContext ctx = calloc(1, sizeof(*ctx));
    ctx->obj = (TEGLObjectBase_t) { .magic = { TERMUX_MAGIC_OBJ, TERMUX_MAGIC_SFC } };
    ctx->base = r;
    list_insert(&contexts, &ctx->link);

    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking CreateContext ended with error %s (0x%X)\n", eglStrError(err), err);
    return ctx;
}

/**
 * eglCreatePixmapSurface stub
 * @param dpy
 * @param config
 * @param pixmap
 * @param attrib_list
 * @return
 */
EGLAPI EGLSurface termuxEGL_CreatePixmapSurface(EGLDisplay __unused dpy, EGLConfig __unused config, EGLNativePixmapType __unused pixmap, const EGLint __unused *attrib_list) {
    // eglCreatePixmapSurface is not implemented on Android
    apiExports->threadInit();
    apiExports->setEGLError(EGL_BAD_ALLOC);
    return EGL_NO_SURFACE;
}

/**
 * eglCreateWindowSurface implementation
 * @param dpy
 * @param config
 * @param win
 * @param attrib_list
 * @return
 */
EGLAPI EGLSurface termuxEGL_CreateWindowSurface(EGLDisplay dpy, EGLConfig config, EGLNativeWindowType win, const EGLint *attrib_list) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_NO_SURFACE);

    EGLSurface r = origin.CreatePbufferSurface(UNWRAP_DPY(dpy), config, (const EGLint[]) { EGL_WIDTH, 2, EGL_HEIGHT, 2, EGL_NONE });
    EGLint err = origin.GetError();

    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking eglCreateWindowSurface ended with error %s (0x%X)\n", eglStrError(err), err);
    apiExports->setEGLError(err);

    if (r == EGL_NO_SURFACE)
        return EGL_NO_SURFACE;

    TEGLSurface sfc = calloc(1, sizeof(*sfc));
    sfc->obj = (TEGLObjectBase_t) { .magic = { TERMUX_MAGIC_OBJ, TERMUX_MAGIC_SFC } };
    sfc->base = r;
    sfc->ctx = EGL_NO_CONTEXT;
    sfc->dpy = dpy;
    sfc->swapInterval = 1;

    sfc->type = TEGL_SURFACE_WINDOW;
    sfc->conn = XGetXCBConnection(CAST_DPY(dpy)->x11dpy);
    sfc->win = (uintptr_t) win;
    xcb_get_geometry_reply_t *geom = xcb_get_geometry_reply(sfc->conn, xcb_get_geometry(sfc->conn, sfc->win), NULL);
    sfc->width = geom ? geom->width : 800;
    sfc->height = geom ? geom->height : 600;
    free(geom);
    sfc->usage = AHARDWAREBUFFER_USAGE_CPU_WRITE_RARELY | AHARDWAREBUFFER_USAGE_CPU_READ_RARELY | AHARDWAREBUFFER_USAGE_GPU_FRAMEBUFFER | AHARDWAREBUFFER_USAGE_GPU_SAMPLED_IMAGE;
    sfc->allocationNeeded = true;

    xcb_setup_t const *const setup = xcb_get_setup(sfc->conn);
    xcb_screen_t *const screen = xcb_setup_roots_iterator(setup).data;

    sfc->gc = xcb_generate_id(sfc->conn);
    xcb_create_gc(sfc->conn, sfc->gc, (uintptr_t) win, XCB_GC_FOREGROUND | XCB_GC_GRAPHICS_EXPOSURES, (const uint32_t[]) {screen->black_pixel, 0});

    uint32_t eid = xcb_generate_id(sfc->conn);
    sfc->special_event = xcb_register_for_special_xge(sfc->conn, &xcb_present_id, eid, NULL);
    xcb_present_select_input(sfc->conn, eid, sfc->win, XCB_PRESENT_EVENT_MASK_COMPLETE_NOTIFY | XCB_PRESENT_EVENT_MASK_CONFIGURE_NOTIFY);

    list_insert(&surfaces, &sfc->link);

    return sfc;
}

/**
 * eglDestroyContext wrapper
 * @param dpy
 * @param ctx
 * @return
 */
EGLAPI EGLBoolean termuxEGL_DestroyContext(EGLDisplay dpy, EGLContext ctx) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);
    ASSERT_CTX(ctx, EGL_FALSE);
    EGLBoolean r = origin.DestroyContext(UNWRAP_DPY(dpy), UNWRAP_CTX(ctx));
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);
    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking DestroyContext ended with error %s (0x%X)\n", eglStrError(err), err);

    // No need to destroy framebuffer or renderbuffer objects, they are a part of the context we already destroyed.
    list_remove(&CAST_CTX(ctx)->link);
    free(ctx);
    return r;
}

static inline uint32_t roundUp(uint32_t num) {
    return ((num + 255) / 256) * 256;
}

/**
 * Reallocates buffers related to surface
 * @param sfc
 * @return
 */
EGLAPI int termuxEGL_reallocateBuffers(TEGLSurface sfc) {
    AHardwareBuffer_Desc desc = { .width = roundUp(sfc->width), .height = roundUp(sfc->height), .format = 5, .layers = 1, .usage = sfc->usage }, desc1 = {0};
    int error = 0;

    AHardwareBuffer* old = !CAST_SFC(sfc)->back ? NULL : CAST_SFC(sfc)->back->self;
    if (old)
        AHardwareBuffer_acquire(old);

    // Release existing buffers if any
    for (int i=0; i<sizeof(sfc->buffers)/sizeof(sfc->buffers[0]); i++) {
        if (!sfc->buffers[i].self)
            continue;

        AHardwareBuffer_release(sfc->buffers[i].self);
        xcb_free_pixmap_checked(sfc->conn, sfc->buffers[i].pixmap);
        memset(&sfc->buffers[i], 0, sizeof(sfc->buffers[i]));
        if (sfc->buffers[i].img)
            eglDestroyImage(UNWRAP_DPY(sfc->dpy), sfc->buffers[i].img);
    }

    // Allocate new buffers
    for (int i=0; i<sizeof(sfc->buffers)/sizeof(sfc->buffers[0]); i++) {
        static const EGLint attrib[] = { EGL_IMAGE_PRESERVED_KHR, EGL_TRUE, EGL_NONE };
        int fds[] = { -1, -1 };
        uint8_t buf = 0;

        if ((error = AHardwareBuffer_allocate(&desc, &sfc->buffers[i].self)) != 0) {
            dprintf(2, "can not allocate buffer width %d height %d format %d usage %lu, error %d\n",
                    desc.width, desc.height, desc.format, desc.usage, error);
            if (old)
                AHardwareBuffer_release(old);
            return ENOMEM;
        }

        if (!sfc->buffers[i].self) {
            dprintf(2, "AHardwareBuffer_allocate returned NO_ERROR but buffer was not allocated\n");
            if (old)
                AHardwareBuffer_release(old);
            return ENOMEM;
        }

        if ((sfc->buffers[i].img = origin.CreateImageKHR(UNWRAP_DPY(sfc->dpy), EGL_NO_CONTEXT, EGL_NATIVE_BUFFER_ANDROID, origin.GetNativeClientBufferANDROID(sfc->buffers[i].self), attrib)) ==  EGL_NO_IMAGE) {
            EGLint eglErr = origin.GetError();
            if (eglErr != EGL_SUCCESS) dprintf(2, "Error: Invoking CreateImageKHR ended with error %s (0x%X)\n", eglStrError(eglErr), eglErr);
            if (old)
                AHardwareBuffer_release(old);
            if (sfc->buffers[i].self) {
                AHardwareBuffer_release(sfc->buffers[i].self);
                memset(&sfc->buffers[i], 0, sizeof(sfc->buffers[i]));
            }
            return ENOMEM;
        }

        if (socketpair(AF_UNIX, SOCK_STREAM, 0, fds) < 0) {
            dprintf(2, "%s:%d: socketpair failed!\n", __FILE__, __LINE__);
            if (old)
                AHardwareBuffer_release(old);
            if (sfc->buffers[i].self) {
                AHardwareBuffer_release(sfc->buffers[i].self);
                memset(&sfc->buffers[i], 0, sizeof(sfc->buffers[i]));
            }
            return ENOMEM;
        }

        sfc->buffers[i].pixmap = xcb_generate_id(sfc->conn);
        AHardwareBuffer_describe(sfc->buffers[i].self, &desc1);
        xcb_void_cookie_t cookie = xcb_dri3_pixmap_from_buffers_checked(sfc->conn, sfc->buffers[i].pixmap, sfc->win, 1, sfc->width, sfc->height, desc1.stride*4, 0, 0, 0, 0, 0, 0, 0, 24, 32, 1256, &fds[1]);
        xcb_flush(sfc->conn);

        read(fds[0], &buf, 1);
        AHardwareBuffer_sendHandleToUnixSocket(sfc->buffers[i].self, fds[0]);
        xcb_generic_error_t *err = xcb_request_check(sfc->conn, cookie);
        if (err) {
            free(err);
            sfc->buffers[i].pixmap = 0;
            AHardwareBuffer_release(sfc->buffers[i].self);
            sfc->buffers[i].self = NULL;
            dprintf(2, "xcb error while doing xcb_dri3_pixmap_from_buffers\n");
            if (old)
                AHardwareBuffer_release(old);
            return ENOMEM;
        }
    }

    sfc->front = &sfc->buffers[0];
    sfc->back = &sfc->buffers[1];

    if (old) {
        // Copy old content to new buffer to avoid flickering
        uint32_t *oldBuffer = NULL, *newBuffer = NULL;
        AHardwareBuffer_Desc oldDesc, newDesc;
        AHardwareBuffer_describe(old, &oldDesc);
        AHardwareBuffer_describe(sfc->back->self, &newDesc);
        if (AHardwareBuffer_lock(old, AHARDWAREBUFFER_USAGE_CPU_WRITE_RARELY, -1, NULL, (void**) &oldBuffer) != 0 ||
            AHardwareBuffer_lock(sfc->back->self, AHARDWAREBUFFER_USAGE_CPU_WRITE_RARELY, -1, NULL, (void**) &newBuffer) != 0) {
            if (oldBuffer)
                AHardwareBuffer_unlock(old, NULL);
            AHardwareBuffer_release(old);
        }

#define min(a, b) ((a) < (b) ? (a) : (b))
        for (int i=0; i<min(oldDesc.height, newDesc.height); i++)
            memcpy(newBuffer + i * newDesc.stride, oldBuffer + i * oldDesc.stride, min(oldDesc.stride, newDesc.stride));
#undef min
        AHardwareBuffer_unlock(old, NULL);
        AHardwareBuffer_unlock(sfc->back->self, NULL);
    } else if (old)
        AHardwareBuffer_release(old);

    sfc->allocationNeeded = false;

    return 0;
}

/**
 * Handles XCB event passed as \p r
 * @param sfc
 * @param r
 */
EGLAPI void termuxEGL_handleEvents(TEGLSurface sfc, xcb_event_t *r) {
    switch(r->present.evtype) {
        case XCB_PRESENT_EVENT_COMPLETE_NOTIFY: {
            if (r->complete.kind != XCB_PRESENT_COMPLETE_KIND_PIXMAP)
                break;

            for (int i=0; i<sizeof(sfc->buffers)/sizeof(sfc->buffers[0]); i++) {
                if (sfc->buffers[i].serial == r->complete.serial) {
                    sfc->buffers[i].busy = false;
                    break;
                }
            }
            break;
        }
        case XCB_PRESENT_EVENT_CONFIGURE_NOTIFY:
            // We should not update pixmaps too frequent. On some devices it may lead to program crash.
            if (roundUp(sfc->width) != roundUp(r->config.pixmap_width) || roundUp(sfc->height) != roundUp(r->config.pixmap_height))
                sfc->allocationNeeded = true;
            sfc->width = r->config.pixmap_width;
            sfc->height = r->config.pixmap_height;
            break;
        default:
            dprintf(2, "got some weird present event %d\n", r->present.evtype);
            xcb_flush(sfc->conn);
    }
}

/**
 * Post back buffer to X server and swap back and front buffers
 * @param sfc
 * @return
 */
EGLAPI int termuxEGL_postBuffer(TEGLSurface sfc) {
    static int serial = 1;
    xcb_generic_event_t* event;

    xcb_flush(sfc->conn);
    while((event = xcb_poll_for_special_event(sfc->conn, sfc->special_event)))
        termuxEGL_handleEvents(sfc, (xcb_event_t*) event);

    if (!sfc->swapInterval && sfc->front->busy)
        return 0;

    while (sfc->front->busy) {
        event = xcb_wait_for_special_event(sfc->conn, sfc->special_event);
        if (!event) {
            dprintf(2, "failed to obtain special event\n");
            return EFAULT;
        }

        termuxEGL_handleEvents(sfc, (xcb_event_t*) event);
    }

    sfc->back->serial = serial++;
    sfc->back->busy = true;
    xcb_void_cookie_t cookie = xcb_present_pixmap_checked(sfc->conn, sfc->win, sfc->back->pixmap, sfc->back->serial, 0, 0, 0, 0, 0, 0, 0, XCB_PRESENT_OPTION_NONE, 0, 0, 0, 0, NULL);
    xcb_discard_reply(sfc->conn, cookie.sequence);
    xcb_flush(sfc->conn);

    void* temp = sfc->front;
    sfc->front = sfc->back;
    sfc->back = temp;

    return 0;
}

/**
 * eglMakeCurrent implementation
 * @param dpy
 * @param draw
 * @param read
 * @param ctx
 * @return
 */
EGLAPI EGLBoolean termuxEGL_MakeCurrent(EGLDisplay dpy, EGLSurface draw, EGLSurface read, EGLContext ctx) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);
    ASSERT_SFC(draw, EGL_FALSE);
    ASSERT_SFC(read, EGL_FALSE);

    TEGLSurface currentReadSurface = surfaceFromEGL(origin.GetCurrentSurface(EGL_READ));
    TEGLSurface currentDrawSurface = surfaceFromEGL(origin.GetCurrentSurface(EGL_DRAW));
    if (currentReadSurface != EGL_NO_SURFACE)
        currentReadSurface->ctx = EGL_NO_CONTEXT;
    if (currentDrawSurface != EGL_NO_SURFACE)
        currentDrawSurface->ctx = EGL_NO_CONTEXT;

    if ((ctx != EGL_NO_CONTEXT && draw != EGL_NO_SURFACE && CAST_SFC(draw)->ctx != EGL_NO_CONTEXT)
            || (ctx != EGL_NO_CONTEXT && read != EGL_NO_SURFACE && CAST_SFC(read)->ctx != EGL_NO_CONTEXT)) {
        apiExports->setEGLError(EGL_BAD_SURFACE);
        return EGL_FALSE;
    }

    EGLBoolean r = origin.MakeCurrent(UNWRAP_DPY(dpy), UNWRAP_SFC(draw), UNWRAP_SFC(read), UNWRAP_CTX(ctx));
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);

    if (err == EGL_SUCCESS) {
        if (read != EGL_NO_SURFACE)
            CAST_SFC(read)->ctx = ctx;
        if (draw != EGL_NO_SURFACE)
            CAST_SFC(draw)->ctx = ctx;
    }

    if (draw)
        termuxEGL_SwapBuffers(dpy, draw);

    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking MakeCurrent ended with error %s (0x%X)\n", eglStrError(err), err);
    return r;
}

/**
 * eglQuerySurface implementation
 * @param dpy
 * @param sfc
 * @param attribute
 * @param value
 * @return
 */
EGLAPI EGLBoolean termuxEGL_QuerySurface(EGLDisplay dpy, EGLSurface sfc, EGLint attribute, EGLint *value) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);
    ASSERT_SFC(sfc, EGL_FALSE);

    EGLBoolean r;
    EGLint err;
    if (!sfc || CAST_SFC(sfc)->type != TEGL_SURFACE_WINDOW) {
        r = origin.QuerySurface(UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), attribute, value);
        err = origin.GetError();
        apiExports->setEGLError(err);
        if (err != EGL_SUCCESS)
            dprintf(2, "Error: Invoking QuerySurface ended with error %s (0x%X)\n", eglStrError(err), err);
        return r;
    }

    if (!value) {
        apiExports->setEGLError(EGL_BAD_PARAMETER);
        return EGL_FALSE;
    }

    switch (attribute) {
        case EGL_WIDTH:
            apiExports->setEGLError(EGL_SUCCESS);
            *value = CAST_SFC(sfc)->width;
            return EGL_TRUE;
        case EGL_HEIGHT:
            apiExports->setEGLError(EGL_SUCCESS);
            *value = CAST_SFC(sfc)->height;
            return EGL_TRUE;
        case EGL_SWAP_BEHAVIOR:
            apiExports->setEGLError(EGL_SUCCESS);
            *value = EGL_BUFFER_DESTROYED;
            return EGL_TRUE;
        case EGL_RENDER_BUFFER:
            apiExports->setEGLError(EGL_SUCCESS);
            *value = EGL_BACK_BUFFER;
            return EGL_TRUE;
        case EGL_HORIZONTAL_RESOLUTION:
        case EGL_VERTICAL_RESOLUTION:
        case EGL_PIXEL_ASPECT_RATIO:
            // Mesa's implementation returns -1, I'll do the same
            apiExports->setEGLError(EGL_SUCCESS);
            *value = -1;
            return EGL_TRUE;
        case EGL_CONFIG_ID:
        case EGL_GL_COLORSPACE:
        case EGL_MIPMAP_LEVEL:
        case EGL_MIPMAP_TEXTURE:
        case EGL_MULTISAMPLE_RESOLVE:
        case EGL_TEXTURE_FORMAT:
        case EGL_TEXTURE_TARGET:
        case EGL_VG_ALPHA_FORMAT:
        case EGL_VG_COLORSPACE:
            // Passthrough to wrapped EGL surface
            r = origin.QuerySurface(UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), attribute, value);
            err = origin.GetError();
            apiExports->setEGLError(err);
            if (err != EGL_SUCCESS)
                dprintf(2, "Error: Invoking QuerySurface ended with error %s (0x%X)\n", eglStrError(err), err);
            return r;
        default:
            apiExports->setEGLError(EGL_BAD_ATTRIBUTE);
            return EGL_FALSE;
    }

    return EGL_SUCCESS;
}

/**
 * eglSwapBuffers implementation
 * @param dpy
 * @param sfc
 * @return
 */
EGLAPI EGLBoolean termuxEGL_SwapBuffers(EGLDisplay dpy, EGLSurface sfc) {
    apiExports->threadInit();
    GLenum err;
    TEGLContext ctx;

    ASSERT_DPY(dpy, EGL_FALSE);
    ASSERT_SFC(sfc, EGL_FALSE);

    ctx = contextFromEGL(origin.GetCurrentContext());
    if (ctx != EGL_NO_CONTEXT)
        origin.glFinish();

    if (!sfc || CAST_SFC(sfc)->type == TEGL_SURFACE_NATIVE) {
        EGLBoolean r = origin.SwapBuffers(UNWRAP_DPY(dpy), UNWRAP_SFC(sfc));
        EGLint eglErr = origin.GetError();
        apiExports->setEGLError(eglErr);
        if (sfc && eglErr != EGL_SUCCESS) dprintf(2, "Error: Invoking SwapBuffers ended with error %s (0x%X), dpy %p/%p sfc %p\n", eglStrError(eglErr), eglErr, dpy, UNWRAP_DPY(dpy), sfc);
        return r;
    }

    if (ctx == EGL_NO_CONTEXT) {
        apiExports->setEGLError(EGL_SUCCESS);
        return EGL_TRUE;
    }

    bool frameBufferCreated = EGL_FALSE;
    EGLint rb, fb;
    origin.glGetIntegerv(GL_RENDERBUFFER_BINDING, &rb);
    origin.glGetIntegerv(GL_FRAMEBUFFER_BINDING, &fb);

    // Generate framebuffer, color and depth renderbuffers.
    // It happens only on the first invocation of SwapBuffers and never happens since.
    // No need to destroy them manually, they will be destroyed with context.
    if (!ctx->fb_id || !ctx->rb_id[0] || !ctx->rb_id[1]) {
        EGLint eglErr = EGL_SUCCESS;

        if (eglErr == EGL_SUCCESS) {
            origin.glGenFramebuffers(1, &ctx->fb_id);
            while ((err = origin.glGetError()) != GL_NO_ERROR) {
                dprintf(2, "glGenFramebuffers finished with error 0x%X\n", err);
                eglErr = EGL_BAD_CONTEXT;
            }
        }

        if (eglErr == EGL_SUCCESS) {
            origin.glGenRenderbuffers(2, ctx->rb_id);
            while ((err = origin.glGetError()) != GL_NO_ERROR) {
                dprintf(2, "glGenRenderbuffers finished with error 0x%X\n", err);
                eglErr = EGL_BAD_CONTEXT;
            }
        }

        frameBufferCreated = EGL_TRUE;

        if (eglErr != EGL_SUCCESS) {
            if (ctx->fb_id != 0)
                glDeleteFramebuffers(1, &ctx->fb_id);
            if (ctx->rb_id[0] != 0)
                glDeleteRenderbuffers(1, &ctx->rb_id[0]);
            if (ctx->rb_id[1] != 0)
                glDeleteRenderbuffers(1, &ctx->rb_id[1]);

            ctx->fb_id = ctx->rb_id[0] = ctx->rb_id[1] = 0;
            apiExports->setEGLError(eglErr);
            return EGL_FALSE;
        }
    }

    if (fb == 0 || fb == ctx->fb_id) {
        EGLImage img = NULL;
        int r;

        if (CAST_SFC(sfc)->back) {
            if ((r = termuxEGL_postBuffer(CAST_SFC(sfc))) != 0) {
                dprintf(2, "%s:%d: queueBuffer failed with error %d\n", __FILE__, __LINE__, r);
                apiExports->setEGLError(EGL_BAD_SURFACE);
                return EGL_FALSE;
            }
        } else {
            // It is a very first EGLSurface's eglSwapBuffers invocation, no need to actually swap buffers, we only need to setup the back buffer
        }

        if (CAST_SFC(sfc)->allocationNeeded && (r = termuxEGL_reallocateBuffers(CAST_SFC(sfc))) != 0) {
            dprintf(2, "%s:%d: reallocateBuffers failed with error %d\n", __FILE__, __LINE__, r);
            apiExports->setEGLError(EGL_BAD_SURFACE);
            return EGL_FALSE;
        }

        origin.glBindRenderbuffer(GL_RENDERBUFFER, ctx->rb_id[0]); glCheckError();
        origin.glEGLImageTargetRenderbufferStorageOES(GL_RENDERBUFFER, CAST_SFC(sfc)->back->img); glCheckError();

        origin.glBindRenderbuffer(GL_RENDERBUFFER, ctx->rb_id[1]); glCheckError();
        origin.glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, (GLsizei) CAST_SFC(sfc)->width, CAST_SFC(sfc)->height); glCheckError();

        origin.glBindFramebuffer(GL_FRAMEBUFFER, ctx->fb_id); glCheckError();
        origin.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, ctx->rb_id[1]); glCheckError();
        origin.glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, ctx->rb_id[0]); glCheckError();

        // restoring original renderbuffer
        origin.glBindRenderbuffer(GL_RENDERBUFFER, rb);

        if (fb != 0 && (!frameBufferCreated && ctx->fb_id != fb)) {
            // we modified framebuffer binding, lets restore it
            origin.glBindFramebuffer(GL_FRAMEBUFFER, fb);
        } else if (!ctx->viewportInitialized) {
            glViewport(0, 0, (GLsizei) CAST_SFC(sfc)->width, CAST_SFC(sfc)->height);
            ctx->viewportInitialized = EGL_TRUE;
        }
    }

    apiExports->setEGLError(EGL_SUCCESS);
    return EGL_TRUE;
}

/**
 * eglSurfaceAttrib implementation
 * @param dpy
 * @param sfc
 * @param attribute
 * @param value
 * @return
 */
EGLAPI EGLBoolean termuxEGL_SurfaceAttrib(EGLDisplay dpy, EGLSurface sfc, EGLint attribute, EGLint value){
    EGLBoolean r;
    EGLint err;
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);
    ASSERT_SFC(sfc, EGL_FALSE);
    if (!sfc || CAST_SFC(sfc)->type != TEGL_SURFACE_WINDOW) {
        r = origin.SurfaceAttrib(UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), attribute, value);
        err = origin.GetError();
        apiExports->setEGLError(err);
        if (err != EGL_SUCCESS)
            dprintf(2, "Error: Invoking SurfaceAttrib ended with error %s (0x%X)\n", eglStrError(err), err);
        return r;
    }

    switch (attribute) {
        case EGL_MIPMAP_LEVEL:
        case EGL_MULTISAMPLE_RESOLVE:
            // Passthrough to native surface
            r = origin.SurfaceAttrib(UNWRAP_DPY(dpy), UNWRAP_SFC(sfc), attribute, value);
            err = origin.GetError();
            apiExports->setEGLError(err);
            if (err != EGL_SUCCESS)
                dprintf(2, "Error: Invoking SurfaceAttrib ended with error %s (0x%X)\n", eglStrError(err), err);
            return r;
        case EGL_SWAP_BEHAVIOR:
            // Not implemented yet
            apiExports->setEGLError(EGL_SUCCESS);
            return EGL_TRUE;
        default:
            // Not implemented yet
            apiExports->setEGLError(EGL_BAD_ATTRIBUTE);
            return EGL_FALSE;
    }
}

/**
 * eglSwapInterval implementation
 * @param dpy
 * @param interval
 * @return
 */
EGLAPI EGLBoolean termuxEGL_SwapInterval(EGLDisplay dpy, EGLint interval) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);

    TEGLSurface sfc = surfaceFromEGL(origin.GetCurrentSurface(EGL_DRAW));
    if (!sfc || sfc->type != TEGL_SURFACE_WINDOW) {
        EGLBoolean r = origin.SwapInterval(UNWRAP_DPY(dpy), interval);
        EGLint err = origin.GetError();
        apiExports->setEGLError(err);
        if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking SwapInterval ended with error %s (0x%X)\n", eglStrError(err), err);
        return r;
    }

    sfc->swapInterval = interval > 1 ? 1 : interval < 0 ? 0 : interval;
    apiExports->setEGLError(EGL_SUCCESS);
    return EGL_TRUE;
}

/**
 * eglDestroySurface implementation
 * @param dpy
 * @param sfc
 * @return
 */
EGLAPI EGLBoolean termuxEGL_DestroySurface(EGLDisplay dpy, EGLSurface sfc) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);
    ASSERT_SFC(sfc, EGL_FALSE);

    EGLBoolean r = origin.DestroySurface(UNWRAP_DPY(dpy), UNWRAP_SFC(sfc));
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);
    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking DestroySurface ended with error %s (0x%X)\n", eglStrError(err), err);

    if (sfc) {
        list_remove(&CAST_SFC(sfc)->link);
        free(sfc); // TODO: destroy all resources as well
    }
    return r;
}

/**
 * eglGetConfigAttrib implementation
 * @param dpy
 * @param config
 * @param attribute
 * @param value
 * @return
 */
EGLAPI EGLBoolean termuxEGL_GetConfigAttrib(EGLDisplay dpy, EGLConfig config, EGLint attribute, EGLint *value) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, EGL_FALSE);
    if (!dpy) {
        apiExports->setEGLError(EGL_BAD_DISPLAY);
        dprintf(2, "Error: Invoking GetConfigAttrib ended with error %s (0x%X) attribute 0x%X value 0x%X\n", eglStrError(EGL_BAD_DISPLAY), EGL_BAD_DISPLAY, attribute, *value);
        return EGL_FALSE;
    }

    if (attribute == EGL_NATIVE_VISUAL_ID) {
        if (dpy == EGL_NO_DISPLAY || CAST_DPY(dpy)->x11dpy == NULL) {
            *value = 0;
            apiExports->setEGLError(EGL_SUCCESS);
            return EGL_TRUE;
        }

        int count = 0;
        XVisualInfo t = { .depth = 24 }, *info = XGetVisualInfo (CAST_DPY(dpy)->x11dpy, VisualDepthMask, &t, &count);

        if (count) {
            *value = (EGLint) info->visualid;
            apiExports->setEGLError(EGL_SUCCESS);
            return EGL_TRUE;
        }

        apiExports->setEGLError(EGL_BAD_ATTRIBUTE);
        dprintf(2, "Error: Invoking GetConfigAttrib ended with error %s (0x%X) attribute 0x%X value 0x%X\n", eglStrError(EGL_BAD_ATTRIBUTE), EGL_BAD_ATTRIBUTE, attribute, *value);
        return EGL_FALSE;
    }

    EGLBoolean r = origin.GetConfigAttrib(UNWRAP_DPY(dpy), config, attribute, value);
    EGLint err = origin.GetError();
    if (err != EGL_SUCCESS)
        dprintf(2, "Error: Invoking GetConfigAttrib ended with error %s (0x%X) attribute 0x%X value 0x%X\n", eglStrError(err), err, attribute, *value);
    apiExports->setEGLError(err);
    return r;
}

/**
 * eglGetCurrentDisplay wrapper
 * @return
 */
EGLAPI EGLDisplay termuxEGL_GetCurrentDisplay(void) {
    apiExports->threadInit();
    EGLDisplay r = origin.GetCurrentDisplay();
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);
    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking GetCurrentDisplay ended with error %s (0x%X)\n", eglStrError(err), err);
    r = displayFromEGL(r);
    if (r == EGL_NO_DISPLAY)
        apiExports->setEGLError(EGL_BAD_DISPLAY);
    return r;
}

/**
 * eglGetCurrentSurface wrapper
 * @param readdraw
 * @return
 */
EGLAPI EGLSurface termuxEGL_GetCurrentSurface(EGLint readdraw) {
    apiExports->threadInit();
    EGLSurface r = origin.GetCurrentSurface(readdraw);
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);
    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking GetCurrentSurface ended with error %s (0x%X)\n", eglStrError(err), err);
    r = surfaceFromEGL(r);
    if (r == EGL_NO_SURFACE)
        apiExports->setEGLError(EGL_BAD_SURFACE);
    return r;
}

/**
 * eglQueryString implementation
 * @param dpy
 * @param name
 * @return
 */
EGLAPI const char * termuxEGL_QueryString(EGLDisplay dpy, EGLint name) {
    apiExports->threadInit();
    ASSERT_DPY(dpy, NULL);
    if (name == EGL_EXTENSIONS) {
        apiExports->setEGLError(EGL_SUCCESS);
        return extensions;
    }
    if (name == EGL_CLIENT_APIS) {
        apiExports->setEGLError(EGL_SUCCESS);
        return "OpenGL_ES";
    }

    const char *r = origin.QueryString(UNWRAP_DPY(dpy), name);
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);
    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking eglQueryString ended with error %s (0x%X)\n", eglStrError(err), err);
    return r;
}

/**
 * eglGetCurrentContext wrapper
 * @return
 */
EGLAPI EGLContext termuxEGL_GetCurrentContext(void) {
    apiExports->threadInit();
    EGLContext r = origin.GetCurrentContext();
    EGLint err = origin.GetError();
    apiExports->setEGLError(err);
    if (err != EGL_SUCCESS) dprintf(2, "Error: Invoking GetCurrentContext ended with error %s (0x%X)\n", eglStrError(err), err);
    r = contextFromEGL(r);
    if (!r)
        apiExports->setEGLError(EGL_BAD_CONTEXT);
    return r;
}

/**
 * __EGLapiImportsRec::GetPlatformDisplay and eglGetPlatformDisplay implementation
 * See libglvnd's documentation for details
 * @param platform
 * @param nativeDisplay
 * @param attrib_list
 */
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

    TEGLDisplay dpy = NULL;
    EGLDisplay r = origin.GetDisplay(EGL_DEFAULT_DISPLAY);
    apiExports->setEGLError(origin.GetError());

    if (r != EGL_NO_DISPLAY) {
        // ReSharper disable once CppDFAMemoryLeak
        dpy = calloc(1, sizeof(*dpy));
        dpy->obj = (TEGLObjectBase_t) { .magic = { TERMUX_MAGIC_OBJ, TERMUX_MAGIC_DPY } };
        dpy->base = r;
        dpy->x11dpy = nativeDisplay;
    }

    return (EGLDisplay) dpy;
}

/**
 * eglGetDisplay implementation. Normally not used by libglvnd.
 * @param display_id
 * @return
 */
EGLAPI EGLDisplay termuxEGL_GetDisplay(EGLNativeDisplayType display_id) {
    apiExports->threadInit();
    dprintf(2, "Error: termuxEGL_GetDisplay is not implemented by design. Report bug if you see this message\n");
    apiExports->setEGLError(EGL_BAD_ALLOC);
    return EGL_NO_DISPLAY;
}

/**
 * eglCreatePlatformWindowSurface implementation
 * @param dpy
 * @param config
 * @param native_window
 * @param attrib_list
 * @return
 */
EGLAPI EGLSurface termuxEGL_CreatePlatformWindowSurface(EGLDisplay dpy, EGLConfig __unused config, void *native_window, const EGLAttrib *attrib_list) {
    return termuxEGL_CreateWindowSurface(dpy, config, (EGLNativeWindowType) native_window, (const EGLint*) attrib_list);
}

/**
 * eglCreatePlatformPixmapSurface stub
 * @param dpy
 * @param config
 * @param native_pixmap
 * @param attrib_list
 * @return
 */
EGLAPI EGLSurface termuxEGL_CreatePlatformPixmapSurface(EGLDisplay __unused dpy, EGLConfig __unused config, void __unused *native_pixmap, const EGLAttrib __unused *attrib_list) {
    // eglCreatePixmapSurface is not implemented on Android
    apiExports->threadInit();
    apiExports->setEGLError(EGL_BAD_ALLOC);
    return EGL_NO_SURFACE;
}

/**
 * glBindFramebuffer wrapper
 * Sets our implementation's framebuffer as default framebuffer instead of using default framebuffer of underlying implementation's pbuffer surface.
 * @param target
 * @param framebuffer
 */
GLAPI void APIENTRY termuxEGL_glBindFramebuffer(GLenum target, GLuint framebuffer) {
    EGLContext ctx = contextFromEGL(origin.GetCurrentContext());
    GLuint fb = !ctx ? 0 : CAST_CTX(ctx)->fb_id;
    origin.glBindFramebuffer(target, framebuffer ?: fb);
}

/**
 * glGetIntegerv implementation
 * Reports default framebuffer handle (0) in the case if current implementation's back buffer is bound
 * @param pname
 * @param params
 */
GLAPI void GLAPIENTRY termuxEGL_glGetIntegerv(GLenum pname, GLint *params) {
    EGLContext ctx = contextFromEGL(origin.GetCurrentContext());
    origin.glGetIntegerv(pname, params);
    if (pname == GL_FRAMEBUFFER && CAST_CTX(ctx) && origin.glGetError() == GL_NO_ERROR && *params == CAST_CTX(ctx)->fb_id)
        *params = 0;
}

/**
 * __EGLapiImportsRec::GetProcAddress and eglGetProcAddress implementation
 * See libglvnd's documentation for details
 * @param procName
 */
EGLAPI void * termuxEGL_GetProcAddress(const char *procName) {
    if (!strncmp("egl", procName, 3)) {
        if (0) {}
        #define FUNC(required, ret, name, argsdef, intro, args) else if (!strcmp("egl" #name, procName)) return termuxEGL_ ## name;
        EGL_FUNCS(FUNC, FUNC)
        #undef FUNC
        dprintf(2, "Error: failed to locate %s symbol using GetProcAddress since it is not implemented\n", procName);
        return NULL;
    }
    if (!strncmp("gl", procName, 2)) {
        if (!strcmp(procName, "glBindFramebuffer"))
            return termuxEGL_glBindFramebuffer;
        else if (!strcmp(procName, "glGetIntegerv"))
            return termuxEGL_glGetIntegerv;

        return dlsym(GLESv2, procName);
    }

    dprintf(2, "Error: failed to locate %s symbol because it does not start with `gl` or `egl`\n", procName);
    return NULL;
}

/**
 * __EGLapiImportsRec::GetSupportsAPI implementation
 * See libglvnd's documentation for details
 * @param api
 */
EGLAPI EGLBoolean termuxEGL_GetSupportsAPI(EGLenum api) {
    return api == EGL_OPENGL_ES_API ? EGL_TRUE : EGL_FALSE;
}

/**
 * __EGLapiImportsRec::GetVendorString( implementation
 * See libglvnd's documentation for details
 * @param name
 */
EGLAPI const char * termuxEGL_GetVendorString(int name) {
    if (name == __EGL_VENDOR_STRING_PLATFORM_EXTENSIONS)
        return "EGL_KHR_platform_android EGL_KHR_platform_x11 EGL_EXT_platform_x11 EGL_EXT_platform_xcb";
    return NULL;
}

/**
 * __EGLapiImportsRec::GetDispatchAddres implementation
 * See libglvnd's documentation for details
 * @param procName
 */
EGLAPI void *termuxEGL_GetDispatchAddress(const char *procName) {
    dprintf(2, "Error: %s is not implemented yet, call with arg \"%s\" is not effective\n", __FUNCTION__, procName); // TODO: implement me
    return NULL;
}

/**
 * __EGLapiImportsRec::SetDispatchIndex implementation
 * See libglvnd's documentation for details
 * @param procName
 * @param index
 */
EGLAPI void termuxEGL_SetDispatchIndex(const char * __unused procName, int __unused index) {
    // Not necessary to be implemented
}

/**
 * libglvnd interface main entry point
 * See libglvnd's documentation for details
 * @param version
 * @param exports
 * @param vendor
 * @param imports
 * @return
 */
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

    if (!AHardwareBuffer_allocate || !AHardwareBuffer_release || !AHardwareBuffer_describe || !AHardwareBuffer_sendHandleToUnixSocket) {
        dprintf(2, "Error: Required symbols not found. termux-wsi-layer is not being used.\n");
        dprintf(2, "AHardwareBuffer_allocate: %p\n", AHardwareBuffer_allocate);
        dprintf(2, "AHardwareBuffer_release: %p\n", AHardwareBuffer_release);
        dprintf(2, "AHardwareBuffer_describe: %p\n", AHardwareBuffer_describe);
        dprintf(2, "AHardwareBuffer_sendHandleToUnixSocket: %p\n", AHardwareBuffer_sendHandleToUnixSocket);
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

#define FUNC(required, ret, name, argsdef, intro, args) \
    origin.name = dlsym(EGL, "egl" #name); \
    if (!origin.name && required) { \
        dprintf(2, "Error: EGL symbol resolution: %s\n", dlerror()); \
        return EGL_FALSE; \
    }
    EGL_FUNCS(FUNC, FUNC)
#undef FUNC

#define LOAD_GL_FUNC(f) \
    origin.f = dlsym(GLESv2, #f); \
    if (!origin.f) { \
        dprintf(2, "Error: GLES2 symbol resolution (" #f "): %s\n", dlerror()); \
        return EGL_FALSE; \
    }
    GL_FUNCS(LOAD_GL_FUNC)
#undef LOAD_GL_FUNC

    asprintf((char**) &extensions, "%s %s", termuxEGL_GetVendorString(__EGL_VENDOR_STRING_PLATFORM_EXTENSIONS), origin.QueryString(EGL_NO_DISPLAY, EGL_EXTENSIONS));

    apiExports = exports;

    imports->getPlatformDisplay = termuxEGL_GetPlatformDisplay;
    imports->getSupportsAPI = termuxEGL_GetSupportsAPI;
    imports->getVendorString = termuxEGL_GetVendorString;
    imports->getProcAddress = termuxEGL_GetProcAddress;
    imports->getDispatchAddress = termuxEGL_GetDispatchAddress;
    imports->setDispatchIndex = termuxEGL_SetDispatchIndex;

    return EGL_TRUE;
}
