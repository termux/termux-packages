/*
 *  db.c
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2005 by Christian Hamar <krics@linuxforum.hu>
 *  Copyright (c) 2006 by David Kimpe <dnaku@frugalware.org>
 *  Copyright (c) 2005, 2006 by Miklos Vajna <vmiklos@frugalware.org>
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>

/* libalpm */
#include "db.h"
#include "alpm_list.h"
#include "log.h"
#include "util.h"
#include "handle.h"
#include "alpm.h"
#include "package.h"
#include "group.h"

alpm_db_t SYMEXPORT *alpm_register_syncdb(alpm_handle_t *handle,
		const char *treename, int siglevel)
{
	alpm_list_t *i;

	/* Sanity checks */
	CHECK_HANDLE(handle, return NULL);
	ASSERT(treename != NULL && strlen(treename) != 0,
			RET_ERR(handle, ALPM_ERR_WRONG_ARGS, NULL));
	ASSERT(!strchr(treename, '/'), RET_ERR(handle, ALPM_ERR_WRONG_ARGS, NULL));
	/* Do not register a database if a transaction is on-going */
	ASSERT(handle->trans == NULL, RET_ERR(handle, ALPM_ERR_TRANS_NOT_NULL, NULL));

	/* ensure database name is unique */
	if(strcmp(treename, "local") == 0) {
		RET_ERR(handle, ALPM_ERR_DB_NOT_NULL, NULL);
	}
	for(i = handle->dbs_sync; i; i = i->next) {
		alpm_db_t *d = i->data;
		if(strcmp(treename, d->treename) == 0) {
			RET_ERR(handle, ALPM_ERR_DB_NOT_NULL, NULL);
		}
	}

	return _alpm_db_register_sync(handle, treename, siglevel);
}

/* Helper function for alpm_db_unregister{_all} */
void _alpm_db_unregister(alpm_db_t *db)
{
	if(db == NULL) {
		return;
	}

	_alpm_log(db->handle, ALPM_LOG_DEBUG, "unregistering database '%s'\n", db->treename);
	_alpm_db_free(db);
}

int SYMEXPORT alpm_unregister_all_syncdbs(alpm_handle_t *handle)
{
	alpm_list_t *i;
	alpm_db_t *db;

	/* Sanity checks */
	CHECK_HANDLE(handle, return -1);
	/* Do not unregister a database if a transaction is on-going */
	ASSERT(handle->trans == NULL, RET_ERR(handle, ALPM_ERR_TRANS_NOT_NULL, -1));

	/* unregister all sync dbs */
	for(i = handle->dbs_sync; i; i = i->next) {
		db = i->data;
		db->ops->unregister(db);
		i->data = NULL;
	}
	FREELIST(handle->dbs_sync);
	return 0;
}

int SYMEXPORT alpm_db_unregister(alpm_db_t *db)
{
	int found = 0;
	alpm_handle_t *handle;

	/* Sanity checks */
	ASSERT(db != NULL, return -1);
	/* Do not unregister a database if a transaction is on-going */
	handle = db->handle;
	handle->pm_errno = ALPM_ERR_OK;
	ASSERT(handle->trans == NULL, RET_ERR(handle, ALPM_ERR_TRANS_NOT_NULL, -1));

	if(db == handle->db_local) {
		handle->db_local = NULL;
		found = 1;
	} else {
		/* Warning : this function shouldn't be used to unregister all sync
		 * databases by walking through the list returned by
		 * alpm_get_syncdbs, because the db is removed from that list here.
		 */
		void *data;
		handle->dbs_sync = alpm_list_remove(handle->dbs_sync,
				db, _alpm_db_cmp, &data);
		if(data) {
			found = 1;
		}
	}

	if(!found) {
		RET_ERR(handle, ALPM_ERR_DB_NOT_FOUND, -1);
	}

	db->ops->unregister(db);
	return 0;
}

alpm_list_t SYMEXPORT *alpm_db_get_servers(const alpm_db_t *db)
{
	ASSERT(db != NULL, return NULL);
	return db->servers;
}

int SYMEXPORT alpm_db_set_servers(alpm_db_t *db, alpm_list_t *servers)
{
	alpm_list_t *i;
	ASSERT(db != NULL, return -1);
	FREELIST(db->servers);
	for(i = servers; i; i = i->next) {
		char *url = i->data;
		if(alpm_db_add_server(db, url) != 0) {
			return -1;
		}
	}
	return 0;
}

