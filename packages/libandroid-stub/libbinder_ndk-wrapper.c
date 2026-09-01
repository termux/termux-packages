#define __ANDROID_UNAVAILABLE_SYMBOLS_ARE_WEAK__

#include "platform-ns.h"

#include <dlfcn.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#include <android/binder_ibinder.h>
#include <android/binder_parcel.h>
#include <android/binder_status.h>

#ifdef __LP64__
#define LIB "/system/lib64/libbinder_ndk.so"
#else
#define LIB "/system/lib/libbinder_ndk.so"
#endif

// Process management functions (from <android/binder_process.h>)
void ABinderProcess_startThreadPool(void);
bool ABinderProcess_setThreadPoolMaxThreadCount(uint32_t numThreads);
bool ABinderProcess_isThreadPoolStarted(void);
void ABinderProcess_joinThreadPool(void);
void ABinderProcess_setupPolling(int* fd);
binder_status_t ABinderProcess_handlePolledCommands(void);

#define FUNCTIONS(f)     f(ABinderProcess_startThreadPool)     f(ABinderProcess_setThreadPoolMaxThreadCount)     f(ABinderProcess_isThreadPoolStarted)     f(ABinderProcess_joinThreadPool)     f(ABinderProcess_setupPolling)     f(ABinderProcess_handlePolledCommands)     f(AIBinder_Class_define)     f(AIBinder_Class_setOnDump)     f(AIBinder_Class_disableInterfaceTokenHeader)     f(AIBinder_new)     f(AIBinder_isRemote)     f(AIBinder_isAlive)     f(AIBinder_ping)     f(AIBinder_dump)     f(AIBinder_linkToDeath)     f(AIBinder_unlinkToDeath)     f(AIBinder_getCallingUid)     f(AIBinder_getCallingPid)     f(AIBinder_incStrong)     f(AIBinder_decStrong)     f(AIBinder_debugGetRefCount)     f(AIBinder_getUserData)     f(AIBinder_prepareTransaction)     f(AIBinder_transact)     f(AIBinder_Weak_new)     f(AIBinder_Weak_delete)     f(AIBinder_Weak_promote)     f(AIBinder_DeathRecipient_new)     f(AIBinder_DeathRecipient_delete)     f(AIBinder_Class_getDescriptor)     f(AStatus_newOk)     f(AStatus_fromExceptionCode)     f(AStatus_fromExceptionCodeWithMessage)     f(AStatus_fromServiceSpecificError)     f(AStatus_fromServiceSpecificErrorWithMessage)     f(AStatus_fromStatus)     f(AStatus_isOk)     f(AStatus_getExceptionCode)     f(AStatus_getServiceSpecificError)     f(AStatus_getStatus)     f(AStatus_getMessage)     f(AStatus_getDescription)     f(AStatus_deleteDescription)     f(AStatus_delete)     f(AParcel_delete)     f(AParcel_setDataPosition)     f(AParcel_getDataPosition)     f(AParcel_writeParcelFileDescriptor)     f(AParcel_readParcelFileDescriptor)     f(AParcel_writeStatusHeader)     f(AParcel_readStatusHeader)     f(AParcel_writeString)     f(AParcel_readString)     f(AParcel_writeStringArray)     f(AParcel_readStringArray)     f(AParcel_writeParcelableArray)     f(AParcel_readParcelableArray)     f(AParcel_writeInt32)     f(AParcel_writeUint32)     f(AParcel_writeInt64)     f(AParcel_writeUint64)     f(AParcel_writeFloat)     f(AParcel_writeDouble)     f(AParcel_writeBool)     f(AParcel_writeChar)     f(AParcel_writeByte)     f(AParcel_readInt32)     f(AParcel_readUint32)     f(AParcel_readInt64)     f(AParcel_readUint64)     f(AParcel_readFloat)     f(AParcel_readDouble)     f(AParcel_readBool)     f(AParcel_readChar)     f(AParcel_readByte)     f(AParcel_writeInt32Array)     f(AParcel_writeUint32Array)     f(AParcel_writeInt64Array)     f(AParcel_writeUint64Array)     f(AParcel_writeFloatArray)     f(AParcel_writeDoubleArray)     f(AParcel_writeBoolArray)     f(AParcel_writeCharArray)     f(AParcel_writeByteArray)     f(AParcel_readInt32Array)     f(AParcel_readUint32Array)     f(AParcel_readInt64Array)     f(AParcel_readUint64Array)     f(AParcel_readFloatArray)     f(AParcel_readDoubleArray)     f(AParcel_readBoolArray)     f(AParcel_readCharArray)     f(AParcel_readByteArray)

