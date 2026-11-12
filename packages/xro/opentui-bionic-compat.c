/*
 * Small compatibility shim so the musl-linked OpenTUI native library
 * (from @opentui/core-linux-*-musl) can be loaded by the Android dynamic
 * linker. It provides the few libc symbols that musl exports but bionic
 * does not (or only exports on newer API levels).
 */
#include <dlfcn.h>
#include <errno.h>
#include <malloc.h>
#include <pthread.h>
#include <stddef.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

static void *libc_sym(const char *name) {
	static void *libc;
	if (libc == NULL)
		libc = dlopen("libc.so", RTLD_NOW | RTLD_NOLOAD);
	return libc != NULL ? dlsym(libc, name) : NULL;
}

int *__errno_location(void) {
	return __errno();
}

void *aligned_alloc(size_t alignment, size_t size) {
	return memalign(alignment, size);
}

int pthread_attr_setinheritsched(pthread_attr_t *attr, int inheritsched) {
	int (*real)(pthread_attr_t *, int) =
		(int (*)(pthread_attr_t *, int))libc_sym("pthread_attr_setinheritsched");
	return real != NULL ? real(attr, inheritsched) : 0;
}

ssize_t copy_file_range(int fd_in, off64_t *off_in, int fd_out,
		off64_t *off_out, size_t len, unsigned int flags) {
	return syscall(__NR_copy_file_range, fd_in, off_in, fd_out, off_out,
		len, flags);
}
