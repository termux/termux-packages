/*
 *  package.c
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

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <errno.h>
#include <time.h>
#include <wchar.h>

#include <alpm.h>
#include <alpm_list.h>

/* pacman */
#include "package.h"
#include "util.h"
#include "conf.h"

#define CLBUF_SIZE 4096

/* The term "title" refers to the first field of each line in the package
 * information displayed by pacman. Titles are stored in the `titles` array and
 * referenced by the following indices.
 */
enum {
	T_ARCHITECTURE = 0,
	T_BACKUP_FILES,
	T_BUILD_DATE,
	T_COMPRESSED_SIZE,
	T_CONFLICTS_WITH,
	T_DEPENDS_ON,
	T_DESCRIPTION,
	T_DOWNLOAD_SIZE,
	T_GROUPS,
	T_INSTALL_DATE,
	T_INSTALL_REASON,
	T_INSTALL_SCRIPT,
	T_INSTALLED_SIZE,
	T_LICENSES,
	T_MD5_SUM,
	T_NAME,
	T_OPTIONAL_DEPS,
	T_OPTIONAL_FOR,
	T_PACKAGER,
	T_PROVIDES,
	T_REPLACES,
	T_REPOSITORY,
	T_REQUIRED_BY,
	T_SHA_256_SUM,
	T_SIGNATURES,
	T_URL,
	T_VALIDATED_BY,
	T_VERSION,
	/* the following is a sentinel and should remain in last position */
	_T_MAX
};

/* As of 2015/10/20, the longest title (all locales considered) was less than 30
 * characters long. We set the title maximum length to 50 to allow for some
 * potential growth.
 */
#define TITLE_MAXLEN 50

static char titles[_T_MAX][TITLE_MAXLEN * sizeof(wchar_t)];

/** Build the `titles` array of localized titles and pad them with spaces so
 * that they align with the longest title. Storage for strings is stack
 * allocated and naively truncated to TITLE_MAXLEN characters.
 */
static void make_aligned_titles(void)
{
	unsigned int i;
	size_t maxlen = 0;
	int maxcol = 0;
	static const wchar_t title_suffix[] = L" :";
	wchar_t wbuf[ARRAYSIZE(titles)][TITLE_MAXLEN + ARRAYSIZE(title_suffix)] = {{ 0 }};
	size_t wlen[ARRAYSIZE(wbuf)];
	int wcol[ARRAYSIZE(wbuf)];
	char *buf[ARRAYSIZE(wbuf)];
	buf[T_ARCHITECTURE] = _("Architecture");
	buf[T_BACKUP_FILES] = _("Backup Files");
	buf[T_BUILD_DATE] = _("Build Date");
	buf[T_COMPRESSED_SIZE] = _("Compressed Size");
	buf[T_CONFLICTS_WITH] = _("Conflicts With");
	buf[T_DEPENDS_ON] = _("Depends On");
	buf[T_DESCRIPTION] = _("Description");
	buf[T_DOWNLOAD_SIZE] = _("Download Size");
	buf[T_GROUPS] = _("Groups");
	buf[T_INSTALL_DATE] = _("Install Date");
	buf[T_INSTALL_REASON] = _("Install Reason");
	buf[T_INSTALL_SCRIPT] = _("Install Script");
	buf[T_INSTALLED_SIZE] = _("Installed Size");
	buf[T_LICENSES] = _("Licenses");
	buf[T_MD5_SUM] = _("MD5 Sum");
	buf[T_NAME] = _("Name");
	buf[T_OPTIONAL_DEPS] = _("Optional Deps");
	buf[T_OPTIONAL_FOR] = _("Optional For");
	buf[T_PACKAGER] = _("Packager");
	buf[T_PROVIDES] = _("Provides");
	buf[T_REPLACES] = _("Replaces");
	buf[T_REPOSITORY] = _("Repository");
	buf[T_REQUIRED_BY] = _("Required By");
	buf[T_SHA_256_SUM] = _("SHA-256 Sum");
	buf[T_SIGNATURES] = _("Signatures");
	buf[T_URL] = _("URL");
	buf[T_VALIDATED_BY] = _("Validated By");
	buf[T_VERSION] = _("Version");

	for(i = 0; i < ARRAYSIZE(wbuf); i++) {
		wlen[i] = mbstowcs(wbuf[i], buf[i], strlen(buf[i]) + 1);
		wcol[i] = wcswidth(wbuf[i], wlen[i]);
		if(wcol[i] > maxcol) {
			maxcol = wcol[i];
		}
		if(wlen[i] > maxlen) {
			maxlen = wlen[i];
		}
	}

	for(i = 0; i < ARRAYSIZE(wbuf); i++) {
		size_t padlen = maxcol - wcol[i];
		wmemset(wbuf[i] + wlen[i], L' ', padlen);
		wmemcpy(wbuf[i] + wlen[i] + padlen, title_suffix, ARRAYSIZE(title_suffix));
		wcstombs(titles[i], wbuf[i], sizeof(wbuf[i]));
	}
}