#define STUB(s) __typeof__(s)* s;
static struct {
    FUNCTIONS(STUB)
} stubs;
#undef STUB

static pthread_once_t loaded_once = PTHREAD_ONCE_INIT;
static uint32_t cached_env_threads = 0;

static void load_stubs(void) {
    // Cache environment variables once during initialization
    const char *env = getenv("ANDROID_BINDER_THREAD_POOL_SIZE");
    if (!env) env = getenv("FFMPEG_ANDROID_BINDER_THREAD_POOL_SIZE");
    if (env) {
        int val = atoi(env);
        if (val > 0) cached_env_threads = (uint32_t)val;
    }

    void* handle = platform_dlopen(LIB, RTLD_LOCAL);
    if (!handle)
        handle = platform_dlopen("libbinder_ndk.so", RTLD_LOCAL);
    if (!handle)
        return;

#define LOAD(s) stubs.s = dlsym(handle, #s);
    FUNCTIONS(LOAD)
#undef LOAD
}

static inline void ensure_loaded(void) {
    pthread_once(&loaded_once, load_stubs);
}

#define CALL(f, def, ...) ensure_loaded(); if (!stubs.f) return def; else return (stubs.f)(__VA_ARGS__)
#define CALL_VOID(f, ...) ensure_loaded(); if (!stubs.f) return; else (stubs.f)(__VA_ARGS__)

void ABinderProcess_startThreadPool(void) {
    CALL_VOID(ABinderProcess_startThreadPool);
}

bool ABinderProcess_setThreadPoolMaxThreadCount(uint32_t numThreads) {
    ensure_loaded();
    if (cached_env_threads > 0) {
        numThreads = cached_env_threads;
    } else if (numThreads < 4) {
        numThreads = 4;
    }
    CALL(ABinderProcess_setThreadPoolMaxThreadCount, false, numThreads);
}

bool ABinderProcess_isThreadPoolStarted(void) {
    CALL(ABinderProcess_isThreadPoolStarted, false);
}

void ABinderProcess_joinThreadPool(void) {
    CALL_VOID(ABinderProcess_joinThreadPool);
}

void ABinderProcess_setupPolling(int* fd) {
    CALL_VOID(ABinderProcess_setupPolling, fd);
}

binder_status_t ABinderProcess_handlePolledCommands(void) {
    CALL(ABinderProcess_handlePolledCommands, STATUS_UNKNOWN_ERROR);
}

AIBinder_Class* AIBinder_Class_define(const char* interfaceDescriptor, AIBinder_Class_onCreate onCreate, AIBinder_Class_onDestroy onDestroy, AIBinder_Class_onTransact onTransact) {
    CALL(AIBinder_Class_define, NULL, interfaceDescriptor, onCreate, onDestroy, onTransact);
}

void AIBinder_Class_setOnDump(AIBinder_Class* clazz, AIBinder_onDump onDump) {
    CALL_VOID(AIBinder_Class_setOnDump, clazz, onDump);
}

void AIBinder_Class_disableInterfaceTokenHeader(AIBinder_Class* clazz) {
    CALL_VOID(AIBinder_Class_disableInterfaceTokenHeader, clazz);
}

AIBinder* AIBinder_new(const AIBinder_Class* clazz, void* args) {
    CALL(AIBinder_new, NULL, clazz, args);
}

bool AIBinder_isRemote(const AIBinder* binder) {
    CALL(AIBinder_isRemote, false, binder);
}

bool AIBinder_isAlive(const AIBinder* binder) {
    CALL(AIBinder_isAlive, false, binder);
}

binder_status_t AIBinder_ping(AIBinder* binder) {
    CALL(AIBinder_ping, STATUS_UNKNOWN_ERROR, binder);
}

binder_status_t AIBinder_dump(AIBinder* binder, int fd, const char** args, uint32_t numArgs) {
    CALL(AIBinder_dump, STATUS_UNKNOWN_ERROR, binder, fd, args, numArgs);
}

