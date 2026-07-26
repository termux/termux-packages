
/*
 * Copyright (C) 2011 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <stdint.h>
#define ANDROID_NATIVE_MAKE_CONSTANT(a,b,c,d) (((unsigned)(a)<<24)|((unsigned)(b)<<16)|((unsigned)(c)<<8)|(unsigned)(d))
#define ANDROID_NATIVE_WINDOW_MAGIC     ANDROID_NATIVE_MAKE_CONSTANT('_','w','n','d')

// ---------------------------------------------------------------------------

/* attributes queriable with query() */
enum {
    NATIVE_WINDOW_WIDTH = 0,
    NATIVE_WINDOW_HEIGHT = 1,
    NATIVE_WINDOW_FORMAT = 2,

    /* see ANativeWindowQuery in vndk/window.h */
    NATIVE_WINDOW_MIN_UNDEQUEUED_BUFFERS =  3 /* ANATIVEWINDOW_QUERY_MIN_UNDEQUEUED_BUFFERS */,

    /* Check whether queueBuffer operations on the ANativeWindow send the buffer
     * to the window compositor.  The query sets the returned 'value' argument
     * to 1 if the ANativeWindow DOES send queued buffers directly to the window
     * compositor and 0 if the buffers do not go directly to the window
     * compositor.
     *
     * This can be used to determine whether protected buffer content should be
     * sent to the ANativeWindow.  Note, however, that a result of 1 does NOT
     * indicate that queued buffers will be protected from applications or users
     * capturing their contents.  If that behavior is desired then some other
     * mechanism (e.g. the GRALLOC_USAGE_PROTECTED flag) should be used in
     * conjunction with this query.
     */
    NATIVE_WINDOW_QUEUES_TO_WINDOW_COMPOSER = 4,

    /* Get the concrete type of a ANativeWindow.  See below for the list of
     * possible return values.
     *
     * This query should not be used outside the Android framework and will
     * likely be removed in the near future.
     */
    NATIVE_WINDOW_CONCRETE_TYPE = 5,

    /*
     * Default width and height of ANativeWindow buffers, these are the
     * dimensions of the window buffers irrespective of the
     * NATIVE_WINDOW_SET_BUFFERS_DIMENSIONS call and match the native window
     * size unless overridden by NATIVE_WINDOW_SET_BUFFERS_USER_DIMENSIONS.
     */
    NATIVE_WINDOW_DEFAULT_WIDTH = 6 /* ANATIVEWINDOW_QUERY_DEFAULT_WIDTH */,
    NATIVE_WINDOW_DEFAULT_HEIGHT = 7 /* ANATIVEWINDOW_QUERY_DEFAULT_HEIGHT */,

    /* see ANativeWindowQuery in vndk/window.h */
    NATIVE_WINDOW_TRANSFORM_HINT = 8 /* ANATIVEWINDOW_QUERY_TRANSFORM_HINT */,

    /*
     * Boolean that indicates whether the consumer is running more than
     * one buffer behind the producer.
     */
    NATIVE_WINDOW_CONSUMER_RUNNING_BEHIND = 9,

    /*
     * The consumer gralloc usage bits currently set by the consumer.
     * The values are defined in hardware/libhardware/include/gralloc.h.
     */
    NATIVE_WINDOW_CONSUMER_USAGE_BITS = 10, /* deprecated */

    /**
     * Transformation that will by applied to buffers by the hwcomposer.
     * This must not be set or checked by producer endpoints, and will
     * disable the transform hint set in SurfaceFlinger (see
     * NATIVE_WINDOW_TRANSFORM_HINT).
     *
     * INTENDED USE:
     * Temporary - Please do not use this.  This is intended only to be used
     * by the camera's LEGACY mode.
     *
     * In situations where a SurfaceFlinger client wishes to set a transform
     * that is not visible to the producer, and will always be applied in the
     * hardware composer, the client can set this flag with
     * native_window_set_buffers_sticky_transform.  This can be used to rotate
     * and flip buffers consumed by hardware composer without actually changing
     * the aspect ratio of the buffers produced.
     */
    NATIVE_WINDOW_STICKY_TRANSFORM = 11,

