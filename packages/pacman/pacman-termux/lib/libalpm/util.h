/*
 *  util.h
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
#ifndef ALPM_UTIL_H
#define ALPM_UTIL_H

#include "alpm_list.h"
#include "alpm.h"
#include "package.h" /* alpm_pkg_t */
#include "handle.h" /* alpm_handle_t */
#include "util-common.h"

#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stddef.h> /* size_t */
#include <sys/types.h>
#include <math.h> /* fabs */
#include <float.h> /* DBL_EPSILON */
#include <fcntl.h> /* open, close */

#include <archive.h> /* struct archive */

#ifdef ENABLE_NLS
#include <libintl.h> /* here so it doesn't need to be included elsewhere */
/* define _() as shortcut for gettext() */
#define _(str) dgettext ("libalpm", str)
#else
#define _(s) (char *)s
#endif

void _alpm_alloc_fail(size_t size);

#define MALLOC(p, s, action) do { p = malloc(s); if(p == NULL) { _alpm_alloc_fail(s); action; } } while(0)
#define CALLOC(p, l, s, action) do { p = calloc(l, s); if(p == NULL) { _alpm_alloc_fail(l * s); action; } } while(0)
#define REALLOC(p, s, action) do { void* np = realloc(p, s); if(np == NULL) { _alpm_alloc_fail(s); action; } else { p = np; } } while(0)
/* This strdup macro is NULL safe- copying NULL will yield NULL */
#define STRDUP(r, s, action) do { if(s != NULL) { r = strdup(s); if(r == NULL) { _alpm_alloc_fail(strlen(s)); action; } } else { r = NULL; } } while(0)
#define STRNDUP(r, s, l, action) do { if(s != NULL) { r = strndup(s, l); if(r == NULL) { _alpm_alloc_fail(l); action; } } else { r = NULL; } } while(0)

#define FREE(p) do { free(p); p = NULL; } while(0)

#define ASSERT(cond, action) do { if(!(cond)) { action; } } while(0)

#define RET_ERR_VOID(handle, err) do { \
	_alpm_log(handle, ALPM_LOG_DEBUG, "returning error %d from %s (%s: %d) : %s\n", err, __func__, __FILE__, __LINE__, alpm_strerror(err)); \
	(handle)->pm_errno = (err); \
	return; } while(0)

#define RET_ERR(handle, err, ret) do { \
	_alpm_log(handle, ALPM_LOG_DEBUG, "returning error %d from %s (%s: %d) : %s\n", err, __func__, __FILE__, __LINE__, alpm_strerror(err)); \
	(handle)->pm_errno = (err); \
	return (ret); } while(0)

#define GOTO_ERR(handle, err, label) do { \
	_alpm_log(handle, ALPM_LOG_DEBUG, "got error %d at %s (%s: %d) : %s\n", err, __func__, __FILE__, __LINE__, alpm_strerror(err)); \
	(handle)->pm_errno = (err); \
	goto label; } while(0)

#define RET_ERR_ASYNC_SAFE(handle, err, ret) do { \
	(handle)->pm_errno = (err); \
	return (ret); } while(0)

#define CHECK_HANDLE(handle, action) do { if(!(handle)) { action; } (handle)->pm_errno = ALPM_ERR_OK; } while(0)

/** Standard buffer size used throughout the library. */
#ifdef BUFSIZ
#define ALPM_BUFFER_SIZE BUFSIZ
#else
#define ALPM_BUFFER_SIZE 8192
#endif

#ifndef O_BINARY
#define O_BINARY 0
#endif

#define OPEN(fd, path, flags) do { fd = open(path, flags | O_BINARY); } while(fd == -1 && errno == EINTR)

/**
 * Used as a buffer/state holder for _alpm_archive_fgets().
 */
struct archive_read_buffer {
	char *line;
	char *line_offset;
	size_t line_size;
	size_t max_line_size;
	size_t real_line_size;

	char *block;
	char *block_offset;
	size_t block_size;

	int ret;
};

int _alpm_makepath(const char *path);
int _alpm_makepath_mode(const char *path, mode_t mode);
int _alpm_copyfile(const char *src, const char *dest);
size_t _alpm_strip_newline(char *str, size_t len);

int _alpm_open_archive(alpm_handle_t *handle, const char *path,
		struct stat *buf, struct archive **archive, alpm_errno_t error);
int _alpm_unpack_single(alpm_handle_t *handle, const char *archive,
		const char *prefix, const char *filename);
int _alpm_unpack(alpm_handle_t *handle, const char *archive, const char *prefix,
		alpm_list_t *list, int breakfirst);

ssize_t _alpm_files_in_directory(alpm_handle_t *handle, const char *path, int full_count);

typedef ssize_t (*_alpm_cb_io)(void *buf, ssize_t len, void *ctx);

int _alpm_run_chroot(alpm_handle_t *handle, const char *cmd, char *const argv[],
		_alpm_cb_io in_cb, void *in_ctx);
int _alpm_ldconfig(alpm_handle_t *handle);
int _alpm_str_cmp(const void *s1, const void *s2);
char *_alpm_filecache_find(alpm_handle_t *handle, const char *filename);
/* Checks whether a file exists in cache */
int _alpm_filecache_exists(alpm_handle_t *handle, const char *filename);
const char *_alpm_filecache_setup(alpm_handle_t *handle);
/* Unlike many uses of alpm_pkgvalidation_t, _alpm_test_checksum expects
 * an enum value rather than a bitfield. */
int _alpm_test_checksum(const char *filepath, const char *expected, alpm_pkgvalidation_t type);
int _alpm_archive_fgets(struct archive *a, struct archive_read_buffer *b);
int _alpm_splitname(const char *target, char **name, char **version,
		unsigned long *name_hash);
unsigned long _alpm_hash_sdbm(const char *str);
off_t _alpm_strtoofft(const char *line);
alpm_time_t _alpm_parsedate(const char *line);
int _alpm_raw_cmp(const char *first, const char *second);
int _alpm_raw_ncmp(const char *first, const char *second, size_t max);
int _alpm_access(alpm_handle_t *handle, const char *dir, const char *file, int amode);
int _alpm_fnmatch_patterns(alpm_list_t *patterns, const char *string);
int _alpm_fnmatch(const void *pattern, const void *string);
void *_alpm_realloc(void **data, size_t *current, const size_t required);
void *_alpm_greedy_grow(void **data, size_t *current, const size_t required);
alpm_errno_t _alpm_read_file(const char *filepath, unsigned char **data, size_t *data_len);

#ifndef HAVE_STRSEP
char *strsep(char **, const char *);
#endif

/* check exported library symbols with: nm -C -D <lib> */
#define SYMEXPORT __attribute__((visibility("default")))

#define UNUSED __attribute__((unused))

#endif /* ALPM_UTIL_H */
