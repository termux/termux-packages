#include <dlfcn.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <android/choreographer.h>
#include <android/configuration.h>
#include <android/hardware_buffer.h>
#include <android/hardware_buffer_jni.h>
#include <android/input.h>
#include <android/looper.h>
#include <android/multinetwork.h>
#include <android/native_activity.h>
#include <android/native_window.h>
#include <android/native_window_jni.h>
#include <android/obb.h>
#include <android/sensor.h>
#include <android/sharedmem.h>
#include <android/sharedmem_jni.h>
#include <android/storage_manager.h>
#include <android/surface_texture.h>
#include <android/surface_texture_jni.h>
#include <android/trace.h>

#ifdef __LP64__
#define LIB "/system/lib64/libandroid.so"
#else
#define LIB "/system/lib/libandroid.so"
#endif

#define FUNCTIONS(f) \
    f(AAssetManager_openDir) \
    f(AAssetManager_open) \
    f(AAssetDir_getNextFileName) \
    f(AAssetDir_rewind) \
    f(AAssetDir_close) \
    f(AAsset_read) \
    f(AAsset_seek) \
    f(AAsset_seek64) \
    f(AAsset_close) \
    f(AAsset_getBuffer) \
    f(AAsset_getLength) \
    f(AAsset_getLength64) \
    f(AAsset_getRemainingLength) \
    f(AAsset_getRemainingLength64) \
    f(AAsset_openFileDescriptor) \
    f(AAsset_openFileDescriptor64) \
    f(AAsset_isAllocated) \
    f(AAssetManager_fromJava) \
    f(AChoreographer_getInstance) \
    f(AChoreographer_postFrameCallback) \
    f(AChoreographer_postFrameCallbackDelayed) \
    f(AConfiguration_new) \
    f(AConfiguration_delete) \
    f(AConfiguration_fromAssetManager) \
    f(AConfiguration_copy) \
    f(AConfiguration_getMcc) \
    f(AConfiguration_setMcc) \
    f(AConfiguration_getMnc) \
    f(AConfiguration_setMnc) \
    f(AConfiguration_getLanguage) \
    f(AConfiguration_setLanguage) \
    f(AConfiguration_getCountry) \
    f(AConfiguration_setCountry) \
    f(AConfiguration_getOrientation) \
    f(AConfiguration_setOrientation) \
    f(AConfiguration_getTouchscreen) \
    f(AConfiguration_setTouchscreen) \
    f(AConfiguration_getDensity) \
    f(AConfiguration_setDensity) \
    f(AConfiguration_getKeyboard) \
    f(AConfiguration_setKeyboard) \
    f(AConfiguration_getNavigation) \
    f(AConfiguration_setNavigation) \
    f(AConfiguration_getKeysHidden) \
    f(AConfiguration_setKeysHidden) \
    f(AConfiguration_getNavHidden) \
    f(AConfiguration_setNavHidden) \
    f(AConfiguration_getSdkVersion) \
    f(AConfiguration_setSdkVersion) \
    f(AConfiguration_getScreenSize) \
    f(AConfiguration_setScreenSize) \
    f(AConfiguration_getScreenLong) \
    f(AConfiguration_setScreenLong) \
    f(AConfiguration_setScreenRound) \
    f(AConfiguration_getUiModeType) \
    f(AConfiguration_setUiModeType) \
    f(AConfiguration_getUiModeNight) \
    f(AConfiguration_setUiModeNight) \
    f(AConfiguration_getScreenWidthDp) \
    f(AConfiguration_setScreenWidthDp) \
    f(AConfiguration_getScreenHeightDp) \
    f(AConfiguration_setScreenHeightDp) \
    f(AConfiguration_getSmallestScreenWidthDp) \
    f(AConfiguration_setSmallestScreenWidthDp) \
    f(AConfiguration_getLayoutDirection) \
    f(AConfiguration_setLayoutDirection) \
    f(AConfiguration_diff) \
    f(AConfiguration_match) \
    f(AConfiguration_isBetterThan) \
    f(AHardwareBuffer_fromHardwareBuffer) \
    f(AHardwareBuffer_toHardwareBuffer) \
    f(AHardwareBuffer_allocate) \
    f(AHardwareBuffer_acquire) \
    f(AHardwareBuffer_release) \
    f(AHardwareBuffer_describe) \
    f(AHardwareBuffer_lock) \
    f(AHardwareBuffer_unlock) \
    f(AHardwareBuffer_sendHandleToUnixSocket) \
    f(AHardwareBuffer_recvHandleFromUnixSocket) \
    f(AInputEvent_getType) \
    f(AInputEvent_getDeviceId) \
    f(AInputEvent_getSource) \
    f(AKeyEvent_getAction) \
    f(AKeyEvent_getFlags) \
    f(AKeyEvent_getKeyCode) \
    f(AKeyEvent_getScanCode) \
    f(AKeyEvent_getMetaState) \
    f(AKeyEvent_getRepeatCount) \
    f(AKeyEvent_getDownTime) \
    f(AKeyEvent_getEventTime) \
    f(AMotionEvent_getAction) \
    f(AMotionEvent_getFlags) \
    f(AMotionEvent_getMetaState) \
    f(AMotionEvent_getButtonState) \
    f(AMotionEvent_getEdgeFlags) \
    f(AMotionEvent_getDownTime) \
    f(AMotionEvent_getEventTime) \
    f(AMotionEvent_getXOffset) \
    f(AMotionEvent_getYOffset) \
    f(AMotionEvent_getXPrecision) \
    f(AMotionEvent_getYPrecision) \
    f(AMotionEvent_getPointerCount) \
    f(AMotionEvent_getPointerId) \
    f(AMotionEvent_getToolType) \
    f(AMotionEvent_getRawX) \
    f(AMotionEvent_getRawY) \
    f(AMotionEvent_getX) \
    f(AMotionEvent_getY) \
    f(AMotionEvent_getPressure) \
    f(AMotionEvent_getSize) \
    f(AMotionEvent_getTouchMajor) \
    f(AMotionEvent_getTouchMinor) \
    f(AMotionEvent_getToolMajor) \
    f(AMotionEvent_getToolMinor) \
    f(AMotionEvent_getOrientation) \
    f(AMotionEvent_getAxisValue) \
    f(AMotionEvent_getHistorySize) \
    f(AMotionEvent_getHistoricalEventTime) \
    f(AMotionEvent_getHistoricalRawX) \
    f(AMotionEvent_getHistoricalRawY) \
    f(AMotionEvent_getHistoricalX) \
    f(AMotionEvent_getHistoricalY) \
    f(AMotionEvent_getHistoricalPressure) \
    f(AMotionEvent_getHistoricalSize) \
    f(AMotionEvent_getHistoricalTouchMajor) \
    f(AMotionEvent_getHistoricalTouchMinor) \
    f(AMotionEvent_getHistoricalToolMajor) \
    f(AMotionEvent_getHistoricalToolMinor) \
    f(AMotionEvent_getHistoricalOrientation) \
    f(AMotionEvent_getHistoricalAxisValue) \
    f(AInputQueue_attachLooper) \
    f(AInputQueue_detachLooper) \
    f(AInputQueue_hasEvents) \
    f(AInputQueue_getEvent) \
    f(AInputQueue_preDispatchEvent) \
    f(AInputQueue_finishEvent) \
    f(ALooper_forThread) \
    f(ALooper_prepare) \
    f(ALooper_acquire) \
    f(ALooper_release) \
    f(ALooper_pollOnce) \
    f(ALooper_wake) \
    f(ALooper_addFd) \
    f(ALooper_removeFd) \
    f(ANativeActivity_finish) \
    f(ANativeActivity_setWindowFormat) \
    f(ANativeActivity_setWindowFlags) \
    f(ANativeActivity_showSoftInput) \
    f(ANativeActivity_hideSoftInput) \
    f(ANativeWindow_fromSurface) \
    f(ANativeWindow_toSurface) \
    f(ANativeWindow_acquire) \
    f(ANativeWindow_release) \
    f(ANativeWindow_getWidth) \
    f(ANativeWindow_getHeight) \
    f(ANativeWindow_getFormat) \
    f(ANativeWindow_setBuffersGeometry) \
    f(ANativeWindow_lock) \
    f(ANativeWindow_unlockAndPost) \
    f(ANativeWindow_setBuffersTransform) \
    f(ANativeWindow_setBuffersDataSpace) \
    f(ANativeWindow_getBuffersDataSpace) \
    f(AObbScanner_getObbInfo) \
    f(AObbInfo_delete) \
    f(AObbInfo_getPackageName) \
    f(AObbInfo_getVersion) \
    f(AObbInfo_getFlags) \
    f(ASensorManager_getInstance) \
    f(ASensorManager_getInstanceForPackage) \
    f(ASensorManager_getSensorList) \
    f(ASensorManager_getDefaultSensor) \
    f(ASensorManager_getDefaultSensorEx) \
    f(ASensorManager_createEventQueue) \
    f(ASensorManager_destroyEventQueue) \
    f(ASensorManager_createSharedMemoryDirectChannel) \
    f(ASensorManager_createHardwareBufferDirectChannel) \
    f(ASensorManager_destroyDirectChannel) \
    f(ASensorManager_configureDirectReport) \
    f(ASensorEventQueue_registerSensor) \
    f(ASensorEventQueue_enableSensor) \
    f(ASensorEventQueue_disableSensor) \
    f(ASensorEventQueue_setEventRate) \
    f(ASensorEventQueue_hasEvents) \
    f(ASensorEventQueue_getEvents) \
    f(ASensor_getName) \
    f(ASensor_getVendor) \
    f(ASensor_getType) \
    f(ASensor_getResolution) \
    f(ASensor_getMinDelay) \
    f(ASensor_getFifoMaxEventCount) \
    f(ASensor_getFifoReservedEventCount) \
    f(ASensor_getStringType) \
    f(ASensor_getReportingMode) \
    f(ASensor_isWakeUpSensor) \
    f(ASensor_isDirectChannelTypeSupported) \
    f(ASensor_getHighestDirectReportRateLevel) \
    f(ASharedMemory_dupFromJava) \
    f(ASharedMemory_create) \
    f(ASharedMemory_getSize) \
    f(ASharedMemory_setProt) \
    f(AStorageManager_new) \
    f(AStorageManager_delete) \
    f(AStorageManager_mountObb) \
    f(AStorageManager_unmountObb) \
    f(AStorageManager_isObbMounted) \
    f(AStorageManager_getMountedObbPath) \
    f(ASurfaceTexture_fromSurfaceTexture) \
    f(ASurfaceTexture_release) \
    f(ASurfaceTexture_acquireANativeWindow) \
    f(ASurfaceTexture_attachToGLContext) \
    f(ASurfaceTexture_detachFromGLContext) \
    f(ASurfaceTexture_updateTexImage) \
    f(ASurfaceTexture_getTransformMatrix) \
    f(ASurfaceTexture_getTimestamp) \
    f(ATrace_isEnabled) \
    f(ATrace_beginSection) \
    f(ATrace_endSection) \
    f(android_setsocknetwork) \
    f(android_setprocnetwork) \
    f(android_getaddrinfofornetwork)

