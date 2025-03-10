#include <dlfcn.h>
#include <stdio.h>

// const attribute will not let us modify our variables
#define const

#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>

#ifdef __LP64__
#define LIB "/system/lib64/libOpenSLES.so"
#else
#define LIB "/system/lib/libOpenSLES.so"
#endif

#define IIDS(s) \
    s(SL_IID_3DCOMMIT) \
    s(SL_IID_3DDOPPLER) \
    s(SL_IID_3DGROUPING) \
    s(SL_IID_3DLOCATION) \
    s(SL_IID_3DMACROSCOPIC) \
    s(SL_IID_3DSOURCE) \
    s(SL_IID_ANDROIDACOUSTICECHOCANCELLATION) \
    s(SL_IID_ANDROIDAUTOMATICGAINCONTROL) \
    s(SL_IID_ANDROIDBUFFERQUEUESOURCE) \
    s(SL_IID_ANDROIDCONFIGURATION) \
    s(SL_IID_ANDROIDEFFECT) \
    s(SL_IID_ANDROIDEFFECTCAPABILITIES) \
    s(SL_IID_ANDROIDEFFECTSEND) \
    s(SL_IID_ANDROIDNOISESUPPRESSION) \
    s(SL_IID_ANDROIDSIMPLEBUFFERQUEUE) \
    s(SL_IID_AUDIODECODERCAPABILITIES) \
    s(SL_IID_AUDIOENCODER) \
    s(SL_IID_AUDIOENCODERCAPABILITIES) \
    s(SL_IID_AUDIOIODEVICECAPABILITIES) \
    s(SL_IID_BASSBOOST) \
    s(SL_IID_BUFFERQUEUE) \
    s(SL_IID_DEVICEVOLUME) \
    s(SL_IID_DYNAMICINTERFACEMANAGEMENT) \
    s(SL_IID_DYNAMICSOURCE) \
    s(SL_IID_EFFECTSEND) \
    s(SL_IID_ENGINE) \
    s(SL_IID_ENGINECAPABILITIES) \
    s(SL_IID_ENVIRONMENTALREVERB) \
    s(SL_IID_EQUALIZER) \
    s(SL_IID_LED) \
    s(SL_IID_METADATAEXTRACTION) \
    s(SL_IID_METADATATRAVERSAL) \
    s(SL_IID_MIDIMESSAGE) \
    s(SL_IID_MIDIMUTESOLO) \
    s(SL_IID_MIDITEMPO) \
    s(SL_IID_MIDITIME) \
    s(SL_IID_MUTESOLO) \
    s(SL_IID_NULL) \
    s(SL_IID_OBJECT) \
    s(SL_IID_OUTPUTMIX) \
    s(SL_IID_PITCH) \
    s(SL_IID_PLAY) \
    s(SL_IID_PLAYBACKRATE) \
    s(SL_IID_PREFETCHSTATUS) \
    s(SL_IID_PRESETREVERB) \
    s(SL_IID_RATEPITCH) \
    s(SL_IID_RECORD) \
    s(SL_IID_SEEK) \
    s(SL_IID_THREADSYNC) \
    s(SL_IID_VIBRA) \
    s(SL_IID_VIRTUALIZER) \
    s(SL_IID_VISUALIZATION) \
    s(SL_IID_VOLUME)

#define IID(s) __typeof__(s) s;
IIDS(IID)
#undef IID

#define FUNCTIONS(f) \
    f(slCreateEngine) \
    f(slQueryNumSupportedEngineInterfaces) \
    f(slQuerySupportedEngineInterfaces)

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
    #define IID(s) s = *((SLInterfaceID*) dlsym(handle, #s));
    IIDS(IID)
    #undef IID
    #define LOAD(s) stubs.s = dlsym(handle, #s);
    FUNCTIONS(LOAD)
    #undef LOAD
}

#define CALL(f, def, ...) if (!stubs.f) return def; else return (stubs.f)(__VA_ARGS__)

SL_API SLresult SLAPIENTRY slCreateEngine(SLObjectItf *pEngine, SLuint32 numOptions, const SLEngineOption *pEngineOptions, SLuint32 numInterfaces, const SLInterfaceID *pInterfaceIds, const SLboolean* pInterfaceRequired) {
    CALL(slCreateEngine, SL_RESULT_FEATURE_UNSUPPORTED, pEngine, numOptions, pEngineOptions, numInterfaces, pInterfaceIds, pInterfaceRequired);
}

SL_API SLresult SLAPIENTRY slQueryNumSupportedEngineInterfaces(SLuint32* pNumSupportedInterfaces) {
    CALL(slQueryNumSupportedEngineInterfaces, SL_RESULT_FEATURE_UNSUPPORTED, pNumSupportedInterfaces);
}

SL_API SLresult SLAPIENTRY slQuerySupportedEngineInterfaces(SLuint32 index, SLInterfaceID* pInterfaceId) {
    CALL(slQuerySupportedEngineInterfaces, SL_RESULT_FEATURE_UNSUPPORTED, index, pInterfaceId);
}
