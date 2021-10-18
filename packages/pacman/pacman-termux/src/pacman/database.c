/*
 *  database.c
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

#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>

#include <alpm.h>
#include <alpm_list.h>

/* pacman */
#include "pacman.h"
#include "conf.h"
#include "util.h"

/**
 * @brief Modify the 'local' package database.
 *
 * @param targets a list of packages (as strings) to modify
 *
 * @return 0 on success, 1 on failure
 */
static int change_install_reason(alpm_list_t *targets)
{
	alpm_list_t *i;
	alpm_db_t *db_local;
	int ret = 0;

	alpm_pkgreason_t reason;

	if(targets == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("no targets specified (use -h for help)\n"));
		return 1;
	}

	if(config->flags & ALPM_TRANS_FLAG_ALLDEPS) { /* --asdeps */
		reason = ALPM_PKG_REASON_DEPEND;
	} else if(config->flags & ALPM_TRANS_FLAG_ALLEXPLICIT) { /* --asexplicit */
		reason = ALPM_PKG_REASON_EXPLICIT;
	} else {
		pm_printf(ALPM_LOG_ERROR, _("no install reason specified (use -h for help)\n"));
		return 1;
	}

	/* Lock database */
	if(trans_init(0, 0) == -1) {
		return 1;
	}

	db_local = alpm_get_localdb(config->handle);
	for(i = targets; i; i = alpm_list_next(i)) {
		char *pkgname = i->data;
		alpm_pkg_t *pkg = alpm_db_get_pkg(db_local, pkgname);
		if(!pkg || alpm_pkg_set_reason(pkg, reason)) {
			pm_printf(ALPM_LOG_ERROR, _("could not set install reason for package %s (%s)\n"),
							pkgname, alpm_strerror(alpm_errno(config->handle)));
			ret = 1;
		} else {
			if(!config->quiet) {
				if(reason == ALPM_PKG_REASON_DEPEND) {
					printf(_("%s: install reason has been set to 'installed as dependency'\n"), pkgname);
				} else {
					printf(_("%s: install reason has been set to 'explicitly installed'\n"), pkgname);
				}
			}
		}
	}

	/* Unlock database */
	if(trans_release() == -1) {
		return 1;
	}
	return ret;
}

static int check_db_missing_deps(alpm_list_t *pkglist)
{
	alpm_list_t *data, *i;
	int ret = 0;
	/* check dependencies */
	data = alpm_checkdeps(config->handle, NULL, NULL, pkglist, 0);
	for(i = data; i; i = alpm_list_next(i)) {
		alpm_depmissing_t *miss = i->data;
		char *depstring = alpm_dep_compute_string(miss->depend);
		pm_printf(ALPM_LOG_ERROR, "missing '%s' dependency for '%s'\n",
				depstring, miss->target);
		free(depstring);
		ret++;
	}
	alpm_list_free_inner(data, (alpm_list_fn_free)alpm_depmissing_free);
	alpm_list_free(data);
	return ret;
}

static int check_db_local_files(void)
{
	struct dirent *ent;
	const char *dbpath;
	char path[PATH_MAX];
	int ret = 0;
	DIR *dbdir;

	dbpath = alpm_option_get_dbpath(config->handle);
	snprintf(path, PATH_MAX, "%slocal", dbpath);
	if(!(dbdir = opendir(path))) {
		pm_printf(ALPM_LOG_ERROR, "could not open local database directory %s: %s\n",
				path, strerror(errno));
		return 1;
	}

	while((ent = readdir(dbdir)) != NULL) {
		if(strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0
				|| strcmp(ent->d_name, "ALPM_DB_VERSION") == 0) {
			continue;
		}
		/* check for expected db files in local database */
		snprintf(path, PATH_MAX, "%slocal/%s/desc", dbpath, ent->d_name);
		if(access(path, F_OK)) {
			pm_printf(ALPM_LOG_ERROR, "'%s': description file is missing\n", ent->d_name);
			ret++;
		}
		snprintf(path, PATH_MAX, "%slocal/%s/files", dbpath, ent->d_name);
		if(access(path, F_OK)) {
			pm_printf(ALPM_LOG_ERROR, "'%s': file list is missing\n", ent->d_name);
			ret++;
		}
	}
	closedir(dbdir);

	return ret;
}

