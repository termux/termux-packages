/*
 *  pkghash.h
 *
 *  Copyright (c) 2011-2021 Pacman Development Team <pacman-dev@archlinux.org>
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

#ifndef ALPM_PKGHASH_H
#define ALPM_PKGHASH_H

#include <stdlib.h>

#include "alpm.h"
#include "alpm_list.h"


/**
 * @brief A hash table for holding alpm_pkg_t objects.
 *
 * A combination of a hash table and a list, allowing for fast look-up
 * by package name but also iteration over the packages.
 */
struct __alpm_pkghash_t {
	/** data held by the hash table */
	alpm_list_t **hash_table;
	/** head node of the hash table data in normal list format */
	alpm_list_t *list;
	/** number of buckets in hash table */
	unsigned int buckets;
	/** number of entries in hash table */
	unsigned int entries;
	/** max number of entries before a resize is needed */
	unsigned int limit;
};

typedef struct __alpm_pkghash_t alpm_pkghash_t;

alpm_pkghash_t *_alpm_pkghash_create(unsigned int size);

alpm_pkghash_t *_alpm_pkghash_add(alpm_pkghash_t **hash, alpm_pkg_t *pkg);
alpm_pkghash_t *_alpm_pkghash_add_sorted(alpm_pkghash_t **hash, alpm_pkg_t *pkg);
alpm_pkghash_t *_alpm_pkghash_remove(alpm_pkghash_t *hash, alpm_pkg_t *pkg, alpm_pkg_t **data);

void _alpm_pkghash_free(alpm_pkghash_t *hash);

alpm_pkg_t *_alpm_pkghash_find(alpm_pkghash_t *hash, const char *name);

#endif /* ALPM_PKGHASH_H */
