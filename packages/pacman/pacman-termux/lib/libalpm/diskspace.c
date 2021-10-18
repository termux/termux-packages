/*
 *  diskspace.c
 *
 *  Copyright (c) 2010-2021 Pacman Development Team <pacman-dev@archlinux.org>
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
#include <errno.h>

#if defined(HAVE_MNTENT_H)
#include <mntent.h>
#endif
#if defined(HAVE_SYS_MNTTAB_H)
#include <sys/mnttab.h>
#endif
#if defined(HAVE_SYS_STATVFS_H)
#include <sys/statvfs.h>
#endif
#if defined(HAVE_SYS_PARAM_H)
#include <sys/param.h>
#endif
#if defined(HAVE_SYS_MOUNT_H)
#include <sys/mount.h>
#endif
#if defined(HAVE_SYS_UCRED_H)
#include <sys/ucred.h>
#endif
#if defined(HAVE_SYS_TYPES_H)
#include <sys/types.h>
#endif

/* libalpm */
#include "diskspace.h"
#include "alpm_list.h"
#include "util.h"
#include "log.h"
#include "trans.h"
#include "handle.h"

static int mount_point_cmp(const void *p1, const void *p2)
{
	const alpm_mountpoint_t *mp1 = p1;
	const alpm_mountpoint_t *mp2 = p2;
	/* the negation will sort all mountpoints before their parent */
	return -strcmp(mp1->mount_dir, mp2->mount_dir);
}

static void mount_point_list_free(alpm_list_t *mount_points)
{
	alpm_list_t *i;

	for(i = mount_points; i; i = i->next) {
		alpm_mountpoint_t *data = i->data;
		FREE(data->mount_dir);
	}
	FREELIST(mount_points);
}

static int mount_point_load_fsinfo(alpm_handle_t *handle, alpm_mountpoint_t *mountpoint)
{
#if defined(HAVE_GETMNTENT)
	/* grab the filesystem usage */
	if(statvfs(mountpoint->mount_dir, &(mountpoint->fsp)) != 0) {
		_alpm_log(handle, ALPM_LOG_WARNING,
				_("could not get filesystem information for %s: %s\n"),
				mountpoint->mount_dir, strerror(errno));
		mountpoint->fsinfo_loaded = MOUNT_FSINFO_FAIL;
		return -1;
	}

	_alpm_log(handle, ALPM_LOG_DEBUG, "loading fsinfo for %s\n", mountpoint->mount_dir);
	mountpoint->read_only = mountpoint->fsp.f_flag & ST_RDONLY;
	mountpoint->fsinfo_loaded = MOUNT_FSINFO_LOADED;
#else
	(void)handle;
	(void)mountpoint;
#endif

	return 0;
}

