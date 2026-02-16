/*
 * Copyright © 2008 Kristian Høgsberg
 * Copyright © 2024 Twaik Yont
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice (including the
 * next paragraph) shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#pragma once

/** \file list.h
 *
 * \brief Circular doubly linked list implementation.
 */

#ifdef  __cplusplus
extern "C" {
#endif

/** \class list
 *
 * \brief Doubly-linked list
 *
 * On its own, an instance of `struct list` represents the sentinel head of
 * a doubly-linked list, and must be initialized using list_init().
 * When empty, the list head's `next` and `prev` members point to the list head
 * itself, otherwise `next` references the first element in the list, and `prev`
 * refers to the last element in the list.
 *
 * Use the `struct list` type to represent both the list head and the links
 * between elements within the list. Use list_empty() to determine if the
 * list is empty in O(1).
 *
 * All elements in the list must be of the same type. The element type must have
 * a `struct list` member, often named `link` by convention. Prior to
 * insertion, there is no need to initialize an element's `link` - invoking
 * list_init() on an individual list element's `struct list` member is
 * unnecessary if the very next operation is list_insert(). However, a
 * common idiom is to initialize an element's `link` prior to removal - ensure
 * safety by invoking list_init() before list_remove().
 *
 * Consider a list reference `struct list foo_list`, an element type as
 * `struct element`, and an element's link member as `struct list link`.
 *
 * The following code initializes a list and adds three elements to it.
 *
 * \code
 * struct list foo_list;
 *
 * struct element {
 *         int foo;
 *         struct list link;
 * };
 * struct element e1, e2, e3;
 *
 * list_init(&foo_list);
 * list_insert(&foo_list, &e1.link);   // e1 is the first element
 * list_insert(&foo_list, &e2.link);   // e2 is now the first element
 * list_insert(&e2.link, &e3.link); // insert e3 after e2
 * \endcode
 *
 * The list now looks like <em>[e2, e3, e1]</em>.
 *
 * The `list` API provides some iterator macros. For example, to iterate
 * a list in ascending order:
 *
 * \code
 * struct element *e;
 * list_for_each(e, foo_list, link) {
 *         do_something_with_element(e);
 * }
 * \endcode
 *
 * See the documentation of each iterator for details.
 * \sa http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/linux/list.h
 */

typedef struct list { struct list *prev, *next; } list;

/**
 * Initializes the list.
 *
 * \param list List to initialize
 *
 * \memberof list
 */
__used __always_inline __LIBC_HIDDEN__ void list_init(struct list *list) {
    list->prev = list;
    list->next = list;
}

/**
 * Inserts an element into the list, after the element represented by \p list.
 * When \p list is a reference to the list itself (the head), set the containing
 * struct of \p elm as the first element in the list.
 *
 * \note If \p elm is already part of a list, inserting it again will lead to
 *       list corruption.
 *
 * \param list List element after which the new element is inserted
 * \param elm Link of the containing struct to insert into the list
 *
 * \memberof list
 */
__used __always_inline __LIBC_HIDDEN__ void list_insert(struct list *list, struct list *elm) {
    elm->prev = list;
    elm->next = list->next;
    list->next = elm;
    elm->next->prev = elm;
}

/**
 * Removes an element from the list.
 *
 * \note This operation leaves \p elm in an invalid state.
 *
 * \param elm Link of the containing struct to remove from the list
 *
 * \memberof list
 */
__used __always_inline __LIBC_HIDDEN__ void list_remove(struct list *elm) {
    elm->prev->next = elm->next;
    elm->next->prev = elm->prev;
    elm->next = NULL;
    elm->prev = NULL;
}

/**
 * Determines the length of the list.
 *
 * \note This is an O(n) operation.
 *
 * \param list List whose length is to be determined
 *
 * \return Number of elements in the list
 *
 * \memberof list
 */
__used __always_inline __LIBC_HIDDEN__ int list_length(const struct list *list) {
    struct list *e;
    int count;

    count = 0;
    e = list->next;
    while (e != list) {
        e = e->next;
        count++;
    }

    return count;
}

/**
 * Determines if the list is empty.
 *
 * \param list List whose emptiness is to be determined
 *
 * \return 1 if empty, or 0 if not empty
 *
 * \memberof list
 */
__used __always_inline __LIBC_HIDDEN__ int list_empty(const struct list *list) {
    return list->next == list;
}

/**
 * Inserts all of the elements of one list into another, after the element
 * represented by \p list.
 *
 * \note This leaves \p other in an invalid state.
 *
 * \param list List element after which the other list elements will be inserted
 * \param other List of elements to insert
 *
 * \memberof list
 */
__used __always_inline __LIBC_HIDDEN__ void list_insert_list(struct list *list, struct list *other) {
    if (!list_empty(other)) {
        other->next->prev = list;
        other->prev->next = list->next;
        list->next->prev = other->prev;
        list->next = other->next;
    }
}

/**
 * Retrieves a pointer to a containing struct, given a member name.
 *
 * This macro allows "conversion" from a pointer to a member to its containing
 * struct. This is useful if you have a contained item like a list,
 * listener, or signal, provided via a callback or other means, and would
 * like to retrieve the struct that contains it.
 *
 * To demonstrate, the following example retrieves a pointer to
 * `example_container` given only its `destroy_listener` member:
 *
 * \code
 * struct example_container {
 *         struct listener destroy_listener;
 *         // other members...
 * };
 *
 * void example_container_destroy(struct listener *listener, void *data)
 * {
 *         struct example_container *ctr;
 *
 *         ctr = container_of(listener, ctr, destroy_listener);
 *         // destroy ctr...
 * }
 * \endcode
 *
 * \note `sample` need not be a valid pointer. A null or uninitialised pointer
 *       is sufficient.
 *
 * \param ptr Valid pointer to the contained member
 * \param sample Pointer to a struct whose type contains \p ptr
 * \param member Named location of \p ptr within the \p sample type
 *
 * \return The container for the specified pointer
 */
#define container_of(ptr, sample, member)				\
	(__typeof__(sample))((char *)(ptr) -				\
			     offsetof(__typeof__(*sample), member))

/**
 * Iterates over a list.
 *
 * This macro expresses a for-each iterator for list. Given a list and
 * list link member name (often named `link` by convention), this macro
 * assigns each element in the list to \p pos, which can then be referenced in
 * a trailing code block. For example, given a list of `struct message`
 * elements:
 *
 * \code
 * struct message {
 *         char *contents;
 *         list link;
 * };
 *
 * struct list *message_list;
 * // Assume message_list now "contains" many messages
 *
 * struct message *m;
 * list_for_each(m, message_list, link) {
 *         do_something_with_message(m);
 * }
 * \endcode
 *
 * \param pos Cursor that each list element will be assigned to
 * \param head Head of the list to iterate over
 * \param member Name of the link member within the element struct
 *
 * \relates list
 */
#define list_for_each(pos, head, member)				\
	for (pos = container_of((head)->next, pos, member);	\
	     &pos->member != (head);					\
	     pos = container_of(pos->member.next, pos, member))

/**
 * Iterates over a list, safe against removal of the list element.
 *
 * \note Only removal of the current element, \p pos, is safe. Removing
 *       any other element during traversal may lead to a loop malfunction.
 *
 * \sa list_for_each()
 *
 * \param pos Cursor that each list element will be assigned to
 * \param tmp Temporary pointer of the same type as \p pos
 * \param head Head of the list to iterate over
 * \param member Name of the link member within the element struct
 *
 * \relates list
 */
#define list_for_each_safe(pos, tmp, head, member)			\
	for (pos = container_of((head)->next, pos, member),		\
	     tmp = container_of((pos)->member.next, tmp, member);	\
	     &pos->member != (head);					\
	     pos = tmp,							\
	     tmp = container_of(pos->member.next, tmp, member))

/**
 * Iterates backwards over a list.
 *
 * \sa list_for_each()
 *
 * \param pos Cursor that each list element will be assigned to
 * \param head Head of the list to iterate over
 * \param member Name of the link member within the element struct
 *
 * \relates list
 */
#define list_for_each_reverse(pos, head, member)			\
	for (pos = container_of((head)->prev, pos, member);	\
	     &pos->member != (head);					\
	     pos = container_of(pos->member.prev, pos, member))

/**
 * Iterates backwards over a list, safe against removal of the list element.
 *
 * \note Only removal of the current element, \p pos, is safe. Removing
 *       any other element during traversal may lead to a loop malfunction.
 *
 * \sa list_for_each()
 *
 * \param pos Cursor that each list element will be assigned to
 * \param tmp Temporary pointer of the same type as \p pos
 * \param head Head of the list to iterate over
 * \param member Name of the link member within the element struct
 *
 * \relates list
 */
#define list_for_each_reverse_safe(pos, tmp, head, member)		\
	for (pos = container_of((head)->prev, pos, member),	\
	     tmp = container_of((pos)->member.prev, tmp, member);	\
	     &pos->member != (head);					\
	     pos = tmp,							\
	     tmp = container_of(pos->member.prev, tmp, member))

#ifdef  __cplusplus
}
#endif
