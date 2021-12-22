/* A stub for gc.h to avoid depending on libgc for
   the host-built mktable program. */
#define GC_INIT()
#define GC_MALLOC(arg) malloc(arg)
#define GC_malloc(arg) malloc(arg)
#define GC_MALLOC_ATOMIC(arg) malloc(arg)

#define GC_free(arg) free(arg)
