#ifndef LIBARCHIVE_COMPAT_H
#define LIBARCHIVE_COMPAT_H

/*
 * libarchive-compat.h
 *
 *  Copyright (c) 2013-2021 Pacman Development Team <pacman-dev@archlinux.org>
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

#include <stdint.h>

static inline int _alpm_archive_read_free(struct archive *archive)
{
	return archive_read_free(archive);
}

static inline int64_t _alpm_archive_compressed_ftell(struct archive *archive)
{
	return archive_filter_bytes(archive, -1);
}

static inline int _alpm_archive_read_open_file(struct archive *archive,
		const char *filename, size_t block_size)
{
	return archive_read_open_filename(archive, filename, block_size);
}

static inline int _alpm_archive_filter_code(struct archive *archive)
{
	return archive_filter_code(archive, 0);
}

static inline int _alpm_archive_read_support_filter_all(struct archive *archive)
{
	return archive_read_support_filter_all(archive);
}

#endif /* LIBARCHIVE_COMPAT_H */
