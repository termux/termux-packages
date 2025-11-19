#include <dlfcn.h>
#include <media/NdkImage.h>
#include <media/NdkImageReader.h>
#include <media/NdkMediaCodec.h>
#include <media/NdkMediaCrypto.h>
#include <media/NdkMediaDataSource.h>
#include <media/NdkMediaDrm.h>
#include <media/NdkMediaExtractor.h>
#include <media/NdkMediaFormat.h>
#include <media/NdkMediaMuxer.h>

#ifdef __LP64__
#define LIB "/system/lib64/libmediandk.so"
#else
#define LIB "/system/lib/libmediandk.so"
#endif

#define FUNCTIONS(f) \
    f(AImage_delete) \
    f(AImage_getWidth) \
    f(AImage_getHeight) \
    f(AImage_getFormat) \
    f(AImage_getCropRect) \
    f(AImage_getTimestamp) \
    f(AImage_getNumberOfPlanes) \
    f(AImage_getPlanePixelStride) \
    f(AImage_getPlaneRowStride) \
    f(AImage_getPlaneData) \
    f(AImage_deleteAsync) \
    f(AImage_getHardwareBuffer) \
    f(AImageReader_new) \
    f(AImageReader_delete) \
    f(AImageReader_getWindow) \
    f(AImageReader_getWidth) \
    f(AImageReader_getHeight) \
    f(AImageReader_getFormat) \
    f(AImageReader_getMaxImages) \
    f(AImageReader_acquireNextImage) \
    f(AImageReader_acquireLatestImage) \
    f(AImageReader_setImageListener) \
    f(AImageReader_newWithUsage) \
    f(AImageReader_acquireNextImageAsync) \
    f(AImageReader_acquireLatestImageAsync) \
    f(AImageReader_setBufferRemovedListener) \
    f(AMediaCodec_createCodecByName) \
    f(AMediaCodec_createDecoderByType) \
    f(AMediaCodec_createEncoderByType) \
    f(AMediaCodec_delete) \
    f(AMediaCodec_configure) \
    f(AMediaCodec_start) \
    f(AMediaCodec_stop) \
    f(AMediaCodec_flush) \
    f(AMediaCodec_getInputBuffer) \
    f(AMediaCodec_getOutputBuffer) \
    f(AMediaCodec_dequeueInputBuffer) \
    f(AMediaCodec_queueInputBuffer) \
    f(AMediaCodec_queueSecureInputBuffer) \
    f(AMediaCodec_dequeueOutputBuffer) \
    f(AMediaCodec_getOutputFormat) \
    f(AMediaCodec_releaseOutputBuffer) \
    f(AMediaCodec_setOutputSurface) \
    f(AMediaCodec_releaseOutputBufferAtTime) \
    f(AMediaCodec_createInputSurface) \
    f(AMediaCodec_createPersistentInputSurface) \
    f(AMediaCodec_setInputSurface) \
    f(AMediaCodec_setParameters) \
    f(AMediaCodec_signalEndOfInputStream) \
    f(AMediaCodec_getBufferFormat) \
    f(AMediaCodec_getName) \
    f(AMediaCodec_releaseName) \
    f(AMediaCodec_setAsyncNotifyCallback) \
    f(AMediaCodec_releaseCrypto) \
    f(AMediaCodec_getInputFormat) \
    f(AMediaCodecActionCode_isRecoverable) \
    f(AMediaCodecActionCode_isTransient) \
    f(AMediaCodecCryptoInfo_new) \
    f(AMediaCodecCryptoInfo_delete) \
    f(AMediaCodecCryptoInfo_setPattern) \
    f(AMediaCodecCryptoInfo_getNumSubSamples) \
    f(AMediaCodecCryptoInfo_getKey) \
    f(AMediaCodecCryptoInfo_getIV) \
    f(AMediaCodecCryptoInfo_getMode) \
    f(AMediaCodecCryptoInfo_getClearBytes) \
    f(AMediaCodecCryptoInfo_getEncryptedBytes) \
    f(AMediaCrypto_isCryptoSchemeSupported) \
    f(AMediaCrypto_requiresSecureDecoderComponent) \
    f(AMediaCrypto_new) \
    f(AMediaCrypto_delete) \
    f(AMediaDataSource_new) \
    f(AMediaDataSource_delete) \
    f(AMediaDataSource_setUserdata) \
    f(AMediaDataSource_setReadAt) \
    f(AMediaDataSource_setGetSize) \
    f(AMediaDataSource_setClose) \
    f(AMediaDrm_isCryptoSchemeSupported) \
    f(AMediaDrm_createByUUID) \
    f(AMediaDrm_release) \
    f(AMediaDrm_setOnEventListener) \
    f(AMediaDrm_openSession) \
    f(AMediaDrm_closeSession) \
    f(AMediaDrm_getKeyRequest) \
    f(AMediaDrm_provideKeyResponse) \
    f(AMediaDrm_restoreKeys) \
    f(AMediaDrm_removeKeys) \
    f(AMediaDrm_queryKeyStatus) \
    f(AMediaDrm_getProvisionRequest) \
    f(AMediaDrm_provideProvisionResponse) \
    f(AMediaDrm_getSecureStops) \
    f(AMediaDrm_releaseSecureStops) \
    f(AMediaDrm_getPropertyString) \
    f(AMediaDrm_getPropertyByteArray) \
    f(AMediaDrm_setPropertyString) \
    f(AMediaDrm_setPropertyByteArray) \
    f(AMediaDrm_encrypt) \
    f(AMediaDrm_decrypt) \
    f(AMediaDrm_sign) \
    f(AMediaDrm_verify) \
    f(AMediaExtractor_new) \
    f(AMediaExtractor_delete) \
    f(AMediaExtractor_setDataSourceFd) \
    f(AMediaExtractor_setDataSource) \
    f(AMediaExtractor_setDataSourceCustom) \
    f(AMediaExtractor_getTrackCount) \
    f(AMediaExtractor_getTrackFormat) \
    f(AMediaExtractor_selectTrack) \
    f(AMediaExtractor_unselectTrack) \
    f(AMediaExtractor_readSampleData) \
    f(AMediaExtractor_getSampleFlags) \
    f(AMediaExtractor_getSampleTrackIndex) \
    f(AMediaExtractor_getSampleTime) \
    f(AMediaExtractor_advance) \
    f(AMediaExtractor_seekTo) \
    f(AMediaExtractor_getPsshInfo) \
    f(AMediaExtractor_getSampleCryptoInfo) \
    f(AMediaExtractor_getFileFormat) \
    f(AMediaExtractor_getSampleSize) \
    f(AMediaExtractor_getCachedDuration) \
    f(AMediaExtractor_getSampleFormat) \
    f(AMediaFormat_new) \
    f(AMediaFormat_delete) \
    f(AMediaFormat_toString) \
    f(AMediaFormat_getInt32) \
    f(AMediaFormat_getInt64) \
    f(AMediaFormat_getFloat) \
    f(AMediaFormat_getSize) \
    f(AMediaFormat_getBuffer) \
    f(AMediaFormat_getString) \
    f(AMediaFormat_setInt32) \
    f(AMediaFormat_setInt64) \
    f(AMediaFormat_setFloat) \
    f(AMediaFormat_setString) \
    f(AMediaFormat_setBuffer) \
    f(AMediaFormat_getDouble) \
    f(AMediaFormat_getRect) \
    f(AMediaFormat_setDouble) \
    f(AMediaFormat_setSize) \
    f(AMediaFormat_setRect) \
    f(AMediaMuxer_new) \
    f(AMediaMuxer_delete) \
    f(AMediaMuxer_setLocation) \
    f(AMediaMuxer_setOrientationHint) \
    f(AMediaMuxer_addTrack) \
    f(AMediaMuxer_start) \
    f(AMediaMuxer_stop) \
    f(AMediaMuxer_writeSampleData)

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

