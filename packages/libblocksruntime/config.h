#ifndef _CONFIG_H_
#define _CONFIG_H_

#ifdef __APPLE__

#define HAVE_AVAILABILITY_MACROS_H 1
#define HAVE_TARGET_CONDITIONALS_H 1
#define HAVE_OSATOMIC_COMPARE_AND_SWAP_INT 1
#define HAVE_OSATOMIC_COMPARE_AND_SWAP_LONG 1
#define HAVE_LIBKERN_OSATOMIC_H

/* Be sneaky and turn OSAtomicCompareAndSwapInt into OSAtomicCompareAndSwap32
 * and OSAtomicCompareAndSwapLong into either OSAtomicCompareAndSwap32
 * or OSAtomicCompareAndSwap64 (depending on __LP64__) so that the library
 * is Tiger compatible!
 */
#include <libkern/OSAtomic.h>
#undef OSAtomicCompareAndSwapInt
#undef OSAtomicCompareAndSwapLong
#define OSAtomicCompareAndSwapInt(o,n,v) OSAtomicCompareAndSwap32Compat(o,n,v)
#ifdef __LP64__
#define OSAtomicCompareAndSwapLong(o,n,v) OSAtomicCompareAndSwap64Compat(o,n,v)
#else
#define OSAtomicCompareAndSwapLong(o,n,v) OSAtomicCompareAndSwap32Compat(o,n,v)
#endif

static __inline bool OSAtomicCompareAndSwap32Compat(int32_t o, int32_t n, volatile int32_t *v)
{return OSAtomicCompareAndSwap32(o,n,(int32_t *)v);}
#ifdef __LP64__
static __inline bool OSAtomicCompareAndSwap64Compat(int64_t o, int64_t n, volatile int64_t *v)
{return OSAtomicCompareAndSwap64(o,n,(int64_t *)v);}
#endif

#else /* !__APPLE__ */

#if defined(__WIN32__) || defined(_WIN32)

/* Poor runtime.c code causes warnings calling InterlockedCompareExchange */
#define _CRT_SECURE_NO_WARNINGS 1
#include <windows.h>
static __inline int InterlockedCompareExchangeCompat(volatile void *v, long n, long o)
{return (int)InterlockedCompareExchange((LONG *)v, (LONG)n, (LONG)o);}
#undef InterlockedCompareExchange
#define InterlockedCompareExchange(v,n,o) InterlockedCompareExchangeCompat(v,n,o)

#elif defined(__GNUC__) /* && !defined(__WIN32__) && !defined(_WIN32) */

#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 1) /* GCC >= 4.1 */

/* runtime.c ignores these if __WIN32__ or _WIN32 is defined */
#define HAVE_SYNC_BOOL_COMPARE_AND_SWAP_INT 1
#define HAVE_SYNC_BOOL_COMPARE_AND_SWAP_LONG 1

#else /* GCC earlier than version 4.1 */

#error GCC version 4.1 (or compatible) or later is required on non-apple, non-w32 targets

#endif /* GCC earlier than version 4.1 */

#endif /* !defined(__GNUC__) && !defined(__WIN32__) && !defined(_WIN32) */

#endif /* !__APPLE__ */

#endif /* _CONFIG_H_ */
