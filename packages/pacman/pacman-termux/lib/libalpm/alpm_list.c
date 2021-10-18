/*
 *  alpm_list.c
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdlib.h>
#include <string.h>

/* Note: alpm_list.{c,h} are intended to be standalone files. Do not include
 * any other libalpm headers.
 */

/* libalpm */
#include "alpm_list.h"

/* check exported library symbols with: nm -C -D <lib> */
#define SYMEXPORT __attribute__((visibility("default")))

/* Allocation */

void SYMEXPORT alpm_list_free(alpm_list_t *list)
{
	alpm_list_t *it = list;

	while(it) {
		alpm_list_t *tmp = it->next;
		free(it);
		it = tmp;
	}
}

void SYMEXPORT alpm_list_free_inner(alpm_list_t *list, alpm_list_fn_free fn)
{
	alpm_list_t *it = list;

	if(fn) {
		while(it) {
			if(it->data) {
				fn(it->data);
			}
			it = it->next;
		}
	}
}


/* Mutators */

alpm_list_t SYMEXPORT *alpm_list_add(alpm_list_t *list, void *data)
{
	alpm_list_append(&list, data);
	return list;
}

alpm_list_t SYMEXPORT *alpm_list_append(alpm_list_t **list, void *data)
{
	alpm_list_t *ptr;

	ptr = malloc(sizeof(alpm_list_t));
	if(ptr == NULL) {
		return NULL;
	}

	ptr->data = data;
	ptr->next = NULL;

	/* Special case: the input list is empty */
	if(*list == NULL) {
		*list = ptr;
		ptr->prev = ptr;
	} else {
		alpm_list_t *lp = alpm_list_last(*list);
		lp->next = ptr;
		ptr->prev = lp;
		(*list)->prev = ptr;
	}

	return ptr;
}

alpm_list_t SYMEXPORT *alpm_list_append_strdup(alpm_list_t **list, const char *data)
{
	alpm_list_t *ret;
	char *dup;
	if((dup = strdup(data)) && (ret = alpm_list_append(list, dup))) {
		return ret;
	} else {
		free(dup);
		return NULL;
	}
}

alpm_list_t SYMEXPORT *alpm_list_add_sorted(alpm_list_t *list, void *data, alpm_list_fn_cmp fn)
{
	if(!fn || !list) {
		return alpm_list_add(list, data);
	} else {
		alpm_list_t *add = NULL, *prev = NULL, *next = list;

		add = malloc(sizeof(alpm_list_t));
		if(add == NULL) {
			return list;
		}
		add->data = data;

		/* Find insertion point. */
		while(next) {
			if(fn(add->data, next->data) <= 0) break;
			prev = next;
			next = next->next;
		}

		/* Insert the add node to the list */
		if(prev == NULL) { /* special case: we insert add as the first element */
			add->prev = list->prev; /* list != NULL */
			add->next = list;
			list->prev = add;
			return add;
		} else if(next == NULL) { /* another special case: add last element */
			add->prev = prev;
			add->next = NULL;
			prev->next = add;
			list->prev = add;
			return list;
		} else {
			add->prev = prev;
			add->next = next;
			next->prev = add;
			prev->next = add;
			return list;
		}
	}
}

alpm_list_t SYMEXPORT *alpm_list_join(alpm_list_t *first, alpm_list_t *second)
{
	alpm_list_t *tmp;

	if(first == NULL) {
		return second;
	}
	if(second == NULL) {
		return first;
	}
	/* tmp is the last element of the first list */
	tmp = first->prev;
	/* link the first list to the second */
	tmp->next = second;
	/* link the second list to the first */
	first->prev = second->prev;
	/* set the back reference to the tail */
	second->prev = tmp;

	return first;
}

alpm_list_t SYMEXPORT *alpm_list_mmerge(alpm_list_t *left, alpm_list_t *right,
		alpm_list_fn_cmp fn)
{
	alpm_list_t *newlist, *lp, *tail_ptr, *left_tail_ptr, *right_tail_ptr;

	if(left == NULL) {
		return right;
	}
	if(right == NULL) {
		return left;
	}

	/* Save tail node pointers for future use */
	left_tail_ptr = left->prev;
	right_tail_ptr = right->prev;

	if(fn(left->data, right->data) <= 0) {
		newlist = left;
		left = left->next;
	}
	else {
		newlist = right;
		right = right->next;
	}
	newlist->prev = NULL;
	newlist->next = NULL;
	lp = newlist;

	while((left != NULL) && (right != NULL)) {
		if(fn(left->data, right->data) <= 0) {
			lp->next = left;
			left->prev = lp;
			left = left->next;
		}
		else {
			lp->next = right;
			right->prev = lp;
			right = right->next;
		}
		lp = lp->next;
		lp->next = NULL;
	}
	if(left != NULL) {
		lp->next = left;
		left->prev = lp;
		tail_ptr = left_tail_ptr;
	}
	else if(right != NULL) {
		lp->next = right;
		right->prev = lp;
		tail_ptr = right_tail_ptr;
	}
	else {
		tail_ptr = lp;
	}

	newlist->prev = tail_ptr;

	return newlist;
}