#define STUB(s) __typeof__(s)* s;
static struct {
    FUNCTIONS(STUB)
} stubs;
#undef STUB

__attribute__((constructor)) static void init() {
    void* handle = dlopen(LIB, RTLD_LOCAL);
    // Nothing bad happened, normal case for termux-docker.
    if (!handle)
        return;
#define LOAD(s) stubs.s = dlsym(handle, #s);
    FUNCTIONS(LOAD)
#undef LOAD
}

#define CALL(f, def, ...) if (!stubs.f) return def; else return (stubs.f)(__VA_ARGS__)

AAssetDir* AAssetManager_openDir(AAssetManager* mgr, const char* dirName) {
    CALL(AAssetManager_openDir, NULL, mgr, dirName);
}

AAsset* AAssetManager_open(AAssetManager* mgr, const char* filename, int mode) {
    CALL(AAssetManager_open, NULL, mgr, filename, mode);
}

const char* AAssetDir_getNextFileName(AAssetDir* assetDir) {
    CALL(AAssetDir_getNextFileName, NULL, assetDir);
}

void AAssetDir_rewind(AAssetDir* assetDir) {
    CALL(AAssetDir_rewind,, assetDir);
}

void AAssetDir_close(AAssetDir* assetDir) {
    CALL(AAssetDir_close,, assetDir);
}

