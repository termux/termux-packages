/* obstack.h - object stack macros
   Copyright (C) 1988-1994,1996-1999,2003,2004,2005,2009,2011,2012
        Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

/* Summary:

All the apparent functions defined here are macros. The idea
is that you would use these pre-tested macros to solve a
very specific set of problems, and they would run fast.
Caution: no side-effects in arguments please!! They may be
evaluated MANY times!!

These macros operate a stack of objects.  Each object starts life
small, and may grow to maturity.  (Consider building a word syllable
by syllable.)  An object can move while it is growing.  Once it has
been "finished" it never changes address again.  So the "top of the
stack" is typically an immature growing object, while the rest of the
stack is of mature, fixed size and fixed address objects.

These routines grab large chunks of memory, using a function you
supply, called `obstack_chunk_alloc'.  On occasion, they free chunks,
by calling `obstack_chunk_free'.  You must define them and declare
them before using any obstack macros.

Each independent stack is represented by a `struct obstack'.
Each of the obstack macros expects a pointer to such a structure
as the first argument.

One motivation for this package is the problem of growing char strings
in symbol tables.  Unless you are "fascist pig with a read-only mind"
--Gosper's immortal quote from HAKMEM item 154, out of context--you
would not like to put any arbitrary upper limit on the length of your
symbols.

In practice this often means you will build many short symbols and a
few long symbols.  At the time you are reading a symbol you don't know
how long it is.  One traditional method is to read a symbol into a
buffer, realloc()ating the buffer every time you try to read a symbol
that is longer than the buffer.  This is beaut, but you still will
want to copy the symbol from the buffer to a more permanent
symbol-table entry say about half the time.

With obstacks, you can work differently.  Use one obstack for all symbol
names.  As you read a symbol, grow the name in the obstack gradually.
When the name is complete, finalize it.  Then, if the symbol exists already,
free the newly read name.

The way we do this is to take a large chunk, allocating memory from
low addresses.  When you want to build a symbol in the chunk you just
add chars above the current "high water mark" in the chunk.  When you
have finished adding chars, because you got to the end of the symbol,
you know how long the chars are, and you can create a new object.
Mostly the chars will not burst over the highest address of the chunk,
because you would typically expect a chunk to be (say) 100 times as
long as an average object.

In case that isn't clear, when we have enough chars to make up
the object, THEY ARE ALREADY CONTIGUOUS IN THE CHUNK (guaranteed)
so we just point to it where it lies.  No moving of chars is
needed and this is the second win: potentially long strings need
never be explicitly shuffled. Once an object is formed, it does not
change its address during its lifetime.

When the chars burst over a chunk boundary, we allocate a larger
chunk, and then copy the partly formed object from the end of the old
chunk to the beginning of the new larger chunk.  We then carry on
accreting characters to the end of the object as we normally would.

A special macro is provided to add a single char at a time to a
growing object.  This allows the use of register variables, which
break the ordinary 'growth' macro.

Summary:
        We allocate large chunks.
        We carve out one object at a time from the current chunk.
        Once carved, an object never moves.
        We are free to append data of any size to the currently
          growing object.
        Exactly one object is growing in an obstack at any one time.
        You can run one obstack per control block.
        You may have as many control blocks as you dare.
        Because of the way we do it, you can `unwind' an obstack
          back to a previous state. (You may remove objects much
          as you would with a stack.)
*/

/* Don't do the contents of this file more than once.  */

#ifndef _OBSTACK_H
#define _OBSTACK_H 1

