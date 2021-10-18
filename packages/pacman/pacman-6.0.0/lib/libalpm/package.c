/*
 *  package.c
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
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

#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

/* libalpm */
#include "package.h"
#include "alpm_list.h"
#include "log.h"
#include "util.h"
#include "db.h"
#include "handle.h"
#include "deps.h"

int SYMEXPORT alpm_pkg_free(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);

	/* Only free packages loaded in user space */
	if(pkg->origin == ALPM_PKG_FROM_FILE) {
		_alpm_pkg_free(pkg);
	}

	return 0;
}

int SYMEXPORT alpm_pkg_checkmd5sum(alpm_pkg_t *pkg)
{
	char *fpath;
	int retval;

	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	/* We only inspect packages from sync repositories */
	ASSERT(pkg->origin == ALPM_PKG_FROM_SYNCDB,
			RET_ERR(pkg->handle, ALPM_ERR_WRONG_ARGS, -1));

	fpath = _alpm_filecache_find(pkg->handle, pkg->filename);

	retval = _alpm_test_checksum(fpath, pkg->md5sum, ALPM_PKG_VALIDATION_MD5SUM);

	FREE(fpath);

	if(retval == 1) {
		pkg->handle->pm_errno = ALPM_ERR_PKG_INVALID;
		retval = -1;
	}

	return retval;
}

/* Default package accessor functions. These will get overridden by any
 * backend logic that needs lazy access, such as the local database through
 * a lazy-load cache. However, the defaults will work just fine for fully-
 * populated package structures. */
static const char *_pkg_get_base(alpm_pkg_t *pkg)        { return pkg->base; }
static const char *_pkg_get_desc(alpm_pkg_t *pkg)        { return pkg->desc; }
static const char *_pkg_get_url(alpm_pkg_t *pkg)         { return pkg->url; }
static alpm_time_t _pkg_get_builddate(alpm_pkg_t *pkg)   { return pkg->builddate; }
static alpm_time_t _pkg_get_installdate(alpm_pkg_t *pkg) { return pkg->installdate; }
static const char *_pkg_get_packager(alpm_pkg_t *pkg)    { return pkg->packager; }
static const char *_pkg_get_arch(alpm_pkg_t *pkg)        { return pkg->arch; }
static off_t _pkg_get_isize(alpm_pkg_t *pkg)             { return pkg->isize; }
static alpm_pkgreason_t _pkg_get_reason(alpm_pkg_t *pkg) { return pkg->reason; }
static int _pkg_get_validation(alpm_pkg_t *pkg) { return pkg->validation; }
static int _pkg_has_scriptlet(alpm_pkg_t *pkg)           { return pkg->scriptlet; }

static alpm_list_t *_pkg_get_licenses(alpm_pkg_t *pkg)   { return pkg->licenses; }
static alpm_list_t *_pkg_get_groups(alpm_pkg_t *pkg)     { return pkg->groups; }
static alpm_list_t *_pkg_get_depends(alpm_pkg_t *pkg)    { return pkg->depends; }
static alpm_list_t *_pkg_get_optdepends(alpm_pkg_t *pkg) { return pkg->optdepends; }
static alpm_list_t *_pkg_get_checkdepends(alpm_pkg_t *pkg) { return pkg->checkdepends; }
static alpm_list_t *_pkg_get_makedepends(alpm_pkg_t *pkg) { return pkg->makedepends; }
static alpm_list_t *_pkg_get_conflicts(alpm_pkg_t *pkg)  { return pkg->conflicts; }
static alpm_list_t *_pkg_get_provides(alpm_pkg_t *pkg)   { return pkg->provides; }
static alpm_list_t *_pkg_get_replaces(alpm_pkg_t *pkg)   { return pkg->replaces; }
static alpm_filelist_t *_pkg_get_files(alpm_pkg_t *pkg)  { return &(pkg->files); }
static alpm_list_t *_pkg_get_backup(alpm_pkg_t *pkg)     { return pkg->backup; }