void AImage_delete(AImage* image) {
    CALL(AImage_delete,, image);
}

media_status_t AImage_getWidth(const AImage* image, /*out*/int32_t* width) {
    CALL(AImage_getWidth, 0, image, width);
}

media_status_t AImage_getHeight(const AImage* image, /*out*/int32_t* height) {
    CALL(AImage_getHeight, 0, image, height);
}

media_status_t AImage_getFormat(const AImage* image, /*out*/int32_t* format) {
    CALL(AImage_getFormat, 0, image, format);
}

media_status_t AImage_getCropRect(const AImage* image, /*out*/AImageCropRect* rect) {
    CALL(AImage_getCropRect, 0, image, rect);
}

media_status_t AImage_getTimestamp(const AImage* image, /*out*/int64_t* timestampNs) {
    CALL(AImage_getTimestamp, 0, image, timestampNs);
}

media_status_t AImage_getNumberOfPlanes(const AImage* image, /*out*/int32_t* numPlanes) {
    CALL(AImage_getNumberOfPlanes, 0, image, numPlanes);
}

media_status_t AImage_getPlanePixelStride(const AImage* image, int planeIdx, /*out*/int32_t* pixelStride) {
    CALL(AImage_getPlanePixelStride, 0, image, planeIdx, pixelStride);
}

media_status_t AImage_getPlaneRowStride(const AImage* image, int planeIdx, /*out*/int32_t* rowStride) {
    CALL(AImage_getPlaneRowStride, 0, image, planeIdx, rowStride);
}

