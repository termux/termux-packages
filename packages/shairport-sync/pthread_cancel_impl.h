#pragma once
#include <pthread.h>

#define PTHREAD_CANCEL_ENABLE 0 //default
#define PTHREAD_CANCEL_DISABLE 1
#define PTHREAD_CANCEL_DEFERRED 0 //default
#define PTHREAD_CANCEL_ASYNCHRONOUS 1
#define PTHREAD_CANCELED ((void *) -1)

#ifdef __cplusplus
extern "C" {
#endif

int pthread_cancel(pthread_t thread);
int pthread_setcancelstate(int state, int *oldstate);
int pthread_setcanceltype(int type, int *oldtype);
void pthread_testcancel(void);

#ifdef __cplusplus
}
#endif
