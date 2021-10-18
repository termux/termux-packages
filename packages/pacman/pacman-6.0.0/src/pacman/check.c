/*
 *  check.c
 *
 *  Copyright (c) 2012-2021 Pacman Development Team <pacman-dev@archlinux.org>
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

#include <limits.h>
#include <string.h>
#include <errno.h>

/* pacman */
#include "check.h"
#include "conf.h"
#include "util.h"

static int check_file_exists(const char *pkgname, char *filepath, size_t rootlen,
		struct stat *st)
{
	/* use lstat to prevent errors from symlinks */
	if(llstat(filepath, st) != 0) {
		if(alpm_option_match_noextract(config->handle, filepath + rootlen) == 0) {
			/* NoExtract */
			return -1;
		} else {
			if(config->quiet) {
				printf("%s %s\n", pkgname, filepath);
			} else {
				pm_printf(ALPM_LOG_WARNING, "%s: %s (%s)\n",
						pkgname, filepath, strerror(errno));
			}
			return 1;
		}
	}

	return 0;
}

static int check_file_type(const char *pkgname, const char *filepath,
		struct stat *st, struct archive_entry *entry)
{
	mode_t archive_type = archive_entry_filetype(entry);
	mode_t file_type = st->st_mode;

	if((archive_type == AE_IFREG && !S_ISREG(file_type)) ||
			(archive_type == AE_IFDIR && !S_ISDIR(file_type)) ||
			(archive_type == AE_IFLNK && !S_ISLNK(file_type))) {
		if(config->quiet) {
			printf("%s %s\n", pkgname, filepath);
		} else {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (File type mismatch)\n"),
					pkgname, filepath);
		}
		return 1;
	}

	return 0;
}

static int check_file_permissions(const char *pkgname, const char *filepath,
		struct stat *st, struct archive_entry *entry)
{
	int errors = 0;
	mode_t fsmode;

	/* uid */
	if(st->st_uid != archive_entry_uid(entry)) {
		errors++;
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (UID mismatch)\n"),
					pkgname, filepath);
		}
	}

	/* gid */
	if(st->st_gid != archive_entry_gid(entry)) {
		errors++;
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (GID mismatch)\n"),
					pkgname, filepath);
		}
	}

	/* mode */
	fsmode = st->st_mode & (S_ISUID | S_ISGID | S_ISVTX | S_IRWXU | S_IRWXG | S_IRWXO);
	if(fsmode != (~AE_IFMT & archive_entry_mode(entry))) {
		errors++;
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (Permissions mismatch)\n"),
					pkgname, filepath);
		}
	}

	return (errors != 0 ? 1 : 0);
}

static int check_file_time(const char *pkgname, const char *filepath,
		struct stat *st, struct archive_entry *entry, int backup)
{
	if(st->st_mtime != archive_entry_mtime(entry)) {
		if(backup) {
			if(!config->quiet) {
				printf("%s%s%s: ", config->colstr.title, _("backup file"),
						config->colstr.nocolor);
				printf(_("%s: %s (Modification time mismatch)\n"),
						pkgname, filepath);
			}
			return 0;
		}
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (Modification time mismatch)\n"),
					pkgname, filepath);
		}
		return 1;
	}

	return 0;
}

static int check_file_link(const char *pkgname, const char *filepath,
		struct stat *st, struct archive_entry *entry)
{
	size_t length = st->st_size + 1;
	char link[length];

	if(readlink(filepath, link, length) != st->st_size) {
		/* this should not happen */
		pm_printf(ALPM_LOG_ERROR, _("unable to read symlink contents: %s\n"), filepath);
		return 1;
	}
	link[length - 1] = '\0';

	if(strcmp(link, archive_entry_symlink(entry)) != 0) {
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (Symlink path mismatch)\n"),
					pkgname, filepath);
		}
		return 1;
	}

	return 0;
}

static int check_file_size(const char *pkgname, const char *filepath,
		struct stat *st, struct archive_entry *entry, int backup)
{
	if(st->st_size != archive_entry_size(entry)) {
		if(backup) {
			if(!config->quiet) {
				printf("%s%s%s: ", config->colstr.title, _("backup file"),
						config->colstr.nocolor);
				printf(_("%s: %s (Size mismatch)\n"),
						pkgname, filepath);
			}
			return 0;
		}
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (Size mismatch)\n"),
					pkgname, filepath);
		}
		return 1;
	}

	return 0;
}