int AAsset_read(AAsset* asset, void* buf, size_t count) {
    CALL(AAsset_read, 0, asset, buf, count);
}

off_t AAsset_seek(AAsset* asset, off_t offset, int whence) {
    CALL(AAsset_seek, 0, asset, offset, whence);
}

off64_t AAsset_seek64(AAsset* asset, off64_t offset, int whence) {
    CALL(AAsset_seek64, 0, asset, offset, whence);
}

void AAsset_close(AAsset* asset) {
    CALL(AAsset_close,, asset);
}

const void* AAsset_getBuffer(AAsset* asset) {
    CALL(AAsset_getBuffer, NULL, asset);
}

off_t AAsset_getLength(AAsset* asset) {
    CALL(AAsset_getLength, 0, asset);
}

off64_t AAsset_getLength64(AAsset* asset) {
    CALL(AAsset_getLength64, 0, asset);
}

off_t AAsset_getRemainingLength(AAsset* asset) {
    CALL(AAsset_getRemainingLength, 0, asset);
}

off64_t AAsset_getRemainingLength64(AAsset* asset) {
    CALL(AAsset_getRemainingLength64, 0, asset);
}

int AAsset_openFileDescriptor(AAsset* asset, off_t* outStart, off_t* outLength) {
    CALL(AAsset_openFileDescriptor, 0, asset, outStart, outLength);
}

int AAsset_openFileDescriptor64(AAsset* asset, off64_t* outStart, off64_t* outLength) {
    CALL(AAsset_openFileDescriptor64, 0, asset, outStart, outLength);
}

int AAsset_isAllocated(AAsset* asset) {
    CALL(AAsset_isAllocated, 0, asset);
}

AAssetManager* AAssetManager_fromJava(JNIEnv* env, jobject assetManager) {
    CALL(AAssetManager_fromJava, NULL, env, assetManager);
}

AChoreographer* AChoreographer_getInstance() {
    CALL(AChoreographer_getInstance, NULL);
}

void AChoreographer_postFrameCallback(AChoreographer* choreographer, AChoreographer_frameCallback callback, void* data) {
    CALL(AChoreographer_postFrameCallback,, choreographer, callback, data);
}

void AChoreographer_postFrameCallbackDelayed(AChoreographer* choreographer, AChoreographer_frameCallback callback, void* data, long delayMillis) {
    CALL(AChoreographer_postFrameCallbackDelayed,, choreographer, callback, data, delayMillis);
}

AConfiguration* AConfiguration_new() {
    CALL(AConfiguration_new, NULL);
}

void AConfiguration_delete(AConfiguration* config) {
    CALL(AConfiguration_delete,, config);
}

void AConfiguration_fromAssetManager(AConfiguration* out, AAssetManager* am) {
    CALL(AConfiguration_fromAssetManager,, out, am);
}

void AConfiguration_copy(AConfiguration* dest, AConfiguration* src) {
    CALL(AConfiguration_copy,, dest, src);
}

int32_t AConfiguration_getMcc(AConfiguration* config) {
    CALL(AConfiguration_getMcc, 0, config);
}

void AConfiguration_setMcc(AConfiguration* config, int32_t mcc) {
    CALL(AConfiguration_setMcc,, config, mcc);
}

int32_t AConfiguration_getMnc(AConfiguration* config) {
    CALL(AConfiguration_getMnc, 0, config);
}

void AConfiguration_setMnc(AConfiguration* config, int32_t mnc) {
    CALL(AConfiguration_setMnc,, config, mnc);
}

void AConfiguration_getLanguage(AConfiguration* config, char* outLanguage) {
    CALL(AConfiguration_getLanguage,, config, outLanguage);
}

void AConfiguration_setLanguage(AConfiguration* config, const char* language) {
    CALL(AConfiguration_setLanguage,, config, language);
}

void AConfiguration_getCountry(AConfiguration* config, char* outCountry) {
    CALL(AConfiguration_getCountry,, config, outCountry);
}

