/* heap.c -- 
 * Created: Sun Aug 10 19:33:49 2003 by vle@gmx.net
 * Copyright 2003 Aleksey Cheusov <vle@gmx.net>
 * This program comes with ABSOLUTELY NO WARRANTY.
 * 
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 1, or (at your option) any
 * later version.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include "dictP.h"
#include "heap.h"

#include <maa.h>

#define HEAP_ARRAY_SIZE 100000
#define HEAP_LIMIT      500
#define HEAP_MAGIC      711755

typedef struct heap_struct {
   char *ptr;

   char *last;

   int magic_num;
   int allocated_bytes;
   int allocation_count;
} heap_s;

int heap_create (void **heap, void *opts)
{
   heap_s *h;
   assert (heap);

   *heap = xmalloc (sizeof (heap_s));
   h = (heap_s *) *heap;

   h -> ptr              = xmalloc (HEAP_ARRAY_SIZE);
   h -> allocated_bytes  = 0;
   h -> magic_num        = HEAP_MAGIC;
   h -> allocation_count = 0;

   return 0;
}

const char *heap_error (int err_code)
{
   assert (err_code); /* error codes are not defined yet */
   return NULL;
}

void heap_destroy (void **heap)
{
   heap_s *h;

   assert (heap);
   h = (heap_s *) *heap;

   assert (h -> magic_num == HEAP_MAGIC);

   xfree (h -> ptr);
   xfree (h);

   *heap = NULL;
}

void * heap_alloc (void *heap, size_t size)
{
   heap_s *h = (heap_s *) heap;

   assert (h -> magic_num == HEAP_MAGIC);
//   fprintf (stderr, "heap_alloc\n");

   if (size >= HEAP_LIMIT || h -> allocated_bytes + size > HEAP_ARRAY_SIZE){
      return xmalloc (size);
   }else{
//      fprintf (stderr, "heap alloc\n");

      h -> last = h -> ptr + h -> allocated_bytes;
      h -> allocated_bytes  += size;
      h -> allocation_count += 1;

      return h -> last;
   }
}

char * heap_strdup (void *heap, const char *s)
{
   heap_s *h = (heap_s *) heap;
   size_t len = strlen (s);
   char *p = (char *) heap_alloc (heap, len + 1);

   assert (h -> magic_num == HEAP_MAGIC);

   memcpy (p, s, len + 1);
   return p;
}

void heap_free (void *heap, void *p)
{
   heap_s *h = (heap_s *) heap;

//   fprintf (stderr, "heap_free\n");

   assert (h -> magic_num == HEAP_MAGIC);

   if (!p){
//      fprintf (stderr, "heap_free(NULL)\n");
      return;
   }

   if ((char *) p >= h -> ptr && (char *) p < h -> ptr + HEAP_ARRAY_SIZE){
//      fprintf (stderr, "heap free\n");

      h -> allocation_count -= 1;

      if (!h -> allocation_count){
//	 fprintf (stderr, "heap destroied\n");
	 h -> allocated_bytes = 0;
      }

      h -> last = NULL;
   }else{
      xfree (p);
   }
}

void * heap_realloc (void *heap, void *p, size_t size)
{
   heap_s *h = (heap_s *) heap;
   char *new_p;

   assert (h -> magic_num == HEAP_MAGIC);

   if (!p)
      return heap_alloc (heap, size);

   if ((char *) p >= h -> ptr && (char *) p < h -> ptr + HEAP_ARRAY_SIZE){
      assert (h -> last == p);

      if (h -> allocated_bytes + size > HEAP_ARRAY_SIZE){
	 new_p = xmalloc (size);
	 memcpy (new_p, (char *) p, (h -> ptr + h -> allocated_bytes) - (char *) p);
	 h -> allocated_bytes = (char *) p - h -> ptr;
	 h -> last = NULL;

	 return new_p;
      }else{
	 h -> allocated_bytes  = ((char *) p - h -> ptr) + size;
	 return p;
      }
   }else{
      return xrealloc (p, size);
   }
}

int heap_isempty (void *heap)
{
   heap_s *h = (heap_s *) heap;

   assert (h -> magic_num == HEAP_MAGIC);

   return h -> allocation_count == 0;
}
