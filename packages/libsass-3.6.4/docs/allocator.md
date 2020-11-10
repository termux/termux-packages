## Custom memory allocator

LibSass comes with a custom memory allocator to improve performance.
First included in LibSass 3.6 and currently disabled by default.
Needs to be enabled by defining `SASS_CUSTOM_ALLOCATOR`.

### Overview

The allocator is a pool/arena allocator with a free-list on top. The
memory usage pattern of LibSass fits this implementation very well.
Every compilation tends to accumulate memory and only releasing some
items from time to time, but the overall memory consumption will mostly
grow until the compilation is finished. This helps us to keep the
implementation as simple as possible, since we don't need to release
much memory back to the system and can re-use it instead.

### Arenas

Each arena is allocated in a (compile time) fixed size. Every allocation
request is served from the current arena. We basically slice up the
arena into different sized chunks. Arenas are never returned to the
system until the whole compilation is finished.

### Slices

A memory slice is a part of an arena. Once the system requests a sized
memory chunk we check the current arena if there is enough space to
hold it. If not a new arena is allocated. Then we return a pointer
into that arena and mark the space as being used. Each slice also
has a header which is invisible to the requester as it lies before
the pointer address that we returned. This is used for book-keeping.

### Free-lists (or buckets)

Once a memory slice is returned to the allocator it will not be released.
It will instead be put on the free list. We keep a fixed number of free lists,
one for every possible chunk size. Since chunk sizes are memory aligned, we
can get the free-list index (aka `bucket`) very quickly (`size/alignment`).
For further readings see https://en.wikipedia.org/wiki/Free_list.

### Chunk-sizes

Since arenas are of fixed size we need to make sure that only small
enough chunks get served from it. This also helps to keep implementation
simple, as we can statically declare some structures for book-keeping.
Allocations that are too big to be tracked on a free-list will be patched
directly to malloc and free. This is the case when the bucket index would
be bigger than `SassAllocatorBuckets`.

### Thread-safety

This implementation is not thread-safe by design. Making it thread-safe
would certainly be possible, but it would come at a (performance) price.
Also it is not needed given the memory usage pattern of LibSass. Instead
we should make sure that memory pools are local to each thread.

### Implementation obstacles

Since memory allocation is a core part of C++ itself, we get into various
difficult territories. This has specially proven true in regard of static
variable initialization and destruction order. E.g when we have a static
string with custom allocator. It might be that it is initialized before
the thread local memory pool. On the other hand it's also possible that
the memory pool is destroyed before another static string wants to give
back its memory to the pool. I tried hard to work around those issues.
Mainly by only using thead local POD (plain old data) objects.

See https://isocpp.org/wiki/faq/ctors#static-init-order

### Performance gains

My tests indicate that the custom allocator brings around 15% performance
enhancement for complex cases (I used the bolt-bench to measure it). Once
more get optimized, the custom allocator can bring up to 30% improvement.
This comes at a small cost of a few percent of overall memory usage. This
can be tweaked, but the sweet spot for now seems to be:

```c
// How many buckets should we have for the free-list
// Determines when allocations go directly to malloc/free
// For maximum size of managed items multiply by alignment
#define SassAllocatorBuckets 512

// The size of the memory pool arenas in bytes.
#define SassAllocatorArenaSize (1024 * 256)
```

These can be found in `settings.hpp`.

### Memory overhead

Both settings `SassAllocatorBuckets` and `SassAllocatorArenaSize` need
to be set in relation to each other. Assuming the memory alignment on
the platform is 8 bytes, the maximum chunk size that can be handled
is 4KB (512*8B). If the arena size is too close to this value, you
may leave a lot of RAM unused. Once an arena can't fullfil the current
request, it is put away and a new one is allocated. We don't keep track
of unused space in previous arenas, as it bloats the code and costs
precious cpu time. By setting the values carefully we can avoid the cost
and still provide reasonable memory overhead. In the worst scenario we
loose around 1.5% for the default settings (4K of 256K).

### Further improvements

It is worth to check if we can re-use the space of old arenas somehow without
scarifying to much performance. Additionally we could check free-lists of
bigger chunks sizes to satisfy an allocation request. But both would need
to be checked for performance impact and their actual gain.