alpm_list_t SYMEXPORT *alpm_list_msort(alpm_list_t *list, size_t n,
		alpm_list_fn_cmp fn)
{
	if(n > 1) {
		size_t half = n / 2;
		size_t i = half - 1;
		alpm_list_t *left = list, *lastleft = list, *right;

		while(i--) {
			lastleft = lastleft->next;
		}
		right = lastleft->next;

		/* tidy new lists */
		lastleft->next = NULL;
		right->prev = left->prev;
		left->prev = lastleft;

		left = alpm_list_msort(left, half, fn);
		right = alpm_list_msort(right, n - half, fn);
		list = alpm_list_mmerge(left, right, fn);
	}
	return list;
}

alpm_list_t SYMEXPORT *alpm_list_remove_item(alpm_list_t *haystack,
		alpm_list_t *item)
{
	if(haystack == NULL || item == NULL) {
		return haystack;
	}

	if(item == haystack) {
		/* Special case: removing the head node which has a back reference to
		 * the tail node */
		haystack = item->next;
		if(haystack) {
			haystack->prev = item->prev;
		}
		item->prev = NULL;
	} else if(item == haystack->prev) {
		/* Special case: removing the tail node, so we need to fix the back
		 * reference on the head node. We also know tail != head. */
		if(item->prev) {
			/* i->next should always be null */
			item->prev->next = item->next;
			haystack->prev = item->prev;
			item->prev = NULL;
		}
	} else {
		/* Normal case, non-head and non-tail node */
		if(item->next) {
			item->next->prev = item->prev;
		}
		if(item->prev) {
			item->prev->next = item->next;
		}
	}

	return haystack;
}

alpm_list_t SYMEXPORT *alpm_list_remove(alpm_list_t *haystack,
		const void *needle, alpm_list_fn_cmp fn, void **data)
{
	alpm_list_t *i = haystack;

	if(data) {
		*data = NULL;
	}

	if(needle == NULL) {
		return haystack;
	}

	while(i) {
		if(i->data == NULL) {
			i = i->next;
			continue;
		}
		if(fn(i->data, needle) == 0) {
			haystack = alpm_list_remove_item(haystack, i);

			if(data) {
				*data = i->data;
			}
			free(i);
			break;
		} else {
			i = i->next;
		}
	}

	return haystack;
}

alpm_list_t SYMEXPORT *alpm_list_remove_str(alpm_list_t *haystack,
		const char *needle, char **data)
{
	return alpm_list_remove(haystack, (const void *)needle,
			(alpm_list_fn_cmp)strcmp, (void **)data);
}

alpm_list_t SYMEXPORT *alpm_list_remove_dupes(const alpm_list_t *list)
{
	const alpm_list_t *lp = list;
	alpm_list_t *newlist = NULL;
	while(lp) {
		if(!alpm_list_find_ptr(newlist, lp->data)) {
			if(alpm_list_append(&newlist, lp->data) == NULL) {
				alpm_list_free(newlist);
				return NULL;
			}
		}
		lp = lp->next;
	}
	return newlist;
}

alpm_list_t SYMEXPORT *alpm_list_strdup(const alpm_list_t *list)
{
	const alpm_list_t *lp = list;
	alpm_list_t *newlist = NULL;
	while(lp) {
		if(alpm_list_append_strdup(&newlist, lp->data) == NULL) {
			FREELIST(newlist);
			return NULL;
		}
		lp = lp->next;
	}
	return newlist;
}

alpm_list_t SYMEXPORT *alpm_list_copy(const alpm_list_t *list)
{
	const alpm_list_t *lp = list;
	alpm_list_t *newlist = NULL;
	while(lp) {
		if(alpm_list_append(&newlist, lp->data) == NULL) {
			alpm_list_free(newlist);
			return NULL;
		}
		lp = lp->next;
	}
	return newlist;
}

alpm_list_t SYMEXPORT *alpm_list_copy_data(const alpm_list_t *list,
		size_t size)
{
	const alpm_list_t *lp = list;
	alpm_list_t *newlist = NULL;
	while(lp) {
		void *newdata = malloc(size);
		if(newdata) {
			memcpy(newdata, lp->data, size);
			if(alpm_list_append(&newlist, newdata) == NULL) {
				free(newdata);
				FREELIST(newlist);
				return NULL;
			}
			lp = lp->next;
		} else {
			FREELIST(newlist);
			return NULL;
		}
	}
	return newlist;
}