#ifdef __cplusplus
extern "C" {
#endif

/* We need the type of a pointer subtraction.  If __PTRDIFF_TYPE__ is
   defined, as with GNU C, use that; that way we don't pollute the
   namespace with <stddef.h>'s symbols.  Otherwise, include <stddef.h>
   and use ptrdiff_t.  */

#ifdef __PTRDIFF_TYPE__
#define PTR_INT_TYPE __PTRDIFF_TYPE__
#else
#include <stddef.h>
#define PTR_INT_TYPE ptrdiff_t
#endif

#include <stdlib.h>

/* If B is the base of an object addressed by P, return the result of
   aligning P to the next multiple of A + 1.  B and P must be of type
   char *.  A + 1 must be a power of 2.  */

#define __BPTR_ALIGN(B, P, A) ((B) + (((P) - (B) + (A)) & ~(A)))

/* Similiar to _BPTR_ALIGN (B, P, A), except optimize the common case
   where pointers can be converted to integers, aligned as integers,
   and converted back again.  If PTR_INT_TYPE is narrower than a
   pointer (e.g., the AS/400), play it safe and compute the alignment
   relative to B.  Otherwise, use the faster strategy of computing the
   alignment relative to 0.  */

#define __PTR_ALIGN(B, P, A)                                                   \
  __BPTR_ALIGN(sizeof(PTR_INT_TYPE) < sizeof(void *) ? (B) : (char *)0, P, A)

#include <string.h>

struct _obstack_chunk /* Lives at front of each chunk. */
{
  char *limit;                 /* 1 past end of this chunk */
  struct _obstack_chunk *prev; /* address of prior chunk or NULL */
  char contents[4];            /* objects begin here */
};

struct obstack /* control current object in current chunk */
{
  long chunk_size;              /* preferred size to allocate chunks in */
  struct _obstack_chunk *chunk; /* address of current struct obstack_chunk */
  char *object_base;            /* address of object we are building */
  char *next_free;              /* where to add next char to current object */
  char *chunk_limit;            /* address of char after current chunk */
  union {
    PTR_INT_TYPE tempint;
    void *tempptr;
  } temp;             /* Temporary for some macros.  */
  int alignment_mask; /* Mask of alignment for each object. */
  /* These prototypes vary based on `use_extra_arg', and we use
     casts to the prototypeless function type in all assignments,
     but having prototypes here quiets -Wstrict-prototypes.  */
  struct _obstack_chunk *(*chunkfun)(void *, long);
  void (*freefun)(void *, struct _obstack_chunk *);
  void *extra_arg;            /* first arg for chunk alloc/dealloc funcs */
  unsigned use_extra_arg : 1; /* chunk alloc/dealloc funcs take extra arg */
  unsigned maybe_empty_object : 1; /* There is a possibility that the current
                                      chunk contains a zero-length object.  This
                                      prevents freeing the chunk if we allocate
                                      a bigger chunk to replace it. */
  unsigned alloc_failed : 1;       /* No longer used, as we now call the failed
                                      handler on error, but retained for binary
                                      compatibility.  */
};

static void _obstack_newchunk(struct obstack *h, int length);

/* Exit value used when `print_and_abort' is used.  */
extern int obstack_exit_failure;

/* Pointer to beginning of object being allocated or to be allocated next.
   Note that this might not be the final address of the object
   because a new chunk might be needed to hold the final size.  */

#define obstack_base(h) ((void *)(h)->object_base)

/* Size for allocating ordinary chunks.  */

#define obstack_chunk_size(h) ((h)->chunk_size)

/* Pointer to next byte not yet allocated in current chunk.  */

#define obstack_next_free(h) ((h)->next_free)

/* Mask specifying low bits that should be clear in address of an object.  */

#define obstack_alignment_mask(h) ((h)->alignment_mask)

/* To prevent prototype warnings provide complete argument list.  */
#define obstack_init(h)                                                        \
  _obstack_begin((h), 0, 0, (void *(*)(long))obstack_chunk_alloc,              \
                 (void (*)(void *))obstack_chunk_free)

#define obstack_begin(h, size)                                                 \
  _obstack_begin((h), (size), 0, (void *(*)(long))obstack_chunk_alloc,         \
                 (void (*)(void *))obstack_chunk_free)

#define obstack_specify_allocation(h, size, alignment, chunkfun, freefun)      \
  _obstack_begin((h), (size), (alignment), (void *(*)(long))(chunkfun),        \
                 (void (*)(void *))(freefun))

#define obstack_specify_allocation_with_arg(h, size, alignment, chunkfun,      \
                                            freefun, arg)                      \
  _obstack_begin_1((h), (size), (alignment),                                   \
                   (void *(*)(void *, long))(chunkfun),                        \
                   (void (*)(void *, void *))(freefun), (arg))

