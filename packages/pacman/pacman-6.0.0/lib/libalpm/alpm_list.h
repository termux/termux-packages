/*
 *  alpm_list.h
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


#ifndef ALPM_LIST_H
#define ALPM_LIST_H

#include <stdlib.h> /* size_t */

/* Note: alpm_list.{c,h} are intended to be standalone files. Do not include
 * any other libalpm headers.
 */

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @ingroup libalpm
 * @addtogroup libalpm_list libalpm_list(3)
 * @brief Functions to manipulate alpm_list_t lists.
 *
 * These functions are designed to create, destroy, and modify lists of
 * type alpm_list_t. This is an internal list type used by libalpm that is
 * publicly exposed for use by frontends if desired.
 *
 * It is exposed so front ends can use it to prevent the need to reimplement
 * lists of their own; however, it is not required that the front end uses
 * it.
 * @{
 */

/** A doubly linked list */
typedef struct __alpm_list_t {
	/** data held by the list node */
	void *data;
	/** pointer to the previous node */
	struct __alpm_list_t *prev;
	/** pointer to the next node */
	struct __alpm_list_t *next;
} alpm_list_t;

/** Frees a list and its contents */
#define FREELIST(p) do { alpm_list_free_inner(p, free); alpm_list_free(p); p = NULL; } while(0)

/** item deallocation callback.
 * @param item the item to free
 */
typedef void (*alpm_list_fn_free)(void * item);

/** item comparison callback */
typedef int (*alpm_list_fn_cmp)(const void *, const void *);

/* allocation */

/** Free a list, but not the contained data.
 *
 * @param list the list to free
 */
void alpm_list_free(alpm_list_t *list);

/** Free the internal data of a list structure but not the list itself.
 *
 * @param list the list to free
 * @param fn a free function for the internal data
 */
void alpm_list_free_inner(alpm_list_t *list, alpm_list_fn_free fn);

/* item mutators */

/** Add a new item to the end of the list.
 *
 * @param list the list to add to
 * @param data the new item to be added to the list
 *
 * @return the resultant list
 */
alpm_list_t *alpm_list_add(alpm_list_t *list, void *data);

/**
 * @brief Add a new item to the end of the list.
 *
 * @param list the list to add to
 * @param data the new item to be added to the list
 *
 * @return the newly added item
 */
alpm_list_t *alpm_list_append(alpm_list_t **list, void *data);

/**
 * @brief Duplicate and append a string to a list.
 *
 * @param list the list to append to
 * @param data the string to duplicate and append
 *
 * @return the newly added item
 */
alpm_list_t *alpm_list_append_strdup(alpm_list_t **list, const char *data);

/**
 * @brief Add items to a list in sorted order.
 *
 * @param list the list to add to
 * @param data the new item to be added to the list
 * @param fn   the comparison function to use to determine order
 *
 * @return the resultant list
 */
alpm_list_t *alpm_list_add_sorted(alpm_list_t *list, void *data, alpm_list_fn_cmp fn);

/**
 * @brief Join two lists.
 * The two lists must be independent. Do not free the original lists after
 * calling this function, as this is not a copy operation. The list pointers
 * passed in should be considered invalid after calling this function.
 *
 * @param first  the first list
 * @param second the second list
 *
 * @return the resultant joined list
 */
alpm_list_t *alpm_list_join(alpm_list_t *first, alpm_list_t *second);

/**
 * @brief Merge the two sorted sublists into one sorted list.
 *
 * @param left  the first list
 * @param right the second list
 * @param fn    comparison function for determining merge order
 *
 * @return the resultant list
 */
alpm_list_t *alpm_list_mmerge(alpm_list_t *left, alpm_list_t *right, alpm_list_fn_cmp fn);

/**
 * @brief Sort a list of size `n` using mergesort algorithm.
 *
 * @param list the list to sort
 * @param n    the size of the list
 * @param fn   the comparison function for determining order
 *
 * @return the resultant list
 */
alpm_list_t *alpm_list_msort(alpm_list_t *list, size_t n, alpm_list_fn_cmp fn);

/**
 * @brief Remove an item from the list.
 * item is not freed; this is the responsibility of the caller.
 *
 * @param haystack the list to remove the item from
 * @param item the item to remove from the list
 *
 * @return the resultant list
 */
alpm_list_t *alpm_list_remove_item(alpm_list_t *haystack, alpm_list_t *item);

/**
 * @brief Remove an item from the list.
 *
 * @param haystack the list to remove the item from
 * @param needle   the data member of the item we're removing
 * @param fn       the comparison function for searching
 * @param data     output parameter containing data of the removed item
 *
 * @return the resultant list
 */
alpm_list_t *alpm_list_remove(alpm_list_t *haystack, const void *needle, alpm_list_fn_cmp fn, void **data);

/**
 * @brief Remove a string from a list.
 *
 * @param haystack the list to remove the item from
 * @param needle   the data member of the item we're removing
 * @param data     output parameter containing data of the removed item
 *
 * @return the resultant list
 */
alpm_list_t *alpm_list_remove_str(alpm_list_t *haystack, const char *needle, char **data);

/**
 * @brief Create a new list without any duplicates.
 *
 * This does NOT copy data members.
 *
 * @param list the list to copy
 *
 * @return a new list containing non-duplicate items
 */
alpm_list_t *alpm_list_remove_dupes(const alpm_list_t *list);

/**
 * @brief Copy a string list, including data.
 *
 * @param list the list to copy
 *
 * @return a copy of the original list
 */
alpm_list_t *alpm_list_strdup(const alpm_list_t *list);

/**
 * @brief Copy a list, without copying data.
 *
 * @param list the list to copy
 *
 * @return a copy of the original list
 */
alpm_list_t *alpm_list_copy(const alpm_list_t *list);

/**
 * @brief Copy a list and copy the data.
 * Note that the data elements to be copied should not contain pointers
 * and should also be of constant size.
 *
 * @param list the list to copy
 * @param size the size of each data element
 *
 * @return a copy of the original list, data copied as well
 */
alpm_list_t *alpm_list_copy_data(const alpm_list_t *list, size_t size);

/**
 * @brief Create a new list in reverse order.
 *
 * @param list the list to copy
 *
 * @return a new list in reverse order
 */
alpm_list_t *alpm_list_reverse(alpm_list_t *list);

/* item accessors */


/**
 * @brief Return nth element from list (starting from 0).
 *
 * @param list the list
 * @param n    the index of the item to find (n < alpm_list_count(list) IS needed)
 *
 * @return an alpm_list_t node for index `n`
 */
alpm_list_t *alpm_list_nth(const alpm_list_t *list, size_t n);

/**
 * @brief Get the next element of a list.
 *
 * @param list the list node
 *
 * @return the next element, or NULL when no more elements exist
 */
alpm_list_t *alpm_list_next(const alpm_list_t *list);

/**
 * @brief Get the previous element of a list.
 *
 * @param list the list head
 *
 * @return the previous element, or NULL when no previous element exist
 */
alpm_list_t *alpm_list_previous(const alpm_list_t *list);

/**
 * @brief Get the last item in the list.
 *
 * @param list the list
 *
 * @return the last element in the list
 */
alpm_list_t *alpm_list_last(const alpm_list_t *list);

/* misc */

/**
 * @brief Get the number of items in a list.
 *
 * @param list the list
 *
 * @return the number of list items
 */
size_t alpm_list_count(const alpm_list_t *list);

/**
 * @brief Find an item in a list.
 *
 * @param needle   the item to search
 * @param haystack the list
 * @param fn       the comparison function for searching (!= NULL)
 *
 * @return `needle` if found, NULL otherwise
 */
void *alpm_list_find(const alpm_list_t *haystack, const void *needle, alpm_list_fn_cmp fn);

/**
 * @brief Find an item in a list.
 *
 * Search for the item whose data matches that of the `needle`.
 *
 * @param needle   the data to search for (== comparison)
 * @param haystack the list
 *
 * @return `needle` if found, NULL otherwise
 */
void *alpm_list_find_ptr(const alpm_list_t *haystack, const void *needle);

/**
 * @brief Find a string in a list.
 *
 * @param needle   the string to search for
 * @param haystack the list
 *
 * @return `needle` if found, NULL otherwise
 */
char *alpm_list_find_str(const alpm_list_t *haystack, const char *needle);

/**
 * @brief Find the differences between list `left` and list `right`
 *
 * The two lists must be sorted. Items only in list `left` are added to the
 * `onlyleft` list. Items only in list `right` are added to the `onlyright`
 * list.
 *
 * @param left      the first list
 * @param right     the second list
 * @param fn        the comparison function
 * @param onlyleft  pointer to the first result list
 * @param onlyright pointer to the second result list
 *
 */
void alpm_list_diff_sorted(const alpm_list_t *left, const alpm_list_t *right,
		alpm_list_fn_cmp fn, alpm_list_t **onlyleft, alpm_list_t **onlyright);

/**
 * @brief Find the items in list `lhs` that are not present in list `rhs`.
 *
 * @param lhs the first list
 * @param rhs the second list
 * @param fn  the comparison function
 *
 * @return a list containing all items in `lhs` not present in `rhs`
 */

alpm_list_t *alpm_list_diff(const alpm_list_t *lhs, const alpm_list_t *rhs, alpm_list_fn_cmp fn);

/**
 * @brief Copy a list and data into a standard C array of fixed length.
 * Note that the data elements are shallow copied so any contained pointers
 * will point to the original data.
 *
 * @param list the list to copy
 * @param n    the size of the list
 * @param size the size of each data element
 *
 * @return an array version of the original list, data copied as well
 */
void *alpm_list_to_array(const alpm_list_t *list, size_t n, size_t size);

/* End of alpm_list */
/** @} */

#ifdef __cplusplus
}
#endif
#endif /* ALPM_LIST_H */