    /**
     * The default data space for the buffers as set by the consumer.
     * The values are defined in graphics.h.
     */
    NATIVE_WINDOW_DEFAULT_DATASPACE = 12,

    /* see ANativeWindowQuery in vndk/window.h */
    NATIVE_WINDOW_BUFFER_AGE = 13 /* ANATIVEWINDOW_QUERY_BUFFER_AGE */,

    /*
     * Returns the duration of the last dequeueBuffer call in microseconds
     * Deprecated: please use NATIVE_WINDOW_GET_LAST_DEQUEUE_DURATION in
     * perform() instead, which supports nanosecond precision.
     */
    NATIVE_WINDOW_LAST_DEQUEUE_DURATION = 14,

    /*
     * Returns the duration of the last queueBuffer call in microseconds
     * Deprecated: please use NATIVE_WINDOW_GET_LAST_QUEUE_DURATION in
     * perform() instead, which supports nanosecond precision.
     */
    NATIVE_WINDOW_LAST_QUEUE_DURATION = 15,

    /*
     * Returns the number of image layers that the ANativeWindow buffer
     * contains. By default this is 1, unless a buffer is explicitly allocated
     * to contain multiple layers.
     */
    NATIVE_WINDOW_LAYER_COUNT = 16,

    /*
     * Returns 1 if the native window is valid, 0 otherwise. native window is valid
     * if it is safe (i.e. no crash will occur) to call any method on it.
     */
    NATIVE_WINDOW_IS_VALID = 17,

    /*
     * Returns 1 if NATIVE_WINDOW_GET_FRAME_TIMESTAMPS will return display
     * present info, 0 if it won't.
     */
    NATIVE_WINDOW_FRAME_TIMESTAMPS_SUPPORTS_PRESENT = 18,

    /*
     * The consumer end is capable of handling protected buffers, i.e. buffer
     * with GRALLOC_USAGE_PROTECTED usage bits on.
     */
    NATIVE_WINDOW_CONSUMER_IS_PROTECTED = 19,

    /*
     * Returns data space for the buffers.
     */
    NATIVE_WINDOW_DATASPACE = 20,

    /*
     * Returns maxBufferCount set by BufferQueueConsumer
     */
    NATIVE_WINDOW_MAX_BUFFER_COUNT = 21,
};

/* Valid operations for the (*perform)() hook.
 *
 * Values marked as 'deprecated' are supported, but have been superceded by
 * other functionality.
 *
 * Values marked as 'private' should be considered private to the framework.
 * HAL implementation code with access to an ANativeWindow should not use these,
 * as it may not interact properly with the framework's use of the
 * ANativeWindow.
 */