void AConfiguration_setCountry(AConfiguration* config, const char* country) {
    CALL(AConfiguration_setCountry,, config, country);
}

int32_t AConfiguration_getOrientation(AConfiguration* config) {
    CALL(AConfiguration_getOrientation, 0, config);
}

void AConfiguration_setOrientation(AConfiguration* config, int32_t orientation) {
    CALL(AConfiguration_setOrientation,, config, orientation);
}

int32_t AConfiguration_getTouchscreen(AConfiguration* config) {
    CALL(AConfiguration_getTouchscreen, 0, config);
}

void AConfiguration_setTouchscreen(AConfiguration* config, int32_t touchscreen) {
    CALL(AConfiguration_setTouchscreen,, config, touchscreen);
}

int32_t AConfiguration_getDensity(AConfiguration* config) {
    CALL(AConfiguration_getDensity, 0, config);
}

void AConfiguration_setDensity(AConfiguration* config, int32_t density) {
    CALL(AConfiguration_setDensity,, config, density);
}

int32_t AConfiguration_getKeyboard(AConfiguration* config) {
    CALL(AConfiguration_getKeyboard, 0, config);
}

void AConfiguration_setKeyboard(AConfiguration* config, int32_t keyboard) {
    CALL(AConfiguration_setKeyboard,, config, keyboard);
}

int32_t AConfiguration_getNavigation(AConfiguration* config) {
    CALL(AConfiguration_getNavigation, 0, config);
}

void AConfiguration_setNavigation(AConfiguration* config, int32_t navigation) {
    CALL(AConfiguration_setNavigation,, config, navigation);
}

int32_t AConfiguration_getKeysHidden(AConfiguration* config) {
    CALL(AConfiguration_getKeysHidden, 0, config);
}

void AConfiguration_setKeysHidden(AConfiguration* config, int32_t keysHidden) {
    CALL(AConfiguration_setKeysHidden,, config, keysHidden);
}

int32_t AConfiguration_getNavHidden(AConfiguration* config) {
    CALL(AConfiguration_getNavHidden, 0, config);
}

void AConfiguration_setNavHidden(AConfiguration* config, int32_t navHidden) {
    CALL(AConfiguration_setNavHidden,, config, navHidden);
}

int32_t AConfiguration_getSdkVersion(AConfiguration* config) {
    CALL(AConfiguration_getSdkVersion, 0, config);
}

void AConfiguration_setSdkVersion(AConfiguration* config, int32_t sdkVersion) {
    CALL(AConfiguration_setSdkVersion,, config, sdkVersion);
}

int32_t AConfiguration_getScreenSize(AConfiguration* config) {
    CALL(AConfiguration_getScreenSize, 0, config);
}

void AConfiguration_setScreenSize(AConfiguration* config, int32_t screenSize) {
    CALL(AConfiguration_setScreenSize,, config, screenSize);
}

int32_t AConfiguration_getScreenLong(AConfiguration* config) {
    CALL(AConfiguration_getScreenLong, 0, config);
}

void AConfiguration_setScreenLong(AConfiguration* config, int32_t screenLong) {
    CALL(AConfiguration_setScreenLong,, config, screenLong);
}

void AConfiguration_setScreenRound(AConfiguration* config, int32_t screenRound) {
    CALL(AConfiguration_setScreenRound,, config, screenRound);
}

int32_t AConfiguration_getUiModeType(AConfiguration* config) {
    CALL(AConfiguration_getUiModeType, 0, config);
}

void AConfiguration_setUiModeType(AConfiguration* config, int32_t uiModeType) {
    CALL(AConfiguration_setUiModeType,, config, uiModeType);
}

int32_t AConfiguration_getUiModeNight(AConfiguration* config) {
    CALL(AConfiguration_getUiModeNight, 0, config);
}

void AConfiguration_setUiModeNight(AConfiguration* config, int32_t uiModeNight) {
    CALL(AConfiguration_setUiModeNight,, config, uiModeNight);
}

int32_t AConfiguration_getScreenWidthDp(AConfiguration* config) {
    CALL(AConfiguration_getScreenWidthDp, 0, config);
}

void AConfiguration_setScreenWidthDp(AConfiguration* config, int32_t value) {
    CALL(AConfiguration_setScreenWidthDp,, config, value);
}

int32_t AConfiguration_getScreenHeightDp(AConfiguration* config) {
    CALL(AConfiguration_getScreenHeightDp, 0, config);
}

void AConfiguration_setScreenHeightDp(AConfiguration* config, int32_t value) {
    CALL(AConfiguration_setScreenHeightDp,, config, value);
}

int32_t AConfiguration_getSmallestScreenWidthDp(AConfiguration* config) {
    CALL(AConfiguration_getSmallestScreenWidthDp, 0, config);
}

void AConfiguration_setSmallestScreenWidthDp(AConfiguration* config, int32_t value) {
    CALL(AConfiguration_setSmallestScreenWidthDp,, config, value);
}

int32_t AConfiguration_getLayoutDirection(AConfiguration* config) {
    CALL(AConfiguration_getLayoutDirection, 0, config);
}

void AConfiguration_setLayoutDirection(AConfiguration* config, int32_t value) {
    CALL(AConfiguration_setLayoutDirection,, config, value);
}

int32_t AConfiguration_diff(AConfiguration* config1, AConfiguration* config2) {
    CALL(AConfiguration_diff, 0, config1, config2);
}