static alpm_list_t *mount_point_list(alpm_handle_t *handle)
{
	alpm_list_t *mount_points = NULL, *ptr;
	alpm_mountpoint_t *mp;

#if defined(HAVE_GETMNTENT) && defined(HAVE_MNTENT_H)
	/* Linux */
	struct mntent *mnt;
	FILE *fp;

	fp = setmntent(MOUNTED, "r");

	if(fp == NULL) {
		_alpm_log(handle, ALPM_LOG_ERROR, _("could not open file: %s: %s\n"),
				MOUNTED, strerror(errno));
		return NULL;
	}

	while((mnt = getmntent(fp))) {
		CALLOC(mp, 1, sizeof(alpm_mountpoint_t), RET_ERR(handle, ALPM_ERR_MEMORY, NULL));
		STRDUP(mp->mount_dir, mnt->mnt_dir, free(mp); RET_ERR(handle, ALPM_ERR_MEMORY, NULL));
		mp->mount_dir_len = strlen(mp->mount_dir);

		mount_points = alpm_list_add(mount_points, mp);
	}

	endmntent(fp);
#elif defined(HAVE_GETMNTENT) && defined(HAVE_MNTTAB_H)
	/* Solaris, Illumos */
	struct mnttab mnt;
	FILE *fp;
	int ret;

	fp = fopen("/etc/mnttab", "r");

	if(fp == NULL) {
		_alpm_log(handle, ALPM_LOG_ERROR, _("could not open file %s: %s\n"),
				"/etc/mnttab", strerror(errno));
		return NULL;
	}

	while((ret = getmntent(fp, &mnt)) == 0) {
		CALLOC(mp, 1, sizeof(alpm_mountpoint_t), RET_ERR(handle, ALPM_ERR_MEMORY, NULL));
		STRDUP(mp->mount_dir, mnt->mnt_mountp,  free(mp); RET_ERR(handle, ALPM_ERR_MEMORY, NULL));
		mp->mount_dir_len = strlen(mp->mount_dir);

		mount_points = alpm_list_add(mount_points, mp);
	}
	/* -1 == EOF */
	if(ret != -1) {
		_alpm_log(handle, ALPM_LOG_WARNING,
				_("could not get filesystem information\n"));
	}

	fclose(fp);
#elif defined(HAVE_GETMNTINFO)
	/* FreeBSD (statfs), NetBSD (statvfs), OpenBSD (statfs), OS X (statfs) */
	int entries;
	FSSTATSTYPE *fsp;

	entries = getmntinfo(&fsp, MNT_NOWAIT);

	if(entries < 0) {
		_alpm_log(handle, ALPM_LOG_ERROR,
				_("could not get filesystem information\n"));
		return NULL;
	}

	for(; entries-- > 0; fsp++) {
		CALLOC(mp, 1, sizeof(alpm_mountpoint_t), RET_ERR(handle, ALPM_ERR_MEMORY, NULL));
		STRDUP(mp->mount_dir, fsp->f_mntonname, free(mp); RET_ERR(handle, ALPM_ERR_MEMORY, NULL));
		mp->mount_dir_len = strlen(mp->mount_dir);
		memcpy(&(mp->fsp), fsp, sizeof(FSSTATSTYPE));
#if defined(HAVE_GETMNTINFO_STATVFS) && defined(HAVE_STRUCT_STATVFS_F_FLAG)
		mp->read_only = fsp->f_flag & ST_RDONLY;
#elif defined(HAVE_GETMNTINFO_STATFS) && defined(HAVE_STRUCT_STATFS_F_FLAGS)
		mp->read_only = fsp->f_flags & MNT_RDONLY;
#endif

		/* we don't support lazy loading on this platform */
		mp->fsinfo_loaded = MOUNT_FSINFO_LOADED;

		mount_points = alpm_list_add(mount_points, mp);
	}
#endif

	mount_points = alpm_list_msort(mount_points, alpm_list_count(mount_points),
			mount_point_cmp);
	for(ptr = mount_points; ptr != NULL; ptr = ptr->next) {
		mp = ptr->data;
		_alpm_log(handle, ALPM_LOG_DEBUG, "discovered mountpoint: %s\n", mp->mount_dir);
	}
	return mount_points;
}

static alpm_mountpoint_t *match_mount_point(const alpm_list_t *mount_points,
		const char *real_path)
{
	const alpm_list_t *mp;

	for(mp = mount_points; mp != NULL; mp = mp->next) {
		alpm_mountpoint_t *data = mp->data;

		/* first, check if the prefix matches */
		if(strncmp(data->mount_dir, real_path, data->mount_dir_len) == 0) {
			/* now, the hard work- a file like '/etc/myconfig' shouldn't map to a
			 * mountpoint '/e', but only '/etc'. If the mountpoint ends in a trailing
			 * slash, we know we didn't have a mismatch, otherwise we have to do some
			 * more sanity checks. */
			if(data->mount_dir[data->mount_dir_len - 1] == '/') {
				return data;
			} else if(strlen(real_path) >= data->mount_dir_len) {
				const char next = real_path[data->mount_dir_len];
				if(next == '/' || next == '\0') {
					return data;
				}
			}
		}
	}

	/* should not get here... */
	return NULL;
}

static int calculate_removed_size(alpm_handle_t *handle,
		const alpm_list_t *mount_points, alpm_pkg_t *pkg)
{
	size_t i;
	alpm_filelist_t *filelist = alpm_pkg_get_files(pkg);

	if(!filelist->count) {
		return 0;
	}

	for(i = 0; i < filelist->count; i++) {
		const alpm_file_t *file = filelist->files + i;
		alpm_mountpoint_t *mp;
		struct stat st;
		char path[PATH_MAX];
		blkcnt_t remove_size;
		const char *filename = file->name;

		snprintf(path, PATH_MAX, "%s%s", handle->root, filename);

		if(llstat(path, &st) == -1) {
			if(alpm_option_match_noextract(handle, filename)) {
				_alpm_log(handle, ALPM_LOG_WARNING,
						_("could not get file information for %s\n"), filename);
			}
			continue;
		}

		/* skip directories and symlinks to be consistent with libarchive that
		 * reports them to be zero size */
		if(S_ISDIR(st.st_mode) || S_ISLNK(st.st_mode)) {
			continue;
		}

		mp = match_mount_point(mount_points, path);
		if(mp == NULL) {
			_alpm_log(handle, ALPM_LOG_WARNING,
					_("could not determine mount point for file %s\n"), filename);
			continue;
		}

		/* don't check a mount that we know we can't stat */
		if(mp && mp->fsinfo_loaded == MOUNT_FSINFO_FAIL) {
			continue;
		}

		/* lazy load filesystem info */
		if(mp->fsinfo_loaded == MOUNT_FSINFO_UNLOADED) {
			if(mount_point_load_fsinfo(handle, mp) < 0) {
				continue;
			}
		}

		/* the addition of (divisor - 1) performs ceil() with integer division */
		remove_size = (st.st_size + mp->fsp.f_bsize - 1) / mp->fsp.f_bsize;
		mp->blocks_needed -= remove_size;
		mp->used |= USED_REMOVE;
	}

	return 0;
}