enum {
    // clang-format off
    NATIVE_WINDOW_SET_USAGE                       =  0 /* ANATIVEWINDOW_PERFORM_SET_USAGE */,   /* deprecated */
    NATIVE_WINDOW_CONNECT                         =  1,   /* deprecated */
    NATIVE_WINDOW_DISCONNECT                      =  2,   /* deprecated */
    NATIVE_WINDOW_SET_CROP                        =  3,   /* private */
    NATIVE_WINDOW_SET_BUFFER_COUNT                =  4,
    NATIVE_WINDOW_SET_BUFFERS_GEOMETRY            =  5 /* ANATIVEWINDOW_PERFORM_SET_BUFFERS_GEOMETRY*/,   /* deprecated */
    NATIVE_WINDOW_SET_BUFFERS_TRANSFORM           =  6,
    NATIVE_WINDOW_SET_BUFFERS_TIMESTAMP           =  7,
    NATIVE_WINDOW_SET_BUFFERS_DIMENSIONS          =  8,
    NATIVE_WINDOW_SET_BUFFERS_FORMAT              =  9 /* ANATIVEWINDOW_PERFORM_SET_BUFFERS_FORMAT */,
    NATIVE_WINDOW_SET_SCALING_MODE                = 10,   /* private */
    NATIVE_WINDOW_LOCK                            = 11,   /* private */
    NATIVE_WINDOW_UNLOCK_AND_POST                 = 12,   /* private */
    NATIVE_WINDOW_API_CONNECT                     = 13,   /* private */
    NATIVE_WINDOW_API_DISCONNECT                  = 14,   /* private */
    NATIVE_WINDOW_SET_BUFFERS_USER_DIMENSIONS     = 15,   /* private */
    NATIVE_WINDOW_SET_POST_TRANSFORM_CROP         = 16,   /* deprecated, unimplemented */
    NATIVE_WINDOW_SET_BUFFERS_STICKY_TRANSFORM    = 17,   /* private */
    NATIVE_WINDOW_SET_SIDEBAND_STREAM             = 18,
    NATIVE_WINDOW_SET_BUFFERS_DATASPACE           = 19,
    NATIVE_WINDOW_SET_SURFACE_DAMAGE              = 20,   /* private */
    NATIVE_WINDOW_SET_SHARED_BUFFER_MODE          = 21,
    NATIVE_WINDOW_SET_AUTO_REFRESH                = 22,
    NATIVE_WINDOW_GET_REFRESH_CYCLE_DURATION      = 23,
    NATIVE_WINDOW_GET_NEXT_FRAME_ID               = 24,
    NATIVE_WINDOW_ENABLE_FRAME_TIMESTAMPS         = 25,
    NATIVE_WINDOW_GET_COMPOSITOR_TIMING           = 26,
    NATIVE_WINDOW_GET_FRAME_TIMESTAMPS            = 27,
    NATIVE_WINDOW_GET_WIDE_COLOR_SUPPORT          = 28,
    NATIVE_WINDOW_GET_HDR_SUPPORT                 = 29,
    NATIVE_WINDOW_SET_USAGE64                     = 30 /* ANATIVEWINDOW_PERFORM_SET_USAGE64 */,
    NATIVE_WINDOW_GET_CONSUMER_USAGE64            = 31,
    NATIVE_WINDOW_SET_BUFFERS_SMPTE2086_METADATA  = 32,
    NATIVE_WINDOW_SET_BUFFERS_CTA861_3_METADATA   = 33,
    NATIVE_WINDOW_SET_BUFFERS_HDR10_PLUS_METADATA = 34,
    NATIVE_WINDOW_SET_AUTO_PREROTATION            = 35,
    NATIVE_WINDOW_GET_LAST_DEQUEUE_START          = 36,    /* private */
    NATIVE_WINDOW_SET_DEQUEUE_TIMEOUT             = 37,    /* private */
    NATIVE_WINDOW_GET_LAST_DEQUEUE_DURATION       = 38,    /* private */
    NATIVE_WINDOW_GET_LAST_QUEUE_DURATION         = 39,    /* private */
    NATIVE_WINDOW_SET_FRAME_RATE                  = 40,
    NATIVE_WINDOW_SET_CANCEL_INTERCEPTOR          = 41,    /* private */
    NATIVE_WINDOW_SET_DEQUEUE_INTERCEPTOR         = 42,    /* private */
    NATIVE_WINDOW_SET_PERFORM_INTERCEPTOR         = 43,    /* private */
    NATIVE_WINDOW_SET_QUEUE_INTERCEPTOR           = 44,    /* private */
    NATIVE_WINDOW_ALLOCATE_BUFFERS                = 45,    /* private */
    NATIVE_WINDOW_GET_LAST_QUEUED_BUFFER          = 46,    /* private */
    NATIVE_WINDOW_SET_QUERY_INTERCEPTOR           = 47,    /* private */
    NATIVE_WINDOW_SET_FRAME_TIMELINE_INFO         = 48,    /* private */
    NATIVE_WINDOW_GET_LAST_QUEUED_BUFFER2         = 49,    /* private */
    NATIVE_WINDOW_SET_BUFFERS_ADDITIONAL_OPTIONS  = 50,
    // clang-format on
};

/* parameter for NATIVE_WINDOW_[API_][DIS]CONNECT */
enum {
    /* Buffers will be queued by EGL via eglSwapBuffers after being filled using
     * OpenGL ES.
     */
    NATIVE_WINDOW_API_EGL = 1,

    /* Buffers will be queued after being filled using the CPU
     */
    NATIVE_WINDOW_API_CPU = 2,

    /* Buffers will be queued by Stagefright after being filled by a video
     * decoder.  The video decoder can either be a software or hardware decoder.
     */
    NATIVE_WINDOW_API_MEDIA = 3,