static char *sanitize_url(const char *url)
{
	char *newurl;
	size_t len = strlen(url);

	STRDUP(newurl, url, return NULL);
	/* strip the trailing slash if one exists */
	if(newurl[len - 1] == '/') {
		newurl[len - 1] = '\0';
	}
	return newurl;
}

int SYMEXPORT alpm_db_add_server(alpm_db_t *db, const char *url)
{
	char *newurl;

	/* Sanity checks */
	ASSERT(db != NULL, return -1);
	db->handle->pm_errno = ALPM_ERR_OK;
	ASSERT(url != NULL && strlen(url) != 0, RET_ERR(db->handle, ALPM_ERR_WRONG_ARGS, -1));

	newurl = sanitize_url(url);
	if(!newurl) {
		return -1;
	}
	db->servers = alpm_list_add(db->servers, newurl);
	_alpm_log(db->handle, ALPM_LOG_DEBUG, "adding new server URL to database '%s': %s\n",
			db->treename, newurl);

	return 0;
}

int SYMEXPORT alpm_db_remove_server(alpm_db_t *db, const char *url)
{
	char *newurl, *vdata = NULL;
	int ret = 1;

	/* Sanity checks */
	ASSERT(db != NULL, return -1);
	db->handle->pm_errno = ALPM_ERR_OK;
	ASSERT(url != NULL && strlen(url) != 0, RET_ERR(db->handle, ALPM_ERR_WRONG_ARGS, -1));

	newurl = sanitize_url(url);
	if(!newurl) {
		return -1;
	}

	db->servers = alpm_list_remove_str(db->servers, newurl, &vdata);

	if(vdata) {
		_alpm_log(db->handle, ALPM_LOG_DEBUG, "removed server URL from database '%s': %s\n",
				db->treename, newurl);
		free(vdata);
		ret = 0;
	}

	free(newurl);
	return ret;
}

const char SYMEXPORT *alpm_db_get_name(const alpm_db_t *db)
{
	ASSERT(db != NULL, return NULL);
	return db->treename;
}

int SYMEXPORT alpm_db_get_siglevel(alpm_db_t *db)
{
	ASSERT(db != NULL, return -1);
	if(db->siglevel & ALPM_SIG_USE_DEFAULT) {
		return db->handle->siglevel;
	} else {
		return db->siglevel;
	}
}

int SYMEXPORT alpm_db_get_valid(alpm_db_t *db)
{
	ASSERT(db != NULL, return -1);
	db->handle->pm_errno = ALPM_ERR_OK;
	return db->ops->validate(db);
}

alpm_pkg_t SYMEXPORT *alpm_db_get_pkg(alpm_db_t *db, const char *name)
{
	alpm_pkg_t *pkg;
	ASSERT(db != NULL, return NULL);
	db->handle->pm_errno = ALPM_ERR_OK;
	ASSERT(name != NULL && strlen(name) != 0,
			RET_ERR(db->handle, ALPM_ERR_WRONG_ARGS, NULL));

	pkg = _alpm_db_get_pkgfromcache(db, name);
	if(!pkg) {
		RET_ERR(db->handle, ALPM_ERR_PKG_NOT_FOUND, NULL);
	}
	return pkg;
}

alpm_list_t SYMEXPORT *alpm_db_get_pkgcache(alpm_db_t *db)
{
	ASSERT(db != NULL, return NULL);
	db->handle->pm_errno = ALPM_ERR_OK;
	return _alpm_db_get_pkgcache(db);
}

alpm_group_t SYMEXPORT *alpm_db_get_group(alpm_db_t *db, const char *name)
{
	ASSERT(db != NULL, return NULL);
	db->handle->pm_errno = 0;
	ASSERT(name != NULL && strlen(name) != 0,
			RET_ERR(db->handle, ALPM_ERR_WRONG_ARGS, NULL));

	return _alpm_db_get_groupfromcache(db, name);
}

alpm_list_t SYMEXPORT *alpm_db_get_groupcache(alpm_db_t *db)
{
	ASSERT(db != NULL, return NULL);
	db->handle->pm_errno = ALPM_ERR_OK;

	return _alpm_db_get_groupcache(db);
}

int SYMEXPORT alpm_db_search(alpm_db_t *db, const alpm_list_t *needles,
		alpm_list_t **ret)
{
	ASSERT(db != NULL && ret != NULL && *ret == NULL,
			RET_ERR(db->handle, ALPM_ERR_WRONG_ARGS, -1));
	db->handle->pm_errno = ALPM_ERR_OK;

	return _alpm_db_search(db, needles, ret);
}

