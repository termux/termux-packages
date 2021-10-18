/*
 * alpm.h
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


/** @mainpage alpm
 *
 * libalpm is a package management library, primarily used by pacman.
 */

#ifndef ALPM_H
#define ALPM_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>    /* int64_t */
#include <sys/types.h> /* off_t */
#include <stdarg.h>    /* va_list */

/* libarchive */
#include <archive.h>
#include <archive_entry.h>

#include <alpm_list.h>

/** @addtogroup libalpm The libalpm Public API
 *
 *
 *
 * libalpm is a package management library, primarily used by pacman.
 * For ease of access, the libalpm manual has been split up into several sections.
 *
 * @section see_also See Also
 * \b libalpm_list(3),
 * \b libalpm_cb(3),
 * \b libalpm_databases(3),
 * \b libalpm_depends(3),
 * \b libalpm_errors(3),
 * \b libalpm_files(3),
 * \b libalpm_groups(3),
 * \b libalpm_handle(3),
 * \b libalpm_log(3),
 * \b libalpm_misc(3),
 * \b libalpm_options(3),
 * \b libalpm_packages(3),
 * \b libalpm_sig(3),
 * \b libalpm_trans(3)
 * @{
 */

/*
 * Opaque Structures
 */

/** The libalpm context handle.
 *
 * This struct represents an instance of libalpm.
 * @ingroup libalpm_handle
 */
typedef struct __alpm_handle_t alpm_handle_t;

/** A database.
 *
 * A database is a container that stores metadata about packages.
 *
 * A database can be located on the local filesystem or on a remote server.
 *
 * To use a database, it must first be registered via \link alpm_register_syncdb \endlink.
 * If the database is already present in dbpath then it will be usable. Otherwise,
 * the database needs to be downloaded using \link alpm_db_update \endlink. Even if the
 * source of the database is the local filesystem.
 *
 * After this, the database can be used to query packages and groups. Any packages or groups
 * from the database will continue to be owned by the database and do not need to be freed by
 * the user. They will be freed when the database is unregistered.
 *
 * Databases are automatically unregistered when the \link alpm_handle_t \endlink is released.
 * @ingroup libalpm_databases
 */
typedef struct __alpm_db_t alpm_db_t;


/** A package.
 *
 * A package can be loaded from disk via \link alpm_pkg_load \endlink or retrieved from a database.
 * Packages from databases are automatically freed when the database is unregistered. Packages loaded
 * from a file must be freed manually.
 *
 * Packages can then be queried for metadata or added to a \link alpm_trans_t transaction \endlink
 * to be added or removed from the system.
 * @ingroup libalpm_packages
 */
typedef struct __alpm_pkg_t alpm_pkg_t;

/** Transaction structure used internally by libalpm
 * @ingroup libalpm_trans
 * */
typedef struct __alpm_trans_t alpm_trans_t;


/** The time type used by libalpm. Represents a unix time stamp
 * @ingroup libalpm_misc */
typedef int64_t alpm_time_t;

/** @addtogroup libalpm_files Files
 * @brief Functions for package files
 * @{
 */

/** File in a package */
typedef struct _alpm_file_t {
       /** Name of the file */
       char *name;
       /** Size of the file */
       off_t size;
       /** The file's permissions */
       mode_t mode;
} alpm_file_t;

/** Package filelist container */
typedef struct _alpm_filelist_t {
       /** Amount of files in the array */
       size_t count;
       /** An array of files */
       alpm_file_t *files;
} alpm_filelist_t;

/** Local package or package file backup entry */
typedef struct _alpm_backup_t {
       /** Name of the file (without .pacsave extension) */
       char *name;
       /** Hash of the filename (used internally) */
       char *hash;
} alpm_backup_t;

/** Determines whether a package filelist contains a given path.
 * The provided path should be relative to the install root with no leading
 * slashes, e.g. "etc/localtime". When searching for directories, the path must
 * have a trailing slash.
 * @param filelist a pointer to a package filelist
 * @param path the path to search for in the package
 * @return a pointer to the matching file or NULL if not found
 */
alpm_file_t *alpm_filelist_contains(alpm_filelist_t *filelist, const char *path);

/* End of libalpm_files */
/** @} */


/** @addtogroup libalpm_groups Groups
 * @brief Functions for package groups
 * @{
 */

/** Package group */
typedef struct _alpm_group_t {
	/** group name */
	char *name;
	/** list of alpm_pkg_t packages */
	alpm_list_t *packages;
} alpm_group_t;

/** Find group members across a list of databases.
 * If a member exists in several databases, only the first database is used.
 * IgnorePkg is also handled.
 * @param dbs the list of alpm_db_t *
 * @param name the name of the group
 * @return the list of alpm_pkg_t * (caller is responsible for alpm_list_free)
 */
alpm_list_t *alpm_find_group_pkgs(alpm_list_t *dbs, const char *name);

/* End of libalpm_groups */
/** @} */


/** @addtogroup libalpm_errors Error Codes
 * Error codes returned by libalpm.
 * @{
 */

/** libalpm's error type */
typedef enum _alpm_errno_t {
	/** No error */
	ALPM_ERR_OK = 0,
	/** Failed to allocate memory */
	ALPM_ERR_MEMORY,
	/** A system error occurred */
	ALPM_ERR_SYSTEM,
	/** Permmision denied */
	ALPM_ERR_BADPERMS,
	/** Should be a file */
	ALPM_ERR_NOT_A_FILE,
	/** Should be a directory */
	ALPM_ERR_NOT_A_DIR,
	/** Function was called with invalid arguments */
	ALPM_ERR_WRONG_ARGS,
	/** Insufficient disk space */
	ALPM_ERR_DISK_SPACE,
	/* Interface */
	/** Handle should be null */
	ALPM_ERR_HANDLE_NULL,
	/** Handle should not be null */
	ALPM_ERR_HANDLE_NOT_NULL,
	/** Failed to acquire lock */
	ALPM_ERR_HANDLE_LOCK,
	/* Databases */
	/** Failed to open database */
	ALPM_ERR_DB_OPEN,
	/** Failed to create database */
	ALPM_ERR_DB_CREATE,
	/** Database should not be null */
	ALPM_ERR_DB_NULL,
	/** Database should be null */
	ALPM_ERR_DB_NOT_NULL,
	/** The database could not be found */
	ALPM_ERR_DB_NOT_FOUND,
	/** Database is invalid */
	ALPM_ERR_DB_INVALID,
	/** Database has an invalid signature */
	ALPM_ERR_DB_INVALID_SIG,
	/** The localdb is in a newer/older format than libalpm expects */
	ALPM_ERR_DB_VERSION,
	/** Failed to write to the database */
	ALPM_ERR_DB_WRITE,
	/** Failed to remove entry from database */
	ALPM_ERR_DB_REMOVE,
	/* Servers */
	/** Server URL is in an invalid format */
	ALPM_ERR_SERVER_BAD_URL,
	/** The database has no configured servers */
	ALPM_ERR_SERVER_NONE,
	/* Transactions */
	/** A transaction is already initialized */
	ALPM_ERR_TRANS_NOT_NULL,
	/** A transaction has not been initialized */
	ALPM_ERR_TRANS_NULL,
	/** Duplicate target in transaction */
	ALPM_ERR_TRANS_DUP_TARGET,
	/** Duplicate filename in transaction */
	ALPM_ERR_TRANS_DUP_FILENAME,
	/** A transaction has not been initialized */
	ALPM_ERR_TRANS_NOT_INITIALIZED,
	/** Transaction has not been prepared */
	ALPM_ERR_TRANS_NOT_PREPARED,
	/** Transaction was aborted */
	ALPM_ERR_TRANS_ABORT,
	/** Failed to interrupt transaction */
	ALPM_ERR_TRANS_TYPE,
	/** Tried to commit transaction without locking the database */
	ALPM_ERR_TRANS_NOT_LOCKED,
	/** A hook failed to run */
	ALPM_ERR_TRANS_HOOK_FAILED,
	/* Packages */
	/** Package not found */
	ALPM_ERR_PKG_NOT_FOUND,
	/** Package is in ignorepkg */
	ALPM_ERR_PKG_IGNORED,
	/** Package is invalid */
	ALPM_ERR_PKG_INVALID,
	/** Package has an invalid checksum */
	ALPM_ERR_PKG_INVALID_CHECKSUM,
	/** Package has an invalid signature */
	ALPM_ERR_PKG_INVALID_SIG,
	/** Package does not have a signature */
	ALPM_ERR_PKG_MISSING_SIG,
	/** Cannot open the package file */
	ALPM_ERR_PKG_OPEN,
	/** Failed to remove package files */
	ALPM_ERR_PKG_CANT_REMOVE,
	/** Package has an invalid name */
	ALPM_ERR_PKG_INVALID_NAME,
	/** Package has an invalid architecture */
	ALPM_ERR_PKG_INVALID_ARCH,
	/* Signatures */
	/** Signatures are missing */
	ALPM_ERR_SIG_MISSING,
	/** Signatures are invalid */
	ALPM_ERR_SIG_INVALID,
	/* Dependencies */
	/** Dependencies could not be satisfied */
	ALPM_ERR_UNSATISFIED_DEPS,
	/** Conflicting dependencies */
	ALPM_ERR_CONFLICTING_DEPS,
	/** Files conflict */
	ALPM_ERR_FILE_CONFLICTS,
	/* Misc */
	/** Download failed */
	ALPM_ERR_RETRIEVE,
	/** Invalid Regex */
	ALPM_ERR_INVALID_REGEX,
	/* External library errors */
	/** Error in libarchive */
	ALPM_ERR_LIBARCHIVE,
	/** Error in libcurl */
	ALPM_ERR_LIBCURL,
	/** Error in external download program */
	ALPM_ERR_EXTERNAL_DOWNLOAD,
	/** Error in gpgme */
	ALPM_ERR_GPGME,
	/** Missing compile-time features */
	ALPM_ERR_MISSING_CAPABILITY_SIGNATURES
} alpm_errno_t;

/** Returns the current error code from the handle.
 * @param handle the context handle
 * @return the current error code of the handle
 */
alpm_errno_t alpm_errno(alpm_handle_t *handle);

/** Returns the string corresponding to an error number.
 * @param err the error code to get the string for
 * @return the string relating to the given error code
 */
const char *alpm_strerror(alpm_errno_t err);

/* End of libalpm_errors */
/** @} */


/** \addtogroup libalpm_handle Handle
 * @brief Functions to initialize and release libalpm
 * @{
 */

/** Initializes the library.
 * Creates handle, connects to database and creates lockfile.
 * This must be called before any other functions are called.
 * @param root the root path for all filesystem operations
 * @param dbpath the absolute path to the libalpm database
 * @param err an optional variable to hold any error return codes
 * @return a context handle on success, NULL on error, err will be set if provided
 */
alpm_handle_t *alpm_initialize(const char *root, const char *dbpath,
		alpm_errno_t *err);

/** Release the library.
 * Disconnects from the database, removes handle and lockfile
 * This should be the last alpm call you make.
 * After this returns, handle should be considered invalid and cannot be reused
 * in any way.
 * @param handle the context handle
 * @return 0 on success, -1 on error
 */
int alpm_release(alpm_handle_t *handle);

/* End of libalpm_handle */
/** @} */


/** @addtogroup libalpm_sig Signature checking
 * @brief Functions to check signatures
 * @{
 */