media_status_t AImage_getPlaneData(const AImage* image, int planeIdx, /*out*/uint8_t** data, /*out*/int* dataLength) {
    CALL(AImage_getPlaneData, 0, image, planeIdx, data, dataLength);
}

void AImage_deleteAsync(AImage* image, int releaseFenceFd) {
    CALL(AImage_deleteAsync,, image, releaseFenceFd);
}

media_status_t AImage_getHardwareBuffer(const AImage* image, /*out*/AHardwareBuffer** buffer) {
    CALL(AImage_getHardwareBuffer, 0, image, buffer);
}

media_status_t AImageReader_new(int32_t width, int32_t height, int32_t format, int32_t maxImages, /*out*/AImageReader** reader) {
    CALL(AImageReader_new, 0, width, height, format, maxImages, reader);
}

void AImageReader_delete(AImageReader* reader) {
    CALL(AImageReader_delete,, reader);
}

media_status_t AImageReader_getWindow(AImageReader* reader, /*out*/ANativeWindow** window) {
    CALL(AImageReader_getWindow, 0, reader, window);
}

media_status_t AImageReader_getWidth(const AImageReader* reader, /*out*/int32_t* width) {
    CALL(AImageReader_getWidth, 0, reader, width);
}

media_status_t AImageReader_getHeight(const AImageReader* reader, /*out*/int32_t* height) {
    CALL(AImageReader_getHeight, 0, reader, height);
}

media_status_t AImageReader_getFormat(const AImageReader* reader, /*out*/int32_t* format) {
    CALL(AImageReader_getFormat, 0, reader, format);
}

media_status_t AImageReader_getMaxImages(const AImageReader* reader, /*out*/int32_t* maxImages) {
    CALL(AImageReader_getMaxImages, 0, reader, maxImages);
}

media_status_t AImageReader_acquireNextImage(AImageReader* reader, /*out*/AImage** image) {
    CALL(AImageReader_acquireNextImage, 0, reader, image);
}

media_status_t AImageReader_acquireLatestImage(AImageReader* reader, /*out*/AImage** image) {
    CALL(AImageReader_acquireLatestImage, 0, reader, image);
}

media_status_t AImageReader_setImageListener(AImageReader* reader, AImageReader_ImageListener* listener) {
    CALL(AImageReader_setImageListener, 0, reader, listener);
}

media_status_t AImageReader_newWithUsage(int32_t width, int32_t height, int32_t format, uint64_t usage, int32_t maxImages, /*out*/ AImageReader** reader) {
    CALL(AImageReader_newWithUsage, 0, width, height, format, usage, maxImages, reader);
}

media_status_t AImageReader_acquireNextImageAsync(AImageReader* reader, /*out*/AImage** image, /*out*/int* acquireFenceFd) {
    CALL(AImageReader_acquireNextImageAsync, 0, reader, image, acquireFenceFd);
}

media_status_t AImageReader_acquireLatestImageAsync(AImageReader* reader, /*out*/AImage** image, /*out*/int* acquireFenceFd) {
    CALL(AImageReader_acquireLatestImageAsync, 0, reader, image, acquireFenceFd);
}

media_status_t AImageReader_setBufferRemovedListener(AImageReader* reader, AImageReader_BufferRemovedListener* listener) {
    CALL(AImageReader_setBufferRemovedListener, 0, reader, listener);
}

AMediaCodec* AMediaCodec_createCodecByName(const char *name) {
    CALL(AMediaCodec_createCodecByName, NULL, name);
}

AMediaCodec* AMediaCodec_createDecoderByType(const char *mime_type) {
    CALL(AMediaCodec_createDecoderByType, NULL, mime_type);
}

AMediaCodec* AMediaCodec_createEncoderByType(const char *mime_type) {
    CALL(AMediaCodec_createEncoderByType, NULL, mime_type);
}

media_status_t AMediaCodec_delete(AMediaCodec* mData) {
    CALL(AMediaCodec_delete, 0, mData);
}

media_status_t AMediaCodec_configure(AMediaCodec* mData, const AMediaFormat* format, ANativeWindow* surface, AMediaCrypto *crypto, uint32_t flags) {
    CALL(AMediaCodec_configure, 0, mData, format, surface, crypto, flags);
}

media_status_t AMediaCodec_start(AMediaCodec* mData) {
    CALL(AMediaCodec_start, 0, mData);
}

media_status_t AMediaCodec_stop(AMediaCodec* mData) {
    CALL(AMediaCodec_stop, 0, mData);
}

media_status_t AMediaCodec_flush(AMediaCodec* mData) {
    CALL(AMediaCodec_flush, 0, mData);
}