int SYMEXPORT alpm_db_set_usage(alpm_db_t *db, int usage)
{
	ASSERT(db != NULL, return -1);
	db->usage = usage;
	return 0;
}

int SYMEXPORT alpm_db_get_usage(alpm_db_t *db, int *usage)
{
	ASSERT(db != NULL, return -1);
	ASSERT(usage != NULL, return -1);
	*usage = db->usage;
	return 0;
}

alpm_db_t *_alpm_db_new(const char *treename, int is_local)
{
	alpm_db_t *db;

	CALLOC(db, 1, sizeof(alpm_db_t), return NULL);
	STRDUP(db->treename, treename, FREE(db); return NULL);
	if(is_local) {
		db->status |= DB_STATUS_LOCAL;
	} else {
		db->status &= ~DB_STATUS_LOCAL;
	}
	db->usage = ALPM_DB_USAGE_ALL;

	return db;
}

void _alpm_db_free(alpm_db_t *db)
{
	ASSERT(db != NULL, return);
	/* cleanup pkgcache */
	_alpm_db_free_pkgcache(db);
	/* cleanup server list */
	FREELIST(db->servers);
	FREE(db->_path);
	FREE(db->treename);
	FREE(db);

	return;
}

const char *_alpm_db_path(alpm_db_t *db)
{
	if(!db) {
		return NULL;
	}
	if(!db->_path) {
		const char *dbpath;
		size_t pathsize;

		dbpath = db->handle->dbpath;
		if(!dbpath) {
			_alpm_log(db->handle, ALPM_LOG_ERROR, _("database path is undefined\n"));
			RET_ERR(db->handle, ALPM_ERR_DB_OPEN, NULL);
		}

		if(db->status & DB_STATUS_LOCAL) {
			pathsize = strlen(dbpath) + strlen(db->treename) + 2;
			CALLOC(db->_path, 1, pathsize, RET_ERR(db->handle, ALPM_ERR_MEMORY, NULL));
			sprintf(db->_path, "%s%s/", dbpath, db->treename);
		} else {
			const char *dbext = db->handle->dbext;

			pathsize = strlen(dbpath) + 5 + strlen(db->treename) + strlen(dbext) + 1;
			CALLOC(db->_path, 1, pathsize, RET_ERR(db->handle, ALPM_ERR_MEMORY, NULL));
			/* all sync DBs now reside in the sync/ subdir of the dbpath */
			sprintf(db->_path, "%ssync/%s%s", dbpath, db->treename, dbext);
		}
		_alpm_log(db->handle, ALPM_LOG_DEBUG, "database path for tree %s set to %s\n",
				db->treename, db->_path);
	}
	return db->_path;
}

int _alpm_db_cmp(const void *d1, const void *d2)
{
	const alpm_db_t *db1 = d1;
	const alpm_db_t *db2 = d2;
	return strcmp(db1->treename, db2->treename);
}

int _alpm_db_search(alpm_db_t *db, const alpm_list_t *needles,
		alpm_list_t **ret)
{
	const alpm_list_t *i, *j, *k;

	if(!(db->usage & ALPM_DB_USAGE_SEARCH)) {
		return 0;
	}

	/* copy the pkgcache- we will free the list var after each needle */
	alpm_list_t *list = alpm_list_copy(_alpm_db_get_pkgcache(db));

	for(i = needles; i; i = i->next) {
		char *targ;
		regex_t reg;

		if(i->data == NULL) {
			continue;
		}
		*ret = NULL;
		targ = i->data;
		_alpm_log(db->handle, ALPM_LOG_DEBUG, "searching for target '%s'\n", targ);

		if(regcomp(&reg, targ, REG_EXTENDED | REG_NOSUB | REG_ICASE | REG_NEWLINE) != 0) {
			db->handle->pm_errno = ALPM_ERR_INVALID_REGEX;
			alpm_list_free(list);
			alpm_list_free(*ret);
			return -1;
		}

		for(j = list; j; j = j->next) {
			alpm_pkg_t *pkg = j->data;
			const char *matched = NULL;
			const char *name = pkg->name;
			const char *desc = alpm_pkg_get_desc(pkg);

			/* check name as regex AND as plain text */
			if(name && (regexec(&reg, name, 0, 0, 0) == 0 || strstr(name, targ))) {
				matched = name;
			}
			/* check desc */
			else if(desc && regexec(&reg, desc, 0, 0, 0) == 0) {
				matched = desc;
			}
			/* TODO: should we be doing this, and should we print something
			 * differently when we do match it since it isn't currently printed? */
			if(!matched) {
				/* check provides */
				for(k = alpm_pkg_get_provides(pkg); k; k = k->next) {
					alpm_depend_t *provide = k->data;
					if(regexec(&reg, provide->name, 0, 0, 0) == 0) {
						matched = provide->name;
						break;
					}
				}
			}
			if(!matched) {
				/* check groups */
				for(k = alpm_pkg_get_groups(pkg); k; k = k->next) {
					if(regexec(&reg, k->data, 0, 0, 0) == 0) {
						matched = k->data;
						break;
					}
				}
			}

			if(matched != NULL) {
				_alpm_log(db->handle, ALPM_LOG_DEBUG,
						"search target '%s' matched '%s' on package '%s'\n",
						targ, matched, name);
				*ret = alpm_list_add(*ret, pkg);
			}
		}

		/* Free the existing search list, and use the returned list for the
		 * next needle. This allows for AND-based package searching. */
		alpm_list_free(list);
		list = *ret;
		regfree(&reg);
	}

	return 0;
}

