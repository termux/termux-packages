/*
 *  handle.h
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
#ifndef ALPM_HANDLE_H
#define ALPM_HANDLE_H

#include <stdio.h>
#include <sys/types.h>
#include <regex.h>

#include "alpm_list.h"
#include "alpm.h"

#ifdef HAVE_LIBCURL
#include <curl/curl.h>
#endif

#define EVENT(h, e) \
do { \
	if((h)->eventcb) { \
		(h)->eventcb((h)->eventcb_ctx, (alpm_event_t *) (e)); \
	} \
} while(0)
#define QUESTION(h, q) \
do { \
	if((h)->questioncb) { \
		(h)->questioncb((h)->questioncb_ctx, (alpm_question_t *) (q)); \
	} \
} while(0)
#define PROGRESS(h, e, p, per, n, r) \
do { \
	if((h)->progresscb) { \
		(h)->progresscb((h)->progresscb_ctx, e, p, per, n, r); \
	} \
} while(0)

struct __alpm_handle_t {
	/* internal usage */
	alpm_db_t *db_local;    /* local db pointer */
	alpm_list_t *dbs_sync;  /* List of (alpm_db_t *) */
	FILE *logstream;        /* log file stream pointer */
	alpm_trans_t *trans;

#ifdef HAVE_LIBCURL
	/* libcurl handle */
	CURLM *curlm;
	alpm_list_t *server_errors;
#endif

	unsigned short disable_dl_timeout;
	unsigned int parallel_downloads; /* number of download streams */

#ifdef HAVE_LIBGPGME
	alpm_list_t *known_keys;  /* keys verified to be in our keychain */
#endif

	/* callback functions */
	alpm_cb_log logcb;          /* Log callback function */
	void *logcb_ctx;
	alpm_cb_download dlcb;      /* Download callback function */
	void *dlcb_ctx;
	alpm_cb_fetch fetchcb;      /* Download file callback function */
	void *fetchcb_ctx;
	alpm_cb_event eventcb;
	void *eventcb_ctx;
	alpm_cb_question questioncb;
	void *questioncb_ctx;
	alpm_cb_progress progresscb;
	void *progresscb_ctx;

	/* filesystem paths */
	char *root;              /* Root path, default '/' */
	char *dbpath;            /* Base path to pacman's DBs */
	char *logfile;           /* Name of the log file */
	char *lockfile;          /* Name of the lock file */
	char *gpgdir;            /* Directory where GnuPG files are stored */
	alpm_list_t *cachedirs;  /* Paths to pacman cache directories */
	alpm_list_t *hookdirs;   /* Paths to hook directories */
	alpm_list_t *overwrite_files; /* Paths that may be overwritten */

	/* package lists */
	alpm_list_t *noupgrade;   /* List of packages NOT to be upgraded */
	alpm_list_t *noextract;   /* List of files NOT to extract */
	alpm_list_t *ignorepkg;   /* List of packages to ignore */
	alpm_list_t *ignoregroup; /* List of groups to ignore */
	alpm_list_t *assumeinstalled;   /* List of virtual packages used to satisfy dependencies */

	/* options */
	alpm_list_t *architectures; /* Architectures of packages we should allow */
	int usesyslog;           /* Use syslog instead of logfile? */ /* TODO move to frontend */
	int checkspace;          /* Check disk space before installing */
	char *dbext;             /* Sync DB extension */
	int siglevel;            /* Default signature verification level */
	int localfilesiglevel;   /* Signature verification level for local file
	                                       upgrade operations */
	int remotefilesiglevel;  /* Signature verification level for remote file
	                                       upgrade operations */

	/* error code */
	alpm_errno_t pm_errno;

	/* lock file descriptor */
	int lockfd;
};

alpm_handle_t *_alpm_handle_new(void);
void _alpm_handle_free(alpm_handle_t *handle);

int _alpm_handle_lock(alpm_handle_t *handle);
int _alpm_handle_unlock(alpm_handle_t *handle);

alpm_errno_t _alpm_set_directory_option(const char *value,
		char **storage, int must_exist);

#endif /* ALPM_HANDLE_H */