#if ARCHIVE_VERSION_NUMBER >= 3005000
static int check_file_cksum(const char *pkgname, const char *filepath,
		int backup, const char *cksum_name, const char *cksum_calc, const char *cksum_mtree)
{
	if(!cksum_calc) {
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (failed to calculate %s checksum)\n"),
					pkgname, filepath, cksum_name);
		}
		return 1;
	}

	if(!cksum_mtree) {
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (%s checksum information not available)\n"),
					pkgname, filepath, cksum_name);
		}
		return 1;
	}

	if(strcmp(cksum_calc, cksum_mtree) != 0) {
		if(backup) {
			if(!config->quiet) {
				printf("%s%s%s: ", config->colstr.title, _("backup file"),
						config->colstr.nocolor);
				printf(_("%s: %s (%s checksum mismatch)\n"),
						pkgname, filepath, cksum_name);
			}
			return 0;
		}
		if(!config->quiet) {
			pm_printf(ALPM_LOG_WARNING, _("%s: %s (%s checksum mismatch)\n"),
					pkgname, filepath, cksum_name);
		}
		return 1;
	}

	return 0;
}
#endif

static int check_file_md5sum(const char *pkgname, const char *filepath,
		struct archive_entry *entry, int backup)
{
	int errors = 0;
#if ARCHIVE_VERSION_NUMBER >= 3005000
	char *cksum_calc = alpm_compute_md5sum(filepath);
	char *cksum_mtree = hex_representation(archive_entry_digest(entry,
													ARCHIVE_ENTRY_DIGEST_MD5), 16);
	errors = check_file_cksum(pkgname, filepath, backup, "MD5", cksum_calc,
									cksum_mtree);
	free(cksum_mtree);
	free(cksum_calc);
#endif
	return (errors != 0 ? 1 : 0);
}

static int check_file_sha256sum(const char *pkgname, const char *filepath,
		struct archive_entry *entry, int backup)
{
	int errors = 0;
#if ARCHIVE_VERSION_NUMBER >= 3005000
	char *cksum_calc = alpm_compute_sha256sum(filepath);
	char *cksum_mtree = hex_representation(archive_entry_digest(entry,
													ARCHIVE_ENTRY_DIGEST_SHA256), 32);
	errors = check_file_cksum(pkgname, filepath, backup, "SHA256", cksum_calc,
									cksum_mtree);
	free(cksum_mtree);
	free(cksum_calc);
#endif
	return (errors != 0 ? 1 : 0);
}

/* Loop through the files of the package to check if they exist. */
int check_pkg_fast(alpm_pkg_t *pkg)
{
	const char *root, *pkgname;
	size_t errors = 0;
	size_t rootlen;
	char filepath[PATH_MAX];
	alpm_filelist_t *filelist;
	size_t i;

	root = alpm_option_get_root(config->handle);
	rootlen = strlen(root);
	if(rootlen + 1 > PATH_MAX) {
		/* we are in trouble here */
		pm_printf(ALPM_LOG_ERROR, _("path too long: %s%s\n"), root, "");
		return 1;
	}
	strcpy(filepath, root);

	pkgname = alpm_pkg_get_name(pkg);
	filelist = alpm_pkg_get_files(pkg);
	for(i = 0; i < filelist->count; i++) {
		const alpm_file_t *file = filelist->files + i;
		struct stat st;
		int exists;
		const char *path = file->name;
		size_t plen = strlen(path);

		if(rootlen + 1 + plen > PATH_MAX) {
			pm_printf(ALPM_LOG_WARNING, _("path too long: %s%s\n"), root, path);
			continue;
		}
		strcpy(filepath + rootlen, path);

		exists = check_file_exists(pkgname, filepath, rootlen, &st);
		if(exists == 0) {
			int expect_dir = path[plen - 1] == '/' ? 1 : 0;
			int is_dir = S_ISDIR(st.st_mode) ? 1 : 0;
			if(expect_dir != is_dir) {
				pm_printf(ALPM_LOG_WARNING, _("%s: %s (File type mismatch)\n"),
						pkgname, filepath);
				++errors;
			}
		} else if(exists == 1) {
			++errors;
		}
	}

	if(!config->quiet) {
		printf(_n("%s: %jd total file, ", "%s: %jd total files, ",
					(unsigned long)filelist->count), pkgname, (intmax_t)filelist->count);
		printf(_n("%jd missing file\n", "%jd missing files\n",
					(unsigned long)errors), (intmax_t)errors);
	}

	return (errors != 0 ? 1 : 0);
}

