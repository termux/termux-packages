#include <stdint.h>

#ifndef LOG_PRI
#define LOG_PRI(priority, tag, ...) \
  __android_log_print(priority, tag, __VA_ARGS__)
#endif

#ifndef LOG_EVENT_STRING
#define LOG_EVENT_STRING(_tag, _value) \
  (void)__android_log_buf_write(LOG_ID_EVENTS, ANDROID_LOG_DEFAULT, _tag, _value);
#endif

#define fgets_unlocked(buf, size, fp) fgets(buf, size, fp)

#define AID_USER_OFFSET 100000 /* offset for uid ranges for each user */
#define AID_APP_START 10000 /* first app user */
#define AID_SDK_SANDBOX_PROCESS_START 20000 /* start of uids allocated to sdk sandbox processes */
#define AID_ISOLATED_START 90000 /* start of uids for fully isolated sandboxed processes */
