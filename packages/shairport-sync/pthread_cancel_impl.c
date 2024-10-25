#include <signal.h>
#include <stdint.h>
#include <errno.h>
#include "pthread_cancel_impl.h"

#define SIGCANCEL 33 // standard, but not exposed in musl and not defined in bionic.

static __thread uint8_t cancel = 0;
static __thread uint8_t state = PTHREAD_CANCEL_ENABLE;
static __thread uint8_t type = PTHREAD_CANCEL_DEFERRED;

static void handler(int sig, siginfo_t *si, void* ctx) {
	cancel = 1;
	if (state == PTHREAD_CANCEL_ENABLE && type == PTHREAD_CANCEL_ASYNCHRONOUS)
		pthread_exit(PTHREAD_CANCELED);
}

int pthread_cancel(pthread_t thread) {
	static int init = 0;
	if (!init) {
		struct sigaction sa = {
			.sa_flags = SA_SIGINFO | SA_RESTART | SA_ONSTACK,
			.sa_sigaction = handler
		};
		sigemptyset (&sa.sa_mask);
		sigaction(SIGCANCEL, &sa, 0);
		init = 1;
	}

	if (pthread_self() == thread)
		handler(SIGCANCEL, NULL, NULL);
	else
		pthread_kill(thread, SIGCANCEL);
	return 0;
}

int pthread_setcancelstate(int new, int *old) {
	if (new > 1)
		return EINVAL;
	if (old)
		*old = state;
	state = new;
	return 0;
}

int pthread_setcanceltype(int new, int *old) {
	if (new > 1)
		return EINVAL;
	if (old)
		*old = type;
	type = new;
	if (new)
		pthread_testcancel();
	return 0;
}

void pthread_testcancel(void) {
	if (cancel && state == PTHREAD_CANCEL_ENABLE)
		pthread_exit(PTHREAD_CANCELED);
}