/* Returns a new package cache from db.
 * It frees the cache if it already exists.
 */
static int load_pkgcache(alpm_db_t *db)
{
	_alpm_db_free_pkgcache(db);

	_alpm_log(db->handle, ALPM_LOG_DEBUG, "loading package cache for repository '%s'\n",
			db->treename);
	if(db->ops->populate(db) == -1) {
		_alpm_log(db->handle, ALPM_LOG_DEBUG,
				"failed to load package cache for repository '%s'\n", db->treename);
		return -1;
	}

	db->status |= DB_STATUS_PKGCACHE;
	return 0;
}

static void free_groupcache(alpm_db_t *db)
{
	alpm_list_t *lg;

	if(db == NULL || !(db->status & DB_STATUS_GRPCACHE)) {
		return;
	}

	_alpm_log(db->handle, ALPM_LOG_DEBUG,
			"freeing group cache for repository '%s'\n", db->treename);

	for(lg = db->grpcache; lg; lg = lg->next) {
		_alpm_group_free(lg->data);
		lg->data = NULL;
	}
	FREELIST(db->grpcache);
	db->status &= ~DB_STATUS_GRPCACHE;
}

void _alpm_db_free_pkgcache(alpm_db_t *db)
{
	if(db == NULL || !(db->status & DB_STATUS_PKGCACHE)) {
		return;
	}

	_alpm_log(db->handle, ALPM_LOG_DEBUG,
			"freeing package cache for repository '%s'\n", db->treename);

	if(db->pkgcache) {
		alpm_list_free_inner(db->pkgcache->list,
				(alpm_list_fn_free)_alpm_pkg_free);
		_alpm_pkghash_free(db->pkgcache);
	}
	db->status &= ~DB_STATUS_PKGCACHE;

	free_groupcache(db);
}

alpm_pkghash_t *_alpm_db_get_pkgcache_hash(alpm_db_t *db)
{
	if(db == NULL) {
		return NULL;
	}

	if(!(db->status & DB_STATUS_VALID)) {
		RET_ERR(db->handle, ALPM_ERR_DB_INVALID, NULL);
	}

	if(!(db->status & DB_STATUS_PKGCACHE)) {
		if(load_pkgcache(db)) {
			/* handle->error set in local/sync-db-populate */
			return NULL;
		}
	}

	return db->pkgcache;
}

alpm_list_t *_alpm_db_get_pkgcache(alpm_db_t *db)
{
	alpm_pkghash_t *hash = _alpm_db_get_pkgcache_hash(db);

	if(hash == NULL) {
		return NULL;
	}

	return hash->list;
}

