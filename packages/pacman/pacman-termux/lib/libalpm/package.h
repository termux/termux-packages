/*
 *  package.h
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2006 by David Kimpe <dnaku@frugalware.org>
 *  Copyright (c) 2005, 2006 by Christian Hamar <krics@linuxforum.hu>
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
#ifndef ALPM_PACKAGE_H
#define ALPM_PACKAGE_H

#include <sys/types.h> /* off_t */

/* libarchive */
#include <archive.h>
#include <archive_entry.h>

#include "alpm.h"
#include "backup.h"
#include "db.h"
#include "signing.h"

/** Package operations struct. This struct contains function pointers to
 * all methods used to access data in a package to allow for things such
 * as lazy package initialization (such as used by the file backend). Each
 * backend is free to define a struct containing pointers to a specific
 * implementation of these methods. Some backends may find using the
 * defined default_pkg_ops struct to work just fine for their needs.
 */
struct pkg_operations {
	const char *(*get_base) (alpm_pkg_t *);
	const char *(*get_desc) (alpm_pkg_t *);
	const char *(*get_url) (alpm_pkg_t *);
	alpm_time_t (*get_builddate) (alpm_pkg_t *);
	alpm_time_t (*get_installdate) (alpm_pkg_t *);
	const char *(*get_packager) (alpm_pkg_t *);
	const char *(*get_arch) (alpm_pkg_t *);
	off_t (*get_isize) (alpm_pkg_t *);
	alpm_pkgreason_t (*get_reason) (alpm_pkg_t *);
	int (*get_validation) (alpm_pkg_t *);
	int (*has_scriptlet) (alpm_pkg_t *);

	alpm_list_t *(*get_licenses) (alpm_pkg_t *);
	alpm_list_t *(*get_groups) (alpm_pkg_t *);
	alpm_list_t *(*get_depends) (alpm_pkg_t *);
	alpm_list_t *(*get_optdepends) (alpm_pkg_t *);
	alpm_list_t *(*get_checkdepends) (alpm_pkg_t *);
	alpm_list_t *(*get_makedepends) (alpm_pkg_t *);
	alpm_list_t *(*get_conflicts) (alpm_pkg_t *);
	alpm_list_t *(*get_provides) (alpm_pkg_t *);
	alpm_list_t *(*get_replaces) (alpm_pkg_t *);
	alpm_filelist_t *(*get_files) (alpm_pkg_t *);
	alpm_list_t *(*get_backup) (alpm_pkg_t *);

	void *(*changelog_open) (alpm_pkg_t *);
	size_t (*changelog_read) (void *, size_t, const alpm_pkg_t *, void *);
	int (*changelog_close) (const alpm_pkg_t *, void *);

	struct archive *(*mtree_open) (alpm_pkg_t *);
	int (*mtree_next) (const alpm_pkg_t *, struct archive *, struct archive_entry **);
	int (*mtree_close) (const alpm_pkg_t *, struct archive *);

	int (*force_load) (alpm_pkg_t *);
};

/** The standard package operations struct. get fields directly from the
 * struct itself with no abstraction layer or any type of lazy loading.
 * The actual definition is in package.c so it can have access to the
 * default accessor functions which are defined there.
 */
extern const struct pkg_operations default_pkg_ops;

struct __alpm_pkg_t {
	unsigned long name_hash;
	char *filename;
	char *base;
	char *name;
	char *version;
	char *desc;
	char *url;
	char *packager;
	char *md5sum;
	char *sha256sum;
	char *base64_sig;
	char *arch;

	alpm_time_t builddate;
	alpm_time_t installdate;

	off_t size;
	off_t isize;
	off_t download_size;

	alpm_handle_t *handle;

	alpm_list_t *licenses;
	alpm_list_t *replaces;
	alpm_list_t *groups;
	alpm_list_t *backup;
	alpm_list_t *depends;
	alpm_list_t *optdepends;
	alpm_list_t *checkdepends;
	alpm_list_t *makedepends;
	alpm_list_t *conflicts;
	alpm_list_t *provides;
	alpm_list_t *removes; /* in transaction targets only */
	alpm_pkg_t *oldpkg; /* in transaction targets only */

	const struct pkg_operations *ops;

	alpm_filelist_t files;

	/* origin == PKG_FROM_FILE, use pkg->origin_data.file
	 * origin == PKG_FROM_*DB, use pkg->origin_data.db */
	union {
		alpm_db_t *db;
		char *file;
	} origin_data;

	alpm_pkgfrom_t origin;
	alpm_pkgreason_t reason;
	int scriptlet;

	/* Bitfield from alpm_dbinfrq_t */
	int infolevel;
	/* Bitfield from alpm_pkgvalidation_t */
	int validation;
};

alpm_file_t *_alpm_file_copy(alpm_file_t *dest, const alpm_file_t *src);

alpm_pkg_t *_alpm_pkg_new(void);
int _alpm_pkg_dup(alpm_pkg_t *pkg, alpm_pkg_t **new_ptr);
void _alpm_pkg_free(alpm_pkg_t *pkg);
void _alpm_pkg_free_trans(alpm_pkg_t *pkg);

int _alpm_pkg_validate_internal(alpm_handle_t *handle,
		const char *pkgfile, alpm_pkg_t *syncpkg, int level,
		alpm_siglist_t **sigdata, int *validation);
alpm_pkg_t *_alpm_pkg_load_internal(alpm_handle_t *handle,
		const char *pkgfile, int full);

int _alpm_pkg_cmp(const void *p1, const void *p2);
int _alpm_pkg_compare_versions(alpm_pkg_t *local_pkg, alpm_pkg_t *pkg);

#endif /* ALPM_PACKAGE_H */