binder_status_t AIBinder_linkToDeath(AIBinder* binder, AIBinder_DeathRecipient* recipient, void* cookie) {
    CALL(AIBinder_linkToDeath, STATUS_UNKNOWN_ERROR, binder, recipient, cookie);
}

binder_status_t AIBinder_unlinkToDeath(AIBinder* binder, AIBinder_DeathRecipient* recipient, void* cookie) {
    CALL(AIBinder_unlinkToDeath, STATUS_UNKNOWN_ERROR, binder, recipient, cookie);
}

uid_t AIBinder_getCallingUid(void) {
    CALL(AIBinder_getCallingUid, (uid_t)-1);
}

pid_t AIBinder_getCallingPid(void) {
    CALL(AIBinder_getCallingPid, (pid_t)-1);
}

void AIBinder_incStrong(AIBinder* binder) {
    CALL_VOID(AIBinder_incStrong, binder);
}

void AIBinder_decStrong(AIBinder* binder) {
    CALL_VOID(AIBinder_decStrong, binder);
}

int32_t AIBinder_debugGetRefCount(AIBinder* binder) {
    CALL(AIBinder_debugGetRefCount, 0, binder);
}

void* AIBinder_getUserData(AIBinder* binder) {
    CALL(AIBinder_getUserData, NULL, binder);
}

binder_status_t AIBinder_prepareTransaction(AIBinder* binder, AParcel** in) {
    CALL(AIBinder_prepareTransaction, STATUS_UNKNOWN_ERROR, binder, in);
}

binder_status_t AIBinder_transact(AIBinder* binder, transaction_code_t code, AParcel** in, AParcel** out, binder_flags_t flags) {
    CALL(AIBinder_transact, STATUS_UNKNOWN_ERROR, binder, code, in, out, flags);
}

AIBinder_Weak* AIBinder_Weak_new(AIBinder* binder) {
    CALL(AIBinder_Weak_new, NULL, binder);
}

void AIBinder_Weak_delete(AIBinder_Weak* weakBinder) {
    CALL_VOID(AIBinder_Weak_delete, weakBinder);
}

AIBinder* AIBinder_Weak_promote(AIBinder_Weak* weakBinder) {
    CALL(AIBinder_Weak_promote, NULL, weakBinder);
}

AIBinder_DeathRecipient* AIBinder_DeathRecipient_new(AIBinder_DeathRecipient_onBinderDied onBinderDied) {
    CALL(AIBinder_DeathRecipient_new, NULL, onBinderDied);
}

void AIBinder_DeathRecipient_delete(AIBinder_DeathRecipient* recipient) {
    CALL_VOID(AIBinder_DeathRecipient_delete, recipient);
}

const char* AIBinder_Class_getDescriptor(const AIBinder_Class* clazz) {
    CALL(AIBinder_Class_getDescriptor, NULL, clazz);
}

AStatus* AStatus_newOk(void) {
    CALL(AStatus_newOk, NULL);
}

AStatus* AStatus_fromExceptionCode(binder_exception_t exception) {
    CALL(AStatus_fromExceptionCode, NULL, exception);
}

AStatus* AStatus_fromExceptionCodeWithMessage(binder_exception_t exception, const char* message) {
    CALL(AStatus_fromExceptionCodeWithMessage, NULL, exception, message);
}

AStatus* AStatus_fromServiceSpecificError(int32_t serviceSpecificError) {
    CALL(AStatus_fromServiceSpecificError, NULL, serviceSpecificError);
}

AStatus* AStatus_fromServiceSpecificErrorWithMessage(int32_t serviceSpecificError, const char* message) {
    CALL(AStatus_fromServiceSpecificErrorWithMessage, NULL, serviceSpecificError, message);
}

AStatus* AStatus_fromStatus(binder_status_t status) {
    CALL(AStatus_fromStatus, NULL, status);
}

bool AStatus_isOk(const AStatus* status) {
    CALL(AStatus_isOk, false, status);
}

binder_exception_t AStatus_getExceptionCode(const AStatus* status) {
    CALL(AStatus_getExceptionCode, EX_NONE, status);
}

int32_t AStatus_getServiceSpecificError(const AStatus* status) {
    CALL(AStatus_getServiceSpecificError, 0, status);
}

binder_status_t AStatus_getStatus(const AStatus* status) {
    CALL(AStatus_getStatus, STATUS_OK, status);
}

const char* AStatus_getMessage(const AStatus* status) {
    CALL(AStatus_getMessage, NULL, status);
}