int32_t AConfiguration_match(AConfiguration* base, AConfiguration* requested) {
    CALL(AConfiguration_match, 0, base, requested);
}

int32_t AConfiguration_isBetterThan(AConfiguration* base, AConfiguration* test, AConfiguration* requested) {
    CALL(AConfiguration_isBetterThan, 0, base, test, requested);
}

AHardwareBuffer* AHardwareBuffer_fromHardwareBuffer(JNIEnv* env, jobject hardwareBufferObj) {
    CALL(AHardwareBuffer_fromHardwareBuffer, NULL, env, hardwareBufferObj);
}

jobject AHardwareBuffer_toHardwareBuffer(JNIEnv* env, AHardwareBuffer* hardwareBuffer) {
    CALL(AHardwareBuffer_toHardwareBuffer, NULL, env, hardwareBuffer);
}

int AHardwareBuffer_allocate(const AHardwareBuffer_Desc* _Nonnull desc, AHardwareBuffer* _Nullable* _Nonnull outBuffer) {
    CALL(AHardwareBuffer_allocate, 0, desc, outBuffer);
}

void AHardwareBuffer_acquire(AHardwareBuffer* _Nonnull buffer) {
    CALL(AHardwareBuffer_acquire,, buffer);
}

void AHardwareBuffer_release(AHardwareBuffer* _Nonnull buffer) {
    CALL(AHardwareBuffer_release,, buffer);
}

void AHardwareBuffer_describe(const AHardwareBuffer* _Nonnull buffer, AHardwareBuffer_Desc* _Nonnull outDesc) {
    CALL(AHardwareBuffer_describe,, buffer, outDesc);
}

int AHardwareBuffer_lock(AHardwareBuffer* _Nonnull buffer, uint64_t usage, int32_t fence, const ARect* _Nullable rect, void* _Nullable* _Nonnull outVirtualAddress) {
    CALL(AHardwareBuffer_lock, 0, buffer, usage, fence, rect, outVirtualAddress);
}

int AHardwareBuffer_unlock(AHardwareBuffer* _Nonnull buffer, int32_t* _Nullable fence) {
    CALL(AHardwareBuffer_unlock, 0, buffer, fence);
}

int AHardwareBuffer_sendHandleToUnixSocket(const AHardwareBuffer* _Nonnull buffer, int socketFd) {
    CALL(AHardwareBuffer_sendHandleToUnixSocket, 0, buffer, socketFd);
}

int AHardwareBuffer_recvHandleFromUnixSocket(int socketFd, AHardwareBuffer* _Nullable* _Nonnull outBuffer) {
    CALL(AHardwareBuffer_recvHandleFromUnixSocket, 0, socketFd, outBuffer);
}

int32_t AInputEvent_getType(const AInputEvent* event) {
    CALL(AInputEvent_getType, 0, event);
}

int32_t AInputEvent_getDeviceId(const AInputEvent* event) {
    CALL(AInputEvent_getType, 0, event);
}

int32_t AInputEvent_getSource(const AInputEvent* event) {
    CALL(AInputEvent_getSource, 0, event);
}

int32_t AKeyEvent_getAction(const AInputEvent* key_event) {
    CALL(AKeyEvent_getAction, 0, key_event);
}

int32_t AKeyEvent_getFlags(const AInputEvent* key_event) {
    CALL(AKeyEvent_getFlags, 0, key_event);
}

int32_t AKeyEvent_getKeyCode(const AInputEvent* key_event) {
    CALL(AKeyEvent_getKeyCode, 0, key_event);
}

int32_t AKeyEvent_getScanCode(const AInputEvent* key_event) {
    CALL(AKeyEvent_getScanCode, 0, key_event);
}

int32_t AKeyEvent_getMetaState(const AInputEvent* key_event) {
    CALL(AKeyEvent_getMetaState, 0, key_event);
}

int32_t AKeyEvent_getRepeatCount(const AInputEvent* key_event) {
    CALL(AKeyEvent_getRepeatCount, 0, key_event);
}

int64_t AKeyEvent_getDownTime(const AInputEvent* key_event) {
    CALL(AKeyEvent_getDownTime, 0, key_event);
}

int64_t AKeyEvent_getEventTime(const AInputEvent* key_event) {
    CALL(AKeyEvent_getEventTime, 0, key_event);
}

int32_t AMotionEvent_getAction(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getAction, 0, motion_event);
}

int32_t AMotionEvent_getFlags(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getFlags, 0, motion_event);
}

int32_t AMotionEvent_getMetaState(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getMetaState, 0, motion_event);
}

int32_t AMotionEvent_getButtonState(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getButtonState, 0, motion_event);
}

int32_t AMotionEvent_getEdgeFlags(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getEdgeFlags, 0, motion_event);
}

int64_t AMotionEvent_getDownTime(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getDownTime, 0, motion_event);
}

int64_t AMotionEvent_getEventTime(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getEventTime, 0, motion_event);
}

float AMotionEvent_getXOffset(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getXOffset, 0, motion_event);
}

float AMotionEvent_getYOffset(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getYOffset, 0, motion_event);
}

float AMotionEvent_getXPrecision(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getXPrecision, 0, motion_event);
}

float AMotionEvent_getYPrecision(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getYPrecision, 0, motion_event);
}

size_t AMotionEvent_getPointerCount(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getPointerCount, 0, motion_event);
}

int32_t AMotionEvent_getPointerId(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getPointerId, 0, motion_event, pointer_index);
}

int32_t AMotionEvent_getToolType(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getToolType, 0, motion_event, pointer_index);
}

