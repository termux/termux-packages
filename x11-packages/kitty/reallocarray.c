#if defined __ANDROID__ && __ANDROID_API__ < 29
#include <stdlib.h>
#include <errno.h>

static void *
reallocarray(void *ptr, size_t nmemb, size_t size)
{
    size_t res;
    if (__builtin_mul_overflow(nmemb, size, &res)) {
        errno = ENOMEM;
        return NULL;
    }
    return realloc(ptr, nmemb * size);
}
#endif