/** PGP signature verification options */
typedef enum _alpm_siglevel_t {
	/** Packages require a signature */
	ALPM_SIG_PACKAGE = (1 << 0),
	/** Packages do not require a signature,
	 * but check packages that do have signatures */
	ALPM_SIG_PACKAGE_OPTIONAL = (1 << 1),
	/* Allow packages with signatures that are marginal trust */
	ALPM_SIG_PACKAGE_MARGINAL_OK = (1 << 2),
	/** Allow packages with signatures that are unknown trust */
	ALPM_SIG_PACKAGE_UNKNOWN_OK = (1 << 3),

	/** Databases require a signature */
	ALPM_SIG_DATABASE = (1 << 10),
	/** Databases do not require a signature,
	 * but check databases that do have signatures */
	ALPM_SIG_DATABASE_OPTIONAL = (1 << 11),
	/** Allow databases with signatures that are marginal trust */
	ALPM_SIG_DATABASE_MARGINAL_OK = (1 << 12),
	/** Allow databases with signatures that are unknown trust */
	ALPM_SIG_DATABASE_UNKNOWN_OK = (1 << 13),

	/** The Default siglevel */
	ALPM_SIG_USE_DEFAULT = (1 << 30)
} alpm_siglevel_t;

/** PGP signature verification status return codes */
typedef enum _alpm_sigstatus_t {
	/** Signature is valid */
	ALPM_SIGSTATUS_VALID,
	/** The key has expired */
	ALPM_SIGSTATUS_KEY_EXPIRED,
	/** The signature has expired */
	ALPM_SIGSTATUS_SIG_EXPIRED,
	/** The key is not in the keyring */
	ALPM_SIGSTATUS_KEY_UNKNOWN,
	/** The key has been disabled */
	ALPM_SIGSTATUS_KEY_DISABLED,
	/** The signature is invalid */
	ALPM_SIGSTATUS_INVALID
} alpm_sigstatus_t;


/** The trust level of a PGP key */
typedef enum _alpm_sigvalidity_t {
	/** The signature is fully trusted */
	ALPM_SIGVALIDITY_FULL,
	/** The signature is marginally trusted */
	ALPM_SIGVALIDITY_MARGINAL,
	/** The signature is never trusted */
	ALPM_SIGVALIDITY_NEVER,
	/** The signature has unknown trust */
	ALPM_SIGVALIDITY_UNKNOWN
} alpm_sigvalidity_t;

/** A PGP key */
typedef struct _alpm_pgpkey_t {
	/** The actual key data */
	void *data;
	/** The key's fingerprint */
	char *fingerprint;
	/** UID of the key */
	char *uid;
	/** Name of the key's owner */
	char *name;
	/** Email of the key's owner */
	char *email;
	/** When the key was created */
	alpm_time_t created;
	/** When the key expires */
	alpm_time_t expires;
	/** The length of the key */
	unsigned int length;
	/** has the key been revoked */
	unsigned int revoked;
	/** A character representing the  encryption algorithm used by the public key
	 *
	 * ? = unknown
	 * R = RSA
	 * D = DSA
	 * E = EDDSA
	 */
	char pubkey_algo;
} alpm_pgpkey_t;

/**
 * Signature result. Contains the key, status, and validity of a given
 * signature.
 */
typedef struct _alpm_sigresult_t {
	/** The key of the signature */
	alpm_pgpkey_t key;
	/** The status of the signature */
	alpm_sigstatus_t status;
	/** The validity of the signature */
	alpm_sigvalidity_t validity;
} alpm_sigresult_t;

/**
 * Signature list. Contains the number of signatures found and a pointer to an
 * array of results. The array is of size count.
 */
typedef struct _alpm_siglist_t {
	/** The amount of results in the array */
	size_t count;
	/** An array of sigresults */
	alpm_sigresult_t *results;
} alpm_siglist_t;

/**
 * Check the PGP signature for the given package file.
 * @param pkg the package to check
 * @param siglist a pointer to storage for signature results
 * @return a int value : 0 (valid), 1 (invalid), -1 (an error occurred)
 */
int alpm_pkg_check_pgp_signature(alpm_pkg_t *pkg, alpm_siglist_t *siglist);

/**
 * Check the PGP signature for the given database.
 * @param db the database to check
 * @param siglist a pointer to storage for signature results
 * @return a int value : 0 (valid), 1 (invalid), -1 (an error occurred)
 */
int alpm_db_check_pgp_signature(alpm_db_t *db, alpm_siglist_t *siglist);

/**
 * Clean up and free a signature result list.
 * Note that this does not free the siglist object itself in case that
 * was allocated on the stack; this is the responsibility of the caller.
 * @param siglist a pointer to storage for signature results
 * @return 0 on success, -1 on error
 */
int alpm_siglist_cleanup(alpm_siglist_t *siglist);

/**
 * Decode a loaded signature in base64 form.
 * @param base64_data the signature to attempt to decode
 * @param data the decoded data; must be freed by the caller
 * @param data_len the length of the returned data
 * @return 0 on success, -1 on failure to properly decode
 */
int alpm_decode_signature(const char *base64_data,
		unsigned char **data, size_t *data_len);

/**
 * Extract the Issuer Key ID from a signature
 * @param handle the context handle
 * @param identifier the identifier of the key.
 * This may be the name of the package or the path to the package.
 * @param sig PGP signature
 * @param len length of signature
 * @param keys a pointer to storage for key IDs
 * @return 0 on success, -1 on error
 */
int alpm_extract_keyid(alpm_handle_t *handle, const char *identifier,
		const unsigned char *sig, const size_t len, alpm_list_t **keys);

/* End of libalpm_sig */
/** @} */


/** @addtogroup libalpm_depends Dependency
 * @brief Functions dealing with libalpm's dependency and conflict
 * information.
 * @{
 */

/** Types of version constraints in dependency specs. */
typedef enum _alpm_depmod_t {
        /** No version constraint */
        ALPM_DEP_MOD_ANY = 1,
        /** Test version equality (package=x.y.z) */
        ALPM_DEP_MOD_EQ,
        /** Test for at least a version (package>=x.y.z) */
        ALPM_DEP_MOD_GE,
        /** Test for at most a version (package<=x.y.z) */
        ALPM_DEP_MOD_LE,
        /** Test for greater than some version (package>x.y.z) */
        ALPM_DEP_MOD_GT,
        /** Test for less than some version (package<x.y.z) */
        ALPM_DEP_MOD_LT
} alpm_depmod_t;

/**
 * File conflict type.
 * Whether the conflict results from a file existing on the filesystem, or with
 * another target in the transaction.
 */
typedef enum _alpm_fileconflicttype_t {
	/** The conflict results with a another target in the transaction */
	ALPM_FILECONFLICT_TARGET = 1,
	/** The conflict results from a file existing on the filesystem */
	ALPM_FILECONFLICT_FILESYSTEM
} alpm_fileconflicttype_t;

/** The basic dependency type.
 *
 * This type is used throughout libalpm, not just for dependencies
 * but also conflicts and providers. */
typedef struct _alpm_depend_t {
	/**  Name of the provider to satisfy this dependency */
	char *name;
	/**  Version of the provider to match against (optional) */
	char *version;
	/** A description of why this dependency is needed (optional) */
	char *desc;
	/** A hash of name (used internally to speed up conflict checks) */
	unsigned long name_hash;
	/** How the version should match against the provider */
	alpm_depmod_t mod;
} alpm_depend_t;

/** Missing dependency. */
typedef struct _alpm_depmissing_t {
	/** Name of the package that has the dependency */
	char *target;
	/** The dependency that was wanted */
	alpm_depend_t *depend;
	/** If the depmissing was caused by a conflict, the name of the package
	 * that would be installed, causing the satisfying package to be removed */
	char *causingpkg;
} alpm_depmissing_t;

/** A conflict that has occurred between two packages. */
typedef struct _alpm_conflict_t {
	/** Hash of the first package name
	 * (used internally to speed up conflict checks) */
	unsigned long package1_hash;
	/** Hash of the second package name
	 * (used internally to speed up conflict checks) */
	unsigned long package2_hash;
	/** Name of the first package */
	char *package1;
	/** Name of the second package */
	char *package2;
	/** The conflict */
	alpm_depend_t *reason;
} alpm_conflict_t;

/** File conflict.
 *
 * A conflict that has happened due to a two packages containing the same file,
 * or a package contains a file that is already on the filesystem and not owned
 * by that package. */
typedef struct _alpm_fileconflict_t {
	/** The name of the package that caused the conflict */
	char *target;
	/** The type of conflict */
	alpm_fileconflicttype_t type;
	/** The name of the file that the package conflicts with */
	char *file;
	/** The name of the package that also owns the file if there is one*/
	char *ctarget;
} alpm_fileconflict_t;

/** Checks dependencies and returns missing ones in a list.
 * Dependencies can include versions with depmod operators.
 * @param handle the context handle
 * @param pkglist the list of local packages
 * @param remove an alpm_list_t* of packages to be removed
 * @param upgrade an alpm_list_t* of packages to be upgraded (remove-then-upgrade)
 * @param reversedeps handles the backward dependencies
 * @return an alpm_list_t* of alpm_depmissing_t pointers.
 */
alpm_list_t *alpm_checkdeps(alpm_handle_t *handle, alpm_list_t *pkglist,
		alpm_list_t *remove, alpm_list_t *upgrade, int reversedeps);

/** Find a package satisfying a specified dependency.
 * The dependency can include versions with depmod operators.
 * @param pkgs an alpm_list_t* of alpm_pkg_t where the satisfyer will be searched
 * @param depstring package or provision name, versioned or not
 * @return a alpm_pkg_t* satisfying depstring
 */
alpm_pkg_t *alpm_find_satisfier(alpm_list_t *pkgs, const char *depstring);

/** Find a package satisfying a specified dependency.
 * First look for a literal, going through each db one by one. Then look for
 * providers. The first satisfyer that belongs to an installed package is
 * returned. If no providers belong to an installed package then an
 * alpm_question_select_provider_t is created to select the provider.
 * The dependency can include versions with depmod operators.
 *
 * @param handle the context handle
 * @param dbs an alpm_list_t* of alpm_db_t where the satisfyer will be searched
 * @param depstring package or provision name, versioned or not
 * @return a alpm_pkg_t* satisfying depstring
 */
alpm_pkg_t *alpm_find_dbs_satisfier(alpm_handle_t *handle,
		alpm_list_t *dbs, const char *depstring);

/** Check the package conflicts in a database
 *
 * @param handle the context handle
 * @param pkglist the list of packages to check
 *
 * @return an alpm_list_t of alpm_conflict_t
 */
alpm_list_t *alpm_checkconflicts(alpm_handle_t *handle, alpm_list_t *pkglist);

/** Returns a newly allocated string representing the dependency information.
 * @param dep a dependency info structure
 * @return a formatted string, e.g. "glibc>=2.12"
 */
char *alpm_dep_compute_string(const alpm_depend_t *dep);

/** Return a newly allocated dependency information parsed from a string
 *\link alpm_dep_free should be used to free the dependency \endlink
 * @param depstring a formatted string, e.g. "glibc=2.12"
 * @return a dependency info structure
 */
alpm_depend_t *alpm_dep_from_string(const char *depstring);

/** Free a dependency info structure
 * @param dep struct to free
 */
void alpm_dep_free(alpm_depend_t *dep);

/** Free a fileconflict and its members.
 * @param conflict the fileconflict to free
 */
void alpm_fileconflict_free(alpm_fileconflict_t *conflict);

/** Free a depmissing and its members
 * @param miss the depmissing to free
 * */
void alpm_depmissing_free(alpm_depmissing_t *miss);

/**
 * Free a conflict and its members.
 * @param conflict the conflict to free
 */
void alpm_conflict_free(alpm_conflict_t *conflict);


/* End of libalpm_depends */
/** @} */