const char* AStatus_getDescription(const AStatus* status) {
    CALL(AStatus_getDescription, NULL, status);
}

void AStatus_deleteDescription(const char* description) {
    CALL_VOID(AStatus_deleteDescription, description);
}

void AStatus_delete(AStatus* status) {
    CALL_VOID(AStatus_delete, status);
}

void AParcel_delete(AParcel* parcel) {
    CALL_VOID(AParcel_delete, parcel);
}

binder_status_t AParcel_setDataPosition(const AParcel* parcel, int32_t position) {
    CALL(AParcel_setDataPosition, STATUS_UNKNOWN_ERROR, parcel, position);
}

int32_t AParcel_getDataPosition(const AParcel* parcel) {
    CALL(AParcel_getDataPosition, 0, parcel);
}

binder_status_t AParcel_writeParcelFileDescriptor(AParcel* parcel, int fd) {
    CALL(AParcel_writeParcelFileDescriptor, STATUS_UNKNOWN_ERROR, parcel, fd);
}

binder_status_t AParcel_readParcelFileDescriptor(const AParcel* parcel, int* fd) {
    CALL(AParcel_readParcelFileDescriptor, STATUS_UNKNOWN_ERROR, parcel, fd);
}

binder_status_t AParcel_writeStatusHeader(AParcel* parcel, const AStatus* status) {
    CALL(AParcel_writeStatusHeader, STATUS_UNKNOWN_ERROR, parcel, status);
}

binder_status_t AParcel_readStatusHeader(const AParcel* parcel, AStatus** status) {
    CALL(AParcel_readStatusHeader, STATUS_UNKNOWN_ERROR, parcel, status);
}

binder_status_t AParcel_writeString(AParcel* parcel, const char* string, int32_t length) {
    CALL(AParcel_writeString, STATUS_UNKNOWN_ERROR, parcel, string, length);
}

binder_status_t AParcel_readString(const AParcel* parcel, void* stringData, AParcel_stringAllocator allocator) {
    CALL(AParcel_readString, STATUS_UNKNOWN_ERROR, parcel, stringData, allocator);
}

binder_status_t AParcel_writeStringArray(AParcel* parcel, const void* arrayData, int32_t length, AParcel_stringArrayElementGetter getter) {
    CALL(AParcel_writeStringArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, length, getter);
}

binder_status_t AParcel_readStringArray(const AParcel* parcel, void* arrayData, AParcel_stringArrayAllocator allocator, AParcel_stringArrayElementAllocator elementAllocator) {
    CALL(AParcel_readStringArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator, elementAllocator);
}

binder_status_t AParcel_writeParcelableArray(AParcel* parcel, const void* arrayData, int32_t length, AParcel_writeParcelableElement elementWriter) {
    CALL(AParcel_writeParcelableArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, length, elementWriter);
}

binder_status_t AParcel_readParcelableArray(const AParcel* parcel, void* arrayData, AParcel_parcelableArrayAllocator allocator, AParcel_readParcelableElement elementReader) {
    CALL(AParcel_readParcelableArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator, elementReader);
}