/* "duplicate" pkg then add it to pkgcache */
int _alpm_db_add_pkgincache(alpm_db_t *db, alpm_pkg_t *pkg)
{
	alpm_pkg_t *newpkg = NULL;

	if(db == NULL || pkg == NULL || !(db->status & DB_STATUS_PKGCACHE)) {
		return -1;
	}

	if(_alpm_pkg_dup(pkg, &newpkg)) {
		/* we return memory on "non-fatal" error in _alpm_pkg_dup */
		_alpm_pkg_free(newpkg);
		return -1;
	}

	_alpm_log(db->handle, ALPM_LOG_DEBUG, "adding entry '%s' in '%s' cache\n",
						newpkg->name, db->treename);
	if(newpkg->origin == ALPM_PKG_FROM_FILE) {
		free(newpkg->origin_data.file);
	}
	newpkg->origin = (db->status & DB_STATUS_LOCAL)
		? ALPM_PKG_FROM_LOCALDB
		: ALPM_PKG_FROM_SYNCDB;
	newpkg->origin_data.db = db;
	if(_alpm_pkghash_add_sorted(&db->pkgcache, newpkg) == NULL) {
		_alpm_pkg_free(newpkg);
		RET_ERR(db->handle, ALPM_ERR_MEMORY, -1);
	}

	free_groupcache(db);

	return 0;
}

int _alpm_db_remove_pkgfromcache(alpm_db_t *db, alpm_pkg_t *pkg)
{
	alpm_pkg_t *data = NULL;

	if(db == NULL || pkg == NULL || !(db->status & DB_STATUS_PKGCACHE)) {
		return -1;
	}

	_alpm_log(db->handle, ALPM_LOG_DEBUG, "removing entry '%s' from '%s' cache\n",
						pkg->name, db->treename);

	db->pkgcache = _alpm_pkghash_remove(db->pkgcache, pkg, &data);
	if(data == NULL) {
		/* package not found */
		_alpm_log(db->handle, ALPM_LOG_DEBUG, "cannot remove entry '%s' from '%s' cache: not found\n",
							pkg->name, db->treename);
		return -1;
	}

	_alpm_pkg_free(data);

	free_groupcache(db);

	return 0;
}

alpm_pkg_t *_alpm_db_get_pkgfromcache(alpm_db_t *db, const char *target)
{
	if(db == NULL) {
		return NULL;
	}

	alpm_pkghash_t *pkgcache = _alpm_db_get_pkgcache_hash(db);
	if(!pkgcache) {
		return NULL;
	}

	return _alpm_pkghash_find(pkgcache, target);
}

/* Returns a new group cache from db.
 */
static int load_grpcache(alpm_db_t *db)
{
	alpm_list_t *lp;

	if(db == NULL) {
		return -1;
	}

	_alpm_log(db->handle, ALPM_LOG_DEBUG, "loading group cache for repository '%s'\n",
			db->treename);

	for(lp = _alpm_db_get_pkgcache(db); lp; lp = lp->next) {
		const alpm_list_t *i;
		alpm_pkg_t *pkg = lp->data;

		for(i = alpm_pkg_get_groups(pkg); i; i = i->next) {
			const char *grpname = i->data;
			alpm_list_t *j;
			alpm_group_t *grp = NULL;
			int found = 0;

			/* first look through the group cache for a group with this name */
			for(j = db->grpcache; j; j = j->next) {
				grp = j->data;

				if(strcmp(grp->name, grpname) == 0
						&& !alpm_list_find_ptr(grp->packages, pkg)) {
					grp->packages = alpm_list_add(grp->packages, pkg);
					found = 1;
					break;
				}
			}
			if(found) {
				continue;
			}
			/* we didn't find the group, so create a new one with this name */
			grp = _alpm_group_new(grpname);
			if(!grp) {
				free_groupcache(db);
				return -1;
			}
			grp->packages = alpm_list_add(grp->packages, pkg);
			db->grpcache = alpm_list_add(db->grpcache, grp);
		}
	}

	db->status |= DB_STATUS_GRPCACHE;
	return 0;
}

alpm_list_t *_alpm_db_get_groupcache(alpm_db_t *db)
{
	if(db == NULL) {
		return NULL;
	}

	if(!(db->status & DB_STATUS_VALID)) {
		RET_ERR(db->handle, ALPM_ERR_DB_INVALID, NULL);
	}

	if(!(db->status & DB_STATUS_GRPCACHE)) {
		load_grpcache(db);
	}

	return db->grpcache;
}

alpm_group_t *_alpm_db_get_groupfromcache(alpm_db_t *db, const char *target)
{
	alpm_list_t *i;

	if(db == NULL || target == NULL || strlen(target) == 0) {
		return NULL;
	}

	for(i = _alpm_db_get_groupcache(db); i; i = i->next) {
		alpm_group_t *info = i->data;

		if(strcmp(info->name, target) == 0) {
			return info;
		}
	}

	return NULL;
}