uint8_t* AMediaCodec_getInputBuffer(AMediaCodec* mData, size_t idx, size_t *out_size) {
    CALL(AMediaCodec_getInputBuffer, NULL, mData, idx, out_size);
}

uint8_t* AMediaCodec_getOutputBuffer(AMediaCodec* mData, size_t idx, size_t *out_size) {
    CALL(AMediaCodec_getOutputBuffer, NULL, mData, idx, out_size);
}

ssize_t AMediaCodec_dequeueInputBuffer(AMediaCodec* mData, int64_t timeoutUs) {
    CALL(AMediaCodec_dequeueInputBuffer, 0, mData, timeoutUs);
}

#if defined(__USE_FILE_OFFSET64) && !defined(__LP64__)
#define _off_t_compat int32_t
#else
#define _off_t_compat off_t
#endif  /* defined(__USE_FILE_OFFSET64) && !defined(__LP64__) */

media_status_t AMediaCodec_queueInputBuffer(AMediaCodec* mData, size_t idx, _off_t_compat offset, size_t size, uint64_t time, uint32_t flags) {
    CALL(AMediaCodec_queueInputBuffer, 0, mData, idx, offset, size, time, flags);
}

media_status_t AMediaCodec_queueSecureInputBuffer(AMediaCodec* mData, size_t idx, _off_t_compat offset, AMediaCodecCryptoInfo* crypto, uint64_t time, uint32_t flags) {
    CALL(AMediaCodec_queueSecureInputBuffer, 0, mData, idx, offset, crypto, time, flags);
}

#undef _off_t_compat

ssize_t AMediaCodec_dequeueOutputBuffer(AMediaCodec* mData, AMediaCodecBufferInfo *info, int64_t timeoutUs) {
    CALL(AMediaCodec_dequeueOutputBuffer, 0, mData, info, timeoutUs);
}

AMediaFormat* AMediaCodec_getOutputFormat(AMediaCodec* mData) {
    CALL(AMediaCodec_getOutputFormat, NULL, mData);
}

media_status_t AMediaCodec_releaseOutputBuffer(AMediaCodec* mData, size_t idx, bool render) {
    CALL(AMediaCodec_releaseOutputBuffer, 0, mData, idx, render);
}

media_status_t AMediaCodec_setOutputSurface(AMediaCodec* mData, ANativeWindow* surface) {
    CALL(AMediaCodec_setOutputSurface, 0, mData, surface);
}

media_status_t AMediaCodec_releaseOutputBufferAtTime(AMediaCodec *mData, size_t idx, int64_t timestampNs) {
    CALL(AMediaCodec_releaseOutputBufferAtTime, 0, mData, idx, timestampNs);
}

media_status_t AMediaCodec_createInputSurface(AMediaCodec *mData, ANativeWindow **surface) {
    CALL(AMediaCodec_createInputSurface, 0, mData, surface);
}

media_status_t AMediaCodec_createPersistentInputSurface(ANativeWindow **surface) {
    CALL(AMediaCodec_createPersistentInputSurface, 0, surface);
}

media_status_t AMediaCodec_setInputSurface(AMediaCodec *mData, ANativeWindow *surface) {
    CALL(AMediaCodec_setInputSurface, 0, mData, surface);
}

media_status_t AMediaCodec_setParameters(AMediaCodec *mData, const AMediaFormat* params) {
    CALL(AMediaCodec_setParameters, 0, mData, params);
}

media_status_t AMediaCodec_signalEndOfInputStream(AMediaCodec *mData) {
    CALL(AMediaCodec_signalEndOfInputStream, 0, mData);
}

AMediaFormat* AMediaCodec_getBufferFormat(AMediaCodec* mData, size_t index) {
    CALL(AMediaCodec_getBufferFormat, 0, mData, index);
}

media_status_t AMediaCodec_getName(AMediaCodec* mData, char** out_name) {
    CALL(AMediaCodec_getName, 0, mData, out_name);
}

void AMediaCodec_releaseName(AMediaCodec* mData, char* name) {
    CALL(AMediaCodec_releaseName,, mData, name);
}

media_status_t AMediaCodec_setAsyncNotifyCallback(AMediaCodec* mData, AMediaCodecOnAsyncNotifyCallback callback, void *userdata) {
    CALL(AMediaCodec_setAsyncNotifyCallback, 0, mData, callback, userdata);
}

media_status_t AMediaCodec_releaseCrypto(AMediaCodec* mData) {
    CALL(AMediaCodec_releaseCrypto, 0, mData);
}

AMediaFormat* AMediaCodec_getInputFormat(AMediaCodec* mData) {
    CALL(AMediaCodec_getInputFormat, NULL, mData);
}

bool AMediaCodecActionCode_isRecoverable(int32_t actionCode) {
    CALL(AMediaCodecActionCode_isRecoverable, false, actionCode);
}