#define obstack_chunkfun(h, newchunkfun)                                       \
  ((h)->chunkfun = (struct _obstack_chunk * (*)(void *, long))(newchunkfun))

#define obstack_freefun(h, newfreefun)                                         \
  ((h)->freefun = (void (*)(void *, struct _obstack_chunk *))(newfreefun))

#define obstack_1grow_fast(h, achar) (*((h)->next_free)++ = (achar))

#define obstack_blank_fast(h, n) ((h)->next_free += (n))

#define obstack_memory_used(h) _obstack_memory_used(h)

#if defined __GNUC__
/* NextStep 2.0 cc is really gcc 1.93 but it defines __GNUC__ = 2 and
   does not implement __extension__.  But that compiler doesn't define
   __GNUC_MINOR__.  */
#if __GNUC__ < 2 || (__NeXT__ && !__GNUC_MINOR__)
#define __extension__
#endif

/* For GNU C, if not -traditional,
   we can define these macros to compute all args only once
   without using a global variable.
   Also, we can avoid using the `temp' slot, to make faster code.  */

#define obstack_object_size(OBSTACK)                                           \
  __extension__({                                                              \
    struct obstack const *__o = (OBSTACK);                                     \
    (unsigned)(__o->next_free - __o->object_base);                             \
  })

#define obstack_room(OBSTACK)                                                  \
  __extension__({                                                              \
    struct obstack const *__o = (OBSTACK);                                     \
    (unsigned)(__o->chunk_limit - __o->next_free);                             \
  })

#define obstack_make_room(OBSTACK, length)                                     \
  __extension__({                                                              \
    struct obstack *__o = (OBSTACK);                                           \
    int __len = (length);                                                      \
    if (__o->chunk_limit - __o->next_free < __len)                             \
      _obstack_newchunk(__o, __len);                                           \
    (void)0;                                                                   \
  })

#define obstack_empty_p(OBSTACK)                                               \
  __extension__({                                                              \
    struct obstack const *__o = (OBSTACK);                                     \
    (__o->chunk->prev == 0 &&                                                  \
     __o->next_free == __PTR_ALIGN((char *)__o->chunk, __o->chunk->contents,   \
                                   __o->alignment_mask));                      \
  })

#define obstack_grow(OBSTACK, where, length)                                   \
  __extension__({                                                              \
    struct obstack *__o = (OBSTACK);                                           \
    int __len = (length);                                                      \
    if (__o->next_free + __len > __o->chunk_limit)                             \
      _obstack_newchunk(__o, __len);                                           \
    memcpy(__o->next_free, where, __len);                                      \
    __o->next_free += __len;                                                   \
    (void)0;                                                                   \
  })

#define obstack_grow0(OBSTACK, where, length)                                  \
  __extension__({                                                              \
    struct obstack *__o = (OBSTACK);                                           \
    int __len = (length);                                                      \
    if (__o->next_free + __len + 1 > __o->chunk_limit)                         \
      _obstack_newchunk(__o, __len + 1);                                       \
    memcpy(__o->next_free, where, __len);                                      \
    __o->next_free += __len;                                                   \
    *(__o->next_free)++ = 0;                                                   \
    (void)0;                                                                   \
  })

#define obstack_1grow(OBSTACK, datum)                                          \
  __extension__({                                                              \
    struct obstack *__o = (OBSTACK);                                           \
    if (__o->next_free + 1 > __o->chunk_limit)                                 \
      _obstack_newchunk(__o, 1);                                               \
    obstack_1grow_fast(__o, datum);                                            \
    (void)0;                                                                   \
  })

/* These assume that the obstack alignment is good enough for pointers
   or ints, and that the data added so far to the current object
   shares that much alignment.  */

#define obstack_ptr_grow(OBSTACK, datum)                                       \
  __extension__({                                                              \
    struct obstack *__o = (OBSTACK);                                           \
    if (__o->next_free + sizeof(void *) > __o->chunk_limit)                    \
      _obstack_newchunk(__o, sizeof(void *));                                  \
    obstack_ptr_grow_fast(__o, datum);                                         \
  })

