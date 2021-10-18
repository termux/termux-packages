/*
 *  conflict.c
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2006 by David Kimpe <dnaku@frugalware.org>
 *  Copyright (c) 2006 by Miklos Vajna <vmiklos@frugalware.org>
 *  Copyright (c) 2006 by Christian Hamar <krics@linuxforum.hu>
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
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <sys/stat.h>
#include <dirent.h>

/* libalpm */
#include "conflict.h"
#include "alpm_list.h"
#include "alpm.h"
#include "handle.h"
#include "trans.h"
#include "util.h"
#include "log.h"
#include "deps.h"
#include "filelist.h"

/**
 * @brief Creates a new conflict.
 */
static alpm_conflict_t *conflict_new(alpm_pkg_t *pkg1, alpm_pkg_t *pkg2,
		alpm_depend_t *reason)
{
	alpm_conflict_t *conflict;

	CALLOC(conflict, 1, sizeof(alpm_conflict_t), return NULL);

	conflict->package1_hash = pkg1->name_hash;
	conflict->package2_hash = pkg2->name_hash;
	STRDUP(conflict->package1, pkg1->name, goto error);
	STRDUP(conflict->package2, pkg2->name, goto error);
	conflict->reason = reason;

	return conflict;

error:
	alpm_conflict_free(conflict);
	return NULL;
}

void SYMEXPORT alpm_conflict_free(alpm_conflict_t *conflict)
{
	ASSERT(conflict != NULL, return);
	FREE(conflict->package2);
	FREE(conflict->package1);
	FREE(conflict);
}

/**
 * @brief Creates a copy of a conflict.
 */
alpm_conflict_t *_alpm_conflict_dup(const alpm_conflict_t *conflict)
{
	alpm_conflict_t *newconflict;
	CALLOC(newconflict, 1, sizeof(alpm_conflict_t), return NULL);

	newconflict->package1_hash = conflict->package1_hash;
	newconflict->package2_hash = conflict->package2_hash;
	STRDUP(newconflict->package1, conflict->package1, goto error);
	STRDUP(newconflict->package2, conflict->package2, goto error);
	newconflict->reason = conflict->reason;

	return newconflict;

error:
	alpm_conflict_free(newconflict);
	return NULL;
}

/**
 * @brief Searches for a conflict in a list.
 *
 * @param needle conflict to search for
 * @param haystack list of conflicts to search
 *
 * @return 1 if needle is in haystack, 0 otherwise
 */
static int conflict_isin(alpm_conflict_t *needle, alpm_list_t *haystack)
{
	alpm_list_t *i;
	for(i = haystack; i; i = i->next) {
		alpm_conflict_t *conflict = i->data;
		if(needle->package1_hash == conflict->package1_hash
				&& needle->package2_hash == conflict->package2_hash
				&& strcmp(needle->package1, conflict->package1) == 0
				&& strcmp(needle->package2, conflict->package2) == 0) {
			return 1;
		}
	}

	return 0;
}

/**
 * @brief Adds the pkg1/pkg2 conflict to the baddeps list.
 *
 * @param handle the context handle
 * @param baddeps list to add conflict to
 * @param pkg1 first package
 * @param pkg2 package causing conflict
 * @param reason reason for this conflict
 *
 * @return 0 on success, -1 on error
 */
static int add_conflict(alpm_handle_t *handle, alpm_list_t **baddeps,
		alpm_pkg_t *pkg1, alpm_pkg_t *pkg2, alpm_depend_t *reason)
{
	alpm_conflict_t *conflict = conflict_new(pkg1, pkg2, reason);
	if(!conflict) {
		return -1;
	}
	if(!conflict_isin(conflict, *baddeps)) {
		char *conflict_str = alpm_dep_compute_string(reason);
		*baddeps = alpm_list_add(*baddeps, conflict);
		_alpm_log(handle, ALPM_LOG_DEBUG, "package %s conflicts with %s (by %s)\n",
				pkg1->name, pkg2->name, conflict_str);
		free(conflict_str);
	} else {
		alpm_conflict_free(conflict);
	}
	return 0;
}

