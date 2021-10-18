/*
 *  pkghash.c
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

#include <errno.h>

#include "pkghash.h"
#include "util.h"

/* List of primes for possible sizes of hash tables.
 *
 * The maximum table size is the last prime under 1,000,000.  That is
 * more than an order of magnitude greater than the number of packages
 * in any Linux distribution, and well under UINT_MAX.
 */
static const unsigned int prime_list[] =
{
	11u, 13u, 17u, 19u, 23u, 29u, 31u, 37u, 41u, 43u, 47u,
	53u, 59u, 61u, 67u, 71u, 73u, 79u, 83u, 89u, 97u, 103u,
	109u, 113u, 127u, 137u, 139u, 149u, 157u, 167u, 179u, 193u,
	199u, 211u, 227u, 241u, 257u, 277u, 293u, 313u, 337u, 359u,
	383u, 409u, 439u, 467u, 503u, 541u, 577u, 619u, 661u, 709u,
	761u, 823u, 887u, 953u, 1031u, 1109u, 1193u, 1289u, 1381u,
	1493u, 1613u, 1741u, 1879u, 2029u, 2179u, 2357u, 2549u,
	2753u, 2971u, 3209u, 3469u, 3739u, 4027u, 4349u, 4703u,
	5087u, 5503u, 5953u, 6427u, 6949u, 7517u, 8123u, 8783u,
	9497u, 10273u, 11113u, 12011u, 12983u, 14033u, 15173u,
	16411u, 17749u, 19183u, 20753u, 22447u, 24281u, 26267u,
	28411u, 30727u, 33223u, 35933u, 38873u, 42043u, 45481u,
	49201u, 53201u, 57557u, 62233u, 67307u, 72817u, 78779u,
	85229u, 92203u, 99733u, 107897u, 116731u, 126271u, 136607u,
	147793u, 159871u, 172933u, 187091u, 202409u, 218971u, 236897u,
	256279u, 277261u, 299951u, 324503u, 351061u, 379787u, 410857u,
	444487u, 480881u, 520241u, 562841u, 608903u, 658753u, 712697u,
	771049u, 834181u, 902483u, 976369u
};

/* How far forward do we look when linear probing for a spot? */
static const unsigned int stride = 1;
/* What is the maximum load percentage of our hash table? */
static const double max_hash_load = 0.68;
/* Initial load percentage given a certain size */
static const double initial_hash_load = 0.58;

/* Allocate a hash table with space for at least "size" elements */
alpm_pkghash_t *_alpm_pkghash_create(unsigned int size)
{
	alpm_pkghash_t *hash = NULL;
	unsigned int i, loopsize;

	CALLOC(hash, 1, sizeof(alpm_pkghash_t), return NULL);
	size = size / initial_hash_load + 1;

	loopsize = ARRAYSIZE(prime_list);
	for(i = 0; i < loopsize; i++) {
		if(prime_list[i] > size) {
			hash->buckets = prime_list[i];
			hash->limit = hash->buckets * max_hash_load;
			break;
		}
	}

	if(hash->buckets < size) {
		errno = ERANGE;
		free(hash);
		return NULL;
	}

	CALLOC(hash->hash_table, hash->buckets, sizeof(alpm_list_t *), \
				free(hash); return NULL);

	return hash;
}

static unsigned int get_hash_position(unsigned long name_hash,
		alpm_pkghash_t *hash)
{
	unsigned int position;

	position = name_hash % hash->buckets;

	/* collision resolution using open addressing with linear probing */
	while(hash->hash_table[position] != NULL) {
		position += stride;
		while(position >= hash->buckets) {
			position -= hash->buckets;
		}
	}

	return position;
}

/* Expand the hash table size to the next increment and rebin the entries */
static alpm_pkghash_t *rehash(alpm_pkghash_t *oldhash)
{
	alpm_pkghash_t *newhash;
	unsigned int newsize, i;

	/* Hash tables will need resized in two cases:
	 *  - adding packages to the local database
	 *  - poor estimation of the number of packages in sync database
	 *
	 * For small hash tables sizes (<500) the increase in size is by a
	 * minimum of a factor of 2 for optimal rehash efficiency.  For
	 * larger database sizes, this increase is reduced to avoid excess
	 * memory allocation as both scenarios requiring a rehash should not
	 * require a table size increase that large. */
	if(oldhash->buckets < 500) {
		newsize = oldhash->buckets * 2;
	} else if(oldhash->buckets < 2000) {
		newsize = oldhash->buckets * 3 / 2;
	} else if(oldhash->buckets < 5000) {
		newsize = oldhash->buckets * 4 / 3;
	} else {
		newsize = oldhash->buckets + 1;
	}

	newhash = _alpm_pkghash_create(newsize);
	if(newhash == NULL) {
		return NULL;
	}

	newhash->list = oldhash->list;
	oldhash->list = NULL;

	for(i = 0; i < oldhash->buckets; i++) {
		if(oldhash->hash_table[i] != NULL) {
			alpm_pkg_t *package = oldhash->hash_table[i]->data;
			unsigned int position = get_hash_position(package->name_hash, newhash);

			newhash->hash_table[position] = oldhash->hash_table[i];
			oldhash->hash_table[i] = NULL;
		}
	}

	newhash->entries = oldhash->entries;

	_alpm_pkghash_free(oldhash);

	return newhash;
}