/** \addtogroup libalpm_cb Callbacks
 * @brief Functions and structures for libalpm's callbacks
 * @{
 */

/**
 * Type of events.
 */
typedef enum _alpm_event_type_t {
	/** Dependencies will be computed for a package. */
	ALPM_EVENT_CHECKDEPS_START = 1,
	/** Dependencies were computed for a package. */
	ALPM_EVENT_CHECKDEPS_DONE,
	/** File conflicts will be computed for a package. */
	ALPM_EVENT_FILECONFLICTS_START,
	/** File conflicts were computed for a package. */
	ALPM_EVENT_FILECONFLICTS_DONE,
	/** Dependencies will be resolved for target package. */
	ALPM_EVENT_RESOLVEDEPS_START,
	/** Dependencies were resolved for target package. */
	ALPM_EVENT_RESOLVEDEPS_DONE,
	/** Inter-conflicts will be checked for target package. */
	ALPM_EVENT_INTERCONFLICTS_START,
	/** Inter-conflicts were checked for target package. */
	ALPM_EVENT_INTERCONFLICTS_DONE,
	/** Processing the package transaction is starting. */
	ALPM_EVENT_TRANSACTION_START,
	/** Processing the package transaction is finished. */
	ALPM_EVENT_TRANSACTION_DONE,
	/** Package will be installed/upgraded/downgraded/re-installed/removed; See
	 * alpm_event_package_operation_t for arguments. */
	ALPM_EVENT_PACKAGE_OPERATION_START,
	/** Package was installed/upgraded/downgraded/re-installed/removed; See
	 * alpm_event_package_operation_t for arguments. */
	ALPM_EVENT_PACKAGE_OPERATION_DONE,
	/** Target package's integrity will be checked. */
	ALPM_EVENT_INTEGRITY_START,
	/** Target package's integrity was checked. */
	ALPM_EVENT_INTEGRITY_DONE,
	/** Target package will be loaded. */
	ALPM_EVENT_LOAD_START,
	/** Target package is finished loading. */
	ALPM_EVENT_LOAD_DONE,
	/** Scriptlet has printed information; See alpm_event_scriptlet_info_t for
	 * arguments. */
	ALPM_EVENT_SCRIPTLET_INFO,
	/** Database files will be downloaded from a repository. */
	ALPM_EVENT_DB_RETRIEVE_START,
	/** Database files were downloaded from a repository. */
	ALPM_EVENT_DB_RETRIEVE_DONE,
	/** Not all database files were successfully downloaded from a repository. */
	ALPM_EVENT_DB_RETRIEVE_FAILED,
	/** Package files will be downloaded from a repository. */
	ALPM_EVENT_PKG_RETRIEVE_START,
	/** Package files were downloaded from a repository. */
	ALPM_EVENT_PKG_RETRIEVE_DONE,
	/** Not all package files were successfully downloaded from a repository. */
	ALPM_EVENT_PKG_RETRIEVE_FAILED,
	/** Disk space usage will be computed for a package. */
	ALPM_EVENT_DISKSPACE_START,
	/** Disk space usage was computed for a package. */
	ALPM_EVENT_DISKSPACE_DONE,
	/** An optdepend for another package is being removed; See
	 * alpm_event_optdep_removal_t for arguments. */
	ALPM_EVENT_OPTDEP_REMOVAL,
	/** A configured repository database is missing; See
	 * alpm_event_database_missing_t for arguments. */
	ALPM_EVENT_DATABASE_MISSING,
	/** Checking keys used to create signatures are in keyring. */
	ALPM_EVENT_KEYRING_START,
	/** Keyring checking is finished. */
	ALPM_EVENT_KEYRING_DONE,
	/** Downloading missing keys into keyring. */
	ALPM_EVENT_KEY_DOWNLOAD_START,
	/** Key downloading is finished. */
	ALPM_EVENT_KEY_DOWNLOAD_DONE,
	/** A .pacnew file was created; See alpm_event_pacnew_created_t for arguments. */
	ALPM_EVENT_PACNEW_CREATED,
	/** A .pacsave file was created; See alpm_event_pacsave_created_t for
	 * arguments. */
	ALPM_EVENT_PACSAVE_CREATED,
	/** Processing hooks will be started. */
	ALPM_EVENT_HOOK_START,
	/** Processing hooks is finished. */
	ALPM_EVENT_HOOK_DONE,
	/** A hook is starting */
	ALPM_EVENT_HOOK_RUN_START,
	/** A hook has finished running. */
	ALPM_EVENT_HOOK_RUN_DONE
} alpm_event_type_t;

/** An event that may represent any event. */
typedef struct _alpm_event_any_t {
	/** Type of event */
	alpm_event_type_t type;
} alpm_event_any_t;

/** An enum over the kind of package operations. */
typedef enum _alpm_package_operation_t {
	/** Package (to be) installed. (No oldpkg) */
	ALPM_PACKAGE_INSTALL = 1,
	/** Package (to be) upgraded */
	ALPM_PACKAGE_UPGRADE,
	/** Package (to be) re-installed */
	ALPM_PACKAGE_REINSTALL,
	/** Package (to be) downgraded */
	ALPM_PACKAGE_DOWNGRADE,
	/** Package (to be) removed (No newpkg) */
	ALPM_PACKAGE_REMOVE
} alpm_package_operation_t;

/** A package operation event occurred. */
typedef struct _alpm_event_package_operation_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Type of operation */
	alpm_package_operation_t operation;
	/** Old package */
	alpm_pkg_t *oldpkg;
	/** New package */
	alpm_pkg_t *newpkg;
} alpm_event_package_operation_t;

/** An optional dependency was removed. */
typedef struct _alpm_event_optdep_removal_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Package with the optdep */
	alpm_pkg_t *pkg;
	/** Optdep being removed */
	alpm_depend_t *optdep;
} alpm_event_optdep_removal_t;

/** A scriptlet was ran. */
typedef struct _alpm_event_scriptlet_info_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Line of scriptlet output */
	const char *line;
} alpm_event_scriptlet_info_t;


/** A database is missing.
 *
 * The database is registered but has not been downloaded
 */
typedef struct _alpm_event_database_missing_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Name of the database */
	const char *dbname;
} alpm_event_database_missing_t;

/** A package was downloaded. */
typedef struct _alpm_event_pkgdownload_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Name of the file */
	const char *file;
} alpm_event_pkgdownload_t;

/** A pacnew file was created. */
typedef struct _alpm_event_pacnew_created_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Whether the creation was result of a NoUpgrade or not */
	int from_noupgrade;
	/** Old package */
	alpm_pkg_t *oldpkg;
	/** New Package */
	alpm_pkg_t *newpkg;
	/** Filename of the file without the .pacnew suffix */
	const char *file;
} alpm_event_pacnew_created_t;

/** A pacsave file was created. */
typedef struct _alpm_event_pacsave_created_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Old package */
	alpm_pkg_t *oldpkg;
	/** Filename of the file without the .pacsave suffix */
	const char *file;
} alpm_event_pacsave_created_t;

/** Kind of hook. */
typedef enum _alpm_hook_when_t {
	/* Pre transaction hook */
	ALPM_HOOK_PRE_TRANSACTION = 1,
	/* Post transaction hook */
	ALPM_HOOK_POST_TRANSACTION
} alpm_hook_when_t;

/** pre/post transaction hooks are to be ran. */
typedef struct _alpm_event_hook_t {
	/** Type of event*/
	alpm_event_type_t type;
	/** Type of hook */
	alpm_hook_when_t when;
} alpm_event_hook_t;

/** A pre/post transaction hook was ran. */
typedef struct _alpm_event_hook_run_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Name of hook */
	const char *name;
	/** Description of hook to be outputted */
	const char *desc;
	/** position of hook being run */
	size_t position;
	/** total hooks being run */
	size_t total;
} alpm_event_hook_run_t;

/** Packages downloading about to start. */
typedef struct _alpm_event_pkg_retrieve_t {
	/** Type of event */
	alpm_event_type_t type;
	/** Number of packages to download */
	size_t num;
	/** Total size of packages to download */
	off_t total_size;
} alpm_event_pkg_retrieve_t;

/** Events.
 * This is a union passed to the callback that allows the frontend to know
 * which type of event was triggered (via type). It is then possible to
 * typecast the pointer to the right structure, or use the union field, in order
 * to access event-specific data. */
typedef union _alpm_event_t {
	/** Type of event it's always safe to access this. */
	alpm_event_type_t type;
	/** The any event type. It's always safe to access this. */
	alpm_event_any_t any;
	/** Package operation */
	alpm_event_package_operation_t package_operation;
	/** An optdept was remove */
	alpm_event_optdep_removal_t optdep_removal;
	/** A scriptlet was ran */
	alpm_event_scriptlet_info_t scriptlet_info;
	/** A database is missing */
	alpm_event_database_missing_t database_missing;
	/** A package was downloaded */
	alpm_event_pkgdownload_t pkgdownload;
	/** A pacnew file was created */
	alpm_event_pacnew_created_t pacnew_created;
	/** A pacsave file was created */
	alpm_event_pacsave_created_t pacsave_created;
	/** Pre/post transaction hooks are being ran */
	alpm_event_hook_t hook;
	/** A hook was ran */
	alpm_event_hook_run_t hook_run;
	/** Download packages */
	alpm_event_pkg_retrieve_t pkg_retrieve;
} alpm_event_t;

/** Event callback.
 *
 * Called when an event occurs
 * @param ctx user-provided context
 * @param event the event that occurred */
typedef void (*alpm_cb_event)(void *ctx, alpm_event_t *);

/**
 * Type of question.
 * Unlike the events or progress enumerations, this enum has bitmask values
 * so a frontend can use a bitmask map to supply preselected answers to the
 * different types of questions.
 */
typedef enum _alpm_question_type_t {
	/** Should target in ignorepkg be installed anyway? */
	ALPM_QUESTION_INSTALL_IGNOREPKG = (1 << 0),
	/** Should a package be replaced? */
	ALPM_QUESTION_REPLACE_PKG = (1 << 1),
	/** Should a conflicting package be removed? */
	ALPM_QUESTION_CONFLICT_PKG = (1 << 2),
	/** Should a corrupted package be deleted? */
	ALPM_QUESTION_CORRUPTED_PKG = (1 << 3),
	/** Should unresolvable targets be removed from the transaction? */
	ALPM_QUESTION_REMOVE_PKGS = (1 << 4),
	/** Provider selection */
	ALPM_QUESTION_SELECT_PROVIDER = (1 << 5),
	/** Should a key be imported? */
	ALPM_QUESTION_IMPORT_KEY = (1 << 6)
} alpm_question_type_t;

/** A question that can represent any other question. */
typedef struct _alpm_question_any_t {
	/** Type of question */
	alpm_question_type_t type;
	/** Answer */
	int answer;
} alpm_question_any_t;

/** Should target in ignorepkg be installed anyway? */
typedef struct _alpm_question_install_ignorepkg_t {
	/** Type of question */
	alpm_question_type_t type;
	/** Answer: whether or not to install pkg anyway */
	int install;
	/** The ignored package that we are deciding whether to install */
	alpm_pkg_t *pkg;
} alpm_question_install_ignorepkg_t;

/** Should a package be replaced? */
typedef struct _alpm_question_replace_t {
	/** Type of question */
	alpm_question_type_t type;
	/** Answer: whether or not to replace oldpkg with newpkg */
	int replace;
	/** Package to be replaced */
	alpm_pkg_t *oldpkg;
	/** Package to replace with.*/
	alpm_pkg_t *newpkg;
	/** DB of newpkg */
	alpm_db_t *newdb;
} alpm_question_replace_t;