#define obstack_int_grow(OBSTACK, datum)                                       \
  __extension__({                                                              \
    struct obstack *__o = (OBSTACK);                                           \
    if (__o->next_free + sizeof(int) > __o->chunk_limit)                       \
      _obstack_newchunk(__o, sizeof(int));                                     \
    obstack_int_grow_fast(__o, datum);                                         \
  })

#define obstack_ptr_grow_fast(OBSTACK, aptr)                                   \
  __extension__({                                                              \
    struct obstack *__o1 = (OBSTACK);                                          \
    *(const void **)__o1->next_free = (aptr);                                  \
    __o1->next_free += sizeof(const void *);                                   \
    (void)0;                                                                   \
  })

#define obstack_int_grow_fast(OBSTACK, aint)                                   \
  __extension__({                                                              \
    struct obstack *__o1 = (OBSTACK);                                          \
    *(int *)__o1->next_free = (aint);                                          \
    __o1->next_free += sizeof(int);                                            \
    (void)0;                                                                   \
  })

#define obstack_blank(OBSTACK, length)                                         \
  __extension__({                                                              \
    struct obstack *__o = (OBSTACK);                                           \
    int __len = (length);                                                      \
    if (__o->chunk_limit - __o->next_free < __len)                             \
      _obstack_newchunk(__o, __len);                                           \
    obstack_blank_fast(__o, __len);                                            \
    (void)0;                                                                   \
  })

#define obstack_alloc(OBSTACK, length)                                         \
  __extension__({                                                              \
    struct obstack *__h = (OBSTACK);                                           \
    obstack_blank(__h, (length));                                              \
    obstack_finish(__h);                                                       \
  })

#define obstack_copy(OBSTACK, where, length)                                   \
  __extension__({                                                              \
    struct obstack *__h = (OBSTACK);                                           \
    obstack_grow(__h, (where), (length));                                      \
    obstack_finish(__h);                                                       \
  })

#define obstack_copy0(OBSTACK, where, length)                                  \
  __extension__({                                                              \
    struct obstack *__h = (OBSTACK);                                           \
    obstack_grow0(__h, (where), (length));                                     \
    obstack_finish(__h);                                                       \
  })

/* The local variable is named __o1 to avoid a name conflict
   when obstack_blank is called.  */
#define obstack_finish(OBSTACK)                                                \
  __extension__({                                                              \
    struct obstack *__o1 = (OBSTACK);                                          \
    void *__value = (void *)__o1->object_base;                                 \
    if (__o1->next_free == __value)                                            \
      __o1->maybe_empty_object = 1;                                            \
    __o1->next_free =                                                          \
        __PTR_ALIGN(__o1->object_base, __o1->next_free, __o1->alignment_mask); \
    if (__o1->next_free - (char *)__o1->chunk >                                \
        __o1->chunk_limit - (char *)__o1->chunk)                               \
      __o1->next_free = __o1->chunk_limit;                                     \
    __o1->object_base = __o1->next_free;                                       \
    __value;                                                                   \
  })

#define obstack_free(OBSTACK, OBJ)                                             \
  __extension__({                                                              \
    struct obstack *__o = (OBSTACK);                                           \
    void *__obj = (OBJ);                                                       \
    if (__obj > (void *)__o->chunk && __obj < (void *)__o->chunk_limit)        \
      __o->next_free = __o->object_base = (char *)__obj;                       \
    else                                                                       \
      (obstack_free_func)(__o, __obj);                                         \
  })

#else /* not __GNUC__ */

#define obstack_object_size(h) (unsigned)((h)->next_free - (h)->object_base)

#define obstack_room(h) (unsigned)((h)->chunk_limit - (h)->next_free)

#define obstack_empty_p(h)                                                     \
  ((h)->chunk->prev == 0 &&                                                    \
   (h)->next_free == __PTR_ALIGN((char *)(h)->chunk, (h)->chunk->contents,     \
                                 (h)->alignment_mask))