/**
 * @brief Check if packages from list1 conflict with packages from list2.
 *
 * @details This looks at the conflicts fields of all packages from list1, and
 * sees if they match packages from list2. If a conflict (pkg1, pkg2) is found,
 * it is added to the baddeps list in this order if order >= 0, or reverse
 * order (pkg2,pkg1) otherwise.
 *
 * @param handle the context handle
 * @param list1 first list of packages
 * @param list2 second list of packages
 * @param baddeps list to store conflicts
 * @param order if >= 0 the conflict order is preserved, if < 0 it's reversed
 */
static void check_conflict(alpm_handle_t *handle,
		alpm_list_t *list1, alpm_list_t *list2,
		alpm_list_t **baddeps, int order)
{
	alpm_list_t *i;

	if(!baddeps) {
		return;
	}
	for(i = list1; i; i = i->next) {
		alpm_pkg_t *pkg1 = i->data;
		alpm_list_t *j;

		for(j = alpm_pkg_get_conflicts(pkg1); j; j = j->next) {
			alpm_depend_t *conflict = j->data;
			alpm_list_t *k;

			for(k = list2; k; k = k->next) {
				alpm_pkg_t *pkg2 = k->data;

				if(pkg1->name_hash == pkg2->name_hash
						&& strcmp(pkg1->name, pkg2->name) == 0) {
					/* skip the package we're currently processing */
					continue;
				}

				if(_alpm_depcmp(pkg2, conflict)) {
					if(order >= 0) {
						add_conflict(handle, baddeps, pkg1, pkg2, conflict);
					} else {
						add_conflict(handle, baddeps, pkg2, pkg1, conflict);
					}
				}
			}
		}
	}
}

/**
 * @brief Check for inter-conflicts in a list of packages.
 *
 * @param handle the context handle
 * @param packages list of packages to check
 *
 * @return list of conflicts
 */
alpm_list_t *_alpm_innerconflicts(alpm_handle_t *handle, alpm_list_t *packages)
{
	alpm_list_t *baddeps = NULL;

	_alpm_log(handle, ALPM_LOG_DEBUG, "check targets vs targets\n");
	check_conflict(handle, packages, packages, &baddeps, 0);

	return baddeps;
}

/**
 * @brief Returns a list of conflicts between a db and a list of packages.
 */
alpm_list_t *_alpm_outerconflicts(alpm_db_t *db, alpm_list_t *packages)
{
	alpm_list_t *baddeps = NULL;

	if(db == NULL) {
		return NULL;
	}

	alpm_list_t *dblist = alpm_list_diff(_alpm_db_get_pkgcache(db),
			packages, _alpm_pkg_cmp);

	/* two checks to be done here for conflicts */
	_alpm_log(db->handle, ALPM_LOG_DEBUG, "check targets vs db\n");
	check_conflict(db->handle, packages, dblist, &baddeps, 1);
	_alpm_log(db->handle, ALPM_LOG_DEBUG, "check db vs targets\n");
	check_conflict(db->handle, dblist, packages, &baddeps, -1);

	alpm_list_free(dblist);
	return baddeps;
}

alpm_list_t SYMEXPORT *alpm_checkconflicts(alpm_handle_t *handle,
		alpm_list_t *pkglist)
{
	CHECK_HANDLE(handle, return NULL);
	return _alpm_innerconflicts(handle, pkglist);
}

/**
 * @brief Creates and adds a file conflict to a conflict list.
 *
 * @param handle the context handle
 * @param conflicts the list of conflicts to append to
 * @param filestr the conflicting file path
 * @param pkg1 package that wishes to install the file
 * @param pkg2 package that currently owns the file, or NULL if unowned
 *
 * @return the updated conflict list
 */