static int calculate_installed_size(alpm_handle_t *handle,
		const alpm_list_t *mount_points, alpm_pkg_t *pkg)
{
	size_t i;
	alpm_filelist_t *filelist = alpm_pkg_get_files(pkg);

	if(!filelist->count) {
		return 0;
	}

	for(i = 0; i < filelist->count; i++) {
		const alpm_file_t *file = filelist->files + i;
		alpm_mountpoint_t *mp;
		char path[PATH_MAX];
		blkcnt_t install_size;
		const char *filename = file->name;

		/* libarchive reports these as zero size anyways */
		/* NOTE: if we do start accounting for directory size, a dir matching a
		 * mountpoint needs to be attributed to the parent, not the mountpoint. */
		if(S_ISDIR(file->mode) || S_ISLNK(file->mode)) {
			continue;
		}

		/* approximate space requirements for db entries */
		if(filename[0] == '.') {
			filename = handle->dbpath;
		}

		snprintf(path, PATH_MAX, "%s%s", handle->root, filename);

		mp = match_mount_point(mount_points, path);
		if(mp == NULL) {
			_alpm_log(handle, ALPM_LOG_WARNING,
					_("could not determine mount point for file %s\n"), filename);
			continue;
		}

		/* don't check a mount that we know we can't stat */
		if(mp && mp->fsinfo_loaded == MOUNT_FSINFO_FAIL) {
			continue;
		}

		/* lazy load filesystem info */
		if(mp->fsinfo_loaded == MOUNT_FSINFO_UNLOADED) {
			if(mount_point_load_fsinfo(handle, mp) < 0) {
				continue;
			}
		}

		/* the addition of (divisor - 1) performs ceil() with integer division */
		install_size = (file->size + mp->fsp.f_bsize - 1) / mp->fsp.f_bsize;
		mp->blocks_needed += install_size;
		mp->used |= USED_INSTALL;
	}

	return 0;
}

static int check_mountpoint(alpm_handle_t *handle, alpm_mountpoint_t *mp)
{
	/* cushion is roughly min(5% capacity, 20MiB) */
	fsblkcnt_t fivepc = (mp->fsp.f_blocks / 20) + 1;
	fsblkcnt_t twentymb = (20 * 1024 * 1024 / mp->fsp.f_bsize) + 1;
	fsblkcnt_t cushion = fivepc < twentymb ? fivepc : twentymb;
	blkcnt_t needed = mp->max_blocks_needed + cushion;

	_alpm_log(handle, ALPM_LOG_DEBUG,
			"partition %s, needed %jd, cushion %ju, free %ju\n",
			mp->mount_dir, (intmax_t)mp->max_blocks_needed,
			(uintmax_t)cushion, (uintmax_t)mp->fsp.f_bavail);
	if(needed >= 0 && (fsblkcnt_t)needed > mp->fsp.f_bavail) {
		_alpm_log(handle, ALPM_LOG_ERROR,
				_("Partition %s too full: %jd blocks needed, %ju blocks free\n"),
				mp->mount_dir, (intmax_t)needed, (uintmax_t)mp->fsp.f_bavail);
		return 1;
	}
	return 0;
}

