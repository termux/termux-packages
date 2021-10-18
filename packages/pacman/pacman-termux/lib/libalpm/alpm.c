/*
 *  alpm.c
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2005 by Christian Hamar <krics@linuxforum.hu>
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

#ifdef HAVE_LIBCURL
#include <curl/curl.h>
#endif

/* libalpm */
#include "alpm.h"
#include "alpm_list.h"
#include "handle.h"
#include "log.h"
#include "util.h"

alpm_handle_t SYMEXPORT *alpm_initialize(const char *root, const char *dbpath,
		alpm_errno_t *err)
{
	alpm_errno_t myerr;
	const char *lf = "db.lck";
	char *hookdir;
	size_t lockfilelen;
	alpm_handle_t *myhandle = _alpm_handle_new();

	if(myhandle == NULL) {
		goto nomem;
	}
	if((myerr = _alpm_set_directory_option(root, &(myhandle->root), 1))) {
		goto cleanup;
	}
	if((myerr = _alpm_set_directory_option(dbpath, &(myhandle->dbpath), 1))) {
		goto cleanup;
	}

	/* to concatenate myhandle->root (ends with a slash) with SYSHOOKDIR (starts
	 * with a slash) correctly, we skip SYSHOOKDIR[0]; the regular +1 therefore
	 * disappears from the allocation */
	MALLOC(hookdir, strlen(myhandle->root) + strlen(SYSHOOKDIR), goto nomem);
	sprintf(hookdir, "%s%s", myhandle->root, &SYSHOOKDIR[1]);
	myhandle->hookdirs = alpm_list_add(NULL, hookdir);

	/* set default database extension */
	STRDUP(myhandle->dbext, ".db", goto nomem);

	lockfilelen = strlen(myhandle->dbpath) + strlen(lf) + 1;
	MALLOC(myhandle->lockfile, lockfilelen, goto nomem);
	snprintf(myhandle->lockfile, lockfilelen, "%s%s", myhandle->dbpath, lf);

	if(_alpm_db_register_local(myhandle) == NULL) {
		myerr = myhandle->pm_errno;
		goto cleanup;
	}

#ifdef HAVE_LIBCURL
	curl_global_init(CURL_GLOBAL_ALL);
	myhandle->curlm = curl_multi_init();
#endif

	myhandle->parallel_downloads = 1;

#ifdef ENABLE_NLS
	bindtextdomain("libalpm", LOCALEDIR);
#endif

	return myhandle;

nomem:
	myerr = ALPM_ERR_MEMORY;
cleanup:
	_alpm_handle_free(myhandle);
	if(err) {
		*err = myerr;
	}
	return NULL;
}

int SYMEXPORT alpm_release(alpm_handle_t *myhandle)
{
	int ret = 0;
	alpm_db_t *db;

	CHECK_HANDLE(myhandle, return -1);

	/* close local database */
	db = myhandle->db_local;
	if(db) {
		db->ops->unregister(db);
		myhandle->db_local = NULL;
	}

	if(alpm_unregister_all_syncdbs(myhandle) == -1) {
		ret = -1;
	}

#ifdef HAVE_LIBCURL
	curl_multi_cleanup(myhandle->curlm);
	curl_global_cleanup();
	FREELIST(myhandle->server_errors);
#endif

	_alpm_handle_unlock(myhandle);
	_alpm_handle_free(myhandle);

	return ret;
}

const char SYMEXPORT *alpm_version(void)
{
	return LIB_VERSION;
}

int SYMEXPORT alpm_capabilities(void)
{
	return 0
#ifdef ENABLE_NLS
		| ALPM_CAPABILITY_NLS
#endif
#ifdef HAVE_LIBCURL
		| ALPM_CAPABILITY_DOWNLOADER
#endif
#ifdef HAVE_LIBGPGME
		| ALPM_CAPABILITY_SIGNATURES
#endif
		| 0;
}