static void *_pkg_changelog_open(alpm_pkg_t UNUSED *pkg)
{
	return NULL;
}

static size_t _pkg_changelog_read(void UNUSED *ptr, size_t UNUSED size,
		const alpm_pkg_t UNUSED *pkg, UNUSED void *fp)
{
	return 0;
}

static int _pkg_changelog_close(const alpm_pkg_t UNUSED *pkg,
		void UNUSED *fp)
{
	return EOF;
}

static struct archive *_pkg_mtree_open(alpm_pkg_t UNUSED *pkg)
{
	return NULL;
}

static int _pkg_mtree_next(const alpm_pkg_t UNUSED *pkg,
		struct archive UNUSED *archive, struct archive_entry UNUSED **entry)
{
	return -1;
}

static int _pkg_mtree_close(const alpm_pkg_t UNUSED *pkg,
		struct archive UNUSED *archive)
{
	return -1;
}

static int _pkg_force_load(alpm_pkg_t UNUSED *pkg) { return 0; }

/** The standard package operations struct. Get fields directly from the
 * struct itself with no abstraction layer or any type of lazy loading.
 */
const struct pkg_operations default_pkg_ops = {
	.get_base        = _pkg_get_base,
	.get_desc        = _pkg_get_desc,
	.get_url         = _pkg_get_url,
	.get_builddate   = _pkg_get_builddate,
	.get_installdate = _pkg_get_installdate,
	.get_packager    = _pkg_get_packager,
	.get_arch        = _pkg_get_arch,
	.get_isize       = _pkg_get_isize,
	.get_reason      = _pkg_get_reason,
	.get_validation  = _pkg_get_validation,
	.has_scriptlet   = _pkg_has_scriptlet,

	.get_licenses    = _pkg_get_licenses,
	.get_groups      = _pkg_get_groups,
	.get_depends     = _pkg_get_depends,
	.get_optdepends  = _pkg_get_optdepends,
	.get_checkdepends = _pkg_get_checkdepends,
	.get_makedepends = _pkg_get_makedepends,
	.get_conflicts   = _pkg_get_conflicts,
	.get_provides    = _pkg_get_provides,
	.get_replaces    = _pkg_get_replaces,
	.get_files       = _pkg_get_files,
	.get_backup      = _pkg_get_backup,

	.changelog_open  = _pkg_changelog_open,
	.changelog_read  = _pkg_changelog_read,
	.changelog_close = _pkg_changelog_close,

	.mtree_open      = _pkg_mtree_open,
	.mtree_next      = _pkg_mtree_next,
	.mtree_close     = _pkg_mtree_close,

	.force_load      = _pkg_force_load,
};

/* Public functions for getting package information. These functions
 * delegate the hard work to the function callbacks attached to each
 * package, which depend on where the package was loaded from. */
const char SYMEXPORT *alpm_pkg_get_filename(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->filename;
}

const char SYMEXPORT *alpm_pkg_get_base(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_base(pkg);
}

const char SYMEXPORT *alpm_pkg_get_name(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->name;
}

const char SYMEXPORT *alpm_pkg_get_version(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->version;
}

alpm_pkgfrom_t SYMEXPORT alpm_pkg_get_origin(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->origin;
}

const char SYMEXPORT *alpm_pkg_get_desc(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_desc(pkg);
}

const char SYMEXPORT *alpm_pkg_get_url(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_url(pkg);
}

alpm_time_t SYMEXPORT alpm_pkg_get_builddate(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_builddate(pkg);
}

alpm_time_t SYMEXPORT alpm_pkg_get_installdate(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_installdate(pkg);
}

const char SYMEXPORT *alpm_pkg_get_packager(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_packager(pkg);
}

const char SYMEXPORT *alpm_pkg_get_md5sum(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->md5sum;
}

const char SYMEXPORT *alpm_pkg_get_sha256sum(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->sha256sum;
}