static int check_db_local_package_conflicts(alpm_list_t *pkglist)
{
	alpm_list_t *data, *i;
	int ret = 0;
	/* check conflicts */
	data = alpm_checkconflicts(config->handle, pkglist);
	for(i = data; i; i = i->next) {
		alpm_conflict_t *conflict = i->data;
		pm_printf(ALPM_LOG_ERROR, "'%s' conflicts with '%s'\n",
				conflict->package1, conflict->package2);
		ret++;
	}
	alpm_list_free_inner(data, (alpm_list_fn_free)alpm_conflict_free);
	alpm_list_free(data);
	return ret;
}

struct fileitem {
	alpm_file_t *file;
	alpm_pkg_t *pkg;
};

static int fileitem_cmp(const void *p1, const void *p2)
{
	const struct fileitem * fi1 = p1;
	const struct fileitem * fi2 = p2;
	return strcmp(fi1->file->name, fi2->file->name);
}

static int check_db_local_filelist_conflicts(alpm_list_t *pkglist)
{
	alpm_list_t *i;
	int ret = 0;
	size_t list_size = 4096;
	size_t offset = 0, j;
	struct fileitem *all_files;
	struct fileitem *prev_fileitem = NULL;

	all_files = malloc(list_size * sizeof(struct fileitem));

	for(i = pkglist; i; i = i->next) {
		alpm_pkg_t *pkg = i->data;
		alpm_filelist_t *filelist = alpm_pkg_get_files(pkg);
		for(j = 0; j < filelist->count; j++) {
			alpm_file_t *file = filelist->files + j;
			/* only add files, not directories, to our big list */
			if(file->name[strlen(file->name) - 1] == '/') {
				continue;
			}

			/* do we need to reallocate and grow our array? */
			if(offset >= list_size) {
				struct fileitem *new_files;
				new_files = realloc(all_files, list_size * 2 * sizeof(struct fileitem));
				if(!new_files) {
					free(all_files);
					return 1;
				}
				all_files = new_files;
				list_size *= 2;
			}

			/* we can finally add it to the list */
			all_files[offset].file = file;
			all_files[offset].pkg = pkg;
			offset++;
		}
	}

	/* now sort the list so we can find duplicates */
	qsort(all_files, offset, sizeof(struct fileitem), fileitem_cmp);

	/* do a 'uniq' style check on the list */
	for(j = 0; j < offset; j++) {
		struct fileitem *fileitem = all_files + j;
		if(prev_fileitem && fileitem_cmp(prev_fileitem, fileitem) == 0) {
			pm_printf(ALPM_LOG_ERROR, "file owned by '%s' and '%s': '%s'\n",
					alpm_pkg_get_name(prev_fileitem->pkg),
					alpm_pkg_get_name(fileitem->pkg),
					fileitem->file->name);
		}
		prev_fileitem = fileitem;
	}

	free(all_files);
	return ret;
}

/**
 * @brief Check 'local' package database for consistency
 *
 * @return 0 on success, >=1 on failure
 */
static int check_db_local(void) {
	int ret = 0;
	alpm_db_t *db = NULL;
	alpm_list_t *pkglist;

	ret = check_db_local_files();
	if(ret) {
		return ret;
	}

	db = alpm_get_localdb(config->handle);
	pkglist = alpm_db_get_pkgcache(db);
	ret += check_db_missing_deps(pkglist);
	ret += check_db_local_package_conflicts(pkglist);
	ret += check_db_local_filelist_conflicts(pkglist);

	return ret;
}

/**
 * @brief Check 'sync' package databases for consistency
 *
 * @return 0 on success, >=1 on failure
 */
static int check_db_sync(void) {
	int ret = 0;
	alpm_list_t *i, *dblist, *pkglist, *syncpkglist = NULL;

	dblist = alpm_get_syncdbs(config->handle);
	for(i = dblist; i; i = alpm_list_next(i)) {
		pkglist = alpm_db_get_pkgcache(i->data);
		syncpkglist = alpm_list_join(syncpkglist, alpm_list_copy(pkglist));
	}
	ret = check_db_missing_deps(syncpkglist);

	alpm_list_free(syncpkglist);
	return ret;
}

int pacman_database(alpm_list_t *targets)
{
	int ret = 0;

	if(config->op_q_check) {
		if(config->op_q_check == 1) {
			ret = check_db_local();
		} else {
			ret = check_db_sync();
		}

		if(ret == 0 && !config->quiet) {
			printf(_("No database errors have been found!\n"));
		}
	}

	if(config->flags & (ALPM_TRANS_FLAG_ALLDEPS | ALPM_TRANS_FLAG_ALLEXPLICIT)) {
		ret = change_install_reason(targets);
	}

	return ret;
}