/* Note that the call to _obstack_newchunk is enclosed in (..., 0)
   so that we can avoid having void expressions
   in the arms of the conditional expression.
   Casting the third operand to void was tried before,
   but some compilers won't accept it.  */

#define obstack_make_room(h, length)                                           \
  ((h)->temp.tempint = (length),                                               \
   (((h)->next_free + (h)->temp.tempint > (h)->chunk_limit)                    \
        ? (_obstack_newchunk((h), (h)->temp.tempint), 0)                       \
        : 0))

#define obstack_grow(h, where, length)                                         \
  ((h)->temp.tempint = (length),                                               \
   (((h)->next_free + (h)->temp.tempint > (h)->chunk_limit)                    \
        ? (_obstack_newchunk((h), (h)->temp.tempint), 0)                       \
        : 0),                                                                  \
   memcpy((h)->next_free, where, (h)->temp.tempint),                           \
   (h)->next_free += (h)->temp.tempint)

#define obstack_grow0(h, where, length)                                        \
  ((h)->temp.tempint = (length),                                               \
   (((h)->next_free + (h)->temp.tempint + 1 > (h)->chunk_limit)                \
        ? (_obstack_newchunk((h), (h)->temp.tempint + 1), 0)                   \
        : 0),                                                                  \
   memcpy((h)->next_free, where, (h)->temp.tempint),                           \
   (h)->next_free += (h)->temp.tempint, *((h)->next_free)++ = 0)

#define obstack_1grow(h, datum)                                                \
  ((((h)->next_free + 1 > (h)->chunk_limit) ? (_obstack_newchunk((h), 1), 0)   \
                                            : 0),                              \
   obstack_1grow_fast(h, datum))

#define obstack_ptr_grow(h, datum)                                             \
  ((((h)->next_free + sizeof(char *) > (h)->chunk_limit)                       \
        ? (_obstack_newchunk((h), sizeof(char *)), 0)                          \
        : 0),                                                                  \
   obstack_ptr_grow_fast(h, datum))

#define obstack_int_grow(h, datum)                                             \
  ((((h)->next_free + sizeof(int) > (h)->chunk_limit)                          \
        ? (_obstack_newchunk((h), sizeof(int)), 0)                             \
        : 0),                                                                  \
   obstack_int_grow_fast(h, datum))

#define obstack_ptr_grow_fast(h, aptr)                                         \
  (((const void **)((h)->next_free += sizeof(void *)))[-1] = (aptr))

#define obstack_int_grow_fast(h, aint)                                         \
  (((int *)((h)->next_free += sizeof(int)))[-1] = (aint))

#define obstack_blank(h, length)                                               \
  ((h)->temp.tempint = (length),                                               \
   (((h)->chunk_limit - (h)->next_free < (h)->temp.tempint)                    \
        ? (_obstack_newchunk((h), (h)->temp.tempint), 0)                       \
        : 0),                                                                  \
   obstack_blank_fast(h, (h)->temp.tempint))

#define obstack_alloc(h, length)                                               \
  (obstack_blank((h), (length)), obstack_finish((h)))

#define obstack_copy(h, where, length)                                         \
  (obstack_grow((h), (where), (length)), obstack_finish((h)))

#define obstack_copy0(h, where, length)                                        \
  (obstack_grow0((h), (where), (length)), obstack_finish((h)))

#define obstack_finish(h)                                                      \
  (((h)->next_free == (h)->object_base ? (((h)->maybe_empty_object = 1), 0)    \
                                       : 0),                                   \
   (h)->temp.tempptr = (h)->object_base,                                       \
   (h)->next_free =                                                            \
       __PTR_ALIGN((h)->object_base, (h)->next_free, (h)->alignment_mask),     \
   (((h)->next_free - (char *)(h)->chunk >                                     \
     (h)->chunk_limit - (char *)(h)->chunk)                                    \
        ? ((h)->next_free = (h)->chunk_limit)                                  \
        : 0),                                                                  \
   (h)->object_base = (h)->next_free, (h)->temp.tempptr)