const char SYMEXPORT *alpm_pkg_get_base64_sig(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->base64_sig;
}

int SYMEXPORT alpm_pkg_get_sig(alpm_pkg_t *pkg, unsigned char **sig, size_t *sig_len)
{
	ASSERT(pkg != NULL, return -1);

	if(pkg->base64_sig) {
		int ret = alpm_decode_signature(pkg->base64_sig, sig, sig_len);
		if(ret != 0) {
			RET_ERR(pkg->handle, ALPM_ERR_SIG_INVALID, -1);
		}
		return 0;
	} else {
		char *pkgpath = NULL, *sigpath = NULL;
		alpm_errno_t err;
		int ret = -1;

		pkgpath = _alpm_filecache_find(pkg->handle, pkg->filename);
		if(!pkgpath) {
			GOTO_ERR(pkg->handle, ALPM_ERR_PKG_NOT_FOUND, cleanup);
		}
		sigpath = _alpm_sigpath(pkg->handle, pkgpath);
		if(!sigpath || _alpm_access(pkg->handle, NULL, sigpath, R_OK)) {
			GOTO_ERR(pkg->handle, ALPM_ERR_SIG_MISSING, cleanup);
		}
		err = _alpm_read_file(sigpath, sig, sig_len);
		if(err == ALPM_ERR_OK) {
			_alpm_log(pkg->handle, ALPM_LOG_DEBUG, "found detached signature %s with size %ld\n",
				sigpath, *sig_len);
		} else {
			GOTO_ERR(pkg->handle, err, cleanup);
		}
		ret = 0;
cleanup:
		FREE(pkgpath);
		FREE(sigpath);
		return ret;
	}
}

const char SYMEXPORT *alpm_pkg_get_arch(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_arch(pkg);
}

off_t SYMEXPORT alpm_pkg_get_size(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->size;
}

off_t SYMEXPORT alpm_pkg_get_isize(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_isize(pkg);
}

alpm_pkgreason_t SYMEXPORT alpm_pkg_get_reason(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_reason(pkg);
}