/** Turn a depends list into a text list.
 * @param deps a list with items of type alpm_depend_t
 */
static void deplist_display(const char *title,
		alpm_list_t *deps, unsigned short cols)
{
	alpm_list_t *i, *text = NULL;
	for(i = deps; i; i = alpm_list_next(i)) {
		alpm_depend_t *dep = i->data;
		text = alpm_list_add(text, alpm_dep_compute_string(dep));
	}
	list_display(title, text, cols);
	FREELIST(text);
}

/** Turn a optdepends list into a text list.
 * @param optdeps a list with items of type alpm_depend_t
 */
static void optdeplist_display(alpm_pkg_t *pkg, unsigned short cols)
{
	alpm_list_t *i, *text = NULL;
	alpm_db_t *localdb = alpm_get_localdb(config->handle);
	for(i = alpm_pkg_get_optdepends(pkg); i; i = alpm_list_next(i)) {
		alpm_depend_t *optdep = i->data;
		char *depstring = alpm_dep_compute_string(optdep);
		if(alpm_pkg_get_origin(pkg) == ALPM_PKG_FROM_LOCALDB) {
			if(alpm_find_satisfier(alpm_db_get_pkgcache(localdb), depstring)) {
				const char *installed = _(" [installed]");
				depstring = realloc(depstring, strlen(depstring) + strlen(installed) + 1);
				strcpy(depstring + strlen(depstring), installed);
			}
		}
		text = alpm_list_add(text, depstring);
	}
	list_display_linebreak(titles[T_OPTIONAL_DEPS], text, cols);
	FREELIST(text);
}

/**
 * Display the details of a package.
 * Extra information entails 'required by' info for sync packages and backup
 * files info for local packages.
 * @param pkg package to display information for
 * @param extra should we show extra information
 */