static alpm_pkghash_t *pkghash_add_pkg(alpm_pkghash_t **hashref, alpm_pkg_t *pkg,
		int sorted)
{
	alpm_list_t *ptr;
	unsigned int position;
	alpm_pkghash_t *hash;

	if(pkg == NULL || hashref == NULL || *hashref == NULL) {
		return NULL;
	}
	hash = *hashref;

	if(hash->entries >= hash->limit) {
		if((hash = rehash(hash)) == NULL) {
			/* resizing failed and there are no more open buckets */
			return NULL;
		}
		*hashref = hash;
	}

	position = get_hash_position(pkg->name_hash, hash);

	MALLOC(ptr, sizeof(alpm_list_t), return NULL);

	ptr->data = pkg;
	ptr->prev = ptr;
	ptr->next = NULL;

	hash->hash_table[position] = ptr;
	if(!sorted) {
		hash->list = alpm_list_join(hash->list, ptr);
	} else {
		hash->list = alpm_list_mmerge(hash->list, ptr, _alpm_pkg_cmp);
	}

	hash->entries += 1;
	return hash;
}

alpm_pkghash_t *_alpm_pkghash_add(alpm_pkghash_t **hash, alpm_pkg_t *pkg)
{
	return pkghash_add_pkg(hash, pkg, 0);
}

alpm_pkghash_t *_alpm_pkghash_add_sorted(alpm_pkghash_t **hash, alpm_pkg_t *pkg)
{
	return pkghash_add_pkg(hash, pkg, 1);
}

static unsigned int move_one_entry(alpm_pkghash_t *hash,
		unsigned int start, unsigned int end)
{
	/* Iterate backwards from 'end' to 'start', seeing if any of the items
	 * would hash to 'start'. If we find one, we move it there and break.  If
	 * we get all the way back to position and find none that hash to it, we
	 * also end iteration. Iterating backwards helps prevent needless shuffles;
	 * we will never need to move more than one item per function call.  The
	 * return value is our current iteration location; if this is equal to
	 * 'start' we can stop this madness. */
	while(end != start) {
		alpm_list_t *i = hash->hash_table[end];
		alpm_pkg_t *info = i->data;
		unsigned int new_position = get_hash_position(info->name_hash, hash);

		if(new_position == start) {
			hash->hash_table[start] = i;
			hash->hash_table[end] = NULL;
			break;
		}

		/* the odd math ensures we are always positive, e.g.
		 * e.g. (0 - 1) % 47      == -1
		 * e.g. (47 + 0 - 1) % 47 == 46 */
		end = (hash->buckets + end - stride) % hash->buckets;
	}
	return end;
}

/**
 * @brief Remove a package from a pkghash.
 *
 * @param hash     the hash to remove the package from
 * @param pkg      the package we are removing
 * @param data     output parameter containing the removed item
 *
 * @return the resultant hash
 */
alpm_pkghash_t *_alpm_pkghash_remove(alpm_pkghash_t *hash, alpm_pkg_t *pkg,
		alpm_pkg_t **data)
{
	alpm_list_t *i;
	unsigned int position;

	if(data) {
		*data = NULL;
	}

	if(pkg == NULL || hash == NULL) {
		return hash;
	}

	position = pkg->name_hash % hash->buckets;
	while((i = hash->hash_table[position]) != NULL) {
		alpm_pkg_t *info = i->data;

		if(info->name_hash == pkg->name_hash &&
					strcmp(info->name, pkg->name) == 0) {
			unsigned int stop, prev;

			/* remove from list and hash */
			hash->list = alpm_list_remove_item(hash->list, i);
			if(data) {
				*data = info;
			}
			hash->hash_table[position] = NULL;
			free(i);
			hash->entries -= 1;

			/* Potentially move entries following removed entry to keep open
			 * addressing collision resolution working. We start by finding the
			 * next null bucket to know how far we have to look. */
			stop = position + stride;
			while(stop >= hash->buckets) {
				stop -= hash->buckets;
			}
			while(hash->hash_table[stop] != NULL && stop != position) {
				stop += stride;
				while(stop >= hash->buckets) {
					stop -= hash->buckets;
				}
			}
			stop = (hash->buckets + stop - stride) % hash->buckets;

			/* We now search backwards from stop to position. If we find an
			 * item that now hashes to position, we will move it, and then try
			 * to plug the new hole we just opened up, until we finally don't
			 * move anything. */
			while((prev = move_one_entry(hash, position, stop)) != position) {
				position = prev;
			}

			return hash;
		}

		position += stride;
		while(position >= hash->buckets) {
			position -= hash->buckets;
		}
	}

	return hash;
}

void _alpm_pkghash_free(alpm_pkghash_t *hash)
{
	if(hash != NULL) {
		unsigned int i;
		for(i = 0; i < hash->buckets; i++) {
			free(hash->hash_table[i]);
		}
		free(hash->hash_table);
	}
	free(hash);
}

alpm_pkg_t *_alpm_pkghash_find(alpm_pkghash_t *hash, const char *name)
{
	alpm_list_t *lp;
	unsigned long name_hash;
	unsigned int position;

	if(name == NULL || hash == NULL) {
		return NULL;
	}

	name_hash = _alpm_hash_sdbm(name);

	position = name_hash % hash->buckets;

	while((lp = hash->hash_table[position]) != NULL) {
		alpm_pkg_t *info = lp->data;

		if(info->name_hash == name_hash && strcmp(info->name, name) == 0) {
			return info;
		}

		position += stride;
		while(position >= hash->buckets) {
			position -= hash->buckets;
		}
	}

	return NULL;
}