/* Loop though files in a package and perform full file property checking. */
int check_pkg_full(alpm_pkg_t *pkg)
{
	const char *root, *pkgname;
	size_t errors = 0;
	size_t rootlen;
	struct archive *mtree;
	struct archive_entry *entry = NULL;
	size_t file_count = 0;
	const alpm_list_t *lp;

	root = alpm_option_get_root(config->handle);
	rootlen = strlen(root);
	if(rootlen + 1 > PATH_MAX) {
		/* we are in trouble here */
		pm_printf(ALPM_LOG_ERROR, _("path too long: %s%s\n"), root, "");
		return 1;
	}

	pkgname = alpm_pkg_get_name(pkg);
	mtree = alpm_pkg_mtree_open(pkg);
	if(mtree == NULL) {
		/* TODO: check error to confirm failure due to no mtree file */
		if(!config->quiet) {
			printf(_("%s: no mtree file\n"), pkgname);
		}
		return 0;
	}

	while(alpm_pkg_mtree_next(pkg, mtree, &entry) == 0) {
		struct stat st;
		const char *path = archive_entry_pathname(entry);
		char filepath[PATH_MAX];
		int filepath_len;
		mode_t type;
		size_t file_errors = 0;
		int backup = 0;
		int exists;

		/* strip leading "./" from path entries */
		if(path[0] == '.' && path[1] == '/') {
			path += 2;
		}

		if(*path == '.') {
			const char *dbfile = NULL;

			if(strcmp(path, ".INSTALL") == 0) {
				dbfile = "install";
			} else if(strcmp(path, ".CHANGELOG") == 0) {
				dbfile = "changelog";
			} else {
				continue;
			}

			/* Do not append root directory as alpm_option_get_dbpath is already
			 * an absoute path */
			filepath_len = snprintf(filepath, PATH_MAX, "%slocal/%s-%s/%s",
					alpm_option_get_dbpath(config->handle),
					pkgname, alpm_pkg_get_version(pkg), dbfile);
			if(filepath_len >= PATH_MAX) {
				pm_printf(ALPM_LOG_WARNING, _("path too long: %slocal/%s-%s/%s\n"),
						alpm_option_get_dbpath(config->handle),
						pkgname, alpm_pkg_get_version(pkg), dbfile);
				continue;
			}
		} else {
			filepath_len = snprintf(filepath, PATH_MAX, "%s%s", root, path);
			if(filepath_len >= PATH_MAX) {
				pm_printf(ALPM_LOG_WARNING, _("path too long: %s%s\n"), root, path);
				continue;
			}
		}

		file_count++;

		exists = check_file_exists(pkgname, filepath, rootlen, &st);
		if(exists == 1) {
			errors++;
			continue;
		} else if(exists == -1) {
			/* NoExtract */
			continue;
		}

		type = archive_entry_filetype(entry);

		if(type != AE_IFDIR && type != AE_IFREG && type != AE_IFLNK) {
			pm_printf(ALPM_LOG_WARNING, _("file type not recognized: %s%s\n"), root, path);
			continue;
		}

		if(check_file_type(pkgname, filepath, &st, entry) == 1) {
			errors++;
			continue;
		}

		file_errors += check_file_permissions(pkgname, filepath, &st, entry);

		if(type == AE_IFLNK) {
			file_errors += check_file_link(pkgname, filepath, &st, entry);
		}

		/* the following checks are expected to fail if a backup file has been
		   modified */
		for(lp = alpm_pkg_get_backup(pkg); lp; lp = lp->next) {
			alpm_backup_t *bl = lp->data;

			if(strcmp(path, bl->name) == 0) {
				backup = 1;
				break;
			}
		}

		if(type != AE_IFDIR) {
			/* file or symbolic link */
			file_errors += check_file_time(pkgname, filepath, &st, entry, backup);
		}

		if(type == AE_IFREG) {
			file_errors += check_file_size(pkgname, filepath, &st, entry, backup);
			file_errors += check_file_md5sum(pkgname, filepath, entry, backup);
			file_errors += check_file_sha256sum(pkgname, filepath, entry, backup);
		}

		if(config->quiet && file_errors) {
			printf("%s %s\n", pkgname, filepath);
		}

		errors += (file_errors != 0 ? 1 : 0);
	}

	alpm_pkg_mtree_close(pkg, mtree);

	if(!config->quiet) {
		printf(_n("%s: %jd total file, ", "%s: %jd total files, ",
					(unsigned long)file_count), pkgname, (intmax_t)file_count);
		printf(_n("%jd altered file\n", "%jd altered files\n",
					(unsigned long)errors), (intmax_t)errors);
	}

	return (errors != 0 ? 1 : 0);
}