void dump_pkg_full(alpm_pkg_t *pkg, int extra)
{
	unsigned short cols;
	time_t bdate, idate;
	alpm_pkgfrom_t from;
	double size;
	char bdatestr[50] = "", idatestr[50] = "";
	const char *label, *reason;
	alpm_list_t *validation = NULL, *requiredby = NULL, *optionalfor = NULL;

	/* make aligned titles once only */
	static int need_alignment = 1;
	if(need_alignment) {
		need_alignment = 0;
		make_aligned_titles();
	}

	from = alpm_pkg_get_origin(pkg);

	/* set variables here, do all output below */
	bdate = (time_t)alpm_pkg_get_builddate(pkg);
	if(bdate) {
		strftime(bdatestr, 50, "%c", localtime(&bdate));
	}
	idate = (time_t)alpm_pkg_get_installdate(pkg);
	if(idate) {
		strftime(idatestr, 50, "%c", localtime(&idate));
	}

	switch(alpm_pkg_get_reason(pkg)) {
		case ALPM_PKG_REASON_EXPLICIT:
			reason = _("Explicitly installed");
			break;
		case ALPM_PKG_REASON_DEPEND:
			reason = _("Installed as a dependency for another package");
			break;
		default:
			reason = _("Unknown");
			break;
	}

	int v = alpm_pkg_get_validation(pkg);
	if(v) {
		if(v & ALPM_PKG_VALIDATION_NONE) {
			validation = alpm_list_add(validation, _("None"));
		} else {
			if(v & ALPM_PKG_VALIDATION_MD5SUM) {
				validation = alpm_list_add(validation, _("MD5 Sum"));
			}
			if(v & ALPM_PKG_VALIDATION_SHA256SUM) {
				validation = alpm_list_add(validation, _("SHA-256 Sum"));
			}
			if(v & ALPM_PKG_VALIDATION_SIGNATURE) {
				validation = alpm_list_add(validation, _("Signature"));
			}
		}
	} else {
		validation = alpm_list_add(validation, _("Unknown"));
	}

	if(extra || from == ALPM_PKG_FROM_LOCALDB) {
		/* compute this here so we don't get a pause in the middle of output */
		requiredby = alpm_pkg_compute_requiredby(pkg);
		optionalfor = alpm_pkg_compute_optionalfor(pkg);
	}

	cols = getcols();

	/* actual output */
	if(from == ALPM_PKG_FROM_SYNCDB) {
		string_display(titles[T_REPOSITORY],
				alpm_db_get_name(alpm_pkg_get_db(pkg)), cols);
	}
	string_display(titles[T_NAME], alpm_pkg_get_name(pkg), cols);
	string_display(titles[T_VERSION], alpm_pkg_get_version(pkg), cols);
	string_display(titles[T_DESCRIPTION], alpm_pkg_get_desc(pkg), cols);
	string_display(titles[T_ARCHITECTURE], alpm_pkg_get_arch(pkg), cols);
	string_display(titles[T_URL], alpm_pkg_get_url(pkg), cols);
	list_display(titles[T_LICENSES], alpm_pkg_get_licenses(pkg), cols);
	list_display(titles[T_GROUPS], alpm_pkg_get_groups(pkg), cols);
	deplist_display(titles[T_PROVIDES], alpm_pkg_get_provides(pkg), cols);
	deplist_display(titles[T_DEPENDS_ON], alpm_pkg_get_depends(pkg), cols);
	optdeplist_display(pkg, cols);

	if(extra || from == ALPM_PKG_FROM_LOCALDB) {
		list_display(titles[T_REQUIRED_BY], requiredby, cols);
		list_display(titles[T_OPTIONAL_FOR], optionalfor, cols);
	}
	deplist_display(titles[T_CONFLICTS_WITH], alpm_pkg_get_conflicts(pkg), cols);
	deplist_display(titles[T_REPLACES], alpm_pkg_get_replaces(pkg), cols);

	size = humanize_size(alpm_pkg_get_size(pkg), '\0', 2, &label);
	if(from == ALPM_PKG_FROM_SYNCDB) {
		printf("%s%s%s %.2f %s\n", config->colstr.title, titles[T_DOWNLOAD_SIZE],
			config->colstr.nocolor, size, label);
	} else if(from == ALPM_PKG_FROM_FILE) {
		printf("%s%s%s %.2f %s\n", config->colstr.title, titles[T_COMPRESSED_SIZE],
			config->colstr.nocolor, size, label);
	} else {
		/* autodetect size for "Installed Size" */
		label = "\0";
	}

	size = humanize_size(alpm_pkg_get_isize(pkg), label[0], 2, &label);
	printf("%s%s%s %.2f %s\n", config->colstr.title, titles[T_INSTALLED_SIZE],
			config->colstr.nocolor, size, label);

	string_display(titles[T_PACKAGER], alpm_pkg_get_packager(pkg), cols);
	string_display(titles[T_BUILD_DATE], bdatestr, cols);
	if(from == ALPM_PKG_FROM_LOCALDB) {
		string_display(titles[T_INSTALL_DATE], idatestr, cols);
		string_display(titles[T_INSTALL_REASON], reason, cols);
	}
	if(from == ALPM_PKG_FROM_FILE || from == ALPM_PKG_FROM_LOCALDB) {
		string_display(titles[T_INSTALL_SCRIPT],
				alpm_pkg_has_scriptlet(pkg) ? _("Yes") : _("No"), cols);
	}

	if(from == ALPM_PKG_FROM_SYNCDB && extra) {
		const char *base64_sig = alpm_pkg_get_base64_sig(pkg);
		alpm_list_t *keys = NULL;
		if(base64_sig) {
			unsigned char *decoded_sigdata = NULL;
			size_t data_len;
			alpm_decode_signature(base64_sig, &decoded_sigdata, &data_len);
			alpm_extract_keyid(config->handle, alpm_pkg_get_name(pkg),
					decoded_sigdata, data_len, &keys);
			free(decoded_sigdata);
		} else {
			keys = alpm_list_add(keys, _("None"));
		}

		string_display(titles[T_MD5_SUM], alpm_pkg_get_md5sum(pkg), cols);
		string_display(titles[T_SHA_256_SUM], alpm_pkg_get_sha256sum(pkg), cols);
		list_display(titles[T_SIGNATURES], keys, cols);

		if(base64_sig) {
			FREELIST(keys);
		}
	} else {
		list_display(titles[T_VALIDATED_BY], validation, cols);
	}

	if(from == ALPM_PKG_FROM_FILE) {
		alpm_siglist_t siglist;
		int err = alpm_pkg_check_pgp_signature(pkg, &siglist);
		if(err && alpm_errno(config->handle) == ALPM_ERR_SIG_MISSING) {
			string_display(titles[T_SIGNATURES], _("None"), cols);
		} else if(err) {
			string_display(titles[T_SIGNATURES],
					alpm_strerror(alpm_errno(config->handle)), cols);
		} else {
			signature_display(titles[T_SIGNATURES], &siglist, cols);
		}
		alpm_siglist_cleanup(&siglist);
	}

	/* Print additional package info if info flag passed more than once */
	if(from == ALPM_PKG_FROM_LOCALDB && extra) {
		dump_pkg_backups(pkg);
	}

	/* final newline to separate packages */
	printf("\n");

	FREELIST(requiredby);
	FREELIST(optionalfor);
	alpm_list_free(validation);
}