float AMotionEvent_getRawX(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getRawX, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getRawY(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getRawY, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getX(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getX, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getY(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getY, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getPressure(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getPressure, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getSize(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getSize, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getTouchMajor(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getTouchMajor, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getTouchMinor(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getTouchMinor, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getToolMajor(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getToolMajor, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getToolMinor(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getToolMinor, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getOrientation(const AInputEvent* motion_event, size_t pointer_index) {
    CALL(AMotionEvent_getOrientation, 0.f, motion_event, pointer_index);
}

float AMotionEvent_getAxisValue(const AInputEvent* motion_event, int32_t axis, size_t pointer_index) {
    CALL(AMotionEvent_getAxisValue, 0.f, motion_event, axis, pointer_index);
}

size_t AMotionEvent_getHistorySize(const AInputEvent* motion_event) {
    CALL(AMotionEvent_getHistorySize, 0, motion_event);
}

int64_t AMotionEvent_getHistoricalEventTime(const AInputEvent* motion_event, size_t history_index) {
    CALL(AMotionEvent_getHistoricalEventTime, 0, motion_event, history_index);
}

float AMotionEvent_getHistoricalRawX(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalRawX, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalRawY(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalRawY, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalX(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalX, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalY(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalY, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalPressure(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalPressure, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalSize(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalSize, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalTouchMajor(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalTouchMajor, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalTouchMinor(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalTouchMinor, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalToolMajor(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalToolMajor, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalToolMinor(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalToolMinor, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalOrientation(const AInputEvent* motion_event, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalOrientation, 0.f, motion_event, pointer_index, history_index);
}

float AMotionEvent_getHistoricalAxisValue(const AInputEvent* motion_event, int32_t axis, size_t pointer_index, size_t history_index) {
    CALL(AMotionEvent_getHistoricalAxisValue, 0.f, motion_event, axis, pointer_index, history_index);
}

void AInputQueue_attachLooper(AInputQueue* queue, ALooper* looper, int ident, ALooper_callbackFunc callback, void* data) {
    CALL(AInputQueue_attachLooper,, queue, looper, ident, callback, data);
}

void AInputQueue_detachLooper(AInputQueue* queue) {
    CALL(AInputQueue_detachLooper,, queue);
}

int32_t AInputQueue_hasEvents(AInputQueue* queue) {
    CALL(AInputQueue_hasEvents, 0, queue);
}

int32_t AInputQueue_getEvent(AInputQueue* queue, AInputEvent** outEvent) {
    CALL(AInputQueue_getEvent, 0, queue, outEvent);
}

int32_t AInputQueue_preDispatchEvent(AInputQueue* queue, AInputEvent* event) {
    CALL(AInputQueue_preDispatchEvent, 0, queue, event);
}

void AInputQueue_finishEvent(AInputQueue* queue, AInputEvent* event, int handled) {
    CALL(AInputQueue_finishEvent,, queue, event, handled);
}

ALooper* ALooper_forThread() {
    CALL(ALooper_forThread, NULL);
}

ALooper* ALooper_prepare(int opts) {
    CALL(ALooper_prepare, NULL, opts);
}

void ALooper_acquire(ALooper* looper) {
    CALL(ALooper_acquire,, looper);
}

void ALooper_release(ALooper* looper) {
    CALL(ALooper_release,, looper);
}

int ALooper_pollOnce(int timeoutMillis, int* outFd, int* outEvents, void** outData) {
    CALL(ALooper_pollOnce, 0, timeoutMillis, outFd, outEvents, outData);
}

void ALooper_wake(ALooper* looper) {
    CALL(ALooper_wake,, looper);
}

int ALooper_addFd(ALooper* looper, int fd, int ident, int events, ALooper_callbackFunc callback, void* data) {
    CALL(ALooper_addFd, 0, looper, fd, ident, events, callback, data);
}

int ALooper_removeFd(ALooper* looper, int fd) {
    CALL(ALooper_removeFd, 0, looper, fd);
}

void ANativeActivity_finish(ANativeActivity* activity) {
    CALL(ANativeActivity_finish,, activity);
}

void ANativeActivity_setWindowFormat(ANativeActivity* activity, int32_t format) {
    CALL(ANativeActivity_setWindowFormat,, activity, format);
}

void ANativeActivity_setWindowFlags(ANativeActivity* activity, uint32_t addFlags, uint32_t removeFlags) {
    CALL(ANativeActivity_setWindowFlags,, activity, addFlags, removeFlags);
}

void ANativeActivity_showSoftInput(ANativeActivity* activity, uint32_t flags) {
    CALL(ANativeActivity_showSoftInput,, activity, flags);
}

void ANativeActivity_hideSoftInput(ANativeActivity* activity, uint32_t flags) {
    CALL(ANativeActivity_hideSoftInput,, activity, flags);
}

ANativeWindow* ANativeWindow_fromSurface(JNIEnv* env, jobject surface) {
    CALL(ANativeWindow_fromSurface, NULL, env, surface);
}

jobject ANativeWindow_toSurface(JNIEnv* env, ANativeWindow* window) {
    CALL(ANativeWindow_toSurface, NULL, env, window);
}

void ANativeWindow_acquire(ANativeWindow* window) {
    CALL(ANativeWindow_acquire,, window);
}

void ANativeWindow_release(ANativeWindow* window) {
    CALL(ANativeWindow_release,, window);
}

int32_t ANativeWindow_getWidth(ANativeWindow* window) {
    CALL(ANativeWindow_getWidth, 0, window);
}

int32_t ANativeWindow_getHeight(ANativeWindow* window) {
    CALL(ANativeWindow_getHeight, 0, window);
}

int32_t ANativeWindow_getFormat(ANativeWindow* window) {
    CALL(ANativeWindow_getFormat, 0, window);
}

int32_t ANativeWindow_setBuffersGeometry(ANativeWindow* window, int32_t width, int32_t height, int32_t format) {
    CALL(ANativeWindow_setBuffersGeometry, 0, window, width, height, format);
}

int32_t ANativeWindow_lock(ANativeWindow* window, ANativeWindow_Buffer* outBuffer, ARect* inOutDirtyBounds) {
    CALL(ANativeWindow_lock, -1, window, outBuffer, inOutDirtyBounds);
}

int32_t ANativeWindow_unlockAndPost(ANativeWindow* window) {
    CALL(ANativeWindow_unlockAndPost, 0, window);
}

int32_t ANativeWindow_setBuffersTransform(ANativeWindow* window, int32_t transform) {
    CALL(ANativeWindow_setBuffersTransform, 0, window, transform);
}

int32_t ANativeWindow_setBuffersDataSpace(ANativeWindow* window, int32_t dataSpace) {
    CALL(ANativeWindow_setBuffersDataSpace, 0, window, dataSpace);
}

int32_t ANativeWindow_getBuffersDataSpace(ANativeWindow* window) {
    CALL(ANativeWindow_getBuffersDataSpace, 0, window);
}

AObbInfo* AObbScanner_getObbInfo(const char* filename) {
    CALL(AObbScanner_getObbInfo, NULL, filename);
}

void AObbInfo_delete(AObbInfo* obbInfo) {
    CALL(AObbInfo_delete,, obbInfo);
}

const char* AObbInfo_getPackageName(AObbInfo* obbInfo) {
    CALL(AObbInfo_getPackageName, NULL, obbInfo);
}

int32_t AObbInfo_getVersion(AObbInfo* obbInfo) {
    CALL(AObbInfo_getVersion, 0, obbInfo);
}

int32_t AObbInfo_getFlags(AObbInfo* obbInfo) {
    CALL(AObbInfo_getFlags, 0, obbInfo);
}

ASensorManager* ASensorManager_getInstance() {
    CALL(ASensorManager_getInstance, NULL);
}

ASensorManager* ASensorManager_getInstanceForPackage(const char* packageName) {
    CALL(ASensorManager_getInstanceForPackage, NULL, packageName);
}

int ASensorManager_getSensorList(ASensorManager* manager, ASensorList* list) {
    CALL(ASensorManager_getSensorList, 0, manager, list);
}

ASensor const* ASensorManager_getDefaultSensor(ASensorManager* manager, int type) {
    CALL(ASensorManager_getDefaultSensor, NULL, manager, type);
}

ASensor const* ASensorManager_getDefaultSensorEx(ASensorManager* manager, int type, bool wakeUp) {
    CALL(ASensorManager_getDefaultSensorEx, NULL, manager, type, wakeUp);
}

ASensorEventQueue* ASensorManager_createEventQueue(ASensorManager* manager, ALooper* looper, int ident, ALooper_callbackFunc callback, void* data) {
    CALL(ASensorManager_createEventQueue, NULL, manager, looper, ident, callback, data);
}

int ASensorManager_destroyEventQueue(ASensorManager* manager, ASensorEventQueue* queue) {
    CALL(ASensorManager_destroyEventQueue, 0, manager, queue);
}

int ASensorManager_createSharedMemoryDirectChannel(ASensorManager* manager, int fd, size_t size) {
    CALL(ASensorManager_createSharedMemoryDirectChannel, 0, manager, fd, size);
}

int ASensorManager_createHardwareBufferDirectChannel(ASensorManager* manager, AHardwareBuffer const * buffer, size_t size) {
    CALL(ASensorManager_createHardwareBufferDirectChannel, 0, manager, buffer, size);
}

void ASensorManager_destroyDirectChannel(ASensorManager* manager, int channelId) {
    CALL(ASensorManager_destroyDirectChannel,, manager, channelId);
}

int ASensorManager_configureDirectReport(ASensorManager* manager, ASensor const* sensor, int channelId, int rate) {
    CALL(ASensorManager_configureDirectReport, 0, manager, sensor, channelId, rate);
}

int ASensorEventQueue_registerSensor(ASensorEventQueue* queue, ASensor const* sensor, int32_t samplingPeriodUs, int64_t maxBatchReportLatencyUs) {
    CALL(ASensorEventQueue_registerSensor, 0, queue, sensor, samplingPeriodUs, maxBatchReportLatencyUs);
}

int ASensorEventQueue_enableSensor(ASensorEventQueue* queue, ASensor const* sensor) {
    CALL(ASensorEventQueue_enableSensor, 0, queue, sensor);
}

int ASensorEventQueue_disableSensor(ASensorEventQueue* queue, ASensor const* sensor) {
    CALL(ASensorEventQueue_disableSensor, 0, queue, sensor);
}

int ASensorEventQueue_setEventRate(ASensorEventQueue* queue, ASensor const* sensor, int32_t usec) {
    CALL(ASensorEventQueue_setEventRate, 0, queue, sensor, usec);
}

int ASensorEventQueue_hasEvents(ASensorEventQueue* queue) {
    CALL(ASensorEventQueue_hasEvents, 0, queue);
}

ssize_t ASensorEventQueue_getEvents(ASensorEventQueue* queue, ASensorEvent* events, size_t count) {
    CALL(ASensorEventQueue_getEvents, 0, queue, events, count);
}

const char* ASensor_getName(ASensor const* sensor) {
    CALL(ASensor_getName, NULL, sensor);
}

const char* ASensor_getVendor(ASensor const* sensor) {
    CALL(ASensor_getVendor, NULL, sensor);
}

int ASensor_getType(ASensor const* sensor) {
    CALL(ASensor_getType, 0, sensor);
}

float ASensor_getResolution(ASensor const* sensor) {
    CALL(ASensor_getResolution, 0.f, sensor);
}

int ASensor_getMinDelay(ASensor const* sensor) {
    CALL(ASensor_getMinDelay, 0, sensor);
}

int ASensor_getFifoMaxEventCount(ASensor const* sensor) {
    CALL(ASensor_getFifoMaxEventCount, 0, sensor);
}

int ASensor_getFifoReservedEventCount(ASensor const* sensor) {
    CALL(ASensor_getFifoReservedEventCount, 0, sensor);
}

const char* ASensor_getStringType(ASensor const* sensor) {
    CALL(ASensor_getStringType, NULL, sensor);
}

int ASensor_getReportingMode(ASensor const* sensor) {
    CALL(ASensor_getReportingMode, 0, sensor);
}

bool ASensor_isWakeUpSensor(ASensor const* sensor) {
    CALL(ASensor_isWakeUpSensor, false, sensor);
}

bool ASensor_isDirectChannelTypeSupported(ASensor const* sensor, int channelType) {
    CALL(ASensor_isDirectChannelTypeSupported, false, sensor, channelType);
}

int ASensor_getHighestDirectReportRateLevel(ASensor const* sensor) {
    CALL(ASensor_getHighestDirectReportRateLevel, 0, sensor);
}

int ASharedMemory_dupFromJava(JNIEnv* env, jobject sharedMemory) {
    CALL(ASharedMemory_dupFromJava, 0, env, sharedMemory);
}

int ASharedMemory_create(const char *name, size_t size) {
    CALL(ASharedMemory_create, -1, name, size);
}

size_t ASharedMemory_getSize(int fd) {
    CALL(ASharedMemory_getSize, 0, fd);
}

int ASharedMemory_setProt(int fd, int prot) {
    CALL(ASharedMemory_setProt, 0, fd, prot);
}

AStorageManager* AStorageManager_new() {
    CALL(AStorageManager_new, NULL);
}

void AStorageManager_delete(AStorageManager* mgr) {
    CALL(AStorageManager_delete,, mgr);
}

void AStorageManager_mountObb(AStorageManager* mgr, const char* filename, const char* key, AStorageManager_obbCallbackFunc cb, void* data) {
    CALL(AStorageManager_mountObb,, mgr, filename, key, cb, data);
}

void AStorageManager_unmountObb(AStorageManager* mgr, const char* filename, const int force, AStorageManager_obbCallbackFunc cb, void* data) {
    CALL(AStorageManager_unmountObb,, mgr, filename, force, cb, data);
}

int AStorageManager_isObbMounted(AStorageManager* mgr, const char* filename) {
    CALL(AStorageManager_isObbMounted, 0, mgr, filename);
}

const char* AStorageManager_getMountedObbPath(AStorageManager* mgr, const char* filename) {
    CALL(AStorageManager_getMountedObbPath, NULL, mgr, filename);
}

ASurfaceTexture* ASurfaceTexture_fromSurfaceTexture(JNIEnv* env, jobject surfacetexture) {
    CALL(ASurfaceTexture_fromSurfaceTexture, NULL, env, surfacetexture);
}

void ASurfaceTexture_release(ASurfaceTexture* st) {
    CALL(ASurfaceTexture_release,, st);
}

ANativeWindow* ASurfaceTexture_acquireANativeWindow(ASurfaceTexture* st) {
    CALL(ASurfaceTexture_acquireANativeWindow, NULL, st);
}

int ASurfaceTexture_attachToGLContext(ASurfaceTexture* st, uint32_t texName) {
    CALL(ASurfaceTexture_attachToGLContext, 0, st, texName);
}

int ASurfaceTexture_detachFromGLContext(ASurfaceTexture* st) {
    CALL(ASurfaceTexture_detachFromGLContext, 0, st);
}

int ASurfaceTexture_updateTexImage(ASurfaceTexture* st) {
    CALL(ASurfaceTexture_updateTexImage, 0, st);
}

void ASurfaceTexture_getTransformMatrix(ASurfaceTexture* st, float mtx[16]) {
    CALL(ASurfaceTexture_getTransformMatrix,, st, mtx);
}

int64_t ASurfaceTexture_getTimestamp(ASurfaceTexture* st) {
    CALL(ASurfaceTexture_getTimestamp, 0, st);
}

bool ATrace_isEnabled() {
    CALL(ATrace_isEnabled, false);
}

void ATrace_beginSection(const char* sectionName) {
    CALL(ATrace_beginSection,, sectionName);
}

void ATrace_endSection() {
    CALL(ATrace_endSection,);
}

int android_setsocknetwork(net_handle_t network, int fd) {
    CALL(android_setsocknetwork, 0, network, fd);
}

int android_setprocnetwork(net_handle_t network) {
    CALL(android_setprocnetwork, 0, network);
}

int android_getaddrinfofornetwork(net_handle_t network, const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res) {
    CALL(android_getaddrinfofornetwork, 0, network, node, service, hints, res);
}