/** Should a conflicting package be removed? */
typedef struct _alpm_question_conflict_t {
	/** Type of question */
	alpm_question_type_t type;
	/** Answer: whether or not to remove conflict->package2 */
	int remove;
	/** Conflict info */
	alpm_conflict_t *conflict;
} alpm_question_conflict_t;

/** Should a corrupted package be deleted? */
typedef struct _alpm_question_corrupted_t {
	/** Type of question */
	alpm_question_type_t type;
	/** Answer: whether or not to remove filepath */
	int remove;
	/** File to remove */
	const char *filepath;
	/** Error code indicating the reason for package invalidity */
	alpm_errno_t reason;
} alpm_question_corrupted_t;

/** Should unresolvable targets be removed from the transaction? */
typedef struct _alpm_question_remove_pkgs_t {
	/** Type of question */
	alpm_question_type_t type;
	/** Answer: whether or not to skip packages */
	int skip;
	/** List of alpm_pkg_t* with unresolved dependencies */
	alpm_list_t *packages;
} alpm_question_remove_pkgs_t;

/** Provider selection */
typedef struct _alpm_question_select_provider_t {
	/** Type of question */
	alpm_question_type_t type;
	/** Answer: which provider to use (index from providers) */
	int use_index;
	/** List of alpm_pkg_t* as possible providers */
	alpm_list_t *providers;
	/** What providers provide for */
	alpm_depend_t *depend;
} alpm_question_select_provider_t;

/** Should a key be imported? */
typedef struct _alpm_question_import_key_t {
	/** Type of question */
	alpm_question_type_t type;
	/** Answer: whether or not to import key */
	int import;
	/** The key to import */
	alpm_pgpkey_t *key;
} alpm_question_import_key_t;

/**
 * Questions.
 * This is an union passed to the callback that allows the frontend to know
 * which type of question was triggered (via type). It is then possible to
 * typecast the pointer to the right structure, or use the union field, in order
 * to access question-specific data. */
typedef union _alpm_question_t {
	/** The type of question. It's always safe to access this. */
	alpm_question_type_t type;
	/** A question that can represent any question.
	 * It's always safe to access this. */
	alpm_question_any_t any;
	/** Should target in ignorepkg be installed anyway? */
	alpm_question_install_ignorepkg_t install_ignorepkg;
	/** Should a package be replaced? */
	alpm_question_replace_t replace;
	/** Should a conflicting package be removed? */
	alpm_question_conflict_t conflict;
	/** Should a corrupted package be deleted? */
	alpm_question_corrupted_t corrupted;
	/** Should unresolvable targets be removed from the transaction? */
	alpm_question_remove_pkgs_t remove_pkgs;
	/** Provider selection */
	alpm_question_select_provider_t select_provider;
	/** Should a key be imported? */
	alpm_question_import_key_t import_key;
} alpm_question_t;

/** Question callback.
 *
 * This callback allows user to give input and decide what to do during certain events
 * @param ctx user-provided context
 * @param question the question being asked.
 */
typedef void (*alpm_cb_question)(void *ctx, alpm_question_t *);

/** An enum over different kinds of progress alerts. */
typedef enum _alpm_progress_t {
	/** Package install */
	ALPM_PROGRESS_ADD_START,
	/** Package upgrade */
	ALPM_PROGRESS_UPGRADE_START,
	/** Package downgrade */
	ALPM_PROGRESS_DOWNGRADE_START,
	/** Package reinstall */
	ALPM_PROGRESS_REINSTALL_START,
	/** Package removal */
	ALPM_PROGRESS_REMOVE_START,
	/** Conflict checking */
	ALPM_PROGRESS_CONFLICTS_START,
	/** Diskspace checking */
	ALPM_PROGRESS_DISKSPACE_START,
	/** Package Integrity checking */
	ALPM_PROGRESS_INTEGRITY_START,
	/** Loading packages from disk */
	ALPM_PROGRESS_LOAD_START,
	/** Checking signatures of packages */
	ALPM_PROGRESS_KEYRING_START
} alpm_progress_t;

/** Progress callback
 *
 * Alert the front end about the progress of certain events.
 * Allows the implementation of loading bars for events that
 * make take a while to complete.
 * @param ctx user-provided context
 * @param progress the kind of event that is progressing
 * @param pkg for package operations, the name of the package being operated on
 * @param percent the percent completion of the action
 * @param howmany the total amount of items in the action
 * @param current the current amount of items completed
 */
/** Progress callback */
typedef void (*alpm_cb_progress)(void *ctx, alpm_progress_t progress, const char *pkg,
		int percent, size_t howmany, size_t current);

/*
 * Downloading
 */

/** File download events.
 * These events are reported by ALPM via download callback.
 */
typedef enum _alpm_download_event_type_t {
	/** A download was started */
	ALPM_DOWNLOAD_INIT,
	/** A download made progress */
	ALPM_DOWNLOAD_PROGRESS,
	/** Download will be retried */
	ALPM_DOWNLOAD_RETRY,
	/** A download completed */
	ALPM_DOWNLOAD_COMPLETED
} alpm_download_event_type_t;

/** Context struct for when a download starts. */
typedef struct _alpm_download_event_init_t {
	/** whether this file is optional and thus the errors could be ignored */
	int optional;
} alpm_download_event_init_t;

/** Context struct for when a download progresses. */
typedef struct _alpm_download_event_progress_t {
	/** Amount of data downloaded */
	off_t downloaded;
	/** Total amount need to be downloaded */
	off_t total;
} alpm_download_event_progress_t;

/** Context struct for when a download retries. */
typedef struct _alpm_download_event_retry_t {
	/** If the download will resume or start over */
	int resume;
} alpm_download_event_retry_t;

/** Context struct for when a download completes. */
typedef struct _alpm_download_event_completed_t {
	/** Total bytes in file */
	off_t total;
	/** download result code:
	 *    0 - download completed successfully
	 *    1 - the file is up-to-date
	 *   -1 - error
	 */
	int result;
} alpm_download_event_completed_t;

/** Type of download progress callbacks.
 * @param ctx user-provided context
 * @param filename the name of the file being downloaded
 * @param event the event type
 * @param data the event data of type alpm_download_event_*_t
 */
typedef void (*alpm_cb_download)(void *ctx, const char *filename,
		alpm_download_event_type_t event, void *data);


/** A callback for downloading files
 * @param ctx user-provided context
 * @param url the URL of the file to be downloaded
 * @param localpath the directory to which the file should be downloaded
 * @param force whether to force an update, even if the file is the same
 * @return 0 on success, 1 if the file exists and is identical, -1 on
 * error.
 */
typedef int (*alpm_cb_fetch)(void *ctx, const char *url, const char *localpath,
		int force);

/* End of libalpm_cb */
/** @} */


/** @addtogroup libalpm_databases Database
 * @brief Functions to query and manipulate the database of libalpm.
 * @{
 */

/** Get the database of locally installed packages.
 * The returned pointer points to an internal structure
 * of libalpm which should only be manipulated through
 * libalpm functions.
 * @return a reference to the local database
 */
alpm_db_t *alpm_get_localdb(alpm_handle_t *handle);

/** Get the list of sync databases.
 * Returns a list of alpm_db_t structures, one for each registered
 * sync database.
 *
 * @param handle the context handle
 * @return a reference to an internal list of alpm_db_t structures
 */
alpm_list_t *alpm_get_syncdbs(alpm_handle_t *handle);

/** Register a sync database of packages.
 * Databases can not be registered when there is an active transaction.
 *
 * @param handle the context handle
 * @param treename the name of the sync repository
 * @param level what level of signature checking to perform on the
 * database; note that this must be a '.sig' file type verification
 * @return an alpm_db_t* on success (the value), NULL on error
 */
alpm_db_t *alpm_register_syncdb(alpm_handle_t *handle, const char *treename,
		int level);

/** Unregister all package databases.
 * Databases can not be unregistered while there is an active transaction.
 *
 * @param handle the context handle
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_unregister_all_syncdbs(alpm_handle_t *handle);

/** Unregister a package database.
 * Databases can not be unregistered when there is an active transaction.
 *
 * @param db pointer to the package database to unregister
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_db_unregister(alpm_db_t *db);

/** Get the name of a package database.
 * @param db pointer to the package database
 * @return the name of the package database, NULL on error
 */
const char *alpm_db_get_name(const alpm_db_t *db);

/** Get the signature verification level for a database.
 * Will return the default verification level if this database is set up
 * with ALPM_SIG_USE_DEFAULT.
 * @param db pointer to the package database
 * @return the signature verification level
 */
int alpm_db_get_siglevel(alpm_db_t *db);

/** Check the validity of a database.
 * This is most useful for sync databases and verifying signature status.
 * If invalid, the handle error code will be set accordingly.
 * @param db pointer to the package database
 * @return 0 if valid, -1 if invalid (pm_errno is set accordingly)
 */
int alpm_db_get_valid(alpm_db_t *db);

/** @name Server accessors
 * @{
 */

/** Get the list of servers assigned to this db.
 * @param db pointer to the database to get the servers from
 * @return a char* list of servers
 */
alpm_list_t *alpm_db_get_servers(const alpm_db_t *db);

/** Sets the list of servers for the database to use.
 * @param db the database to set the servers. The list will be duped and
 * the original will still need to be freed by the caller.
 * @param servers a char* list of servers.
 */
int alpm_db_set_servers(alpm_db_t *db, alpm_list_t *servers);

/** Add a download server to a database.
 * @param db database pointer
 * @param url url of the server
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_db_add_server(alpm_db_t *db, const char *url);

/** Remove a download server from a database.
 * @param db database pointer
 * @param url url of the server
 * @return 0 on success, 1 on server not present,
 * -1 on error (pm_errno is set accordingly)
 */
int alpm_db_remove_server(alpm_db_t *db, const char *url);

/* End of server accessors */
/** @} */

/** Update package databases.
 *
 * An update of the package databases in the list \a dbs will be attempted.
 * Unless \a force is true, the update will only be performed if the remote
 * databases were modified since the last update.
 *
 * This operation requires a database lock, and will return an applicable error
 * if the lock could not be obtained.
 *
 * Example:
 * @code
 * alpm_list_t *dbs = alpm_get_syncdbs(config->handle);
 * ret = alpm_db_update(config->handle, dbs, force);
 * if(ret < 0) {
 *     pm_printf(ALPM_LOG_ERROR, _("failed to synchronize all databases (%s)\n"),
 *         alpm_strerror(alpm_errno(config->handle)));
 * }
 * @endcode
 *
 * @note After a successful update, the \link alpm_db_get_pkgcache()
 * package cache \endlink will be invalidated
 * @param handle the context handle
 * @param dbs list of package databases to update
 * @param force if true, then forces the update, otherwise update only in case
 * the databases aren't up to date
 * @return 0 on success, -1 on error (pm_errno is set accordingly),
 * 1 if all databases are up to to date
 */
int alpm_db_update(alpm_handle_t *handle, alpm_list_t *dbs, int force);

/** Get a package entry from a package database.
 * Looking up a package is O(1) and will be significantly faster than
 * iterating over the pkgcahe.
 * @param db pointer to the package database to get the package from
 * @param name of the package
 * @return the package entry on success, NULL on error
 */
alpm_pkg_t *alpm_db_get_pkg(alpm_db_t *db, const char *name);

/** Get the package cache of a package database.
 * This is a list of all packages the db contains.
 * @param db pointer to the package database to get the package from
 * @return the list of packages on success, NULL on error
 */
alpm_list_t *alpm_db_get_pkgcache(alpm_db_t *db);