#define obstack_free(h, obj)                                                   \
  ((h)->temp.tempint = (char *)(obj) - (char *)(h)->chunk,                     \
   ((((h)->temp.tempint > 0 &&                                                 \
      (h)->temp.tempint < (h)->chunk_limit - (char *)(h)->chunk))              \
        ? (((h)->next_free = (h)->object_base =                                \
                (h)->temp.tempint + (char *)(h)->chunk),                       \
           0)                                                                  \
        : ((obstack_free_func)((h), (h)->temp.tempint + (char *)(h)->chunk),   \
           0)))

#endif /* not __GNUC__ */

/* START LOCAL ADDITION */
static inline int obstack_printf(struct obstack *obst, const char *fmt, ...) {
  char buf[1024];
  va_list ap;
  int len;

  va_start(ap, fmt);
  len = vsnprintf(buf, sizeof(buf), fmt, ap);
  obstack_grow(obst, buf, len);
  va_end(ap);

  return len;
}
/* Determine default alignment.  */
union fooround {
  uintmax_t i;
  long double d;
  void *p;
};
struct fooalign {
  char c;
  union fooround u;
};
/* If malloc were really smart, it would round addresses to DEFAULT_ALIGNMENT.
   But in fact it might be less smart and round addresses to as much as
   DEFAULT_ROUNDING.  So we prepare for it to do that.  */
enum {
  DEFAULT_ALIGNMENT = offsetof(struct fooalign, u),
  DEFAULT_ROUNDING = sizeof(union fooround)
};

/* When we copy a long block of data, this is the unit to do it with.
   On some machines, copying successive ints does not work;
   in such a case, redefine COPYING_UNIT to `long' (if that works)
   or `char' as a last resort.  */
#ifndef COPYING_UNIT
#define COPYING_UNIT int
#endif

/* The functions allocating more room by calling `obstack_chunk_alloc'
   jump to the handler pointed to by `obstack_alloc_failed_handler'.
   This can be set to a user defined function which should either
   abort gracefully or use longjump - but shouldn't return.  This
   variable by default points to the internal function
   `print_and_abort'.  */
static void print_and_abort(void);

#ifdef _LIBC
#if SHLIB_COMPAT(libc, GLIBC_2_0, GLIBC_2_3_4)
/* A looong time ago (before 1994, anyway; we're not sure) this global variable
   was used by non-GNU-C macros to avoid multiple evaluation.  The GNU C
   library still exports it because somebody might use it.  */
struct obstack *_obstack_compat;
compat_symbol(libc, _obstack_compat, _obstack, GLIBC_2_0);
#endif
#endif

/* Define a macro that either calls functions with the traditional malloc/free
   calling interface, or calls functions with the mmalloc/mfree interface
   (that adds an extra first argument), based on the state of use_extra_arg.
   For free, do not use ?:, since some compilers, like the MIPS compilers,
   do not allow (expr) ? void : void.  */

#define CALL_CHUNKFUN(h, size)                                                 \
  (((h)->use_extra_arg)                                                        \
       ? (*(h)->chunkfun)((h)->extra_arg, (size))                              \
       : (*(struct _obstack_chunk * (*)(long))(h)->chunkfun)((size)))

#define CALL_FREEFUN(h, old_chunk)                                             \
  do {                                                                         \
    if ((h)->use_extra_arg)                                                    \
      (*(h)->freefun)((h)->extra_arg, (old_chunk));                            \
    else                                                                       \
      (*(void (*)(void *))(h)->freefun)((old_chunk));                          \
  } while (0)

/* Initialize an obstack H for use.  Specify chunk size SIZE (0 means default).
   Objects start on multiples of ALIGNMENT (0 means use default).
   CHUNKFUN is the function to use to allocate chunks,
   and FREEFUN the function to free them.
   Return nonzero if successful, calls obstack_alloc_failed_handler if
   allocation fails.  */