static alpm_list_t *add_fileconflict(alpm_handle_t *handle,
		alpm_list_t *conflicts, const char *filestr,
		alpm_pkg_t *pkg1, alpm_pkg_t *pkg2)
{
	alpm_fileconflict_t *conflict;
	CALLOC(conflict, 1, sizeof(alpm_fileconflict_t), goto error);

	STRDUP(conflict->target, pkg1->name, goto error);
	STRDUP(conflict->file, filestr, goto error);
	if(!pkg2) {
		conflict->type = ALPM_FILECONFLICT_FILESYSTEM;
		STRDUP(conflict->ctarget, "", goto error);
	} else if(pkg2->origin == ALPM_PKG_FROM_LOCALDB) {
		conflict->type = ALPM_FILECONFLICT_FILESYSTEM;
		STRDUP(conflict->ctarget, pkg2->name, goto error);
	} else {
		conflict->type = ALPM_FILECONFLICT_TARGET;
		STRDUP(conflict->ctarget, pkg2->name, goto error);
	}

	conflicts = alpm_list_add(conflicts, conflict);
	_alpm_log(handle, ALPM_LOG_DEBUG, "found file conflict %s, packages %s and %s\n",
	          filestr, pkg1->name, pkg2 ? pkg2->name : "(filesystem)");

	return conflicts;

error:
	alpm_fileconflict_free(conflict);
	RET_ERR(handle, ALPM_ERR_MEMORY, conflicts);
}

void SYMEXPORT alpm_fileconflict_free(alpm_fileconflict_t *conflict)
{
	ASSERT(conflict != NULL, return);
	FREE(conflict->ctarget);
	FREE(conflict->file);
	FREE(conflict->target);
	FREE(conflict);
}

/**
 * @brief Recursively checks if a set of packages own all subdirectories and
 * files in a directory.
 *
 * @param handle the context handle
 * @param dirpath path of the directory to check
 * @param pkgs packages being checked against
 *
 * @return 1 if a package owns all subdirectories and files, 0 otherwise
 */
static int dir_belongsto_pkgs(alpm_handle_t *handle, const char *dirpath,
		alpm_list_t *pkgs)
{
	char path[PATH_MAX], full_path[PATH_MAX];
	DIR *dir;
	struct dirent *ent = NULL;

	snprintf(full_path, PATH_MAX, "%s%s", handle->root, dirpath);
	dir = opendir(full_path);
	if(dir == NULL) {
		return 0;
	}

	while((ent = readdir(dir)) != NULL) {
		const char *name = ent->d_name;
		int owned = 0, is_dir = 0;
		alpm_list_t *i;
		struct stat sbuf;

		if(strcmp(name, ".") == 0 || strcmp(name, "..") == 0) {
			continue;
		}

		snprintf(full_path, PATH_MAX, "%s%s%s", handle->root, dirpath, name);

		if(lstat(full_path, &sbuf) != 0) {
			_alpm_log(handle, ALPM_LOG_DEBUG, "could not stat %s\n", full_path);
			closedir(dir);
			return 0;
		}
		is_dir = S_ISDIR(sbuf.st_mode);

		snprintf(path, PATH_MAX, "%s%s%s", dirpath, name, is_dir ? "/" : "");

		for(i = pkgs; i && !owned; i = i->next) {
			if(alpm_filelist_contains(alpm_pkg_get_files(i->data), path)) {
				owned = 1;
			}
		}

		if(owned && is_dir) {
			owned = dir_belongsto_pkgs(handle, path, pkgs);
		}

		if(!owned) {
			closedir(dir);
			_alpm_log(handle, ALPM_LOG_DEBUG,
					"unowned file %s found in directory\n", path);
			return 0;
		}
	}
	closedir(dir);
	return 1;
}

static alpm_list_t *alpm_db_find_file_owners(alpm_db_t* db, const char *path)
{
	alpm_list_t *i, *owners = NULL;
	for(i = alpm_db_get_pkgcache(db); i; i = i->next) {
		if(alpm_filelist_contains(alpm_pkg_get_files(i->data), path)) {
			owners = alpm_list_add(owners, i->data);
		}
	}
	return owners;
}