/** Get a group entry from a package database.
 * Looking up a group is O(1) and will be significantly faster than
 * iterating over the groupcahe.
 * @param db pointer to the package database to get the group from
 * @param name of the group
 * @return the groups entry on success, NULL on error
 */
alpm_group_t *alpm_db_get_group(alpm_db_t *db, const char *name);

/** Get the group cache of a package database.
 * @param db pointer to the package database to get the group from
 * @return the list of groups on success, NULL on error
 */
alpm_list_t *alpm_db_get_groupcache(alpm_db_t *db);

/** Searches a database with regular expressions.
 * @param db pointer to the package database to search in
 * @param needles a list of regular expressions to search for
 * @param ret pointer to list for storing packages matching all
 * regular expressions - must point to an empty (NULL) alpm_list_t *.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_db_search(alpm_db_t *db, const alpm_list_t *needles,
		alpm_list_t **ret);

/** The usage level of a database. */
typedef enum _alpm_db_usage_t {
       /** Enable refreshes for this database */
       ALPM_DB_USAGE_SYNC = 1,
       /** Enable search for this database */
       ALPM_DB_USAGE_SEARCH = (1 << 1),
       /** Enable installing packages from this database */
       ALPM_DB_USAGE_INSTALL = (1 << 2),
       /** Enable sysupgrades with this database */
       ALPM_DB_USAGE_UPGRADE = (1 << 3),
       /** Enable all usage levels */
       ALPM_DB_USAGE_ALL = (1 << 4) - 1,
} alpm_db_usage_t;

/** @name Usage accessors
 * @{
 */

/** Sets the usage of a database.
 * @param db pointer to the package database to set the status for
 * @param usage a bitmask of alpm_db_usage_t values
 * @return 0 on success, or -1 on error
 */
int alpm_db_set_usage(alpm_db_t *db, int usage);

/** Gets the usage of a database.
 * @param db pointer to the package database to get the status of
 * @param usage pointer to an alpm_db_usage_t to store db's status
 * @return 0 on success, or -1 on error
 */
int alpm_db_get_usage(alpm_db_t *db, int *usage);

/* End of usage accessors */
/** @} */


/* End of libalpm_databases */
/** @} */


/** \addtogroup libalpm_log Logging Functions
 * @brief Functions to log using libalpm
 * @{
 */

/** Logging Levels */
typedef enum _alpm_loglevel_t {
       /** Error */
       ALPM_LOG_ERROR    = 1,
       /** Warning */
       ALPM_LOG_WARNING  = (1 << 1),
       /** Debug */
       ALPM_LOG_DEBUG    = (1 << 2),
       /** Function */
       ALPM_LOG_FUNCTION = (1 << 3)
} alpm_loglevel_t;


/** The callback type for logging.
 *
 * libalpm will call this function whenever something is to be logged.
 * many libalpm will produce log output. Additionally any calls to \link alpm_logaction
 * \endlink will also call this callback.
 * @param ctx user-provided context
 * @param level the currently set loglevel
 * @param fmt the printf like format string
 * @param args printf like arguments
 */
typedef void (*alpm_cb_log)(void *ctx, alpm_loglevel_t level, const char *fmt, va_list args);

/** A printf-like function for logging.
 * @param handle the context handle
 * @param prefix caller-specific prefix for the log
 * @param fmt output format
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_logaction(alpm_handle_t *handle, const char *prefix,
		const char *fmt, ...) __attribute__((format(printf, 3, 4)));

/* End of libalpm_log */
/** @} */


/** @addtogroup libalpm_options Options
 * Libalpm option getters and setters
 * @{
 */

/** @name Accessors for callbacks
 * @{
 */

/** Returns the callback used for logging.
 * @param handle the context handle
 * @return the currently set log callback
 */
alpm_cb_log alpm_option_get_logcb(alpm_handle_t *handle);

/** Returns the callback used for logging.
 * @param handle the context handle
 * @return the currently set log callback context
 */
void *alpm_option_get_logcb_ctx(alpm_handle_t *handle);

/** Sets the callback used for logging.
 * @param handle the context handle
 * @param cb the cb to use
 * @param ctx user-provided context to pass to cb
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_logcb(alpm_handle_t *handle, alpm_cb_log cb, void *ctx);

/** Returns the callback used to report download progress.
 * @param handle the context handle
 * @return the currently set download callback
 */
alpm_cb_download alpm_option_get_dlcb(alpm_handle_t *handle);

/** Returns the callback used to report download progress.
 * @param handle the context handle
 * @return the currently set download callback context
 */
void *alpm_option_get_dlcb_ctx(alpm_handle_t *handle);

/** Sets the callback used to report download progress.
 * @param handle the context handle
 * @param cb the cb to use
 * @param ctx user-provided context to pass to cb
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_dlcb(alpm_handle_t *handle, alpm_cb_download cb, void *ctx);

/** Returns the downloading callback.
 * @param handle the context handle
 * @return the currently set fetch callback
 */
alpm_cb_fetch alpm_option_get_fetchcb(alpm_handle_t *handle);

/** Returns the downloading callback.
 * @param handle the context handle
 * @return the currently set fetch callback context
 */
void *alpm_option_get_fetchcb_ctx(alpm_handle_t *handle);

/** Sets the downloading callback.
 * @param handle the context handle
 * @param cb the cb to use
 * @param ctx user-provided context to pass to cb
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_fetchcb(alpm_handle_t *handle, alpm_cb_fetch cb, void *ctx);

/** Returns the callback used for events.
 * @param handle the context handle
 * @return the currently set event callback
 */
alpm_cb_event alpm_option_get_eventcb(alpm_handle_t *handle);

/** Returns the callback used for events.
 * @param handle the context handle
 * @return the currently set event callback context
 */
void *alpm_option_get_eventcb_ctx(alpm_handle_t *handle);

/** Sets the callback used for events.
 * @param handle the context handle
 * @param cb the cb to use
 * @param ctx user-provided context to pass to cb
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_eventcb(alpm_handle_t *handle, alpm_cb_event cb, void *ctx);

/** Returns the callback used for questions.
 * @param handle the context handle
 * @return the currently set question callback
 */
alpm_cb_question alpm_option_get_questioncb(alpm_handle_t *handle);

/** Returns the callback used for questions.
 * @param handle the context handle
 * @return the currently set question callback context
 */
void *alpm_option_get_questioncb_ctx(alpm_handle_t *handle);

/** Sets the callback used for questions.
 * @param handle the context handle
 * @param cb the cb to use
 * @param ctx user-provided context to pass to cb
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_questioncb(alpm_handle_t *handle, alpm_cb_question cb, void *ctx);

/**Returns the callback used for operation progress.
 * @param handle the context handle
 * @return the currently set progress callback
 */
alpm_cb_progress alpm_option_get_progresscb(alpm_handle_t *handle);

/**Returns the callback used for operation progress.
 * @param handle the context handle
 * @return the currently set progress callback context
 */
void *alpm_option_get_progresscb_ctx(alpm_handle_t *handle);

/** Sets the callback used for operation progress.
 * @param handle the context handle
 * @param cb the cb to use
 * @param ctx user-provided context to pass to cb
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_progresscb(alpm_handle_t *handle, alpm_cb_progress cb, void *ctx);
/* End of callback accessors */
/** @} */


/** @name Accessors to the root directory
 *
 * The root directory is the prefix to which libalpm installs packages to.
 * Hooks and scriptlets will also be run in a chroot to ensure they behave correctly
 * in alternative roots.
 * @{
 */

/** Returns the root path. Read-only.
 * @param handle the context handle
 */
const char *alpm_option_get_root(alpm_handle_t *handle);
/* End of root accessors */
/** @} */


/** @name Accessors to the database path
 *
 * The dbpath is where libalpm stores the local db and
 * downloads sync databases.
 * @{
 */

/** Returns the path to the database directory. Read-only.
 * @param handle the context handle
 */
const char *alpm_option_get_dbpath(alpm_handle_t *handle);
/* End of dbpath accessors */
/** @} */


/** @name Accessors to the lockfile
 *
 * The lockfile is used to ensure two instances of libalpm can not write
 * to the database at the same time. The lock file is created when
 * committing a transaction and released when the transaction completes.
 * Or when calling \link alpm_unlock \endlink.
 * @{
 */

/** Get the name of the database lock file. Read-only.
 * This is the name that the lockfile would have. It does not
 * matter if the lockfile actually exists on disk.
 * @param handle the context handle
 */
const char *alpm_option_get_lockfile(alpm_handle_t *handle);
/* End of lockfile accessors */
/** @} */

/** @name Accessors to the list of package cache directories.
 *
 * This is where libalpm will store downloaded packages.
 * @{
 */

/** Gets the currently configured cachedirs,
 * @param handle the context handle
 * @return a char* list of cache directories
 */
alpm_list_t *alpm_option_get_cachedirs(alpm_handle_t *handle);

/** Sets the cachedirs.
 * @param handle the context handle
 * @param cachedirs a char* list of cachdirs. The list will be duped and
 * the original will still need to be freed by the caller.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_cachedirs(alpm_handle_t *handle, alpm_list_t *cachedirs);

/** Append a cachedir to the configured cachedirs.
 * @param handle the context handle
 * @param cachedir the cachedir to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_add_cachedir(alpm_handle_t *handle, const char *cachedir);

/** Remove a cachedir from the configured cachedirs.
 * @param handle the context handle
 * @param cachedir the cachedir to remove
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_remove_cachedir(alpm_handle_t *handle, const char *cachedir);
/* End of cachedir accessors */
/** @} */


/** @name Accessors to the list of package hook directories.
 *
 * libalpm will search these directories for hooks to run. A hook in
 * a later directory will override previous hooks if they have the same name.
 * @{
 */

/** Gets the currently configured hookdirs,
 * @param handle the context handle
 * @return a char* list of hook directories
 */
alpm_list_t *alpm_option_get_hookdirs(alpm_handle_t *handle);

/** Sets the hookdirs.
 * @param handle the context handle
 * @param hookdirs a char* list of hookdirs. The list will be duped and
 * the original will still need to be freed by the caller.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_hookdirs(alpm_handle_t *handle, alpm_list_t *hookdirs);

/** Append a hookdir to the configured hookdirs.
 * @param handle the context handle
 * @param hookdir the hookdir to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_add_hookdir(alpm_handle_t *handle, const char *hookdir);

/** Remove a hookdir from the configured hookdirs.
 * @param handle the context handle
 * @param hookdir the hookdir to remove
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_remove_hookdir(alpm_handle_t *handle, const char *hookdir);
/* End of hookdir accessors */
/** @} */


/** @name Accessors to the list of overwritable files.
 *
 * Normally libalpm will refuse to install a package that owns files that
 * are already on disk and not owned by that package.
 *
 * If a conflicting file matches a glob in the overwrite_files list, then no
 * conflict will be raised and libalpm will simply overwrite the file.
 * @{
 */

/** Gets the currently configured overwritable files,
 * @param handle the context handle
 * @return a char* list of overwritable file globs
 */
alpm_list_t *alpm_option_get_overwrite_files(alpm_handle_t *handle);

/** Sets the overwritable files.
 * @param handle the context handle
 * @param globs a char* list of overwritable file globs. The list will be duped and
 * the original will still need to be freed by the caller.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_overwrite_files(alpm_handle_t *handle, alpm_list_t *globs);

/** Append an overwritable file to the configured overwritable files.
 * @param handle the context handle
 * @param glob the file glob to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_add_overwrite_file(alpm_handle_t *handle, const char *glob);

/** Remove a file glob from the configured overwritable files globs.
 * @note The overwritable file list contains a list of globs. The glob to
 * remove must exactly match the entry to remove. There is no glob expansion.
 * @param handle the context handle
 * @param glob the file glob to remove
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_remove_overwrite_file(alpm_handle_t *handle, const char *glob);
/* End of overwrite accessors */
/** @} */