int SYMEXPORT alpm_pkg_get_validation(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_validation(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_licenses(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_licenses(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_groups(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_groups(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_depends(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_depends(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_optdepends(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_optdepends(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_checkdepends(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_checkdepends(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_makedepends(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_makedepends(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_conflicts(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_conflicts(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_provides(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_provides(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_replaces(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_replaces(pkg);
}

alpm_filelist_t SYMEXPORT *alpm_pkg_get_files(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_files(pkg);
}

alpm_list_t SYMEXPORT *alpm_pkg_get_backup(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->get_backup(pkg);
}

alpm_db_t SYMEXPORT *alpm_pkg_get_db(alpm_pkg_t *pkg)
{
	/* Sanity checks */
	ASSERT(pkg != NULL, return NULL);
	ASSERT(pkg->origin != ALPM_PKG_FROM_FILE, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;

	return pkg->origin_data.db;
}

void SYMEXPORT *alpm_pkg_changelog_open(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->changelog_open(pkg);
}

size_t SYMEXPORT alpm_pkg_changelog_read(void *ptr, size_t size,
		const alpm_pkg_t *pkg, void *fp)
{
	ASSERT(pkg != NULL, return 0);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->changelog_read(ptr, size, pkg, fp);
}

int SYMEXPORT alpm_pkg_changelog_close(const alpm_pkg_t *pkg, void *fp)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->changelog_close(pkg, fp);
}

struct archive SYMEXPORT *alpm_pkg_mtree_open(alpm_pkg_t * pkg)
{
	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->mtree_open(pkg);
}

int SYMEXPORT alpm_pkg_mtree_next(const alpm_pkg_t * pkg, struct archive *archive,
	struct archive_entry **entry)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->mtree_next(pkg, archive, entry);
}

int SYMEXPORT alpm_pkg_mtree_close(const alpm_pkg_t * pkg, struct archive *archive)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->mtree_close(pkg, archive);
}

int SYMEXPORT alpm_pkg_has_scriptlet(alpm_pkg_t *pkg)
{
	ASSERT(pkg != NULL, return -1);
	pkg->handle->pm_errno = ALPM_ERR_OK;
	return pkg->ops->has_scriptlet(pkg);
}

static void find_requiredby(alpm_pkg_t *pkg, alpm_db_t *db, alpm_list_t **reqs,
		int optional)
{
	const alpm_list_t *i;
	pkg->handle->pm_errno = ALPM_ERR_OK;

	for(i = _alpm_db_get_pkgcache(db); i; i = i->next) {
		alpm_pkg_t *cachepkg = i->data;
		alpm_list_t *j;

		if(optional == 0) {
			j = alpm_pkg_get_depends(cachepkg);
		} else {
			j = alpm_pkg_get_optdepends(cachepkg);
		}

		for(; j; j = j->next) {
			if(_alpm_depcmp(pkg, j->data)) {
				const char *cachepkgname = cachepkg->name;
				if(alpm_list_find_str(*reqs, cachepkgname) == NULL) {
					*reqs = alpm_list_add(*reqs, strdup(cachepkgname));
				}
			}
		}
	}
}

static alpm_list_t *compute_requiredby(alpm_pkg_t *pkg, int optional)
{
	const alpm_list_t *i;
	alpm_list_t *reqs = NULL;
	alpm_db_t *db;

	ASSERT(pkg != NULL, return NULL);
	pkg->handle->pm_errno = ALPM_ERR_OK;

	if(pkg->origin == ALPM_PKG_FROM_FILE) {
		/* The sane option; search locally for things that require this. */
		find_requiredby(pkg, pkg->handle->db_local, &reqs, optional);
	} else {
		/* We have a DB package. if it is a local package, then we should
		 * only search the local DB; else search all known sync databases. */
		db = pkg->origin_data.db;
		if(db->status & DB_STATUS_LOCAL) {
			find_requiredby(pkg, db, &reqs, optional);
		} else {
			for(i = pkg->handle->dbs_sync; i; i = i->next) {
				db = i->data;
				find_requiredby(pkg, db, &reqs, optional);
			}
			reqs = alpm_list_msort(reqs, alpm_list_count(reqs), _alpm_str_cmp);
		}
	}
	return reqs;
}

alpm_list_t SYMEXPORT *alpm_pkg_compute_requiredby(alpm_pkg_t *pkg)
{
	return compute_requiredby(pkg, 0);
}

alpm_list_t SYMEXPORT *alpm_pkg_compute_optionalfor(alpm_pkg_t *pkg)
{
	return compute_requiredby(pkg, 1);
}

alpm_file_t *_alpm_file_copy(alpm_file_t *dest,
		const alpm_file_t *src)
{
	STRDUP(dest->name, src->name, return NULL);
	dest->size = src->size;
	dest->mode = src->mode;

	return dest;
}

alpm_pkg_t *_alpm_pkg_new(void)
{
	alpm_pkg_t *pkg;

	CALLOC(pkg, 1, sizeof(alpm_pkg_t), return NULL);

	return pkg;
}

static alpm_list_t *list_depdup(alpm_list_t *old)
{
	alpm_list_t *i, *new = NULL;
	for(i = old; i; i = i->next) {
		new = alpm_list_add(new, _alpm_dep_dup(i->data));
	}
	return new;
}

/**
 * Duplicate a package data struct.
 * @param pkg the package to duplicate
 * @param new_ptr location to store duplicated package pointer
 * @return 0 on success, -1 on fatal error, 1 on non-fatal error
 */
int _alpm_pkg_dup(alpm_pkg_t *pkg, alpm_pkg_t **new_ptr)
{
	alpm_pkg_t *newpkg;
	alpm_list_t *i;
	int ret = 0;

	if(!pkg || !pkg->handle) {
		return -1;
	}

	if(!new_ptr) {
		RET_ERR(pkg->handle, ALPM_ERR_WRONG_ARGS, -1);
	}

	if(pkg->ops->force_load(pkg)) {
		_alpm_log(pkg->handle, ALPM_LOG_WARNING,
				_("could not fully load metadata for package %s-%s\n"),
				pkg->name, pkg->version);
		ret = 1;
		pkg->handle->pm_errno = ALPM_ERR_PKG_INVALID;
	}

	CALLOC(newpkg, 1, sizeof(alpm_pkg_t), goto cleanup);

	newpkg->name_hash = pkg->name_hash;
	STRDUP(newpkg->filename, pkg->filename, goto cleanup);
	STRDUP(newpkg->base, pkg->base, goto cleanup);
	STRDUP(newpkg->name, pkg->name, goto cleanup);
	STRDUP(newpkg->version, pkg->version, goto cleanup);
	STRDUP(newpkg->desc, pkg->desc, goto cleanup);
	STRDUP(newpkg->url, pkg->url, goto cleanup);
	newpkg->builddate = pkg->builddate;
	newpkg->installdate = pkg->installdate;
	STRDUP(newpkg->packager, pkg->packager, goto cleanup);
	STRDUP(newpkg->md5sum, pkg->md5sum, goto cleanup);
	STRDUP(newpkg->sha256sum, pkg->sha256sum, goto cleanup);
	STRDUP(newpkg->arch, pkg->arch, goto cleanup);
	newpkg->size = pkg->size;
	newpkg->isize = pkg->isize;
	newpkg->scriptlet = pkg->scriptlet;
	newpkg->reason = pkg->reason;
	newpkg->validation = pkg->validation;

	newpkg->licenses   = alpm_list_strdup(pkg->licenses);
	newpkg->replaces   = list_depdup(pkg->replaces);
	newpkg->groups     = alpm_list_strdup(pkg->groups);
	for(i = pkg->backup; i; i = i->next) {
		newpkg->backup = alpm_list_add(newpkg->backup, _alpm_backup_dup(i->data));
	}
	newpkg->depends    = list_depdup(pkg->depends);
	newpkg->optdepends = list_depdup(pkg->optdepends);
	newpkg->conflicts  = list_depdup(pkg->conflicts);
	newpkg->provides   = list_depdup(pkg->provides);

	if(pkg->files.count) {
		size_t filenum;
		size_t len = sizeof(alpm_file_t) * pkg->files.count;
		MALLOC(newpkg->files.files, len, goto cleanup);
		for(filenum = 0; filenum < pkg->files.count; filenum++) {
			if(!_alpm_file_copy(newpkg->files.files + filenum,
						pkg->files.files + filenum)) {
				goto cleanup;
			}
		}
		newpkg->files.count = pkg->files.count;
	}

	/* internal */
	newpkg->infolevel = pkg->infolevel;
	newpkg->origin = pkg->origin;
	if(newpkg->origin == ALPM_PKG_FROM_FILE) {
		STRDUP(newpkg->origin_data.file, pkg->origin_data.file, goto cleanup);
	} else {
		newpkg->origin_data.db = pkg->origin_data.db;
	}
	newpkg->ops = pkg->ops;
	newpkg->handle = pkg->handle;

	*new_ptr = newpkg;
	return ret;

cleanup:
	_alpm_pkg_free(newpkg);
	RET_ERR(pkg->handle, ALPM_ERR_MEMORY, -1);
}

static void free_deplist(alpm_list_t *deps)
{
	alpm_list_free_inner(deps, (alpm_list_fn_free)alpm_dep_free);
	alpm_list_free(deps);
}

void _alpm_pkg_free(alpm_pkg_t *pkg)
{
	if(pkg == NULL) {
		return;
	}

	FREE(pkg->filename);
	FREE(pkg->base);
	FREE(pkg->name);
	FREE(pkg->version);
	FREE(pkg->desc);
	FREE(pkg->url);
	FREE(pkg->packager);
	FREE(pkg->md5sum);
	FREE(pkg->sha256sum);
	FREE(pkg->base64_sig);
	FREE(pkg->arch);

	FREELIST(pkg->licenses);
	free_deplist(pkg->replaces);
	FREELIST(pkg->groups);
	if(pkg->files.count) {
		size_t i;
		for(i = 0; i < pkg->files.count; i++) {
			FREE(pkg->files.files[i].name);
		}
		free(pkg->files.files);
	}
	alpm_list_free_inner(pkg->backup, (alpm_list_fn_free)_alpm_backup_free);
	alpm_list_free(pkg->backup);
	free_deplist(pkg->depends);
	free_deplist(pkg->optdepends);
	free_deplist(pkg->checkdepends);
	free_deplist(pkg->makedepends);
	free_deplist(pkg->conflicts);
	free_deplist(pkg->provides);
	alpm_list_free(pkg->removes);
	_alpm_pkg_free(pkg->oldpkg);

	if(pkg->origin == ALPM_PKG_FROM_FILE) {
		FREE(pkg->origin_data.file);
	}
	FREE(pkg);
}

/* This function should be used when removing a target from upgrade/sync target list
 * Case 1: If pkg is a loaded package file (ALPM_PKG_FROM_FILE), it will be freed.
 * Case 2: If pkg is a pkgcache entry (ALPM_PKG_FROM_CACHE), it won't be freed,
 *         only the transaction specific fields of pkg will be freed.
 */
void _alpm_pkg_free_trans(alpm_pkg_t *pkg)
{
	if(pkg == NULL) {
		return;
	}

	if(pkg->origin == ALPM_PKG_FROM_FILE) {
		_alpm_pkg_free(pkg);
		return;
	}

	alpm_list_free(pkg->removes);
	pkg->removes = NULL;
	_alpm_pkg_free(pkg->oldpkg);
	pkg->oldpkg = NULL;
}

/* Is spkg an upgrade for localpkg? */
int _alpm_pkg_compare_versions(alpm_pkg_t *spkg, alpm_pkg_t *localpkg)
{
	return alpm_pkg_vercmp(spkg->version, localpkg->version);
}

/* Helper function for comparing packages
 */
int _alpm_pkg_cmp(const void *p1, const void *p2)
{
	const alpm_pkg_t *pkg1 = p1;
	const alpm_pkg_t *pkg2 = p2;
	return strcmp(pkg1->name, pkg2->name);
}

/* Test for existence of a package in a alpm_list_t*
 * of alpm_pkg_t*
 */
alpm_pkg_t SYMEXPORT *alpm_pkg_find(alpm_list_t *haystack, const char *needle)
{
	alpm_list_t *lp;
	unsigned long needle_hash;

	if(needle == NULL || haystack == NULL) {
		return NULL;
	}

	needle_hash = _alpm_hash_sdbm(needle);

	for(lp = haystack; lp; lp = lp->next) {
		alpm_pkg_t *info = lp->data;

		if(info) {
			if(info->name_hash != needle_hash) {
				continue;
			}

			/* finally: we had hash match, verify string match */
			if(strcmp(info->name, needle) == 0) {
				return info;
			}
		}
	}
	return NULL;
}

int SYMEXPORT alpm_pkg_should_ignore(alpm_handle_t *handle, alpm_pkg_t *pkg)
{
	alpm_list_t *groups = NULL;

	/* first see if the package is ignored */
	if(alpm_list_find(handle->ignorepkg, pkg->name, _alpm_fnmatch)) {
		return 1;
	}

	/* next see if the package is in a group that is ignored */
	for(groups = alpm_pkg_get_groups(pkg); groups; groups = groups->next) {
		char *grp = groups->data;
		if(alpm_list_find(handle->ignoregroup, grp, _alpm_fnmatch)) {
			return 1;
		}
	}

	return 0;
}