binder_status_t AParcel_writeInt32(AParcel* parcel, int32_t value) {
    CALL(AParcel_writeInt32, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeUint32(AParcel* parcel, uint32_t value) {
    CALL(AParcel_writeUint32, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeInt64(AParcel* parcel, int64_t value) {
    CALL(AParcel_writeInt64, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeUint64(AParcel* parcel, uint64_t value) {
    CALL(AParcel_writeUint64, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeFloat(AParcel* parcel, float value) {
    CALL(AParcel_writeFloat, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeDouble(AParcel* parcel, double value) {
    CALL(AParcel_writeDouble, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeBool(AParcel* parcel, bool value) {
    CALL(AParcel_writeBool, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeChar(AParcel* parcel, char16_t value) {
    CALL(AParcel_writeChar, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeByte(AParcel* parcel, int8_t value) {
    CALL(AParcel_writeByte, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readInt32(const AParcel* parcel, int32_t* value) {
    CALL(AParcel_readInt32, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readUint32(const AParcel* parcel, uint32_t* value) {
    CALL(AParcel_readUint32, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readInt64(const AParcel* parcel, int64_t* value) {
    CALL(AParcel_readInt64, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readUint64(const AParcel* parcel, uint64_t* value) {
    CALL(AParcel_readUint64, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readFloat(const AParcel* parcel, float* value) {
    CALL(AParcel_readFloat, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readDouble(const AParcel* parcel, double* value) {
    CALL(AParcel_readDouble, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readBool(const AParcel* parcel, bool* value) {
    CALL(AParcel_readBool, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readChar(const AParcel* parcel, char16_t* value) {
    CALL(AParcel_readChar, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_readByte(const AParcel* parcel, int8_t* value) {
    CALL(AParcel_readByte, STATUS_UNKNOWN_ERROR, parcel, value);
}

binder_status_t AParcel_writeInt32Array(AParcel* parcel, const int32_t* arrayData, int32_t length) {
    CALL(AParcel_writeInt32Array, STATUS_UNKNOWN_ERROR, parcel, arrayData, length);
}

binder_status_t AParcel_writeUint32Array(AParcel* parcel, const uint32_t* arrayData, int32_t length) {
    CALL(AParcel_writeUint32Array, STATUS_UNKNOWN_ERROR, parcel, arrayData, length);
}

binder_status_t AParcel_writeInt64Array(AParcel* parcel, const int64_t* arrayData, int32_t length) {
    CALL(AParcel_writeInt64Array, STATUS_UNKNOWN_ERROR, parcel, arrayData, length);
}

binder_status_t AParcel_writeUint64Array(AParcel* parcel, const uint64_t* arrayData, int32_t length) {
    CALL(AParcel_writeUint64Array, STATUS_UNKNOWN_ERROR, parcel, arrayData, length);
}

binder_status_t AParcel_writeFloatArray(AParcel* parcel, const float* arrayData, int32_t length) {
    CALL(AParcel_writeFloatArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, length);
}

binder_status_t AParcel_writeDoubleArray(AParcel* parcel, const double* arrayData, int32_t length) {
    CALL(AParcel_writeDoubleArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, length);
}

binder_status_t AParcel_writeBoolArray(AParcel* parcel, const void* arrayData, int32_t length, AParcel_boolArrayGetter getter) {
    CALL(AParcel_writeBoolArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, length, getter);
}

binder_status_t AParcel_writeCharArray(AParcel* parcel, const char16_t* arrayData, int32_t length) {
    CALL(AParcel_writeCharArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, length);
}

binder_status_t AParcel_writeByteArray(AParcel* parcel, const int8_t* arrayData, int32_t length) {
    CALL(AParcel_writeByteArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, length);
}

binder_status_t AParcel_readInt32Array(const AParcel* parcel, void* arrayData, AParcel_int32ArrayAllocator allocator) {
    CALL(AParcel_readInt32Array, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator);
}

binder_status_t AParcel_readUint32Array(const AParcel* parcel, void* arrayData, AParcel_uint32ArrayAllocator allocator) {
    CALL(AParcel_readUint32Array, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator);
}

binder_status_t AParcel_readInt64Array(const AParcel* parcel, void* arrayData, AParcel_int64ArrayAllocator allocator) {
    CALL(AParcel_readInt64Array, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator);
}

binder_status_t AParcel_readUint64Array(const AParcel* parcel, void* arrayData, AParcel_uint64ArrayAllocator allocator) {
    CALL(AParcel_readUint64Array, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator);
}

binder_status_t AParcel_readFloatArray(const AParcel* parcel, void* arrayData, AParcel_floatArrayAllocator allocator) {
    CALL(AParcel_readFloatArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator);
}

binder_status_t AParcel_readDoubleArray(const AParcel* parcel, void* arrayData, AParcel_doubleArrayAllocator allocator) {
    CALL(AParcel_readDoubleArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator);
}

binder_status_t AParcel_readBoolArray(const AParcel* parcel, void* arrayData, AParcel_boolArrayAllocator allocator, AParcel_boolArraySetter setter) {
    CALL(AParcel_readBoolArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator, setter);
}

binder_status_t AParcel_readCharArray(const AParcel* parcel, void* arrayData, AParcel_charArrayAllocator allocator) {
    CALL(AParcel_readCharArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator);
}

binder_status_t AParcel_readByteArray(const AParcel* parcel, void* arrayData, AParcel_byteArrayAllocator allocator) {
    CALL(AParcel_readByteArray, STATUS_UNKNOWN_ERROR, parcel, arrayData, allocator);
}