/** @name Accessors to the log file
 *
 * This controls where libalpm will save log output to.
 * @{
 */

/** Gets the filepath to the currently set logfile.
 * @param handle the context handle
 * @return the path to the logfile
 */
const char *alpm_option_get_logfile(alpm_handle_t *handle);

/** Sets the logfile path.
 * @param handle the context handle
 * @param logfile path to the new location of the logfile
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_logfile(alpm_handle_t *handle, const char *logfile);
/* End of logfile accessors */
/** @} */


/** @name Accessors to the GPG directory
 *
 * This controls where libalpm will store GnuPG's files.
 * @{
 */

/** Returns the path to libalpm's GnuPG home directory.
 * @param handle the context handle
 * @return the path to libalpms's GnuPG home directory
 */
const char *alpm_option_get_gpgdir(alpm_handle_t *handle);

/** Sets the path to libalpm's GnuPG home directory.
 * @param handle the context handle
 * @param gpgdir the gpgdir to set
 */
int alpm_option_set_gpgdir(alpm_handle_t *handle, const char *gpgdir);
/* End of gpdir accessors */
/** @} */


/** @name Accessors for use syslog
 *
 * This controls whether libalpm will also use the syslog. Even if this option
 * is enabled, libalpm will still try to log to its log file.
 * @{
 */

/** Returns whether to use syslog (0 is FALSE, TRUE otherwise).
 * @param handle the context handle
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_get_usesyslog(alpm_handle_t *handle);

/** Sets whether to use syslog (0 is FALSE, TRUE otherwise).
 * @param handle the context handle
 * @param usesyslog whether to use the syslog (0 is FALSE, TRUE otherwise)
 */
int alpm_option_set_usesyslog(alpm_handle_t *handle, int usesyslog);
/* End of usesyslog accessors */
/** @} */


/** @name Accessors to the list of no-upgrade files.
 * These functions modify the list of files which should
 * not be updated by package installation.
 * @{
 */

/** Get the list of no-upgrade files
 * @param handle the context handle
 * @return the char* list of no-upgrade files
 */
alpm_list_t *alpm_option_get_noupgrades(alpm_handle_t *handle);

/** Add a file to the no-upgrade list
 * @param handle the context handle
 * @param path the path to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_add_noupgrade(alpm_handle_t *handle, const char *path);

/** Sets the list of no-upgrade files
 * @param handle the context handle
 * @param noupgrade a char* list of file to not upgrade.
 * The list will be duped and the original will still need to be freed by the caller.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_noupgrades(alpm_handle_t *handle, alpm_list_t *noupgrade);

/** Remove an entry from the no-upgrade list
 * @param handle the context handle
 * @param path the path to remove
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_remove_noupgrade(alpm_handle_t *handle, const char *path);

/** Test if a path matches any of the globs in the no-upgrade list
 * @param handle the context handle
 * @param path the path to test
 * @return 0 is the path matches a glob, negative if there is no match and
 * positive is the  match was inverted
 */
int alpm_option_match_noupgrade(alpm_handle_t *handle, const char *path);
/* End of noupgrade accessors */
/** @} */


/** @name Accessors to the list of no-extract files.
 * These functions modify the list of filenames which should
 * be skipped packages which should
 * not be upgraded by a sysupgrade operation.
 * @{
 */

/** Get the list of no-extract files
 * @param handle the context handle
 * @return the char* list of no-extract files
 */
alpm_list_t *alpm_option_get_noextracts(alpm_handle_t *handle);

/** Add a file to the no-extract list
 * @param handle the context handle
 * @param path the path to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_add_noextract(alpm_handle_t *handle, const char *path);

/** Sets the list of no-extract files
 * @param handle the context handle
 * @param noextract a char* list of file to not extract.
 * The list will be duped and the original will still need to be freed by the caller.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_noextracts(alpm_handle_t *handle, alpm_list_t *noextract);

/** Remove an entry from the no-extract list
 * @param handle the context handle
 * @param path the path to remove
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_remove_noextract(alpm_handle_t *handle, const char *path);

/** Test if a path matches any of the globs in the no-extract list
 * @param handle the context handle
 * @param path the path to test
 * @return 0 is the path matches a glob, negative if there is no match and
 * positive is the  match was inverted
 */
int alpm_option_match_noextract(alpm_handle_t *handle, const char *path);
/* End of noextract accessors */
/** @} */


/** @name Accessors to the list of ignored packages.
 * These functions modify the list of packages that
 * should be ignored by a sysupgrade.
 *
 * Entries in this list may be globs and only match the package's
 * name. Providers are not taken into account.
 * @{
 */

/** Get the list of ignored packages
 * @param handle the context handle
 * @return the char* list of ignored packages
 */
alpm_list_t *alpm_option_get_ignorepkgs(alpm_handle_t *handle);

/** Add a file to the ignored package list
 * @param handle the context handle
 * @param pkg the package to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_add_ignorepkg(alpm_handle_t *handle, const char *pkg);

/** Sets the list of packages to ignore
 * @param handle the context handle
 * @param ignorepkgs a char* list of packages to ignore
 * The list will be duped and the original will still need to be freed by the caller.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_ignorepkgs(alpm_handle_t *handle, alpm_list_t *ignorepkgs);

/** Remove an entry from the ignorepkg list
 * @param handle the context handle
 * @param pkg the package to remove
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_remove_ignorepkg(alpm_handle_t *handle, const char *pkg);
/* End of ignorepkg accessors */
/** @} */


/** @name Accessors to the list of ignored groups.
 * These functions modify the list of groups whose packages
 * should be ignored by a sysupgrade.
 *
 * Entries in this list may be globs.
 * @{
 */

/** Get the list of ignored groups
 * @param handle the context handle
 * @return the char* list of ignored groups
 */
alpm_list_t *alpm_option_get_ignoregroups(alpm_handle_t *handle);

/** Add a file to the ignored group list
 * @param handle the context handle
 * @param grp the group to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_add_ignoregroup(alpm_handle_t *handle, const char *grp);

/** Sets the list of groups to ignore
 * @param handle the context handle
 * @param ignoregrps a char* list of groups to ignore
 * The list will be duped and the original will still need to be freed by the caller.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_ignoregroups(alpm_handle_t *handle, alpm_list_t *ignoregrps);

/** Remove an entry from the ignoregroup list
 * @param handle the context handle
 * @param grp the group to remove
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_remove_ignoregroup(alpm_handle_t *handle, const char *grp);
/* End of ignoregroup accessors */
/** @} */


/** @name Accessors to the list of ignored dependencies.
 * These functions modify the list of dependencies that
 * should be ignored by a sysupgrade.
 *
 * This is effectively a list of virtual providers that
 * packages can use to satisfy their dependencies.
 * @{
 */

/** Gets the list of dependencies that are assumed to be met
 * @param handle the context handle
 * @return a list of alpm_depend_t*
 */
alpm_list_t *alpm_option_get_assumeinstalled(alpm_handle_t *handle);

/** Add a depend to the assumed installed list
 * @param handle the context handle
 * @param dep the dependency to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_add_assumeinstalled(alpm_handle_t *handle, const alpm_depend_t *dep);

/** Sets the list of dependencies that are assumed to be met
 * @param handle the context handle
 * @param deps a list of *alpm_depend_t
 * The list will be duped and the original will still need to be freed by the caller.
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_assumeinstalled(alpm_handle_t *handle, alpm_list_t *deps);

/** Remove an entry from the assume installed list
 * @param handle the context handle
 * @param dep the dep to remove
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_remove_assumeinstalled(alpm_handle_t *handle, const alpm_depend_t *dep);
/* End of assunmeinstalled accessors */
/** @} */


/** @name Accessors to the list of allowed architectures.
 * libalpm will only install packages that match one of the configured
 * architectures. The architectures do not need to match the physical
   architecture. They can just be treated as a label.
 * @{
 */

/** Returns the allowed package architecture.
 * @param handle the context handle
 * @return the configured package architectures
 */
alpm_list_t *alpm_option_get_architectures(alpm_handle_t *handle);

/** Adds an allowed package architecture.
 * @param handle the context handle
 * @param arch the architecture to set
 */
int alpm_option_add_architecture(alpm_handle_t *handle, const char *arch);

/** Sets the allowed package architecture.
 * @param handle the context handle
 * @param arches the architecture to set
 */
int alpm_option_set_architectures(alpm_handle_t *handle, alpm_list_t *arches);

/** Removes an allowed package architecture.
 * @param handle the context handle
 * @param arch the architecture to remove
 */
int alpm_option_remove_architecture(alpm_handle_t *handle, const char *arch);

/* End of arch accessors */
/** @} */


/** @name Accessors for check space.
 *
 * This controls whether libalpm will check if there is sufficient before
 * installing packages.
 * @{
 */

/** Get whether or not checking for free space before installing packages is enabled.
 * @param handle the context handle
 * @return 0 if disabled, 1 if enabled
 */
int alpm_option_get_checkspace(alpm_handle_t *handle);

/** Enable/disable checking free space before installing packages.
 * @param handle the context handle
 * @param checkspace 0 for disabled, 1 for enabled
 */
int alpm_option_set_checkspace(alpm_handle_t *handle, int checkspace);
/* End of checkspace accessors */
/** @} */


/** @name Accessors for the database extension
 *
 * This controls the extension used for sync databases. libalpm will use this
 * extension to both lookup remote databses and as the name used when opening
 * reading them.
 *
 * This is useful for file databases. Seems as files can increase the size of
 * a database by quite a lot, a server could hold a database without files under
 * one extension, and another with files under another extension.
 *
 * Which one is downloaded and used then depends on this setting.
 * @{
 */

/** Gets the configured database extension.
 * @param handle the context handle
 * @return the configured database extension
 */
const char *alpm_option_get_dbext(alpm_handle_t *handle);

/** Sets the database extension.
 * @param handle the context handle
 * @param dbext the database extension to use
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_dbext(alpm_handle_t *handle, const char *dbext);
/* End of dbext accessors */
/** @} */


/** @name Accessors for the signature levels
 * @{
 */

/** Get the default siglevel.
 * @param handle the context handle
 * @return a \link alpm_siglevel_t \endlink bitfield of the siglevel
 */
int alpm_option_get_default_siglevel(alpm_handle_t *handle);

/** Set the default siglevel.
 * @param handle the context handle
 * @param level a \link alpm_siglevel_t \endlink bitfield of the level to set
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_default_siglevel(alpm_handle_t *handle, int level);

/** Get the configured local file siglevel.
 * @param handle the context handle
 * @return a \link alpm_siglevel_t \endlink bitfield of the siglevel
 */
int alpm_option_get_local_file_siglevel(alpm_handle_t *handle);

/** Set the local file siglevel.
 * @param handle the context handle
 * @param level a \link alpm_siglevel_t \endlink bitfield of the level to set
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_local_file_siglevel(alpm_handle_t *handle, int level);

/** Get the configured remote file siglevel.
 * @param handle the context handle
 * @return a \link alpm_siglevel_t \endlink bitfield of the siglevel
 */
int alpm_option_get_remote_file_siglevel(alpm_handle_t *handle);

/** Set the remote file siglevel.
 * @param handle the context handle
 * @param level a \link alpm_siglevel_t \endlink bitfield of the level to set
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_remote_file_siglevel(alpm_handle_t *handle, int level);
/* End of signature accessors */
/** @} */