int _alpm_check_downloadspace(alpm_handle_t *handle, const char *cachedir,
		size_t num_files, const off_t *file_sizes)
{
	alpm_list_t *mount_points;
	alpm_mountpoint_t *cachedir_mp;
	char resolved_cachedir[PATH_MAX];
	size_t j;
	int error = 0;

	/* resolve the cachedir path to ensure we check the right mountpoint. We
	 * handle failures silently, and continue to use the possibly unresolved
	 * path. */
	if(realpath(cachedir, resolved_cachedir) != NULL) {
		cachedir = resolved_cachedir;
	}

	mount_points = mount_point_list(handle);
	if(mount_points == NULL) {
		_alpm_log(handle, ALPM_LOG_ERROR, _("could not determine filesystem mount points\n"));
		return -1;
	}

	cachedir_mp = match_mount_point(mount_points, cachedir);
	if(cachedir_mp == NULL) {
		_alpm_log(handle, ALPM_LOG_ERROR, _("could not determine cachedir mount point %s\n"),
				cachedir);
		error = 1;
		goto finish;
	}

	if(cachedir_mp->fsinfo_loaded == MOUNT_FSINFO_UNLOADED) {
		if(mount_point_load_fsinfo(handle, cachedir_mp)) {
			error = 1;
			goto finish;
		}
	}

	/* there's no need to check for a R/O mounted filesystem here, as
	 * _alpm_filecache_setup will never give us a non-writable directory */

	/* round up the size of each file to the nearest block and accumulate */
	for(j = 0; j < num_files; j++) {
		cachedir_mp->max_blocks_needed += (file_sizes[j] + cachedir_mp->fsp.f_bsize + 1) /
			cachedir_mp->fsp.f_bsize;
	}

	if(check_mountpoint(handle, cachedir_mp)) {
		error = 1;
	}

finish:
	mount_point_list_free(mount_points);

	if(error) {
		RET_ERR(handle, ALPM_ERR_DISK_SPACE, -1);
	}

	return 0;
}

int _alpm_check_diskspace(alpm_handle_t *handle)
{
	alpm_list_t *mount_points, *i;
	alpm_mountpoint_t *root_mp;
	size_t replaces = 0, current = 0, numtargs;
	int error = 0;
	alpm_list_t *targ;
	alpm_trans_t *trans = handle->trans;

	numtargs = alpm_list_count(trans->add);
	mount_points = mount_point_list(handle);
	if(mount_points == NULL) {
		_alpm_log(handle, ALPM_LOG_ERROR, _("could not determine filesystem mount points\n"));
		return -1;
	}
	root_mp = match_mount_point(mount_points, handle->root);
	if(root_mp == NULL) {
		_alpm_log(handle, ALPM_LOG_ERROR, _("could not determine root mount point %s\n"),
				handle->root);
		error = 1;
		goto finish;
	}

	replaces = alpm_list_count(trans->remove);
	if(replaces) {
		numtargs += replaces;
		for(targ = trans->remove; targ; targ = targ->next, current++) {
			alpm_pkg_t *local_pkg;
			int percent = (current * 100) / numtargs;
			PROGRESS(handle, ALPM_PROGRESS_DISKSPACE_START, "", percent,
					numtargs, current);

			local_pkg = targ->data;
			calculate_removed_size(handle, mount_points, local_pkg);
		}
	}

	for(targ = trans->add; targ; targ = targ->next, current++) {
		alpm_pkg_t *pkg, *local_pkg;
		int percent = (current * 100) / numtargs;
		PROGRESS(handle, ALPM_PROGRESS_DISKSPACE_START, "", percent,
				numtargs, current);

		pkg = targ->data;
		/* is this package already installed? */
		local_pkg = _alpm_db_get_pkgfromcache(handle->db_local, pkg->name);
		if(local_pkg) {
			calculate_removed_size(handle, mount_points, local_pkg);
		}
		calculate_installed_size(handle, mount_points, pkg);

		for(i = mount_points; i; i = i->next) {
			alpm_mountpoint_t *data = i->data;
			if(data->blocks_needed > data->max_blocks_needed) {
				data->max_blocks_needed = data->blocks_needed;
			}
		}
	}

	PROGRESS(handle, ALPM_PROGRESS_DISKSPACE_START, "", 100,
			numtargs, current);

	for(i = mount_points; i; i = i->next) {
		alpm_mountpoint_t *data = i->data;
		if(data->used && data->read_only) {
			_alpm_log(handle, ALPM_LOG_ERROR, _("Partition %s is mounted read only\n"),
					data->mount_dir);
			error = 1;
		} else if(data->used & USED_INSTALL && check_mountpoint(handle, data)) {
			error = 1;
		}
	}

finish:
	mount_point_list_free(mount_points);

	if(error) {
		RET_ERR(handle, ALPM_ERR_DISK_SPACE, -1);
	}

	return 0;
}