    /* Buffers will be queued by the the camera HAL.
     */
    NATIVE_WINDOW_API_CAMERA = 4,
};

/* parameter for NATIVE_WINDOW_SET_BUFFERS_TRANSFORM */
enum {
    /* flip source image horizontally */
    NATIVE_WINDOW_TRANSFORM_FLIP_H = 1 /* HAL_TRANSFORM_FLIP_H */,
    /* flip source image vertically */
    NATIVE_WINDOW_TRANSFORM_FLIP_V = 2 /* HAL_TRANSFORM_FLIP_V */,
    /* rotate source image 90 degrees clock-wise, and is applied after TRANSFORM_FLIP_{H|V} */
    NATIVE_WINDOW_TRANSFORM_ROT_90 = 4 /* HAL_TRANSFORM_ROT_90 */,
    /* rotate source image 180 degrees */
    NATIVE_WINDOW_TRANSFORM_ROT_180 = 3 /* HAL_TRANSFORM_ROT_180 */,
    /* rotate source image 270 degrees clock-wise */
    NATIVE_WINDOW_TRANSFORM_ROT_270 = 7 /* HAL_TRANSFORM_ROT_270 */,
    /* transforms source by the inverse transform of the screen it is displayed onto. This
     * transform is applied last */
    NATIVE_WINDOW_TRANSFORM_INVERSE_DISPLAY = 0x08
};

/* parameter for NATIVE_WINDOW_SET_SCALING_MODE
 * keep in sync with Surface.java in frameworks/base */
enum {
    /* the window content is not updated (frozen) until a buffer of
     * the window size is received (enqueued)
     */
    NATIVE_WINDOW_SCALING_MODE_FREEZE           = 0,
    /* the buffer is scaled in both dimensions to match the window size */
    NATIVE_WINDOW_SCALING_MODE_SCALE_TO_WINDOW  = 1,
    /* the buffer is scaled uniformly such that the smaller dimension
     * of the buffer matches the window size (cropping in the process)
     */
    NATIVE_WINDOW_SCALING_MODE_SCALE_CROP       = 2,
    /* the window is clipped to the size of the buffer's crop rectangle; pixels
     * outside the crop rectangle are treated as if they are completely
     * transparent.
     */
    NATIVE_WINDOW_SCALING_MODE_NO_SCALE_CROP    = 3,
};

/* values returned by the NATIVE_WINDOW_CONCRETE_TYPE query */
enum {
    NATIVE_WINDOW_FRAMEBUFFER               = 0, /* FramebufferNativeWindow */
    NATIVE_WINDOW_SURFACE                   = 1, /* Surface */
};

/* parameter for NATIVE_WINDOW_SET_BUFFERS_TIMESTAMP
 *
 * Special timestamp value to indicate that timestamps should be auto-generated
 * by the native window when queueBuffer is called.  This is equal to INT64_MIN,
 * defined directly to avoid problems with C99/C++ inclusion of stdint.h.
 */
static const int64_t __unused NATIVE_WINDOW_TIMESTAMP_AUTO = (-9223372036854775807LL-1);

/* parameter for NATIVE_WINDOW_GET_FRAME_TIMESTAMPS
 *
 * Special timestamp value to indicate the timestamps aren't yet known or
 * that they are invalid.
 */
static const int64_t __unused NATIVE_WINDOW_TIMESTAMP_PENDING = -2;
static const int64_t __unused NATIVE_WINDOW_TIMESTAMP_INVALID = -1;

struct ANativeWindowBuffer;

typedef struct android_native_base_t
{
    /* a magic value defined by the actual EGL native type */
    int magic;

    /* the sizeof() of the actual EGL native type */
    int version;

    void* reserved[4];

    /* reference-counting interface */
    void (*incRef)(struct android_native_base_t* base);
    void (*decRef)(struct android_native_base_t* base);
} android_native_base_t;

struct ANativeWindow
{
    #ifdef __cplusplus
    ANativeWindow()
    : flags(0), minSwapInterval(0), maxSwapInterval(0), xdpi(0), ydpi(0)
    {
        common.magic = ANDROID_NATIVE_WINDOW_MAGIC;
        common.version = sizeof(ANativeWindow);
        memset(common.reserved, 0, sizeof(common.reserved));
    }

