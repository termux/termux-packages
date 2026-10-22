#define _GNU_SOURCE
#include <dlfcn.h>
#include <stddef.h>

// Android < 8 (API < 26) libc does not export {set,get,end}{pw,gr}ent.
// Forward to the real libc symbols via dlsym(RTLD_NEXT) when available at
// runtime on Android >= 8, or return NULL / no-op on older Android versions.
// Returning void * is ABI-compatible with struct passwd * and struct group *
// (pointers are passed in the standard return register on all supported ABIs)
// while avoiding headers and type definitions not present on API 24.

void setpwent(void) {
	void (*real)(void) = (void (*)(void))dlsym(RTLD_NEXT, "setpwent");
	if (real) {
		real();
	}
}

void endpwent(void) {
	void (*real)(void) = (void (*)(void))dlsym(RTLD_NEXT, "endpwent");
	if (real) {
		real();
	}
}

void *getpwent(void) {
	void *(*real)(void) = (void *(*)(void))dlsym(RTLD_NEXT, "getpwent");
	return real ? real() : NULL;
}

void setgrent(void) {
	void (*real)(void) = (void (*)(void))dlsym(RTLD_NEXT, "setgrent");
	if (real) {
		real();
	}
}

void endgrent(void) {
	void (*real)(void) = (void (*)(void))dlsym(RTLD_NEXT, "endgrent");
	if (real) {
		real();
	}
}

void *getgrent(void) {
	void *(*real)(void) = (void *(*)(void))dlsym(RTLD_NEXT, "getgrent");
	return real ? real() : NULL;
}