/** @name Accessors for download timeout
 *
 * By default, libalpm will timeout if a download has been transferring
 * less than 1 byte for 10 seconds.
 * @{
 */

/** Enables/disables the download timeout.
 * @param handle the context handle
 * @param disable_dl_timeout 0 for enabled, 1 for disabled
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_option_set_disable_dl_timeout(alpm_handle_t *handle, unsigned short disable_dl_timeout);
/* End of disable_dl_timeout accessors */
/** @} */


/** @name Accessors for parallel downloads
 * \link alpm_db_update \endlink, \link alpm_fetch_pkgurl \endlink and
 * \link alpm_trans_commit \endlink can all download packages in parallel.
 * This setting configures how many packages can be downloaded in parallel,
 *
 * By default this value is set to 1, meaning packages are downloading
 * sequentially.
 *
 * @{
 */

/** Gets the number of parallel streams to download database and package files.
 * @param handle the context handle
 * @return the number of parallel streams to download database and package files
 */
int alpm_option_get_parallel_downloads(alpm_handle_t *handle);

/** Sets number of parallel streams to download database and package files.
 * @param handle the context handle
 * @param num_streams number of parallel download streams
 * @return 0 on success, -1 on error
 */
int alpm_option_set_parallel_downloads(alpm_handle_t *handle, unsigned int num_streams);
/* End of parallel_downloads accessors */
/** @} */


/* End of libalpm_options */
/** @} */


/** @addtogroup libalpm_packages Package Functions
 * Functions to manipulate libalpm packages
 * @{
 */

/** Package install reasons. */
typedef enum _alpm_pkgreason_t {
	/** Explicitly requested by the user. */
	ALPM_PKG_REASON_EXPLICIT = 0,
	/** Installed as a dependency for another package. */
	ALPM_PKG_REASON_DEPEND = 1
} alpm_pkgreason_t;

/** Location a package object was loaded from. */
typedef enum _alpm_pkgfrom_t {
	/** Loaded from a file via \link alpm_pkg_load \endlink */
	ALPM_PKG_FROM_FILE = 1,
	/** From the local database */
	ALPM_PKG_FROM_LOCALDB,
	/** From a sync database */
	ALPM_PKG_FROM_SYNCDB
} alpm_pkgfrom_t;


/** Method used to validate a package. */
typedef enum _alpm_pkgvalidation_t {
	/** The package's validation type is unknown */
	ALPM_PKG_VALIDATION_UNKNOWN = 0,
	/** The package does not have any validation */
	ALPM_PKG_VALIDATION_NONE = (1 << 0),
	/** The package is validated with md5 */
	ALPM_PKG_VALIDATION_MD5SUM = (1 << 1),
	/** The package is validated with sha256 */
	ALPM_PKG_VALIDATION_SHA256SUM = (1 << 2),
	/** The package is validated with a PGP signature */
	ALPM_PKG_VALIDATION_SIGNATURE = (1 << 3)
} alpm_pkgvalidation_t;

/** Create a package from a file.
 * If full is false, the archive is read only until all necessary
 * metadata is found. If it is true, the entire archive is read, which
 * serves as a verification of integrity and the filelist can be created.
 * The allocated structure should be freed using alpm_pkg_free().
 * @param handle the context handle
 * @param filename location of the package tarball
 * @param full whether to stop the load after metadata is read or continue
 * through the full archive
 * @param level what level of package signature checking to perform on the
 * package; note that this must be a '.sig' file type verification
 * @param pkg address of the package pointer
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_pkg_load(alpm_handle_t *handle, const char *filename, int full,
		int level, alpm_pkg_t **pkg);

/** Fetch a list of remote packages.
 * @param handle the context handle
 * @param urls list of package URLs to download
 * @param fetched list of filepaths to the fetched packages, each item
 *    corresponds to one in `urls` list. This is an output parameter,
 *    the caller should provide a pointer to an empty list
 *    (*fetched === NULL) and the callee fills the list with data.
 * @return 0 on success or -1 on failure
 */
int alpm_fetch_pkgurl(alpm_handle_t *handle, const alpm_list_t *urls,
	  alpm_list_t **fetched);

/** Find a package in a list by name.
 * @param haystack a list of alpm_pkg_t
 * @param needle the package name
 * @return a pointer to the package if found or NULL
 */
alpm_pkg_t *alpm_pkg_find(alpm_list_t *haystack, const char *needle);

/** Free a package.
 * Only packages loaded with \link alpm_pkg_load \endlink can be freed.
 * Packages from databases will be freed by libalpm when they are unregistered.
 * @param pkg package pointer to free
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_pkg_free(alpm_pkg_t *pkg);

/** Check the integrity (with md5) of a package from the sync cache.
 * @param pkg package pointer
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_pkg_checkmd5sum(alpm_pkg_t *pkg);

/** Compare two version strings and determine which one is 'newer'.
 * Returns a value comparable to the way strcmp works. Returns 1
 * if a is newer than b, 0 if a and b are the same version, or -1
 * if b is newer than a.
 *
 * Different epoch values for version strings will override any further
 * comparison. If no epoch is provided, 0 is assumed.
 *
 * Keep in mind that the pkgrel is only compared if it is available
 * on both versions handed to this function. For example, comparing
 * 1.5-1 and 1.5 will yield 0; comparing 1.5-1 and 1.5-2 will yield
 * -1 as expected. This is mainly for supporting versioned dependencies
 * that do not include the pkgrel.
 */
int alpm_pkg_vercmp(const char *a, const char *b);

/** Computes the list of packages requiring a given package.
 * The return value of this function is a newly allocated
 * list of package names (char*), it should be freed by the caller.
 * @param pkg a package
 * @return the list of packages requiring pkg
 */
alpm_list_t *alpm_pkg_compute_requiredby(alpm_pkg_t *pkg);

/** Computes the list of packages optionally requiring a given package.
 * The return value of this function is a newly allocated
 * list of package names (char*), it should be freed by the caller.
 * @param pkg a package
 * @return the list of packages optionally requiring pkg
 */
alpm_list_t *alpm_pkg_compute_optionalfor(alpm_pkg_t *pkg);

/** Test if a package should be ignored.
 * Checks if the package is ignored via IgnorePkg, or if the package is
 * in a group ignored via IgnoreGroup.
 * @param handle the context handle
 * @param pkg the package to test
 * @return 1 if the package should be ignored, 0 otherwise
 */
int alpm_pkg_should_ignore(alpm_handle_t *handle, alpm_pkg_t *pkg);

/** @name Package Property Accessors
 * Any pointer returned by these functions points to internal structures
 * allocated by libalpm. They should not be freed nor modified in any
 * way.
 *
 * For loaded packages, they will be freed when \link alpm_pkg_free \endlink is called.
 * For database packages, they will be freed when the database is unregistered.
 * @{
 */

/** Gets the name of the file from which the package was loaded.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_filename(alpm_pkg_t *pkg);

/** Returns the package base name.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_base(alpm_pkg_t *pkg);

/** Returns the package name.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_name(alpm_pkg_t *pkg);

/** Returns the package version as a string.
 * This includes all available epoch, version, and pkgrel components. Use
 * alpm_pkg_vercmp() to compare version strings if necessary.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_version(alpm_pkg_t *pkg);

/** Returns the origin of the package.
 * @return an alpm_pkgfrom_t constant, -1 on error
 */
alpm_pkgfrom_t alpm_pkg_get_origin(alpm_pkg_t *pkg);

/** Returns the package description.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_desc(alpm_pkg_t *pkg);

/** Returns the package URL.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_url(alpm_pkg_t *pkg);

/** Returns the build timestamp of the package.
 * @param pkg a pointer to package
 * @return the timestamp of the build time
 */
alpm_time_t alpm_pkg_get_builddate(alpm_pkg_t *pkg);

/** Returns the install timestamp of the package.
 * @param pkg a pointer to package
 * @return the timestamp of the install time
 */
alpm_time_t alpm_pkg_get_installdate(alpm_pkg_t *pkg);

/** Returns the packager's name.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_packager(alpm_pkg_t *pkg);

/** Returns the package's MD5 checksum as a string.
 * The returned string is a sequence of 32 lowercase hexadecimal digits.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_md5sum(alpm_pkg_t *pkg);

/** Returns the package's SHA256 checksum as a string.
 * The returned string is a sequence of 64 lowercase hexadecimal digits.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_sha256sum(alpm_pkg_t *pkg);

/** Returns the architecture for which the package was built.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_arch(alpm_pkg_t *pkg);

/** Returns the size of the package. This is only available for sync database
 * packages and package files, not those loaded from the local database.
 * @param pkg a pointer to package
 * @return the size of the package in bytes.
 */
off_t alpm_pkg_get_size(alpm_pkg_t *pkg);

/** Returns the installed size of the package.
 * @param pkg a pointer to package
 * @return the total size of files installed by the package.
 */
off_t alpm_pkg_get_isize(alpm_pkg_t *pkg);

/** Returns the package installation reason.
 * @param pkg a pointer to package
 * @return an enum member giving the install reason.
 */
alpm_pkgreason_t alpm_pkg_get_reason(alpm_pkg_t *pkg);

/** Returns the list of package licenses.
 * @param pkg a pointer to package
 * @return a pointer to an internal list of strings.
 */
alpm_list_t *alpm_pkg_get_licenses(alpm_pkg_t *pkg);

/** Returns the list of package groups.
 * @param pkg a pointer to package
 * @return a pointer to an internal list of strings.
 */
alpm_list_t *alpm_pkg_get_groups(alpm_pkg_t *pkg);

/** Returns the list of package dependencies as alpm_depend_t.
 * @param pkg a pointer to package
 * @return a reference to an internal list of alpm_depend_t structures.
 */
alpm_list_t *alpm_pkg_get_depends(alpm_pkg_t *pkg);

/** Returns the list of package optional dependencies.
 * @param pkg a pointer to package
 * @return a reference to an internal list of alpm_depend_t structures.
 */
alpm_list_t *alpm_pkg_get_optdepends(alpm_pkg_t *pkg);

/** Returns a list of package check dependencies
 * @param pkg a pointer to package
 * @return a reference to an internal list of alpm_depend_t structures.
 */
alpm_list_t *alpm_pkg_get_checkdepends(alpm_pkg_t *pkg);

/** Returns a list of package make dependencies
 * @param pkg a pointer to package
 * @return a reference to an internal list of alpm_depend_t structures.
 */
alpm_list_t *alpm_pkg_get_makedepends(alpm_pkg_t *pkg);

/** Returns the list of packages conflicting with pkg.
 * @param pkg a pointer to package
 * @return a reference to an internal list of alpm_depend_t structures.
 */
alpm_list_t *alpm_pkg_get_conflicts(alpm_pkg_t *pkg);

/** Returns the list of packages provided by pkg.
 * @param pkg a pointer to package
 * @return a reference to an internal list of alpm_depend_t structures.
 */
alpm_list_t *alpm_pkg_get_provides(alpm_pkg_t *pkg);

/** Returns the list of packages to be replaced by pkg.
 * @param pkg a pointer to package
 * @return a reference to an internal list of alpm_depend_t structures.
 */
alpm_list_t *alpm_pkg_get_replaces(alpm_pkg_t *pkg);

/** Returns the list of files installed by pkg.
 * The filenames are relative to the install root,
 * and do not include leading slashes.
 * @param pkg a pointer to package
 * @return a pointer to a filelist object containing a count and an array of
 * package file objects
 */
alpm_filelist_t *alpm_pkg_get_files(alpm_pkg_t *pkg);

/** Returns the list of files backed up when installing pkg.
 * @param pkg a pointer to package
 * @return a reference to a list of alpm_backup_t objects
 */
