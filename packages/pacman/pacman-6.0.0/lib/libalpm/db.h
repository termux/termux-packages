/*
 *  db.h
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2006 by Miklos Vajna <vmiklos@frugalware.org>
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
#ifndef ALPM_DB_H
#define ALPM_DB_H

/* libarchive */
#include <archive.h>
#include <archive_entry.h>

#include "alpm.h"
#include "pkghash.h"
#include "signing.h"

/* Database entries */
typedef enum _alpm_dbinfrq_t {
	INFRQ_BASE = (1 << 0),
	INFRQ_DESC = (1 << 1),
	INFRQ_FILES = (1 << 2),
	INFRQ_SCRIPTLET = (1 << 3),
	INFRQ_DSIZE = (1 << 4),
	/* ALL should be info stored in the package or database */
	INFRQ_ALL = INFRQ_BASE | INFRQ_DESC | INFRQ_FILES |
		INFRQ_SCRIPTLET | INFRQ_DSIZE,
	INFRQ_ERROR = (1 << 30)
} alpm_dbinfrq_t;

/** Database status. Bitflags. */
enum _alpm_dbstatus_t {
	DB_STATUS_VALID = (1 << 0),
	DB_STATUS_INVALID = (1 << 1),
	DB_STATUS_EXISTS = (1 << 2),
	DB_STATUS_MISSING = (1 << 3),

	DB_STATUS_LOCAL = (1 << 10),
	DB_STATUS_PKGCACHE = (1 << 11),
	DB_STATUS_GRPCACHE = (1 << 12)
};

struct db_operations {
	int (*validate) (alpm_db_t *);
	int (*populate) (alpm_db_t *);
	void (*unregister) (alpm_db_t *);
};

/* Database */
struct __alpm_db_t {
	alpm_handle_t *handle;
	char *treename;
	/* do not access directly, use _alpm_db_path(db) for lazy access */
	char *_path;
	alpm_pkghash_t *pkgcache;
	alpm_list_t *grpcache;
	alpm_list_t *servers;
	const struct db_operations *ops;

	/* bitfields for validity, local, loaded caches, etc. */
	/* From _alpm_dbstatus_t */
	int status;
	/* alpm_siglevel_t */
	int siglevel;
	/* alpm_db_usage_t */
	int usage;
};


/* db.c, database general calls */
alpm_db_t *_alpm_db_new(const char *treename, int is_local);
void _alpm_db_free(alpm_db_t *db);
const char *_alpm_db_path(alpm_db_t *db);
int _alpm_db_cmp(const void *d1, const void *d2);
int _alpm_db_search(alpm_db_t *db, const alpm_list_t *needles,
		alpm_list_t **ret);
alpm_db_t *_alpm_db_register_local(alpm_handle_t *handle);
alpm_db_t *_alpm_db_register_sync(alpm_handle_t *handle, const char *treename,
		int level);
void _alpm_db_unregister(alpm_db_t *db);

/* be_*.c, backend specific calls */
int _alpm_local_db_prepare(alpm_db_t *db, alpm_pkg_t *info);
int _alpm_local_db_write(alpm_db_t *db, alpm_pkg_t *info, int inforeq);
int _alpm_local_db_remove(alpm_db_t *db, alpm_pkg_t *info);
char *_alpm_local_db_pkgpath(alpm_db_t *db, alpm_pkg_t *info, const char *filename);

/* cache bullshit */
/* packages */
void _alpm_db_free_pkgcache(alpm_db_t *db);
int _alpm_db_add_pkgincache(alpm_db_t *db, alpm_pkg_t *pkg);
int _alpm_db_remove_pkgfromcache(alpm_db_t *db, alpm_pkg_t *pkg);
alpm_pkghash_t *_alpm_db_get_pkgcache_hash(alpm_db_t *db);
alpm_list_t *_alpm_db_get_pkgcache(alpm_db_t *db);
alpm_pkg_t *_alpm_db_get_pkgfromcache(alpm_db_t *db, const char *target);
/* groups */
alpm_list_t *_alpm_db_get_groupcache(alpm_db_t *db);
alpm_group_t *_alpm_db_get_groupfromcache(alpm_db_t *db, const char *target);

#endif /* ALPM_DB_H */
