/*
 *  error.c
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

#ifdef HAVE_LIBCURL
#include <curl/curl.h>
#endif

/* libalpm */
#include "util.h"
#include "alpm.h"
#include "handle.h"

alpm_errno_t SYMEXPORT alpm_errno(alpm_handle_t *handle)
{
	return handle->pm_errno;
}

const char SYMEXPORT *alpm_strerror(alpm_errno_t err)
{
	switch(err) {
		/* System */
		case ALPM_ERR_MEMORY:
			return _("out of memory!");
		case ALPM_ERR_SYSTEM:
			return _("unexpected system error");
		case ALPM_ERR_BADPERMS:
			return _("permission denied");
		case ALPM_ERR_NOT_A_FILE:
			return _("could not find or read file");
		case ALPM_ERR_NOT_A_DIR:
			return _("could not find or read directory");
		case ALPM_ERR_WRONG_ARGS:
			return _("wrong or NULL argument passed");
		case ALPM_ERR_DISK_SPACE:
			return _("not enough free disk space");
		/* Interface */
		case ALPM_ERR_HANDLE_NULL:
			return _("library not initialized");
		case ALPM_ERR_HANDLE_NOT_NULL:
			return _("library already initialized");
		case ALPM_ERR_HANDLE_LOCK:
			return _("unable to lock database");
		/* Databases */
		case ALPM_ERR_DB_OPEN:
			return _("could not open database");
		case ALPM_ERR_DB_CREATE:
			return _("could not create database");
		case ALPM_ERR_DB_NULL:
			return _("database not initialized");
		case ALPM_ERR_DB_NOT_NULL:
			return _("database already registered");
		case ALPM_ERR_DB_NOT_FOUND:
			return _("could not find database");
		case ALPM_ERR_DB_INVALID:
			return _("invalid or corrupted database");
		case ALPM_ERR_DB_INVALID_SIG:
			return _("invalid or corrupted database (PGP signature)");
		case ALPM_ERR_DB_VERSION:
			return _("database is incorrect version");
		case ALPM_ERR_DB_WRITE:
			return _("could not update database");
		case ALPM_ERR_DB_REMOVE:
			return _("could not remove database entry");
		/* Servers */
		case ALPM_ERR_SERVER_BAD_URL:
			return _("invalid url for server");
		case ALPM_ERR_SERVER_NONE:
			return _("no servers configured for repository");
		/* Transactions */
		case ALPM_ERR_TRANS_NOT_NULL:
			return _("transaction already initialized");
		case ALPM_ERR_TRANS_NULL:
			return _("transaction not initialized");
		case ALPM_ERR_TRANS_DUP_TARGET:
			return _("duplicate target");
		case ALPM_ERR_TRANS_DUP_FILENAME:
			return _("duplicate filename");
		case ALPM_ERR_TRANS_NOT_INITIALIZED:
			return _("transaction not initialized");
		case ALPM_ERR_TRANS_NOT_PREPARED:
			return _("transaction not prepared");
		case ALPM_ERR_TRANS_ABORT:
			return _("transaction aborted");
		case ALPM_ERR_TRANS_TYPE:
			return _("operation not compatible with the transaction type");
		case ALPM_ERR_TRANS_NOT_LOCKED:
			return _("transaction commit attempt when database is not locked");
		case ALPM_ERR_TRANS_HOOK_FAILED:
			return _("failed to run transaction hooks");
		/* Packages */
		case ALPM_ERR_PKG_NOT_FOUND:
			return _("could not find or read package");
		case ALPM_ERR_PKG_IGNORED:
			return _("operation cancelled due to ignorepkg");
		case ALPM_ERR_PKG_INVALID:
			return _("invalid or corrupted package");
		case ALPM_ERR_PKG_INVALID_CHECKSUM:
			return _("invalid or corrupted package (checksum)");
		case ALPM_ERR_PKG_INVALID_SIG:
			return _("invalid or corrupted package (PGP signature)");
		case ALPM_ERR_PKG_MISSING_SIG:
			return _("package missing required signature");
		case ALPM_ERR_PKG_OPEN:
			return _("cannot open package file");
		case ALPM_ERR_PKG_CANT_REMOVE:
			return _("cannot remove all files for package");
		case ALPM_ERR_PKG_INVALID_NAME:
			return _("package filename is not valid");
		case ALPM_ERR_PKG_INVALID_ARCH:
			return _("package architecture is not valid");
		/* Signatures */
		case ALPM_ERR_SIG_MISSING:
			return _("missing PGP signature");
		case ALPM_ERR_SIG_INVALID:
			return _("invalid PGP signature");
		/* Dependencies */
		case ALPM_ERR_UNSATISFIED_DEPS:
			return _("could not satisfy dependencies");
		case ALPM_ERR_CONFLICTING_DEPS:
			return _("conflicting dependencies");
		case ALPM_ERR_FILE_CONFLICTS:
			return _("conflicting files");
		/* Miscellaenous */
		case ALPM_ERR_RETRIEVE:
			return _("failed to retrieve some files");
		case ALPM_ERR_INVALID_REGEX:
			return _("invalid regular expression");
		/* Errors from external libraries- our own wrapper error */
		case ALPM_ERR_LIBARCHIVE:
			/* it would be nice to use archive_error_string() here, but that
			 * requires the archive struct, so we can't. Just use a generic
			 * error string instead. */
			return _("libarchive error");
		case ALPM_ERR_LIBCURL:
			return _("download library error");
		case ALPM_ERR_GPGME:
			return _("gpgme error");
		case ALPM_ERR_EXTERNAL_DOWNLOAD:
			return _("error invoking external downloader");
		/* Missing compile-time features */
		case ALPM_ERR_MISSING_CAPABILITY_SIGNATURES:
				return _("compiled without signature support");
		/* Unknown error! */
		default:
			return _("unexpected error");
	}
}