bool AMediaCodecActionCode_isTransient(int32_t actionCode) {
    CALL(AMediaCodecActionCode_isTransient, false, actionCode);
}

AMediaCodecCryptoInfo *AMediaCodecCryptoInfo_new(int numsubsamples, uint8_t key[16], uint8_t iv[16], cryptoinfo_mode_t mode, size_t *clearbytes, size_t *encryptedbytes) {
    CALL(AMediaCodecCryptoInfo_new, NULL, numsubsamples, key, iv, mode, clearbytes, encryptedbytes);
}

media_status_t AMediaCodecCryptoInfo_delete(AMediaCodecCryptoInfo* crypto) {
    CALL(AMediaCodecCryptoInfo_delete, 0, crypto);
}

void AMediaCodecCryptoInfo_setPattern(AMediaCodecCryptoInfo *info, cryptoinfo_pattern_t *pattern) {
    CALL(AMediaCodecCryptoInfo_setPattern,, info, pattern);
}

size_t AMediaCodecCryptoInfo_getNumSubSamples(AMediaCodecCryptoInfo* crypto) {
    CALL(AMediaCodecCryptoInfo_getNumSubSamples, 0, crypto);
}

media_status_t AMediaCodecCryptoInfo_getKey(AMediaCodecCryptoInfo* crypto, uint8_t *dst) {
    CALL(AMediaCodecCryptoInfo_getKey, 0, crypto, dst);
}

media_status_t AMediaCodecCryptoInfo_getIV(AMediaCodecCryptoInfo* crypto, uint8_t *dst) {
    CALL(AMediaCodecCryptoInfo_getIV, 0, crypto, dst);
}

cryptoinfo_mode_t AMediaCodecCryptoInfo_getMode(AMediaCodecCryptoInfo* crypto) {
    CALL(AMediaCodecCryptoInfo_getMode, 0, crypto);
}

media_status_t AMediaCodecCryptoInfo_getClearBytes(AMediaCodecCryptoInfo* crypto, size_t *dst) {
    CALL(AMediaCodecCryptoInfo_getClearBytes, 0, crypto, dst);
}

media_status_t AMediaCodecCryptoInfo_getEncryptedBytes(AMediaCodecCryptoInfo* crypto, size_t *dst) {
    CALL(AMediaCodecCryptoInfo_getEncryptedBytes, 0, crypto, dst);
}

bool AMediaCrypto_isCryptoSchemeSupported(const AMediaUUID uuid) {
    CALL(AMediaCrypto_isCryptoSchemeSupported, false, uuid);
}

bool AMediaCrypto_requiresSecureDecoderComponent(const char *mime) {
    CALL(AMediaCrypto_requiresSecureDecoderComponent, false, mime);
}

AMediaCrypto* AMediaCrypto_new(const AMediaUUID uuid, const void *initData, size_t initDataSize) {
    CALL(AMediaCrypto_new, NULL, uuid, initData, initDataSize);
}

void AMediaCrypto_delete(AMediaCrypto* crypto) {
    CALL(AMediaCrypto_delete,, crypto);
}

AMediaDataSource* AMediaDataSource_new() {
    CALL(AMediaDataSource_new, NULL);
}

void AMediaDataSource_delete(AMediaDataSource* source) {
    CALL(AMediaDataSource_delete,, source);
}

void AMediaDataSource_setUserdata(AMediaDataSource* source, void *userdata) {
    CALL(AMediaDataSource_setUserdata,, source, userdata);
}

void AMediaDataSource_setReadAt(AMediaDataSource* source, AMediaDataSourceReadAt cb) {
    CALL(AMediaDataSource_setReadAt,, source, cb);
}

void AMediaDataSource_setGetSize(AMediaDataSource* source, AMediaDataSourceGetSize cb) {
    CALL(AMediaDataSource_setGetSize,, source, cb);
}

void AMediaDataSource_setClose(AMediaDataSource* source, AMediaDataSourceClose cb) {
    CALL(AMediaDataSource_setClose,, source, cb);
}

bool AMediaDrm_isCryptoSchemeSupported(const uint8_t *uuid, const char *mimeType) {
    CALL(AMediaDrm_isCryptoSchemeSupported, false, uuid, mimeType);
}

AMediaDrm* AMediaDrm_createByUUID(const uint8_t *uuid) {
    CALL(AMediaDrm_createByUUID, NULL, uuid);
}

void AMediaDrm_release(AMediaDrm *mData) {
    CALL(AMediaDrm_release,, mData);
}

media_status_t AMediaDrm_setOnEventListener(AMediaDrm *mData, AMediaDrmEventListener listener) {
    CALL(AMediaDrm_setOnEventListener, 0, mData, listener);
}