    /* Implement the methods that sp<ANativeWindow> expects so that it
     * can be used to automatically refcount ANativeWindow's. */
    void incStrong(const void* /*id*/) const {
        common.incRef(const_cast<android_native_base_t*>(&common));
    }
    void decStrong(const void* /*id*/) const {
        common.decRef(const_cast<android_native_base_t*>(&common));
    }
    #endif

    struct android_native_base_t common;

    /* flags describing some attributes of this surface or its updater */
    const uint32_t flags;

    /* min swap interval supported by this updated */
    const int   minSwapInterval;

    /* max swap interval supported by this updated */
    const int   maxSwapInterval;

    /* horizontal and vertical resolution in DPI */
    const float xdpi;
    const float ydpi;

    /* Some storage reserved for the OEM's driver. */
    intptr_t    oem[4];

    /*
     * Set the swap interval for this surface.
     *
     * Returns 0 on success or -errno on error.
     */
    int     (*setSwapInterval)(struct ANativeWindow* window,
                               int interval);

    /*
     * Hook called by EGL to acquire a buffer. After this call, the buffer
     * is not locked, so its content cannot be modified. This call may block if
     * no buffers are available.
     *
     * The window holds a reference to the buffer between dequeueBuffer and
     * either queueBuffer or cancelBuffer, so clients only need their own
     * reference if they might use the buffer after queueing or canceling it.
     * Holding a reference to a buffer after queueing or canceling it is only
     * allowed if a specific buffer count has been set.
     *
     * Returns 0 on success or -errno on error.
     *
     * XXX: This function is deprecated.  It will continue to work for some
     * time for binary compatibility, but the new dequeueBuffer function that
     * outputs a fence file descriptor should be used in its place.
     */
    int     (*dequeueBuffer_DEPRECATED)(struct ANativeWindow* window,
                                        struct ANativeWindowBuffer** buffer);

    /*
     * hook called by EGL to lock a buffer. This MUST be called before modifying
     * the content of a buffer. The buffer must have been acquired with
     * dequeueBuffer first.
     *
     * Returns 0 on success or -errno on error.
     *
     * XXX: This function is deprecated.  It will continue to work for some
     * time for binary compatibility, but it is essentially a no-op, and calls
     * to it should be removed.
     */
    int     (*lockBuffer_DEPRECATED)(struct ANativeWindow* window,
                                     struct ANativeWindowBuffer* buffer);

    /*
     * Hook called by EGL when modifications to the render buffer are done.
     * This unlocks and post the buffer.
     *
     * The window holds a reference to the buffer between dequeueBuffer and
     * either queueBuffer or cancelBuffer, so clients only need their own
     * reference if they might use the buffer after queueing or canceling it.
     * Holding a reference to a buffer after queueing or canceling it is only
     * allowed if a specific buffer count has been set.
     *
     * Buffers MUST be queued in the same order than they were dequeued.
     *
     * Returns 0 on success or -errno on error.
     *
     * XXX: This function is deprecated.  It will continue to work for some
     * time for binary compatibility, but the new queueBuffer function that
     * takes a fence file descriptor should be used in its place (pass a value
     * of -1 for the fence file descriptor if there is no valid one to pass).
     */
    int     (*queueBuffer_DEPRECATED)(struct ANativeWindow* window,
                                      struct ANativeWindowBuffer* buffer);

    /*
     * hook used to retrieve information about the native window.
     *
     * Returns 0 on success or -errno on error.
     */
    int     (*query)(const struct ANativeWindow* window,
                     int what, int* value);

    /*
     * hook used to perform various operations on the surface.
     * (*perform)() is a generic mechanism to add functionality to
     * ANativeWindow while keeping backward binary compatibility.
     *
     * DO NOT CALL THIS HOOK DIRECTLY.  Instead, use the helper functions
     * defined below.
     *
     * (*perform)() returns -ENOENT if the 'what' parameter is not supported
     * by the surface's implementation.
     *
     * See above for a list of valid operations, such as
     * NATIVE_WINDOW_SET_USAGE or NATIVE_WINDOW_CONNECT
     */
    int     (*perform)(struct ANativeWindow* window,
                       int operation, ... );

