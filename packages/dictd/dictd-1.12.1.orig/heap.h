/* heap.h -- 
 * Created: Sun Aug 10 19:33:53 2003 by vle@gmx.net
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

/* create a heap. 'opts' MUST BE NULL at this time */

#ifndef DONOT_USE_INTERNAL_HEAP

extern int heap_create (void **heap, void *opts);
extern const char *heap_error (int err_code);
extern void heap_destroy (void **heap);
extern void * heap_alloc (void *heap, size_t size);
extern char * heap_strdup (void *heap, const char *s);
extern void heap_free (void *heap, void *p);
extern void * heap_realloc (void *heap, void *p, size_t size);
extern int heap_isempty (void *heap);

#else

#define heap_create(heap, opts) (0);
#define heap_error(err_code) (NULL)
#define heap_destroy(heap) (0)
#define heap_alloc(heap, size) (xmalloc (size))
#define heap_strdup(heap, s) (xstrdup (s))
#define heap_free(heap, p) (p ? xfree (p), NULL : NULL)
#define heap_realloc(heap, p, size) (realloc (p, size))
#define heap_isempty(heap) (1)

#endif