static int _obstack_begin(struct obstack *h, int size, int alignment,
                          void *(*chunkfun)(long), void (*freefun)(void *)) {
  register struct _obstack_chunk *chunk; /* points to new chunk */

  if (alignment == 0)
    alignment = DEFAULT_ALIGNMENT;
  if (size == 0)
  /* Default size is what GNU malloc can fit in a 4096-byte block.  */
  {
    /* 12 is sizeof (mhead) and 4 is EXTRA from GNU malloc.
       Use the values for range checking, because if range checking is off,
       the extra bytes won't be missed terribly, but if range checking is on
       and we used a larger request, a whole extra 4096 bytes would be
       allocated.
       These number are irrelevant to the new GNU malloc.  I suspect it is
       less sensitive to the size of the request.  */
    int extra = ((((12 + DEFAULT_ROUNDING - 1) & ~(DEFAULT_ROUNDING - 1)) + 4 +
                  DEFAULT_ROUNDING - 1) &
                 ~(DEFAULT_ROUNDING - 1));
    size = 4096 - extra;
  }

  h->chunkfun = (struct _obstack_chunk * (*)(void *, long)) chunkfun;
  h->freefun = (void (*)(void *, struct _obstack_chunk *))freefun;
  h->chunk_size = size;
  h->alignment_mask = alignment - 1;
  h->use_extra_arg = 0;

  chunk = h->chunk = CALL_CHUNKFUN(h, h->chunk_size);
  if (!chunk)
    print_and_abort();
  h->next_free = h->object_base =
      __PTR_ALIGN((char *)chunk, chunk->contents, alignment - 1);
  h->chunk_limit = chunk->limit = (char *)chunk + h->chunk_size;
  chunk->prev = 0;
  /* The initial chunk now contains no empty object.  */
  h->maybe_empty_object = 0;
  h->alloc_failed = 0;
  return 1;
}

static int _obstack_begin_1(struct obstack *h, int size, int alignment,
                            void *(*chunkfun)(void *, long),
                            void (*freefun)(void *, void *), void *arg) {
  register struct _obstack_chunk *chunk; /* points to new chunk */

  if (alignment == 0)
    alignment = DEFAULT_ALIGNMENT;
  if (size == 0)
  /* Default size is what GNU malloc can fit in a 4096-byte block.  */
  {
    /* 12 is sizeof (mhead) and 4 is EXTRA from GNU malloc.
       Use the values for range checking, because if range checking is off,
       the extra bytes won't be missed terribly, but if range checking is on
       and we used a larger request, a whole extra 4096 bytes would be
       allocated.
       These number are irrelevant to the new GNU malloc.  I suspect it is
       less sensitive to the size of the request.  */
    int extra = ((((12 + DEFAULT_ROUNDING - 1) & ~(DEFAULT_ROUNDING - 1)) + 4 +
                  DEFAULT_ROUNDING - 1) &
                 ~(DEFAULT_ROUNDING - 1));
    size = 4096 - extra;
  }

  h->chunkfun = (struct _obstack_chunk * (*)(void *, long)) chunkfun;
  h->freefun = (void (*)(void *, struct _obstack_chunk *))freefun;
  h->chunk_size = size;
  h->alignment_mask = alignment - 1;
  h->extra_arg = arg;
  h->use_extra_arg = 1;

  chunk = h->chunk = CALL_CHUNKFUN(h, h->chunk_size);
  if (!chunk)
    print_and_abort();
  h->next_free = h->object_base =
      __PTR_ALIGN((char *)chunk, chunk->contents, alignment - 1);
  h->chunk_limit = chunk->limit = (char *)chunk + h->chunk_size;
  chunk->prev = 0;
  /* The initial chunk now contains no empty object.  */
  h->maybe_empty_object = 0;
  h->alloc_failed = 0;
  return 1;
}

/* Allocate a new current chunk for the obstack *H
   on the assumption that LENGTH bytes need to be added
   to the current object, or a new object of length LENGTH allocated.
   Copies any partial object from the end of the old chunk
   to the beginning of the new one.  */