    /*
     * Hook used to cancel a buffer that has been dequeued.
     * No synchronization is performed between dequeue() and cancel(), so
     * either external synchronization is needed, or these functions must be
     * called from the same thread.
     *
     * The window holds a reference to the buffer between dequeueBuffer and
     * either queueBuffer or cancelBuffer, so clients only need their own
     * reference if they might use the buffer after queueing or canceling it.
     * Holding a reference to a buffer after queueing or canceling it is only
     * allowed if a specific buffer count has been set.
     *
     * XXX: This function is deprecated.  It will continue to work for some
     * time for binary compatibility, but the new cancelBuffer function that
     * takes a fence file descriptor should be used in its place (pass a value
     * of -1 for the fence file descriptor if there is no valid one to pass).
     */
    int     (*cancelBuffer_DEPRECATED)(struct ANativeWindow* window,
                                       struct ANativeWindowBuffer* buffer);

    /*
     * Hook called by EGL to acquire a buffer. This call may block if no
     * buffers are available.
     *
     * The window holds a reference to the buffer between dequeueBuffer and
     * either queueBuffer or cancelBuffer, so clients only need their own
     * reference if they might use the buffer after queueing or canceling it.
     * Holding a reference to a buffer after queueing or canceling it is only
     * allowed if a specific buffer count has been set.
     *
     * The libsync fence file descriptor returned in the int pointed to by the
     * fenceFd argument will refer to the fence that must signal before the
     * dequeued buffer may be written to.  A value of -1 indicates that the
     * caller may access the buffer immediately without waiting on a fence.  If
     * a valid file descriptor is returned (i.e. any value except -1) then the
     * caller is responsible for closing the file descriptor.
     *
     * Returns 0 on success or -errno on error.
     */
    int     (*dequeueBuffer)(struct ANativeWindow* window,
                             struct ANativeWindowBuffer** buffer, int* fenceFd);

    /*
     * Hook called by EGL when modifications to the render buffer are done.
     * This unlocks and post the buffer.
     *
     * The window holds a reference to the buffer between dequeueBuffer and
     * either queueBuffer or cancelBuffer, so clients only need their own
     * reference if they might use the buffer after queueing or canceling it.
     * Holding a reference to a buffer after queueing or canceling it is only
     * allowed if a specific buffer count has been set.
     *
     * The fenceFd argument specifies a libsync fence file descriptor for a
     * fence that must signal before the buffer can be accessed.  If the buffer
     * can be accessed immediately then a value of -1 should be used.  The
     * caller must not use the file descriptor after it is passed to
     * queueBuffer, and the ANativeWindow implementation is responsible for
     * closing it.
     *
     * Returns 0 on success or -errno on error.
     */
    int     (*queueBuffer)(struct ANativeWindow* window,
                           struct ANativeWindowBuffer* buffer, int fenceFd);

    /*
     * Hook used to cancel a buffer that has been dequeued.
     * No synchronization is performed between dequeue() and cancel(), so
     * either external synchronization is needed, or these functions must be
     * called from the same thread.
     *
     * The window holds a reference to the buffer between dequeueBuffer and
     * either queueBuffer or cancelBuffer, so clients only need their own
     * reference if they might use the buffer after queueing or canceling it.
     * Holding a reference to a buffer after queueing or canceling it is only
     * allowed if a specific buffer count has been set.
     *
     * The fenceFd argument specifies a libsync fence file decsriptor for a
     * fence that must signal before the buffer can be accessed.  If the buffer
     * can be accessed immediately then a value of -1 should be used.
     *
     * Note that if the client has not waited on the fence that was returned
     * from dequeueBuffer, that same fence should be passed to cancelBuffer to
     * ensure that future uses of the buffer are preceded by a wait on that
     * fence.  The caller must not use the file descriptor after it is passed
     * to cancelBuffer, and the ANativeWindow implementation is responsible for
     * closing it.
     *
     * Returns 0 on success or -errno on error.
     */
    int     (*cancelBuffer)(struct ANativeWindow* window,
                            struct ANativeWindowBuffer* buffer, int fenceFd);
};