alpm_list_t *alpm_pkg_get_backup(alpm_pkg_t *pkg);

/** Returns the database containing pkg.
 * Returns a pointer to the alpm_db_t structure the package is
 * originating from, or NULL if the package was loaded from a file.
 * @param pkg a pointer to package
 * @return a pointer to the DB containing pkg, or NULL.
 */
alpm_db_t *alpm_pkg_get_db(alpm_pkg_t *pkg);

/** Returns the base64 encoded package signature.
 * @param pkg a pointer to package
 * @return a reference to an internal string
 */
const char *alpm_pkg_get_base64_sig(alpm_pkg_t *pkg);

/** Extracts package signature either from embedded package signature
 * or if it is absent then reads data from detached signature file.
 * @param pkg a pointer to package.
 * @param sig output parameter for signature data. Callee function allocates
 * a buffer needed for the signature data. Caller is responsible for
 * freeing this buffer.
 * @param sig_len output parameter for the signature data length.
 * @return 0 on success, negative number on error.
 */
int alpm_pkg_get_sig(alpm_pkg_t *pkg, unsigned char **sig, size_t *sig_len);

/** Returns the method used to validate a package during install.
 * @param pkg a pointer to package
 * @return an enum member giving the validation method
 */
int alpm_pkg_get_validation(alpm_pkg_t *pkg);

/** Returns whether the package has an install scriptlet.
 * @return 0 if FALSE, TRUE otherwise
 */
int alpm_pkg_has_scriptlet(alpm_pkg_t *pkg);

/** Returns the size of the files that will be downloaded to install a
 * package.
 * @param newpkg the new package to upgrade to
 * @return the size of the download
 */
off_t alpm_pkg_download_size(alpm_pkg_t *newpkg);

/** Set install reason for a package in the local database.
 * The provided package object must be from the local database or this method
 * will fail. The write to the local database is performed immediately.
 * @param pkg the package to update
 * @param reason the new install reason
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_pkg_set_reason(alpm_pkg_t *pkg, alpm_pkgreason_t reason);


/* End of libalpm_pkg_t accessors */
/** @} */


/** @name Changelog functions
 *  Functions for reading the changelog
 * @{
 */

/** Open a package changelog for reading.
 * Similar to fopen in functionality, except that the returned 'file
 * stream' could really be from an archive as well as from the database.
 * @param pkg the package to read the changelog of (either file or db)
 * @return a 'file stream' to the package changelog
 */
void *alpm_pkg_changelog_open(alpm_pkg_t *pkg);

/** Read data from an open changelog 'file stream'.
 * Similar to fread in functionality, this function takes a buffer and
 * amount of data to read. If an error occurs pm_errno will be set.
 * @param ptr a buffer to fill with raw changelog data
 * @param size the size of the buffer
 * @param pkg the package that the changelog is being read from
 * @param fp a 'file stream' to the package changelog
 * @return the number of characters read, or 0 if there is no more data or an
 * error occurred.
 */
size_t alpm_pkg_changelog_read(void *ptr, size_t size,
		const alpm_pkg_t *pkg, void *fp);

/** Close a package changelog for reading.
 * @param pkg the package to close the changelog of (either file or db)
 * @param fp the 'file stream' to the package changelog to close
 * @return 0 on success, -1 on error
 */
int alpm_pkg_changelog_close(const alpm_pkg_t *pkg, void *fp);

/* End of changelog accessors */
/** @} */


/** @name Mtree functions
 *  Functions for reading the mtree
 * @{
 */

/** Open a package mtree file for reading.
 * @param pkg the local package to read the mtree of
 * @return an archive structure for the package mtree file
 */
struct archive *alpm_pkg_mtree_open(alpm_pkg_t *pkg);

/** Read next entry from a package mtree file.
 * @param pkg the package that the mtree file is being read from
 * @param archive the archive structure reading from the mtree file
 * @param entry an archive_entry to store the entry header information
 * @return 0 on success, 1 if end of archive is reached, -1 otherwise.
 */
int alpm_pkg_mtree_next(const alpm_pkg_t *pkg, struct archive *archive,
		struct archive_entry **entry);

/** Close a package mtree file.
 * @param pkg the local package to close the mtree of
 * @param archive the archive to close
 */
int alpm_pkg_mtree_close(const alpm_pkg_t *pkg, struct archive *archive);

/* End of mtree accessors */
/** @} */


/* End of libalpm_packages */
/** @} */

/** @addtogroup libalpm_trans Transaction
 * @brief Functions to manipulate libalpm transactions
 *
 * Transactions are the way to add/remove packages to/from the system.
 * Only one transaction can exist at a time.
 *
 * The basic workflow of a transaction is to:
 *
 * - Initialize with \link alpm_trans_init \endlink
 * - Choose which packages to add with \link alpm_add_pkg \endlink and \link alpm_remove_pkg \endlink
 * - Prepare the transaction with \link alpm_trans_prepare \endlink
 * - Commit the transaction with \link alpm_trans_commit \endlink
 * - Release the transaction with \link alpm_trans_release \endlink
 *
 * A transaction can be released at any time. A transaction does not have to be committed.
 * @{
 */

/** Transaction flags */
typedef enum _alpm_transflag_t {
	/** Ignore dependency checks. */
	ALPM_TRANS_FLAG_NODEPS = 1,
	/* (1 << 1) flag can go here */
	/** Delete files even if they are tagged as backup. */
	ALPM_TRANS_FLAG_NOSAVE = (1 << 2),
	/** Ignore version numbers when checking dependencies. */
	ALPM_TRANS_FLAG_NODEPVERSION = (1 << 3),
	/** Remove also any packages depending on a package being removed. */
	ALPM_TRANS_FLAG_CASCADE = (1 << 4),
	/** Remove packages and their unneeded deps (not explicitly installed). */
	ALPM_TRANS_FLAG_RECURSE = (1 << 5),
	/** Modify database but do not commit changes to the filesystem. */
	ALPM_TRANS_FLAG_DBONLY = (1 << 6),
	/* (1 << 7) flag can go here */
	/** Use ALPM_PKG_REASON_DEPEND when installing packages. */
	ALPM_TRANS_FLAG_ALLDEPS = (1 << 8),
	/** Only download packages and do not actually install. */
	ALPM_TRANS_FLAG_DOWNLOADONLY = (1 << 9),
	/** Do not execute install scriptlets after installing. */
	ALPM_TRANS_FLAG_NOSCRIPTLET = (1 << 10),
	/** Ignore dependency conflicts. */
	ALPM_TRANS_FLAG_NOCONFLICTS = (1 << 11),
	/* (1 << 12) flag can go here */
	/** Do not install a package if it is already installed and up to date. */
	ALPM_TRANS_FLAG_NEEDED = (1 << 13),
	/** Use ALPM_PKG_REASON_EXPLICIT when installing packages. */
	ALPM_TRANS_FLAG_ALLEXPLICIT = (1 << 14),
	/** Do not remove a package if it is needed by another one. */
	ALPM_TRANS_FLAG_UNNEEDED = (1 << 15),
	/** Remove also explicitly installed unneeded deps (use with ALPM_TRANS_FLAG_RECURSE). */
	ALPM_TRANS_FLAG_RECURSEALL = (1 << 16),
	/** Do not lock the database during the operation. */
	ALPM_TRANS_FLAG_NOLOCK = (1 << 17)
} alpm_transflag_t;

/** Returns the bitfield of flags for the current transaction.
 * @param handle the context handle
 * @return the bitfield of transaction flags
 */
int alpm_trans_get_flags(alpm_handle_t *handle);

/** Returns a list of packages added by the transaction.
 * @param handle the context handle
 * @return a list of alpm_pkg_t structures
 */
alpm_list_t *alpm_trans_get_add(alpm_handle_t *handle);

/** Returns the list of packages removed by the transaction.
 * @param handle the context handle
 * @return a list of alpm_pkg_t structures
 */
alpm_list_t *alpm_trans_get_remove(alpm_handle_t *handle);

/** Initialize the transaction.
 * @param handle the context handle
 * @param flags flags of the transaction (like nodeps, etc; see alpm_transflag_t)
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_trans_init(alpm_handle_t *handle, int flags);

/** Prepare a transaction.
 * @param handle the context handle
 * @param data the address of an alpm_list where a list
 * of alpm_depmissing_t objects is dumped (conflicting packages)
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_trans_prepare(alpm_handle_t *handle, alpm_list_t **data);

/** Commit a transaction.
 * @param handle the context handle
 * @param data the address of an alpm_list where detailed description
 * of an error can be dumped (i.e. list of conflicting files)
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_trans_commit(alpm_handle_t *handle, alpm_list_t **data);

/** Interrupt a transaction.
 * @param handle the context handle
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_trans_interrupt(alpm_handle_t *handle);

/** Release a transaction.
 * @param handle the context handle
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_trans_release(alpm_handle_t *handle);

/** @name Add/Remove packages
 * These functions remove/add packages to the transactions
 * @{
 * */

/** Search for packages to upgrade and add them to the transaction.
 * @param handle the context handle
 * @param enable_downgrade allow downgrading of packages if the remote version is lower
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_sync_sysupgrade(alpm_handle_t *handle, int enable_downgrade);

/** Add a package to the transaction.
 * If the package was loaded by alpm_pkg_load(), it will be freed upon
 * \link alpm_trans_release \endlink invocation.
 * @param handle the context handle
 * @param pkg the package to add
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_add_pkg(alpm_handle_t *handle, alpm_pkg_t *pkg);

/** Add a package removal to the transaction.
 * @param handle the context handle
 * @param pkg the package to uninstall
 * @return 0 on success, -1 on error (pm_errno is set accordingly)
 */
int alpm_remove_pkg(alpm_handle_t *handle, alpm_pkg_t *pkg);

/* End of add/remove packages */
/** @} */


/* End of libalpm_trans */
/** @} */


/** \addtogroup libalpm_misc Miscellaneous Functions
 * @brief Various libalpm functions
 * @{
 */

/** Check for new version of pkg in syncdbs.
 *
 * If the same package appears multiple dbs only the first will be checked
 *
 * This only checks the syncdb for a newer version. It does not access the network at all.
 * See \link alpm_db_update \endlink to update a database.
 */
alpm_pkg_t *alpm_sync_get_new_version(alpm_pkg_t *pkg, alpm_list_t *dbs_sync);

/** Get the md5 sum of file.
 * @param filename name of the file
 * @return the checksum on success, NULL on error
 */
char *alpm_compute_md5sum(const char *filename);

/** Get the sha256 sum of file.
 * @param filename name of the file
 * @return the checksum on success, NULL on error
 */
char *alpm_compute_sha256sum(const char *filename);

/** Remove the database lock file
 * @param handle the context handle
 * @return 0 on success, -1 on error
 *
 * @note Safe to call from inside signal handlers.
 */
int alpm_unlock(alpm_handle_t *handle);

/** Enum of possible compile time features */
enum alpm_caps {
        /** localization */
        ALPM_CAPABILITY_NLS = (1 << 0),
        /** Ability to download */
        ALPM_CAPABILITY_DOWNLOADER = (1 << 1),
        /** Signature checking */
        ALPM_CAPABILITY_SIGNATURES = (1 << 2)
};

/** Get the version of library.
 * @return the library version, e.g. "6.0.4"
 * */
const char *alpm_version(void);

/** Get the capabilities of the library.
 * @return a bitmask of the capabilities
 * */
int alpm_capabilities(void);

/* End of libalpm_misc */
/** @} */

/* End of libalpm_api */
/** @} */

#ifdef __cplusplus
}
#endif
#endif /* ALPM_H */