media_status_t AMediaDrm_openSession(AMediaDrm *mData, AMediaDrmSessionId *sessionId) {
    CALL(AMediaDrm_openSession, 0, mData, sessionId);
}

media_status_t AMediaDrm_closeSession(AMediaDrm * mData, const AMediaDrmSessionId *sessionId) {
    CALL(AMediaDrm_closeSession, 0, mData, sessionId);
}

media_status_t AMediaDrm_getKeyRequest(AMediaDrm * mData, const AMediaDrmScope *scope, const uint8_t *init, size_t initSize, const char *mimeType, AMediaDrmKeyType keyType, const AMediaDrmKeyValue *optionalParameters, size_t numOptionalParameters, const uint8_t **keyRequest, size_t *keyRequestSize) {
    CALL(AMediaDrm_getKeyRequest, 0, mData, scope, init, initSize, mimeType, keyType, optionalParameters, numOptionalParameters, keyRequest, keyRequestSize);
}

media_status_t AMediaDrm_provideKeyResponse(AMediaDrm *mData, const AMediaDrmScope *scope, const uint8_t *response, size_t responseSize, AMediaDrmKeySetId *keySetId) {
    CALL(AMediaDrm_provideKeyResponse, 0, mData, scope, response, responseSize, keySetId);
}

media_status_t AMediaDrm_restoreKeys(AMediaDrm *mData, const AMediaDrmSessionId *sessionId, const AMediaDrmKeySetId *keySetId) {
    CALL(AMediaDrm_restoreKeys, 0, mData, sessionId, keySetId);
}

media_status_t AMediaDrm_removeKeys(AMediaDrm *mData, const AMediaDrmSessionId *keySetId) {
    CALL(AMediaDrm_removeKeys, 0, mData, keySetId);
}

media_status_t AMediaDrm_queryKeyStatus(AMediaDrm *mData, const AMediaDrmSessionId *sessionId, AMediaDrmKeyValue *keyValuePairs, size_t *numPairs) {
    CALL(AMediaDrm_queryKeyStatus, 0, mData, sessionId, keyValuePairs, numPairs);
}

media_status_t AMediaDrm_getProvisionRequest(AMediaDrm *mData, const uint8_t **provisionRequest, size_t *provisionRequestSize, const char **serverUrl) {
    CALL(AMediaDrm_getProvisionRequest, 0, mData, provisionRequest, provisionRequestSize, serverUrl);
}

media_status_t AMediaDrm_provideProvisionResponse(AMediaDrm *mData, const uint8_t *response, size_t responseSize) {
    CALL(AMediaDrm_provideProvisionResponse, 0, mData, response, responseSize);
}

media_status_t AMediaDrm_getSecureStops(AMediaDrm *mData, AMediaDrmSecureStop *secureStops, size_t *numSecureStops) {
    CALL(AMediaDrm_getSecureStops, 0, mData, secureStops, numSecureStops);
}

media_status_t AMediaDrm_releaseSecureStops(AMediaDrm *mData, const AMediaDrmSecureStop *ssRelease) {
    CALL(AMediaDrm_releaseSecureStops, 0, mData, ssRelease);
}

media_status_t AMediaDrm_getPropertyString(AMediaDrm *mData, const char *propertyName, const char **propertyValue) {
    CALL(AMediaDrm_getPropertyString, 0, mData, propertyName, propertyValue);
}

media_status_t AMediaDrm_getPropertyByteArray(AMediaDrm *mData, const char *propertyName, AMediaDrmByteArray *propertyValue) {
    CALL(AMediaDrm_getPropertyByteArray, 0, mData, propertyName, propertyValue);
}

media_status_t AMediaDrm_setPropertyString(AMediaDrm *mData, const char *propertyName, const char *value) {
    CALL(AMediaDrm_setPropertyString, 0, mData, propertyName, value);
}

media_status_t AMediaDrm_setPropertyByteArray(AMediaDrm *mData, const char *propertyName, const uint8_t *value, size_t valueSize) {
    CALL(AMediaDrm_setPropertyByteArray, 0, mData, propertyName, value, valueSize);
}

media_status_t AMediaDrm_encrypt(AMediaDrm *mData, const AMediaDrmSessionId *sessionId, const char *cipherAlgorithm, uint8_t *keyId, uint8_t *iv, const uint8_t *input, uint8_t *output, size_t dataSize) {
    CALL(AMediaDrm_encrypt, 0, mData, sessionId, cipherAlgorithm, keyId, iv, input, output, dataSize);
}

media_status_t AMediaDrm_decrypt(AMediaDrm *mData, const AMediaDrmSessionId *sessionId, const char *cipherAlgorithm, uint8_t *keyId, uint8_t *iv, const uint8_t *input, uint8_t *output, size_t dataSize) {
    CALL(AMediaDrm_decrypt, 0, mData, sessionId, cipherAlgorithm, keyId, iv, input, output, dataSize);
}

