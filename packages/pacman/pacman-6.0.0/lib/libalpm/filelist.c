/*
 *  filelist.c
 *
 *  Copyright (c) 2012-2021 Pacman Development Team <pacman-dev@archlinux.org>
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

#include <limits.h>
#include <string.h>
#include <sys/stat.h>

/* libalpm */
#include "filelist.h"
#include "util.h"

/* Returns the difference of the provided two lists of files.
 * Pre-condition: both lists are sorted!
 * When done, free the list but NOT the contained data.
 */
alpm_list_t *_alpm_filelist_difference(alpm_filelist_t *filesA,
		alpm_filelist_t *filesB)
{
	alpm_list_t *ret = NULL;
	size_t ctrA = 0, ctrB = 0;

	while(ctrA < filesA->count && ctrB < filesB->count) {
		char *strA = filesA->files[ctrA].name;
		char *strB = filesB->files[ctrB].name;

		int cmp = strcmp(strA, strB);
		if(cmp < 0) {
			/* item only in filesA, qualifies as a difference */
			ret = alpm_list_add(ret, strA);
			ctrA++;
		} else if(cmp > 0) {
			ctrB++;
		} else {
			ctrA++;
			ctrB++;
		}
	}

	/* ensure we have completely emptied pA */
	while(ctrA < filesA->count) {
		ret = alpm_list_add(ret, filesA->files[ctrA].name);
		ctrA++;
	}

	return ret;
}

static int _alpm_filelist_pathcmp(const char *p1, const char *p2)
{
	while(*p1 && *p1 == *p2) {
		p1++;
		p2++;
	}

	/* skip trailing '/' */
	if(*p1 == '\0' && *p2 == '/') {
		p2++;
	} else if(*p2 == '\0' && *p1 == '/') {
		p1++;
	}

	return *p1 - *p2;
}

/* Returns the intersection of the provided two lists of files.
 * Pre-condition: both lists are sorted!
 * When done, free the list but NOT the contained data.
 */
alpm_list_t *_alpm_filelist_intersection(alpm_filelist_t *filesA,
		alpm_filelist_t *filesB)
{
	alpm_list_t *ret = NULL;
	size_t ctrA = 0, ctrB = 0;
	alpm_file_t *arrA = filesA->files, *arrB = filesB->files;

	while(ctrA < filesA->count && ctrB < filesB->count) {
		const char *strA = arrA[ctrA].name, *strB = arrB[ctrB].name;
		int cmp = _alpm_filelist_pathcmp(strA, strB);
		if(cmp < 0) {
			ctrA++;
		} else if(cmp > 0) {
			ctrB++;
		} else {
			/* when not directories, item in both qualifies as an intersect */
			if(strA[strlen(strA) - 1] != '/' || strB[strlen(strB) - 1] != '/') {
				ret = alpm_list_add(ret, arrA[ctrA].name);
			}
			ctrA++;
			ctrB++;
		}
	}

	return ret;
}

/* Helper function for comparing files list entries
 */
static int _alpm_files_cmp(const void *f1, const void *f2)
{
	const alpm_file_t *file1 = f1;
	const alpm_file_t *file2 = f2;
	return strcmp(file1->name, file2->name);
}

alpm_file_t SYMEXPORT *alpm_filelist_contains(alpm_filelist_t *filelist,
		const char *path)
{
	alpm_file_t key;

	if(!filelist) {
		return NULL;
	}

	key.name = (char *)path;

	return bsearch(&key, filelist->files, filelist->count,
			sizeof(alpm_file_t), _alpm_files_cmp);
}

void _alpm_filelist_sort(alpm_filelist_t *filelist)
{
	size_t i;
	for(i = 1; i < filelist->count; i++) {
		if(strcmp(filelist->files[i - 1].name, filelist->files[i].name) > 0) {
			/* filelist is not pre-sorted */
			qsort(filelist->files, filelist->count,
					sizeof(alpm_file_t), _alpm_files_cmp);
			return;
		}
	}
}