static const char *get_backup_file_status(const char *root,
		const alpm_backup_t *backup)
{
	char path[PATH_MAX];
	const char *ret;

	snprintf(path, PATH_MAX, "%s%s", root, backup->name);

	/* if we find the file, calculate checksums, otherwise it is missing */
	if(access(path, R_OK) == 0) {
		char *md5sum = alpm_compute_md5sum(path);

		if(md5sum == NULL) {
			pm_printf(ALPM_LOG_ERROR,
					_("could not calculate checksums for %s\n"), path);
			return NULL;
		}

		/* if checksums don't match, file has been modified */
		if(strcmp(md5sum, backup->hash) != 0) {
			ret = "MODIFIED";
		} else {
			ret = "UNMODIFIED";
		}
		free(md5sum);
	} else {
		switch(errno) {
			case EACCES:
				ret = "UNREADABLE";
				break;
			case ENOENT:
				ret = "MISSING";
				break;
			default:
				ret = "UNKNOWN";
		}
	}
	return ret;
}

/* Display list of backup files and their modification states
 */
void dump_pkg_backups(alpm_pkg_t *pkg)
{
	alpm_list_t *i;
	const char *root = alpm_option_get_root(config->handle);
	printf("%s%s\n%s", config->colstr.title, titles[T_BACKUP_FILES],
				 config->colstr.nocolor);
	if(alpm_pkg_get_backup(pkg)) {
		/* package has backup files, so print them */
		for(i = alpm_pkg_get_backup(pkg); i; i = alpm_list_next(i)) {
			const alpm_backup_t *backup = i->data;
			const char *value;
			if(!backup->hash) {
				continue;
			}
			value = get_backup_file_status(root, backup);
			printf("%s\t%s%s\n", value, root, backup->name);
		}
	} else {
		/* package had no backup files */
		printf(_("(none)\n"));
	}
}

/* List all files contained in a package
 */
void dump_pkg_files(alpm_pkg_t *pkg, int quiet)
{
	const char *pkgname, *root;
	alpm_filelist_t *pkgfiles;
	size_t i;

	pkgname = alpm_pkg_get_name(pkg);
	pkgfiles = alpm_pkg_get_files(pkg);
	root = alpm_option_get_root(config->handle);

	for(i = 0; i < pkgfiles->count; i++) {
		const alpm_file_t *file = pkgfiles->files + i;
		/* Regular: '<pkgname> <root><filepath>\n'
		 * Quiet  : '<root><filepath>\n'
		 */
		if(!quiet) {
			printf("%s%s%s ", config->colstr.title, pkgname, config->colstr.nocolor);
		}
		printf("%s%s\n", root, file->name);
	}

	fflush(stdout);
}