media_status_t AMediaDrm_sign(AMediaDrm *mData, const AMediaDrmSessionId *sessionId, const char *macAlgorithm, uint8_t *keyId, uint8_t *message, size_t messageSize, uint8_t *signature, size_t *signatureSize) {
    CALL(AMediaDrm_sign, 0, mData, sessionId, macAlgorithm, keyId, message, messageSize, signature, signatureSize);
}

media_status_t AMediaDrm_verify(AMediaDrm *mData, const AMediaDrmSessionId *sessionId, const char *macAlgorithm, uint8_t *keyId, const uint8_t *message, size_t messageSize, const uint8_t *signature, size_t signatureSize) {
    CALL(AMediaDrm_verify, 0, mData, sessionId, macAlgorithm, keyId, message, messageSize, signature, signatureSize);
}

AMediaExtractor* AMediaExtractor_new() {
    CALL(AMediaExtractor_new, NULL);
}

media_status_t AMediaExtractor_delete(AMediaExtractor* ex) {
    CALL(AMediaExtractor_delete, 0, ex);
}

media_status_t AMediaExtractor_setDataSourceFd(AMediaExtractor* ex, int fd, off64_t offset, off64_t length) {
    CALL(AMediaExtractor_setDataSourceFd, 0, ex, fd, offset, length);
}

media_status_t AMediaExtractor_setDataSource(AMediaExtractor* ex, const char *location) {
    CALL(AMediaExtractor_setDataSource, 0, ex, location);
}

media_status_t AMediaExtractor_setDataSourceCustom(AMediaExtractor* ex, AMediaDataSource *src) {
    CALL(AMediaExtractor_setDataSourceCustom, 0, ex, src);
}

size_t AMediaExtractor_getTrackCount(AMediaExtractor* ex) {
    CALL(AMediaExtractor_getTrackCount, 0, ex);
}

AMediaFormat* AMediaExtractor_getTrackFormat(AMediaExtractor* ex, size_t idx) {
    CALL(AMediaExtractor_getTrackFormat, NULL, ex, idx);
}

media_status_t AMediaExtractor_selectTrack(AMediaExtractor* ex, size_t idx) {
    CALL(AMediaExtractor_selectTrack, 0, ex, idx);
}

media_status_t AMediaExtractor_unselectTrack(AMediaExtractor* ex, size_t idx) {
    CALL(AMediaExtractor_unselectTrack, 0, ex, idx);
}

ssize_t AMediaExtractor_readSampleData(AMediaExtractor* ex, uint8_t *buffer, size_t capacity) {
    CALL(AMediaExtractor_readSampleData, 0, ex, buffer, capacity);
}

uint32_t AMediaExtractor_getSampleFlags(AMediaExtractor* ex) {
    CALL(AMediaExtractor_getSampleFlags, 0, ex);
}

int AMediaExtractor_getSampleTrackIndex(AMediaExtractor* ex) {
    CALL(AMediaExtractor_getSampleTrackIndex, 0, ex);
}

int64_t AMediaExtractor_getSampleTime(AMediaExtractor* ex) {
    CALL(AMediaExtractor_getSampleTime, 0, ex);
}

bool AMediaExtractor_advance(AMediaExtractor* ex) {
    CALL(AMediaExtractor_advance, false, ex);
}

media_status_t AMediaExtractor_seekTo(AMediaExtractor* ex, int64_t seekPosUs, SeekMode mode) {
    CALL(AMediaExtractor_seekTo, 0, ex, seekPosUs, mode);
}

PsshInfo* AMediaExtractor_getPsshInfo(AMediaExtractor* ex) {
    CALL(AMediaExtractor_getPsshInfo, NULL, ex);
}

AMediaCodecCryptoInfo *AMediaExtractor_getSampleCryptoInfo(AMediaExtractor *ex) {
    CALL(AMediaExtractor_getSampleCryptoInfo, NULL, ex);
}

AMediaFormat* AMediaExtractor_getFileFormat(AMediaExtractor* ex) {
    CALL(AMediaExtractor_getFileFormat, NULL, ex);
}

ssize_t AMediaExtractor_getSampleSize(AMediaExtractor* ex) {
    CALL(AMediaExtractor_getSampleSize, 0, ex);
}

int64_t AMediaExtractor_getCachedDuration(AMediaExtractor* ex) {
    CALL(AMediaExtractor_getCachedDuration, 0, ex);
}

media_status_t AMediaExtractor_getSampleFormat(AMediaExtractor *ex, AMediaFormat *fmt) {
    CALL(AMediaExtractor_getSampleFormat, 0, ex, fmt);
}