static alpm_pkg_t *_alpm_find_file_owner(alpm_handle_t *handle, const char *path)
{
	alpm_list_t *i;
	for(i = alpm_db_get_pkgcache(handle->db_local); i; i = i->next) {
		if(alpm_filelist_contains(alpm_pkg_get_files(i->data), path)) {
			return i->data;
		}
	}
	return NULL;
}

static int _alpm_can_overwrite_file(alpm_handle_t *handle, const char *path, const char *rootedpath)
{
	return _alpm_fnmatch_patterns(handle->overwrite_files, path) == 0
		|| _alpm_fnmatch_patterns(handle->overwrite_files, rootedpath) == 0;
}

/**
 * @brief Find file conflicts that may occur during the transaction.
 *
 * @details Performs two checks:
 *   1. check every target against every target
 *   2. check every target against the filesystem
 *
 * @param handle the context handle
 * @param upgrade list of packages being installed
 * @param rem list of packages being removed
 *
 * @return list of file conflicts
 */
alpm_list_t *_alpm_db_find_fileconflicts(alpm_handle_t *handle,
		alpm_list_t *upgrade, alpm_list_t *rem)
{
	alpm_list_t *i, *conflicts = NULL;
	size_t numtargs = alpm_list_count(upgrade);
	size_t current;
	size_t rootlen;

	if(!upgrade) {
		return NULL;
	}

	rootlen = strlen(handle->root);

	/* TODO this whole function needs a huge change, which hopefully will
	 * be possible with real transactions. Right now we only do half as much
	 * here as we do when we actually extract files in add.c with our 12
	 * different cases. */
	for(current = 0, i = upgrade; i; i = i->next, current++) {
		alpm_pkg_t *p1 = i->data;
		alpm_list_t *j;
		alpm_list_t *newfiles = NULL;
		alpm_pkg_t *dbpkg;

		int percent = (current * 100) / numtargs;
		PROGRESS(handle, ALPM_PROGRESS_CONFLICTS_START, "", percent,
		         numtargs, current);

		/* CHECK 1: check every target against every target */
		_alpm_log(handle, ALPM_LOG_DEBUG, "searching for file conflicts: %s\n",
				p1->name);
		for(j = i->next; j; j = j->next) {
			alpm_list_t *common_files;
			alpm_pkg_t *p2 = j->data;

			alpm_filelist_t *p1_files = alpm_pkg_get_files(p1);
			alpm_filelist_t *p2_files = alpm_pkg_get_files(p2);

			common_files = _alpm_filelist_intersection(p1_files, p2_files);

			if(common_files) {
				alpm_list_t *k;
				char path[PATH_MAX];
				for(k = common_files; k; k = k->next) {
					char *filename = k->data;
					snprintf(path, PATH_MAX, "%s%s", handle->root, filename);

					/* can skip file-file conflicts when forced *
					 * checking presence in p2_files detects dir-file or file-dir
					 * conflicts as the path from p1 is returned */
					if(_alpm_can_overwrite_file(handle, filename, path)
							&& alpm_filelist_contains(p2_files, filename)) {
						_alpm_log(handle, ALPM_LOG_DEBUG,
							"%s exists in both '%s' and '%s'\n", filename,
							p1->name, p2->name);
						_alpm_log(handle, ALPM_LOG_DEBUG,
							"file-file conflict being forced\n");
						continue;
					}

					conflicts = add_fileconflict(handle, conflicts, path, p1, p2);
					if(handle->pm_errno == ALPM_ERR_MEMORY) {
						alpm_list_free_inner(conflicts,
								(alpm_list_fn_free) alpm_conflict_free);
						alpm_list_free(conflicts);
						alpm_list_free(common_files);
						return NULL;
					}
				}
				alpm_list_free(common_files);
			}
		}

		/* CHECK 2: check every target against the filesystem */
		_alpm_log(handle, ALPM_LOG_DEBUG, "searching for filesystem conflicts: %s\n",
				p1->name);
		dbpkg = _alpm_db_get_pkgfromcache(handle->db_local, p1->name);

		/* Do two different checks here. If the package is currently installed,
		 * then only check files that are new in the new package. If the package
		 * is not currently installed, then simply stat the whole filelist. Note
		 * that the former list needs to be freed while the latter list should NOT
		 * be freed. */
		if(dbpkg) {
			/* older ver of package currently installed */
			newfiles = _alpm_filelist_difference(alpm_pkg_get_files(p1),
					alpm_pkg_get_files(dbpkg));
		} else {
			/* no version of package currently installed */
			alpm_filelist_t *fl = alpm_pkg_get_files(p1);
			size_t filenum;
			for(filenum = 0; filenum < fl->count; filenum++) {
				newfiles = alpm_list_add(newfiles, fl->files[filenum].name);
			}
		}

		for(j = newfiles; j; j = j->next) {
			const char *filestr = j->data;
			const char *relative_path;
			alpm_list_t *k;
			/* have we acted on this conflict? */
			int resolved_conflict = 0;
			struct stat lsbuf;
			char path[PATH_MAX];
			size_t pathlen;
			int pfile_isdir;

			pathlen = snprintf(path, PATH_MAX, "%s%s", handle->root, filestr);
			relative_path = path + rootlen;

			/* stat the file - if it exists, do some checks */
			if(llstat(path, &lsbuf) != 0) {
				continue;
			}

			_alpm_log(handle, ALPM_LOG_DEBUG, "checking possible conflict: %s\n", path);

			pfile_isdir = path[pathlen - 1] == '/';
			if(pfile_isdir) {
				if(S_ISDIR(lsbuf.st_mode)) {
					_alpm_log(handle, ALPM_LOG_DEBUG, "file is a directory, not a conflict\n");
					continue;
				}
				/* if we made it to here, we want all subsequent path comparisons to
				 * not include the trailing slash. This allows things like file ->
				 * directory replacements. */
				path[pathlen - 1] = '\0';

				/* Check if the directory was a file in dbpkg */
				if(alpm_filelist_contains(alpm_pkg_get_files(dbpkg), relative_path)) {
					size_t fslen = strlen(filestr);
					_alpm_log(handle, ALPM_LOG_DEBUG,
							"replacing package file with a directory, not a conflict\n");
					resolved_conflict = 1;

					/* go ahead and skip any files inside filestr as they will
					 * necessarily be resolved by replacing the file with a dir
					 * NOTE: afterward, j will point to the last file inside filestr */
					for( ; j->next; j = j->next) {
						const char *filestr2 = j->next->data;
						if(strncmp(filestr, filestr2, fslen) != 0) {
							break;
						}
					}
				}
			}

			/* Check remove list (will we remove the conflicting local file?) */
			for(k = rem; k && !resolved_conflict; k = k->next) {
				alpm_pkg_t *rempkg = k->data;
				if(rempkg && alpm_filelist_contains(alpm_pkg_get_files(rempkg),
							relative_path)) {
					_alpm_log(handle, ALPM_LOG_DEBUG,
							"local file will be removed, not a conflict\n");
					resolved_conflict = 1;
					if(pfile_isdir) {
						/* go ahead and skip any files inside filestr as they will
						 * necessarily be resolved by replacing the file with a dir
						 * NOTE: afterward, j will point to the last file inside filestr */
						size_t fslen = strlen(filestr);
						for( ; j->next; j = j->next) {
							const char *filestr2 = j->next->data;
							if(strncmp(filestr, filestr2, fslen) != 0) {
								break;
							}
						}
					}
				}
			}

			/* Look at all the targets to see if file has changed hands */
			for(k = upgrade; k && !resolved_conflict; k = k->next) {
				alpm_pkg_t *localp2, *p2 = k->data;
				if(!p2 || p1 == p2) {
					/* skip p1; both p1 and p2 come directly from the upgrade list
					 * so they can be compared directly */
					continue;
				}
				localp2 = _alpm_db_get_pkgfromcache(handle->db_local, p2->name);

				/* localp2->files will be removed (target conflicts are handled by CHECK 1) */
				if(localp2 && alpm_filelist_contains(alpm_pkg_get_files(localp2), relative_path)) {
					size_t fslen = strlen(filestr);

					/* skip removal of file, but not add. this will prevent a second
					 * package from removing the file when it was already installed
					 * by its new owner (whether the file is in backup array or not */
					handle->trans->skip_remove =
						alpm_list_add(handle->trans->skip_remove, strdup(relative_path));
					_alpm_log(handle, ALPM_LOG_DEBUG,
							"file changed packages, adding to remove skiplist\n");
					resolved_conflict = 1;

					if(filestr[fslen - 1] == '/') {
						/* replacing a file with a directory:
						 * go ahead and skip any files inside filestr as they will
						 * necessarily be resolved by replacing the file with a dir
						 * NOTE: afterward, j will point to the last file inside filestr */
						for( ; j->next; j = j->next) {
							const char *filestr2 = j->next->data;
							if(strncmp(filestr, filestr2, fslen) != 0) {
								break;
							}
						}
					}
				}
			}

			/* check if all files of the dir belong to the installed pkg */
			if(!resolved_conflict && S_ISDIR(lsbuf.st_mode)) {
				alpm_list_t *owners;
				char *dir = malloc(strlen(relative_path) + 2);
				sprintf(dir, "%s/", relative_path);

				owners = alpm_db_find_file_owners(handle->db_local, dir);
				if(owners) {
					alpm_list_t *pkgs = NULL, *diff;

					if(dbpkg) {
						pkgs = alpm_list_add(pkgs, dbpkg);
					}
					pkgs = alpm_list_join(pkgs, alpm_list_copy(rem));
					if((diff = alpm_list_diff(owners, pkgs, _alpm_pkg_cmp))) {
						/* dir is owned by files we aren't removing */
						/* TODO: with better commit ordering, we may be able to check
						 * against upgrades as well */
						alpm_list_free(diff);
					} else {
						_alpm_log(handle, ALPM_LOG_DEBUG,
								"checking if all files in %s belong to removed packages\n",
								dir);
						resolved_conflict = dir_belongsto_pkgs(handle, dir, owners);
					}
					alpm_list_free(pkgs);
					alpm_list_free(owners);
				}
				free(dir);
			}

			/* is the file unowned and in the backup list of the new package? */
			if(!resolved_conflict && _alpm_needbackup(relative_path, p1)) {
				alpm_list_t *local_pkgs = _alpm_db_get_pkgcache(handle->db_local);
				int found = 0;
				for(k = local_pkgs; k && !found; k = k->next) {
					if(alpm_filelist_contains(alpm_pkg_get_files(k->data), relative_path)) {
							found = 1;
					}
				}
				if(!found) {
					_alpm_log(handle, ALPM_LOG_DEBUG,
							"file was unowned but in new backup list\n");
					resolved_conflict = 1;
				}
			}

			/* skip file-file conflicts when being forced */
			if(!S_ISDIR(lsbuf.st_mode)
					&& _alpm_can_overwrite_file(handle, filestr, path)) {
				_alpm_log(handle, ALPM_LOG_DEBUG,
							"conflict with file on filesystem being forced\n");
				resolved_conflict = 1;
			}

			if(!resolved_conflict) {
				conflicts = add_fileconflict(handle, conflicts, path, p1,
						_alpm_find_file_owner(handle, relative_path));
				if(handle->pm_errno == ALPM_ERR_MEMORY) {
					alpm_list_free_inner(conflicts,
							(alpm_list_fn_free) alpm_conflict_free);
					alpm_list_free(conflicts);
					alpm_list_free(newfiles);
					return NULL;
				}
			}
		}
		alpm_list_free(newfiles);
	}
	PROGRESS(handle, ALPM_PROGRESS_CONFLICTS_START, "", 100,
			numtargs, current);

	return conflicts;
}