/* Display the changelog of a package
 */
void dump_pkg_changelog(alpm_pkg_t *pkg)
{
	void *fp = NULL;

	if((fp = alpm_pkg_changelog_open(pkg)) == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("no changelog available for '%s'.\n"),
				alpm_pkg_get_name(pkg));
		return;
	} else {
		fprintf(stdout, _("Changelog for %s:\n"), alpm_pkg_get_name(pkg));
		/* allocate a buffer to get the changelog back in chunks */
		char buf[CLBUF_SIZE];
		size_t ret = 0;
		while((ret = alpm_pkg_changelog_read(buf, CLBUF_SIZE, pkg, fp))) {
			if(ret < CLBUF_SIZE) {
				/* if we hit the end of the file, we need to add a null terminator */
				*(buf + ret) = '\0';
			}
			fputs(buf, stdout);
		}
		alpm_pkg_changelog_close(pkg, fp);
		putchar('\n');
	}
}

void print_installed(alpm_db_t *db_local, alpm_pkg_t *pkg)
{
	const char *pkgname = alpm_pkg_get_name(pkg);
	const char *pkgver = alpm_pkg_get_version(pkg);
	alpm_pkg_t *lpkg = alpm_db_get_pkg(db_local, pkgname);
	if(lpkg) {
		const char *lpkgver = alpm_pkg_get_version(lpkg);
		const colstr_t *colstr = &config->colstr;
		if(strcmp(lpkgver, pkgver) == 0) {
			printf(" %s[%s]%s", colstr->meta, _("installed"), colstr->nocolor);
		} else {
			printf(" %s[%s: %s]%s", colstr->meta, _("installed"),
					lpkgver, colstr->nocolor);
		}
	}
}

void print_groups(alpm_pkg_t *pkg)
{
	alpm_list_t *grp;
	if((grp = alpm_pkg_get_groups(pkg)) != NULL) {
		const colstr_t *colstr = &config->colstr;
		alpm_list_t *k;
		printf(" %s(", colstr->groups);
		for(k = grp; k; k = alpm_list_next(k)) {
			const char *group = k->data;
			fputs(group, stdout);
			if(alpm_list_next(k)) {
				/* only print a spacer if there are more groups */
				putchar(' ');
			}
		}
		printf(")%s", colstr->nocolor);
	}
}

/**
 * Display the details of a search.
 * @param db the database we're searching
 * @param targets the targets we're searching for
 * @param show_status show if the package is also in the local db
 * @return -1 on error, 0 if there were matches, 1 if there were not
 */
int dump_pkg_search(alpm_db_t *db, alpm_list_t *targets, int show_status)
{
	int freelist = 0;
	alpm_db_t *db_local;
	alpm_list_t *i, *searchlist = NULL;
	unsigned short cols;
	const colstr_t *colstr = &config->colstr;

	if(show_status) {
		db_local = alpm_get_localdb(config->handle);
	}

	/* if we have a targets list, search for packages matching it */
	if(targets) {
		if(alpm_db_search(db, targets, &searchlist) != 0) {
			return -1;
		}
		freelist = 1;
	} else {
		searchlist = alpm_db_get_pkgcache(db);
		freelist = 0;
	}
	if(searchlist == NULL) {
		return 1;
	}

	cols = getcols();
	for(i = searchlist; i; i = alpm_list_next(i)) {
		alpm_pkg_t *pkg = i->data;

		if(config->quiet) {
			fputs(alpm_pkg_get_name(pkg), stdout);
		} else {
			printf("%s%s/%s%s %s%s%s", colstr->repo, alpm_db_get_name(db),
					colstr->title, alpm_pkg_get_name(pkg),
					colstr->version, alpm_pkg_get_version(pkg), colstr->nocolor);

			print_groups(pkg);
			if(show_status) {
				print_installed(db_local, pkg);
			}

			/* we need a newline and initial indent first */
			fputs("\n    ", stdout);
			indentprint(alpm_pkg_get_desc(pkg), 4, cols);
		}
		fputc('\n', stdout);
	}

	/* we only want to free if the list was a search list */
	if(freelist) {
		alpm_list_free(searchlist);
	}

	return 0;
}
