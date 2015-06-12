#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <android/log.h>

/* https://android.googlesource.com/platform/system/core/+/android-4.4.4_r2/include/log/log.h */

#define QUOTEME_(x) #x
#define QUOTEME(x) QUOTEME_(x)

#define ALOGV(...) printf("VERBOSE (" __FILE__ ":" QUOTEME(__LINE__) "): " __VA_ARGS__)
#define ALOGD(...) printf("DEBUG (" __FILE__ ":" QUOTEME(__LINE__) "): " __VA_ARGS__)
#define ALOGI(...) printf("INFO (" __FILE__ ":" QUOTEME(__LINE__) "): " __VA_ARGS__)
#define ALOGW(...) printf("WARNING (" __FILE__ ":" QUOTEME(__LINE__) "): " __VA_ARGS__)
#define ALOGE(...) printf("ERROR (" __FILE__ ":" QUOTEME(__LINE__) "): " __VA_ARGS__)

#define HAL_PRIORITY_URGENT_DISPLAY ANDROID_LOG_INFO

#define LOG_FATAL_IF(...)
#define LOG_ALWAYS_FATAL(...)
#define LOG_ALWAYS_FATAL_IF(...)
#define LOG_PRI(...)

#define ALOGW_IF(...)

#define android_printAssert(cond, tag, fmt...)
#define ALOG_ASSERT(...)

#define CONDITION(cond)     (__builtin_expect((cond)!=0, 0))

#define OS_PATH_SEPARATOR '/'