AMediaFormat *AMediaFormat_new() {
    CALL(AMediaFormat_new, NULL);
}

media_status_t AMediaFormat_delete(AMediaFormat* mData) {
    CALL(AMediaFormat_delete, 0, mData);
}

const char* AMediaFormat_toString(AMediaFormat* mData) {
    CALL(AMediaFormat_toString, NULL, mData);
}

bool AMediaFormat_getInt32(AMediaFormat* mData, const char *name, int32_t *out) {
    CALL(AMediaFormat_getInt32, false, mData, name, out);
}

bool AMediaFormat_getInt64(AMediaFormat* mData, const char *name, int64_t *out) {
    CALL(AMediaFormat_getInt64, false, mData, name, out);
}

bool AMediaFormat_getFloat(AMediaFormat* mData, const char *name, float *out) {
    CALL(AMediaFormat_getFloat, false, mData, name, out);
}

bool AMediaFormat_getSize(AMediaFormat* mData, const char *name, size_t *out) {
    CALL(AMediaFormat_getSize, false, mData, name, out);
}

bool AMediaFormat_getBuffer(AMediaFormat* mData, const char *name, void** data, size_t *size) {
    CALL(AMediaFormat_getBuffer, false, mData, name, data, size);
}

bool AMediaFormat_getString(AMediaFormat* mData, const char *name, const char **out) {
    CALL(AMediaFormat_getString, false, mData, name, out);
}

void AMediaFormat_setInt32(AMediaFormat* mData, const char* name, int32_t value) {
    CALL(AMediaFormat_setInt32,, mData, name, value);
}

void AMediaFormat_setInt64(AMediaFormat* mData, const char* name, int64_t value) {
    CALL(AMediaFormat_setInt64,, mData, name, value);
}

void AMediaFormat_setFloat(AMediaFormat* mData, const char* name, float value) {
    CALL(AMediaFormat_setFloat,, mData, name, value);
}

void AMediaFormat_setString(AMediaFormat* mData, const char* name, const char* value) {
    CALL(AMediaFormat_setString,, mData, name, value);
}

void AMediaFormat_setBuffer(AMediaFormat* mData, const char* name, const void* data, size_t size) {
    CALL(AMediaFormat_setBuffer,, mData, name, data, size);
}

bool AMediaFormat_getDouble(AMediaFormat* mData, const char *name, double *out) {
    CALL(AMediaFormat_getDouble, false, mData, name, out);
}

bool AMediaFormat_getRect(AMediaFormat* mData, const char *name, int32_t *left, int32_t *top, int32_t *right, int32_t *bottom) {
    CALL(AMediaFormat_getRect, false, mData, name, left, top, right, bottom);
}

void AMediaFormat_setDouble(AMediaFormat* mData, const char* name, double value) {
    CALL(AMediaFormat_setDouble,, mData, name, value);
}

void AMediaFormat_setSize(AMediaFormat* mData, const char* name, size_t value) {
    CALL(AMediaFormat_setSize,, mData, name, value);
}

void AMediaFormat_setRect(AMediaFormat* mData, const char* name, int32_t left, int32_t top, int32_t right, int32_t bottom) {
    CALL(AMediaFormat_setRect,, mData, name, left, top, right, bottom);
}

AMediaMuxer* AMediaMuxer_new(int fd, OutputFormat format) {
    CALL(AMediaMuxer_new, NULL, fd, format);
}

media_status_t AMediaMuxer_delete(AMediaMuxer* muxer) {
    CALL(AMediaMuxer_delete, 0, muxer);
}

media_status_t AMediaMuxer_setLocation(AMediaMuxer* muxer, float latitude, float longitude) {
    CALL(AMediaMuxer_setLocation, 0, muxer, latitude, longitude);
}

media_status_t AMediaMuxer_setOrientationHint(AMediaMuxer* muxer, int degrees) {
    CALL(AMediaMuxer_setOrientationHint, 0, muxer, degrees);
}

ssize_t AMediaMuxer_addTrack(AMediaMuxer* muxer, const AMediaFormat* format) {
    CALL(AMediaMuxer_addTrack, 0, muxer, format);
}

media_status_t AMediaMuxer_start(AMediaMuxer* muxer) {
    CALL(AMediaMuxer_start, 0, muxer);
}

media_status_t AMediaMuxer_stop(AMediaMuxer* muxer) {
    CALL(AMediaMuxer_stop, 0, muxer);
}

media_status_t AMediaMuxer_writeSampleData(AMediaMuxer *muxer, size_t trackIdx, const uint8_t *data, const AMediaCodecBufferInfo *info) {
    CALL(AMediaMuxer_writeSampleData, 0, muxer, trackIdx, data, info);
}