static void _obstack_newchunk(struct obstack *h, int length) {
  register struct _obstack_chunk *old_chunk = h->chunk;
  register struct _obstack_chunk *new_chunk;
  register long new_size;
  register long obj_size = h->next_free - h->object_base;
  register long i;
  long already;
  char *object_base;

  /* Compute size for new chunk.  */
  new_size = (obj_size + length) + (obj_size >> 3) + h->alignment_mask + 100;
  if (new_size < h->chunk_size)
    new_size = h->chunk_size;

  /* Allocate and initialize the new chunk.  */
  new_chunk = CALL_CHUNKFUN(h, new_size);
  if (!new_chunk)
    print_and_abort();
  h->chunk = new_chunk;
  new_chunk->prev = old_chunk;
  new_chunk->limit = h->chunk_limit = (char *)new_chunk + new_size;

  /* Compute an aligned object_base in the new chunk */
  object_base =
      __PTR_ALIGN((char *)new_chunk, new_chunk->contents, h->alignment_mask);

  /* Move the existing object to the new chunk.
     Word at a time is fast and is safe if the object
     is sufficiently aligned.  */
  if (h->alignment_mask + 1 >= DEFAULT_ALIGNMENT) {
    for (i = obj_size / sizeof(COPYING_UNIT) - 1; i >= 0; i--)
      ((COPYING_UNIT *)object_base)[i] = ((COPYING_UNIT *)h->object_base)[i];
    /* We used to copy the odd few remaining bytes as one extra COPYING_UNIT,
       but that can cross a page boundary on a machine
       which does not do strict alignment for COPYING_UNITS.  */
    already = obj_size / sizeof(COPYING_UNIT) * sizeof(COPYING_UNIT);
  } else
    already = 0;
  /* Copy remaining bytes one by one.  */
  for (i = already; i < obj_size; i++)
    object_base[i] = h->object_base[i];

  /* If the object just copied was the only data in OLD_CHUNK,
     free that chunk and remove it from the chain.
     But not if that chunk might contain an empty object.  */
  if (!h->maybe_empty_object &&
      (h->object_base == __PTR_ALIGN((char *)old_chunk, old_chunk->contents,
                                     h->alignment_mask))) {
    new_chunk->prev = old_chunk->prev;
    CALL_FREEFUN(h, old_chunk);
  }

  h->object_base = object_base;
  h->next_free = h->object_base + obj_size;
  /* The new chunk certainly contains no empty object yet.  */
  h->maybe_empty_object = 0;
}

/* Return nonzero if object OBJ has been allocated from obstack H.
   This is here for debugging.
   If you use it in a program, you are probably losing.  */

/* Free objects in obstack H, including OBJ and everything allocate
   more recently than OBJ.  If OBJ is zero, free everything in H.  */
static void obstack_free_func(struct obstack *h, void *obj) {
  register struct _obstack_chunk
      *lp; /* below addr of any objects in this chunk */
  register struct _obstack_chunk *plp; /* point to previous chunk if any */

  lp = h->chunk;
  /* We use >= because there cannot be an object at the beginning of a chunk.
     But there can be an empty object at that address
     at the end of another chunk.  */
  while (lp != 0 && ((void *)lp >= obj || (void *)(lp)->limit < obj)) {
    plp = lp->prev;
    CALL_FREEFUN(h, lp);
    lp = plp;
    /* If we switch chunks, we can't tell whether the new current
       chunk contains an empty object, so assume that it may.  */
    h->maybe_empty_object = 1;
  }
  if (lp) {
    h->object_base = h->next_free = (char *)(obj);
    h->chunk_limit = lp->limit;
    h->chunk = lp;
  } else if (obj != 0)
    /* obj is not in any of the chunks! */
    abort();
}

static int _obstack_memory_used(struct obstack *h) {
  register struct _obstack_chunk *lp;
  register int nbytes = 0;

  for (lp = h->chunk; lp != 0; lp = lp->prev) {
    nbytes += lp->limit - (char *)lp;
  }
  return nbytes;
}

static void __attribute__((noreturn)) print_and_abort(void) {
  fprintf(stderr, "%s\n", "memory exhausted");
  exit(1);
}

/* END LOCAL ADDITION */

#ifdef __cplusplus
} /* C++ */
#endif

#endif /* obstack.h */