alpm_list_t SYMEXPORT *alpm_list_reverse(alpm_list_t *list)
{
	const alpm_list_t *lp;
	alpm_list_t *newlist = NULL, *backup;

	if(list == NULL) {
		return NULL;
	}

	lp = alpm_list_last(list);
	/* break our reverse circular list */
	backup = list->prev;
	list->prev = NULL;

	while(lp) {
		if(alpm_list_append(&newlist, lp->data) == NULL) {
			alpm_list_free(newlist);
			return NULL;
		}
		lp = lp->prev;
	}
	list->prev = backup; /* restore tail pointer */
	return newlist;
}

/* Accessors */

alpm_list_t SYMEXPORT *alpm_list_nth(const alpm_list_t *list, size_t n)
{
	const alpm_list_t *i = list;
	while(n--) {
		i = i->next;
	}
	return (alpm_list_t *)i;
}

inline alpm_list_t SYMEXPORT *alpm_list_next(const alpm_list_t *node)
{
	if(node) {
		return node->next;
	} else {
		return NULL;
	}
}

inline alpm_list_t SYMEXPORT *alpm_list_previous(const alpm_list_t *list)
{
	if(list && list->prev->next) {
		return list->prev;
	} else {
		return NULL;
	}
}

alpm_list_t SYMEXPORT *alpm_list_last(const alpm_list_t *list)
{
	if(list) {
		return list->prev;
	} else {
		return NULL;
	}
}

/* Misc */

size_t SYMEXPORT alpm_list_count(const alpm_list_t *list)
{
	size_t i = 0;
	const alpm_list_t *lp = list;
	while(lp) {
		++i;
		lp = lp->next;
	}
	return i;
}

void SYMEXPORT *alpm_list_find(const alpm_list_t *haystack, const void *needle,
		alpm_list_fn_cmp fn)
{
	const alpm_list_t *lp = haystack;
	while(lp) {
		if(lp->data && fn(lp->data, needle) == 0) {
			return lp->data;
		}
		lp = lp->next;
	}
	return NULL;
}

/* trivial helper function for alpm_list_find_ptr */
static int ptr_cmp(const void *p, const void *q)
{
	return (p != q);
}

void SYMEXPORT *alpm_list_find_ptr(const alpm_list_t *haystack,
		const void *needle)
{
	return alpm_list_find(haystack, needle, ptr_cmp);
}

char SYMEXPORT *alpm_list_find_str(const alpm_list_t *haystack,
		const char *needle)
{
	return (char *)alpm_list_find(haystack, (const void *)needle,
			(alpm_list_fn_cmp)strcmp);
}

void SYMEXPORT alpm_list_diff_sorted(const alpm_list_t *left,
		const alpm_list_t *right, alpm_list_fn_cmp fn,
		alpm_list_t **onlyleft, alpm_list_t **onlyright)
{
	const alpm_list_t *l = left;
	const alpm_list_t *r = right;

	if(!onlyleft && !onlyright) {
		return;
	}

	while(l != NULL && r != NULL) {
		int cmp = fn(l->data, r->data);
		if(cmp < 0) {
			if(onlyleft) {
				*onlyleft = alpm_list_add(*onlyleft, l->data);
			}
			l = l->next;
		}
		else if(cmp > 0) {
			if(onlyright) {
				*onlyright = alpm_list_add(*onlyright, r->data);
			}
			r = r->next;
		} else {
			l = l->next;
			r = r->next;
		}
	}
	while(l != NULL) {
		if(onlyleft) {
			*onlyleft = alpm_list_add(*onlyleft, l->data);
		}
		l = l->next;
	}
	while(r != NULL) {
		if(onlyright) {
			*onlyright = alpm_list_add(*onlyright, r->data);
		}
		r = r->next;
	}
}


alpm_list_t SYMEXPORT *alpm_list_diff(const alpm_list_t *lhs,
		const alpm_list_t *rhs, alpm_list_fn_cmp fn)
{
	alpm_list_t *left, *right;
	alpm_list_t *ret = NULL;

	left = alpm_list_copy(lhs);
	left = alpm_list_msort(left, alpm_list_count(left), fn);
	right = alpm_list_copy(rhs);
	right = alpm_list_msort(right, alpm_list_count(right), fn);

	alpm_list_diff_sorted(left, right, fn, &ret, NULL);

	alpm_list_free(left);
	alpm_list_free(right);
	return ret;
}

void SYMEXPORT *alpm_list_to_array(const alpm_list_t *list, size_t n,
		size_t size)
{
	size_t i;
	const alpm_list_t *item;
	char *array;

	if(n == 0) {
		return NULL;
	}

	array = malloc(n * size);
	if(array == NULL) {
		return NULL;
	}
	for(i = 0, item = list; i < n && item; i++, item = item->next) {
		memcpy(array + i * size, item->data, size);
	}
	return array;
}
