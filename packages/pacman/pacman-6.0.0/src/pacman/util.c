/*
 *  util.c
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

#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <time.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdint.h> /* intmax_t */
#include <string.h>
#include <errno.h>
#include <dirent.h>
#include <unistd.h>
#include <limits.h>
#include <wchar.h>
#include <wctype.h>
#ifdef HAVE_TERMIOS_H
#include <termios.h> /* tcflush */
#endif

#include <alpm.h>
#include <alpm_list.h>

/* pacman */
#include "util.h"
#include "conf.h"
#include "callback.h"

static int cached_columns = -1;

struct table_cell_t {
	char *label;
	size_t len;
	int mode;
};

enum {
	CELL_NORMAL = 0,
	CELL_TITLE = (1 << 0),
	CELL_RIGHT_ALIGN = (1 << 1),
	CELL_FREE = (1 << 3)
};

int trans_init(int flags, int check_valid)
{
	int ret;

	check_syncdbs(0, check_valid);

	ret = alpm_trans_init(config->handle, flags);
	if(ret == -1) {
		trans_init_error();
		return -1;
	}
	return 0;
}

void trans_init_error(void)
{
	alpm_errno_t err = alpm_errno(config->handle);
	pm_printf(ALPM_LOG_ERROR, _("failed to init transaction (%s)\n"),
			alpm_strerror(err));
	if(err == ALPM_ERR_HANDLE_LOCK) {
		const char *lockfile = alpm_option_get_lockfile(config->handle);
		pm_printf(ALPM_LOG_ERROR, _("could not lock database: %s\n"),
					strerror(errno));
		if(access(lockfile, F_OK) == 0) {
			fprintf(stderr, _("  if you're sure a package manager is not already\n"
						"  running, you can remove %s\n"), lockfile);
		}
	}
}

int trans_release(void)
{
	if(alpm_trans_release(config->handle) == -1) {
		pm_printf(ALPM_LOG_ERROR, _("failed to release transaction (%s)\n"),
				alpm_strerror(alpm_errno(config->handle)));
		return -1;
	}
	return 0;
}

int needs_root(void)
{
	if(config->sysroot) {
		return 1;
	}
	switch(config->op) {
		case PM_OP_DATABASE:
			return !config->op_q_check;
		case PM_OP_UPGRADE:
		case PM_OP_REMOVE:
			return !config->print;
		case PM_OP_SYNC:
			return (config->op_s_clean || config->op_s_sync ||
					(!config->group && !config->op_s_info && !config->op_q_list &&
					 !config->op_s_search && !config->print));
		case PM_OP_FILES:
			return config->op_s_sync;
		default:
			return 0;
	}
}

int check_syncdbs(size_t need_repos, int check_valid)
{
	int ret = 0;
	alpm_list_t *i;
	alpm_list_t *sync_dbs = alpm_get_syncdbs(config->handle);

	if(need_repos && sync_dbs == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("no usable package repositories configured.\n"));
		return 1;
	}

	if(check_valid) {
		/* ensure all known dbs are valid */
		for(i = sync_dbs; i; i = alpm_list_next(i)) {
			alpm_db_t *db = i->data;
			if(alpm_db_get_valid(db)) {
				pm_printf(ALPM_LOG_ERROR, _("database '%s' is not valid (%s)\n"),
						alpm_db_get_name(db), alpm_strerror(alpm_errno(config->handle)));
				ret = 1;
			}
		}
	}
	return ret;
}

int sync_syncdbs(int level, alpm_list_t *syncs)
{
	int ret;
	int force = (level < 2 ? 0 : 1);

	multibar_move_completed_up(false);
	ret = alpm_db_update(config->handle, syncs, force);
	if(ret < 0) {
		pm_printf(ALPM_LOG_ERROR, _("failed to synchronize all databases (%s)\n"),
			alpm_strerror(alpm_errno(config->handle)));
	}

	return (ret >= 0);
}

/* discard unhandled input on the terminal's input buffer */
static int flush_term_input(int fd)
{
#ifdef HAVE_TCFLUSH
	if(isatty(fd)) {
		return tcflush(fd, TCIFLUSH);
	}
#endif

	/* fail silently */
	return 0;
}

void columns_cache_reset(void)
{
	cached_columns = -1;
}

static int getcols_fd(int fd)
{
	int width = -1;

	if(!isatty(fd)) {
		return 0;
	}

#if defined(TIOCGSIZE)
	struct ttysize win;
	if(ioctl(fd, TIOCGSIZE, &win) == 0) {
		width = win.ts_cols;
	}
#elif defined(TIOCGWINSZ)
	struct winsize win;
	if(ioctl(fd, TIOCGWINSZ, &win) == 0) {
		width = win.ws_col;
	}
#endif

	if(width <= 0) {
		return -EIO;
	}

	return width;
}

unsigned short getcols(void)
{
	const char *e;
	int c = -1;

	if(cached_columns >= 0) {
		return cached_columns;
	}

	e = getenv("COLUMNS");
	if(e && *e) {
		char *p = NULL;
		c = strtol(e, &p, 10);
		if(*p != '\0') {
			c= -1;
		}
	}

	if(c < 0) {
		c = getcols_fd(STDOUT_FILENO);
	}

	if(c < 0) {
		c = 80;
	}

	cached_columns = c;
	return c;
}

/* does the same thing as 'rm -rf' */
int rmrf(const char *path)
{
	int errflag = 0;
	struct dirent *dp;
	DIR *dirp;

	if(!unlink(path)) {
		return 0;
	} else {
		switch(errno) {
		case ENOENT:
			return 0;
		case EPERM:
		case EISDIR:
			break;
		default:
			/* not a directory */
			return 1;
		}

		dirp = opendir(path);
		if(!dirp) {
			return 1;
		}
		for(dp = readdir(dirp); dp != NULL; dp = readdir(dirp)) {
			if(strcmp(dp->d_name, "..") != 0 && strcmp(dp->d_name, ".") != 0) {
				char name[PATH_MAX];
				snprintf(name, PATH_MAX, "%s/%s", path, dp->d_name);
				errflag += rmrf(name);
			}
		}
		closedir(dirp);
		if(rmdir(path)) {
			errflag++;
		}
		return errflag;
	}
}

/* output a string, but wrap words properly with a specified indentation
 */
void indentprint(const char *str, unsigned short indent, unsigned short cols)
{
	wchar_t *wcstr;
	const wchar_t *p;
	size_t len, cidx;

	if(!str) {
		return;
	}

	/* if we're not a tty, or our tty is not wide enough that wrapping even makes
	 * sense, print without indenting */
	if(cols == 0 || indent > cols) {
		fputs(str, stdout);
		return;
	}

	len = strlen(str) + 1;
	wcstr = calloc(len, sizeof(wchar_t));
	len = mbstowcs(wcstr, str, len);
	p = wcstr;
	cidx = indent;

	if(!p || !len) {
		free(wcstr);
		return;
	}

	while(*p) {
		if(*p == L' ') {
			const wchar_t *q, *next;
			p++;
			if(p == NULL || *p == L' ') continue;
			next = wcschr(p, L' ');
			if(next == NULL) {
				next = p + wcslen(p);
			}
			/* len captures # cols */
			len = 0;
			q = p;
			while(q < next) {
				len += wcwidth(*q++);
			}
			if((len + 1) > (cols - cidx)) {
				/* wrap to a newline and reindent */
				printf("\n%-*s", (int)indent, "");
				cidx = indent;
			} else {
				printf(" ");
				cidx++;
			}
			continue;
		}
		printf("%lc", (wint_t)*p);
		cidx += wcwidth(*p);
		p++;
	}
	free(wcstr);
}

/* Replace all occurrences of 'needle' with 'replace' in 'str', returning
 * a new string (must be free'd) */
char *strreplace(const char *str, const char *needle, const char *replace)
{
	const char *p = NULL, *q = NULL;
	char *newstr = NULL, *newp = NULL;
	alpm_list_t *i = NULL, *list = NULL;
	size_t needlesz = strlen(needle), replacesz = strlen(replace);
	size_t newsz;

	if(!str) {
		return NULL;
	}

	p = str;
	q = strstr(p, needle);
	while(q) {
		list = alpm_list_add(list, (char *)q);
		p = q + needlesz;
		q = strstr(p, needle);
	}

	/* no occurrences of needle found */
	if(!list) {
		return strdup(str);
	}
	/* size of new string = size of old string + "number of occurrences of needle"
	 * x "size difference between replace and needle" */
	newsz = strlen(str) + 1 +
		alpm_list_count(list) * (replacesz - needlesz);
	newstr = calloc(newsz, sizeof(char));
	if(!newstr) {
		return NULL;
	}

	p = str;
	newp = newstr;
	for(i = list; i; i = alpm_list_next(i)) {
		q = i->data;
		if(q > p) {
			/* add chars between this occurrence and last occurrence, if any */
			memcpy(newp, p, (size_t)(q - p));
			newp += q - p;
		}
		memcpy(newp, replace, replacesz);
		newp += replacesz;
		p = q + needlesz;
	}
	alpm_list_free(list);

	if(*p) {
		/* add the rest of 'p' */
		strcpy(newp, p);
	}

	return newstr;
}

static size_t string_length(const char *s)
{
	int len;
	wchar_t *wcstr;

	if(!s || s[0] == '\0') {
		return 0;
	}
	if(strstr(s, "\033")) {
		char* replaced = malloc(sizeof(char) * strlen(s));
		int iter = 0;
		for(; *s; s++) {
			if(*s == '\033') {
				while(*s != 'm') {
					s++;
				}
			} else {
				replaced[iter] = *s;
				iter++;
			}
		}
		replaced[iter] = '\0';
		len = iter;
		wcstr = calloc(len, sizeof(wchar_t));
		len = mbstowcs(wcstr, replaced, len);
		len = wcswidth(wcstr, len);
		free(wcstr);
		free(replaced);
	} else {
		/* len goes from # bytes -> # chars -> # cols */
		len = strlen(s) + 1;
		wcstr = calloc(len, sizeof(wchar_t));
		len = mbstowcs(wcstr, s, len);
		len = wcswidth(wcstr, len);
		free(wcstr);
	}

	return len;
}

static void add_table_cell(alpm_list_t **row, char *label, int mode)
{
	struct table_cell_t *cell = malloc(sizeof(struct table_cell_t));

	cell->label = label;
	cell->mode = mode;
	cell->len = string_length(label);

	*row = alpm_list_add(*row, cell);
}

static void table_free_cell(void *ptr)
{
	struct table_cell_t *cell = ptr;

	if(cell) {
		if(cell->mode & CELL_FREE) {
			free(cell->label);
		}
		free(cell);
	}
}

static void table_free(alpm_list_t *headers, alpm_list_t *rows)
{
	alpm_list_t *i;

	alpm_list_free_inner(headers, table_free_cell);

	for(i = rows; i; i = alpm_list_next(i)) {
		alpm_list_free_inner(i->data, table_free_cell);
		alpm_list_free(i->data);
	}

	alpm_list_free(headers);
	alpm_list_free(rows);
}

static void add_transaction_sizes_row(alpm_list_t **rows, char *label, off_t size)
{
	alpm_list_t *row = NULL;
	char *str;
	const char *units;
	double s = humanize_size(size, 'M', 2, &units);
	pm_asprintf(&str, "%.2f %s", s, units);

	add_table_cell(&row, label, CELL_TITLE);
	add_table_cell(&row, str, CELL_RIGHT_ALIGN | CELL_FREE);

	*rows = alpm_list_add(*rows, row);
}

void string_display(const char *title, const char *string, unsigned short cols)
{
	if(title) {
		printf("%s%s%s ", config->colstr.title, title, config->colstr.nocolor);
	}
	if(string == NULL || string[0] == '\0') {
		printf(_("None"));
	} else {
		/* compute the length of title + a space */
		size_t len = string_length(title) + 1;
		indentprint(string, (unsigned short)len, cols);
	}
	printf("\n");
}

static void table_print_line(const alpm_list_t *line, short col_padding,
		size_t colcount, const size_t *widths, const int *has_data)
{
	size_t i;
	int need_padding = 0;
	const alpm_list_t *curcell;

	for(i = 0, curcell = line; curcell && i < colcount;
			i++, curcell = alpm_list_next(curcell)) {
		const struct table_cell_t *cell = curcell->data;
		const char *str = (cell->label ? cell->label : "");
		int cell_width;

		if(!has_data[i]) {
			continue;
		}

		/* calculate cell width, adjusting for multi-byte character strings */
		cell_width = (int)widths[i] - string_length(str) + strlen(str);
		cell_width = cell->mode & CELL_RIGHT_ALIGN ? cell_width : -cell_width;

		if(need_padding) {
			printf("%*s", col_padding, "");
		}

		if(cell->mode & CELL_TITLE) {
			printf("%s%*s%s", config->colstr.title, cell_width, str, config->colstr.nocolor);
		} else {
			printf("%*s", cell_width, str);
		}
		need_padding = 1;
	}

	printf("\n");
}


/**
 * Find the max string width of each column. Also determines whether values
 * exist in the column and sets the value in has_data accordingly.
 * @param header a list of header strings
 * @param rows a list of lists of rows as strings
 * @param padding the amount of padding between columns
 * @param totalcols the total number of columns in the header and each row
 * @param widths a pointer to store width data
 * @param has_data a pointer to store whether column has data
 *
 * @return the total width of the table; 0 on failure
 */
static size_t table_calc_widths(const alpm_list_t *header,
		const alpm_list_t *rows, short padding, size_t totalcols,
		size_t **widths, int **has_data)
{
	const alpm_list_t *i;
	size_t curcol, totalwidth = 0, usefulcols = 0;
	size_t *colwidths;
	int *coldata;

	if(totalcols <= 0) {
		return 0;
	}

	colwidths = malloc(totalcols * sizeof(size_t));
	coldata = calloc(totalcols, sizeof(int));
	if(!colwidths || !coldata) {
		free(colwidths);
		free(coldata);
		return 0;
	}
	/* header determines column count and initial values of longest_strs */
	for(i = header, curcol = 0; i; i = alpm_list_next(i), curcol++) {
		const struct table_cell_t *row = i->data;
		colwidths[curcol] = row->len;
		/* note: header does not determine whether column has data */
	}

	/* now find the longest string in each column */
	for(i = rows; i; i = alpm_list_next(i)) {
		/* grab first column of each row and iterate through columns */
		const alpm_list_t *j = i->data;
		for(curcol = 0; j; j = alpm_list_next(j), curcol++) {
			const struct table_cell_t *cell = j->data;
			size_t str_len = cell ? cell->len : 0;

			if(str_len > colwidths[curcol]) {
				colwidths[curcol] = str_len;
			}
			if(str_len > 0) {
				coldata[curcol] = 1;
			}
		}
	}

	for(i = header, curcol = 0; i; i = alpm_list_next(i), curcol++) {
		/* only include columns that have data */
		if(coldata[curcol]) {
			usefulcols++;
			totalwidth += colwidths[curcol];
		}
	}

	/* add padding between columns */
	if(usefulcols > 0) {
		totalwidth += padding * (usefulcols - 1);
	}

	*widths = colwidths;
	*has_data = coldata;
	return totalwidth;
}

/** Displays the list in table format
 *
 * @param header the column headers. column count is determined by the nr
 *               of headers
 * @param rows the rows to display as a list of lists of strings. the outer
 *             list represents the rows, the inner list the cells (= columns)
 * @param cols the number of columns available in the terminal
 * @return -1 if not enough terminal cols available, else 0
 */
static int table_display(const alpm_list_t *header,
		const alpm_list_t *rows, unsigned short cols)
{
	const unsigned short padding = 2;
	const alpm_list_t *i, *first;
	size_t *widths = NULL, totalcols, totalwidth;
	int *has_data = NULL;
	int ret = 0;

	if(rows == NULL) {
		return ret;
	}

	/* we want the first row. if no headers are provided, use the first
	 * entry of the rows array. */
	first = header ? header : rows->data;

	totalcols = alpm_list_count(first);
	totalwidth = table_calc_widths(first, rows, padding, totalcols,
			&widths, &has_data);
	/* return -1 if terminal is not wide enough */
	if(cols && totalwidth > cols) {
		pm_printf(ALPM_LOG_WARNING,
				_("insufficient columns available for table display\n"));
		ret = -1;
		goto cleanup;
	}
	if(!totalwidth || !widths || !has_data) {
		ret = -1;
		goto cleanup;
	}

	if(header) {
		table_print_line(header, padding, totalcols, widths, has_data);
		printf("\n");
	}

	for(i = rows; i; i = alpm_list_next(i)) {
		table_print_line(i->data, padding, totalcols, widths, has_data);
	}

cleanup:
	free(widths);
	free(has_data);
	return ret;
}

void list_display(const char *title, const alpm_list_t *list,
		unsigned short maxcols)
{
	const alpm_list_t *i;
	size_t len = 0;

	if(title) {
		len = string_length(title) + 1;
		printf("%s%s%s ", config->colstr.title, title, config->colstr.nocolor);
	}

	if(!list) {
		printf("%s\n", _("None"));
	} else {
		size_t cols = len;
		const char *str = list->data;
		fputs(str, stdout);
		cols += string_length(str);
		for(i = alpm_list_next(list); i; i = alpm_list_next(i)) {
			str = i->data;
			size_t s = string_length(str);
			/* wrap only if we have enough usable column space */
			if(maxcols > len && cols + s + 2 >= maxcols) {
				size_t j;
				cols = len;
				printf("\n");
				for(j = 1; j <= len; j++) {
					printf(" ");
				}
			} else if(cols != len) {
				/* 2 spaces are added if this is not the first element on a line. */
				printf("  ");
				cols += 2;
			}
			fputs(str, stdout);
			cols += s;
		}
		putchar('\n');
	}
}

void list_display_linebreak(const char *title, const alpm_list_t *list,
		unsigned short maxcols)
{
	unsigned short len = 0;

	if(title) {
		len = (unsigned short)string_length(title) + 1;
		printf("%s%s%s ", config->colstr.title, title, config->colstr.nocolor);
	}

	if(!list) {
		printf("%s\n", _("None"));
	} else {
		const alpm_list_t *i;
		/* Print the first element */
		indentprint((const char *)list->data, len, maxcols);
		printf("\n");
		/* Print the rest */
		for(i = alpm_list_next(list); i; i = alpm_list_next(i)) {
			size_t j;
			for(j = 1; j <= len; j++) {
				printf(" ");
			}
			indentprint((const char *)i->data, len, maxcols);
			printf("\n");
		}
	}
}

void signature_display(const char *title, alpm_siglist_t *siglist,
		unsigned short maxcols)
{
	unsigned short len = 0;

	if(title) {
		len = (unsigned short)string_length(title) + 1;
		printf("%s%s%s ", config->colstr.title, title, config->colstr.nocolor);
	}
	if(siglist->count == 0) {
		printf(_("None"));
	} else {
		size_t i;
		for(i = 0; i < siglist->count; i++) {
			char *sigline;
			const char *status, *validity, *name;
			int ret;
			alpm_sigresult_t *result = siglist->results + i;
			/* Don't re-indent the first result */
			if(i != 0) {
				size_t j;
				for(j = 1; j <= len; j++) {
					printf(" ");
				}
			}
			switch(result->status) {
				case ALPM_SIGSTATUS_VALID:
					status = _("Valid");
					break;
				case ALPM_SIGSTATUS_KEY_EXPIRED:
					status = _("Key expired");
					break;
				case ALPM_SIGSTATUS_SIG_EXPIRED:
					status = _("Expired");
					break;
				case ALPM_SIGSTATUS_INVALID:
					status = _("Invalid");
					break;
				case ALPM_SIGSTATUS_KEY_UNKNOWN:
					status = _("Key unknown");
					break;
				case ALPM_SIGSTATUS_KEY_DISABLED:
					status = _("Key disabled");
					break;
				default:
					status = _("Signature error");
					break;
			}
			switch(result->validity) {
				case ALPM_SIGVALIDITY_FULL:
					validity = _("full trust");
					break;
				case ALPM_SIGVALIDITY_MARGINAL:
					validity = _("marginal trust");
					break;
				case ALPM_SIGVALIDITY_NEVER:
					validity = _("never trust");
					break;
				case ALPM_SIGVALIDITY_UNKNOWN:
				default:
					validity = _("unknown trust");
					break;
			}
			name = result->key.uid ? result->key.uid : result->key.fingerprint;
			ret = pm_asprintf(&sigline, _("%s, %s from \"%s\""),
					status, validity, name);
			if(ret == -1) {
				continue;
			}
			indentprint(sigline, len, maxcols);
			printf("\n");
			free(sigline);
		}
	}
}

/* creates a header row for use with table_display */
static alpm_list_t *create_verbose_header(size_t count)
{
	alpm_list_t *ret = NULL;

	char *header;
	pm_asprintf(&header, "%s (%zu)", _("Package"), count);

	add_table_cell(&ret, header, CELL_TITLE | CELL_FREE);
	add_table_cell(&ret, _("Old Version"), CELL_TITLE);
	add_table_cell(&ret, _("New Version"), CELL_TITLE);
	add_table_cell(&ret, _("Net Change"), CELL_TITLE);
	add_table_cell(&ret, _("Download Size"), CELL_TITLE);

	return ret;
}

/* returns package info as list of strings */
static alpm_list_t *create_verbose_row(pm_target_t *target)
{
	char *str;
	off_t size = 0;
	double human_size;
	const char *label;
	alpm_list_t *ret = NULL;

	/* a row consists of the package name, */
	if(target->install) {
		const alpm_db_t *db = alpm_pkg_get_db(target->install);
		if(db) {
			pm_asprintf(&str, "%s/%s", alpm_db_get_name(db), alpm_pkg_get_name(target->install));
		} else {
			pm_asprintf(&str, "%s", alpm_pkg_get_name(target->install));
		}
	} else {
		pm_asprintf(&str, "%s", alpm_pkg_get_name(target->remove));
	}
	add_table_cell(&ret, str, CELL_NORMAL | CELL_FREE);

	/* old and new versions */
	pm_asprintf(&str, "%s",
			target->remove != NULL ? alpm_pkg_get_version(target->remove) : "");
	add_table_cell(&ret, str, CELL_NORMAL | CELL_FREE);

	pm_asprintf(&str, "%s",
			target->install != NULL ? alpm_pkg_get_version(target->install) : "");
	add_table_cell(&ret, str, CELL_NORMAL | CELL_FREE);

	/* and size */
	size -= target->remove ? alpm_pkg_get_isize(target->remove) : 0;
	size += target->install ? alpm_pkg_get_isize(target->install) : 0;
	human_size = humanize_size(size, 'M', 2, &label);
	pm_asprintf(&str, "%.2f %s", human_size, label);
	add_table_cell(&ret, str, CELL_RIGHT_ALIGN | CELL_FREE);

	size = target->install ? alpm_pkg_download_size(target->install) : 0;
	if(size != 0) {
		human_size = humanize_size(size, 'M', 2, &label);
		pm_asprintf(&str, "%.2f %s", human_size, label);
	} else {
		str = NULL;
	}
	add_table_cell(&ret, str, CELL_RIGHT_ALIGN | CELL_FREE);

	return ret;
}

/* prepare a list of pkgs to display */
static void _display_targets(alpm_list_t *targets, int verbose)
{
	char *str;
	off_t isize = 0, rsize = 0, dlsize = 0;
	unsigned short cols;
	alpm_list_t *i, *names = NULL, *header = NULL, *rows = NULL;

	if(!targets) {
		return;
	}

	/* gather package info */
	for(i = targets; i; i = alpm_list_next(i)) {
		pm_target_t *target = i->data;

		if(target->install) {
			dlsize += alpm_pkg_download_size(target->install);
			isize += alpm_pkg_get_isize(target->install);
		}
		if(target->remove) {
			/* add up size of all removed packages */
			rsize += alpm_pkg_get_isize(target->remove);
		}
	}

	/* form data for both verbose and non-verbose display */
	for(i = targets; i; i = alpm_list_next(i)) {
		pm_target_t *target = i->data;

		if(verbose) {
			rows = alpm_list_add(rows, create_verbose_row(target));
		}

		if(target->install) {
			pm_asprintf(&str, "%s%s-%s%s", alpm_pkg_get_name(target->install), config->colstr.faint,
					alpm_pkg_get_version(target->install), config->colstr.nocolor);
		} else if(isize == 0) {
			pm_asprintf(&str, "%s%s-%s%s", alpm_pkg_get_name(target->remove), config->colstr.faint,
					alpm_pkg_get_version(target->remove), config->colstr.nocolor);
		} else {
			pm_asprintf(&str, "%s%s-%s %s[%s]%s", alpm_pkg_get_name(target->remove), config->colstr.faint,
					alpm_pkg_get_version(target->remove), config->colstr.nocolor, _("removal"), config->colstr.nocolor);
		}
		names = alpm_list_add(names, str);
	}

	/* print to screen */
	pm_asprintf(&str, "%s (%zu)", _("Packages"), alpm_list_count(targets));
	printf("\n");

	cols = getcols();
	if(verbose) {
		header = create_verbose_header(alpm_list_count(targets));
		if(table_display(header, rows, cols) != 0) {
			/* fallback to list display if table wouldn't fit */
			list_display(str, names, cols);
		}
	} else {
		list_display(str, names, cols);
	}
	printf("\n");

	table_free(header, rows);
	FREELIST(names);
	free(str);
	rows = NULL;

	if(dlsize > 0 || config->op_s_downloadonly) {
		add_transaction_sizes_row(&rows, _("Total Download Size:"), dlsize);
	}
	if(!config->op_s_downloadonly) {
		if(isize > 0) {
			add_transaction_sizes_row(&rows, _("Total Installed Size:"), isize);
		}
		if(rsize > 0 && isize == 0) {
			add_transaction_sizes_row(&rows, _("Total Removed Size:"), rsize);
		}
		/* only show this net value if different from raw installed size */
		if(isize > 0 && rsize > 0) {
			add_transaction_sizes_row(&rows, _("Net Upgrade Size:"), isize - rsize);
		}
	}
	table_display(NULL, rows, cols);
	table_free(NULL, rows);
}

static int target_cmp(const void *p1, const void *p2)
{
	const pm_target_t *targ1 = p1;
	const pm_target_t *targ2 = p2;
	/* explicit are always sorted after implicit (e.g. deps, pulled targets) */
	if(targ1->is_explicit != targ2->is_explicit) {
		return targ1->is_explicit > targ2->is_explicit;
	}
	const char *name1 = targ1->install ?
		alpm_pkg_get_name(targ1->install) : alpm_pkg_get_name(targ1->remove);
	const char *name2 = targ2->install ?
		alpm_pkg_get_name(targ2->install) : alpm_pkg_get_name(targ2->remove);
	return strcmp(name1, name2);
}

static int pkg_cmp(const void *p1, const void *p2)
{
	/* explicit cast due to (un)necessary removal of const */
	alpm_pkg_t *pkg1 = (alpm_pkg_t *)p1;
	alpm_pkg_t *pkg2 = (alpm_pkg_t *)p2;
	return strcmp(alpm_pkg_get_name(pkg1), alpm_pkg_get_name(pkg2));
}

void display_targets(void)
{
	alpm_list_t *i, *targets = NULL;
	alpm_db_t *db_local = alpm_get_localdb(config->handle);

	for(i = alpm_trans_get_add(config->handle); i; i = alpm_list_next(i)) {
		alpm_pkg_t *pkg = i->data;
		pm_target_t *targ = calloc(1, sizeof(pm_target_t));
		if(!targ) return;
		targ->install = pkg;
		targ->remove = alpm_db_get_pkg(db_local, alpm_pkg_get_name(pkg));
		if(alpm_list_find(config->explicit_adds, pkg, pkg_cmp)) {
			targ->is_explicit = 1;
		}
		targets = alpm_list_add(targets, targ);
	}
	for(i = alpm_trans_get_remove(config->handle); i; i = alpm_list_next(i)) {
		alpm_pkg_t *pkg = i->data;
		pm_target_t *targ = calloc(1, sizeof(pm_target_t));
		if(!targ) return;
		targ->remove = pkg;
		if(alpm_list_find(config->explicit_removes, pkg, pkg_cmp)) {
			targ->is_explicit = 1;
		}
		targets = alpm_list_add(targets, targ);
	}

	targets = alpm_list_msort(targets, alpm_list_count(targets), target_cmp);
	_display_targets(targets, config->verbosepkglists);
	FREELIST(targets);
}

static off_t pkg_get_size(alpm_pkg_t *pkg)
{
	switch(config->op) {
		case PM_OP_SYNC:
			return alpm_pkg_download_size(pkg);
		case PM_OP_UPGRADE:
			return alpm_pkg_get_size(pkg);
		default:
			return alpm_pkg_get_isize(pkg);
	}
}

static char *pkg_get_location(alpm_pkg_t *pkg)
{
	alpm_list_t *servers;
	char *string = NULL;
	switch(alpm_pkg_get_origin(pkg)) {
		case ALPM_PKG_FROM_SYNCDB:
			if(alpm_pkg_download_size(pkg) == 0) {
				/* file is already in the package cache */
				alpm_list_t *i;
				const char *pkgfile = alpm_pkg_get_filename(pkg);
				char path[PATH_MAX];
				struct stat buf;

				for(i = alpm_option_get_cachedirs(config->handle); i; i = i->next) {
					snprintf(path, PATH_MAX, "%s%s", (char *)i->data, pkgfile);
					if(stat(path, &buf) == 0 && S_ISREG(buf.st_mode)) {
						pm_asprintf(&string, "file://%s", path);
						return string;
					}
				}
			}

			servers = alpm_db_get_servers(alpm_pkg_get_db(pkg));
			if(servers) {
				pm_asprintf(&string, "%s/%s", (char *)(servers->data),
						alpm_pkg_get_filename(pkg));
				return string;
			}

			/* fallthrough - for theoretical serverless repos */
			__attribute__((fallthrough));

		case ALPM_PKG_FROM_FILE:
			return strdup(alpm_pkg_get_filename(pkg));

		case ALPM_PKG_FROM_LOCALDB:
		default:
			pm_asprintf(&string, "%s-%s", alpm_pkg_get_name(pkg), alpm_pkg_get_version(pkg));
			return string;
	}
}

/* a pow() implementation that is specialized for an integer base and small,
 * positive-only integer exponents. */
static double simple_pow(int base, int exp)
{
	double result = 1.0;
	for(; exp > 0; exp--) {
		result *= base;
	}
	return result;
}

/** Converts sizes in bytes into human readable units.
 *
 * @param bytes the size in bytes
 * @param target_unit '\0' or a short label. If equal to one of the short unit
 * labels ('B', 'K', ...) bytes is converted to target_unit; if '\0', the first
 * unit which will bring the value to below a threshold of 2048 will be chosen.
 * @param precision number of decimal places, ensures -0.00 gets rounded to
 * 0.00; -1 if no rounding desired
 * @param label will be set to the appropriate unit label
 *
 * @return the size in the appropriate unit
 */
double humanize_size(off_t bytes, const char target_unit, int precision,
		const char **label)
{
	static const char *labels[] = {"B", "KiB", "MiB", "GiB",
		"TiB", "PiB", "EiB", "ZiB", "YiB"};
	static const int unitcount = ARRAYSIZE(labels);

	double val = (double)bytes;
	int index;

	for(index = 0; index < unitcount - 1; index++) {
		if(target_unit != '\0' && labels[index][0] == target_unit) {
			break;
		} else if(target_unit == '\0' && val <= 2048.0 && val >= -2048.0) {
			break;
		}
		val /= 1024.0;
	}

	if(label) {
		*label = labels[index];
	}

	/* do not display negative zeroes */
	if(precision >= 0 && val < 0.0 &&
			val > (-0.5 / simple_pow(10, precision))) {
		val = 0.0;
	}

	return val;
}

void print_packages(const alpm_list_t *packages)
{
	const alpm_list_t *i;
	if(!config->print_format) {
		config->print_format = strdup("%l");
	}
	for(i = packages; i; i = alpm_list_next(i)) {
		alpm_pkg_t *pkg = i->data;
		char *string = strdup(config->print_format);
		char *temp = string;
		/* %n : pkgname */
		if(strstr(temp, "%n")) {
			string = strreplace(temp, "%n", alpm_pkg_get_name(pkg));
			free(temp);
			temp = string;
		}
		/* %v : pkgver */
		if(strstr(temp, "%v")) {
			string = strreplace(temp, "%v", alpm_pkg_get_version(pkg));
			free(temp);
			temp = string;
		}
		/* %l : location */
		if(strstr(temp, "%l")) {
			char *pkgloc = pkg_get_location(pkg);
			string = strreplace(temp, "%l", pkgloc);
			free(pkgloc);
			free(temp);
			temp = string;
		}
		/* %r : repo */
		if(strstr(temp, "%r")) {
			const char *repo = "local";
			alpm_db_t *db = alpm_pkg_get_db(pkg);
			if(db) {
				repo = alpm_db_get_name(db);
			}
			string = strreplace(temp, "%r", repo);
			free(temp);
			temp = string;
		}
		/* %s : size */
		if(strstr(temp, "%s")) {
			char *size;
			pm_asprintf(&size, "%jd", (intmax_t)pkg_get_size(pkg));
			string = strreplace(temp, "%s", size);
			free(size);
			free(temp);
		}
		printf("%s\n", string);
		free(string);
	}
}

/**
 * Helper function for comparing depends using the alpm "compare func"
 * signature. The function descends through the structure in the following
 * comparison order: name, modifier (e.g., '>', '='), version, description.
 * @param d1 the first depend structure
 * @param d2 the second depend structure
 * @return -1, 0, or 1 if first is <, ==, or > second
 */
static int depend_cmp(const void *d1, const void *d2)
{
	const alpm_depend_t *dep1 = d1;
	const alpm_depend_t *dep2 = d2;
	int ret;

	ret = strcmp(dep1->name, dep2->name);
	if(ret == 0) {
		ret = dep1->mod - dep2->mod;
	}
	if(ret == 0) {
		if(dep1->version && dep2->version) {
			ret = strcmp(dep1->version, dep2->version);
		} else if(!dep1->version && dep2->version) {
			ret = -1;
		} else if(dep1->version && !dep2->version) {
			ret = 1;
		}
	}
	if(ret == 0) {
		if(dep1->desc && dep2->desc) {
			ret = strcmp(dep1->desc, dep2->desc);
		} else if(!dep1->desc && dep2->desc) {
			ret = -1;
		} else if(dep1->desc && !dep2->desc) {
			ret = 1;
		}
	}

	return ret;
}

static char *make_optstring(alpm_depend_t *optdep)
{
	alpm_db_t *localdb = alpm_get_localdb(config->handle);
	char *optstring = alpm_dep_compute_string(optdep);
	char *status = NULL;
	if(alpm_find_satisfier(alpm_db_get_pkgcache(localdb), optstring)) {
		status = _(" [installed]");
	} else if(alpm_find_satisfier(alpm_trans_get_add(config->handle), optstring)) {
		status = _(" [pending]");
	}
	if(status) {
		optstring = realloc(optstring, strlen(optstring) + strlen(status) + 1);
		strcpy(optstring + strlen(optstring), status);
	}
	return optstring;
}

void display_new_optdepends(alpm_pkg_t *oldpkg, alpm_pkg_t *newpkg)
{
	alpm_list_t *i, *old, *new, *optdeps, *optstrings = NULL;

	old = alpm_pkg_get_optdepends(oldpkg);
	new = alpm_pkg_get_optdepends(newpkg);
	optdeps = alpm_list_diff(new, old, depend_cmp);

	/* turn optdepends list into a text list */
	for(i = optdeps; i; i = alpm_list_next(i)) {
		alpm_depend_t *optdep = i->data;
		optstrings = alpm_list_add(optstrings, make_optstring(optdep));
	}

	if(optstrings) {
		printf(_("New optional dependencies for %s\n"), alpm_pkg_get_name(newpkg));
		unsigned short cols = getcols();
		list_display_linebreak("   ", optstrings, cols);
	}

	alpm_list_free(optdeps);
	FREELIST(optstrings);
}

void display_optdepends(alpm_pkg_t *pkg)
{
	alpm_list_t *i, *optdeps, *optstrings = NULL;

	optdeps = alpm_pkg_get_optdepends(pkg);

	/* turn optdepends list into a text list */
	for(i = optdeps; i; i = alpm_list_next(i)) {
		alpm_depend_t *optdep = i->data;
		optstrings = alpm_list_add(optstrings, make_optstring(optdep));
	}

	if(optstrings) {
		printf(_("Optional dependencies for %s\n"), alpm_pkg_get_name(pkg));
		unsigned short cols = getcols();
		list_display_linebreak("   ", optstrings, cols);
	}

	FREELIST(optstrings);
}

static void display_repo_list(const char *dbname, alpm_list_t *list,
		unsigned short cols)
{
	const char *prefix = "  ";
	const colstr_t *colstr = &config->colstr;

	colon_printf(_("Repository %s%s\n"), colstr->repo, dbname);
	list_display(prefix, list, cols);
}

void select_display(const alpm_list_t *pkglist)
{
	const alpm_list_t *i;
	int nth = 1;
	alpm_list_t *list = NULL;
	char *string = NULL;
	const char *dbname = NULL;
	unsigned short cols = getcols();

	for(i = pkglist; i; i = i->next) {
		alpm_pkg_t *pkg = i->data;
		alpm_db_t *db = alpm_pkg_get_db(pkg);

		if(!dbname) {
			dbname = alpm_db_get_name(db);
		}
		if(strcmp(alpm_db_get_name(db), dbname) != 0) {
			display_repo_list(dbname, list, cols);
			FREELIST(list);
			dbname = alpm_db_get_name(db);
		}
		string = NULL;
		pm_asprintf(&string, "%d) %s", nth, alpm_pkg_get_name(pkg));
		list = alpm_list_add(list, string);
		nth++;
	}
	display_repo_list(dbname, list, cols);
	FREELIST(list);
}

static int parseindex(char *s, int *val, int min, int max)
{
	char *endptr = NULL;
	int n = strtol(s, &endptr, 10);
	if(*endptr == '\0') {
		if(n < min || n > max) {
			pm_printf(ALPM_LOG_ERROR,
					_("invalid value: %d is not between %d and %d\n"),
					n, min, max);
			return -1;
		}
		*val = n;
		return 0;
	} else {
		pm_printf(ALPM_LOG_ERROR, _("invalid number: %s\n"), s);
		return -1;
	}
}

static int multiselect_parse(char *array, int count, char *response)
{
	char *str, *saveptr;

	for(str = response; ; str = NULL) {
		int include = 1;
		int start, end;
		size_t len;
		char *ends = NULL;
		char *starts = strtok_r(str, " ,", &saveptr);

		if(starts == NULL) {
			break;
		}
		len = strtrim(starts);
		if(len == 0) {
			continue;
		}

		if(*starts == '^') {
			starts++;
			len--;
			include = 0;
		} else if(str) {
			/* if first token is including, we deselect all targets */
			memset(array, 0, count);
		}

		if(len > 1) {
			/* check for range */
			char *p;
			if((p = strchr(starts + 1, '-'))) {
				*p = 0;
				ends = p + 1;
			}
		}

		if(parseindex(starts, &start, 1, count) != 0) {
			return -1;
		}

		if(!ends) {
			array[start - 1] = include;
		} else {
			if(parseindex(ends, &end, start, count) != 0) {
				return -1;
			}
			do {
				array[start - 1] = include;
			} while(start++ < end);
		}
	}

	return 0;
}

void console_cursor_hide(void) {
	if(isatty(fileno(stdout))) {
		printf(CURSOR_HIDE_ANSICODE);
	}
}

void console_cursor_show(void) {
	if(isatty(fileno(stdout))) {
		printf(CURSOR_SHOW_ANSICODE);
	}
}

char *safe_fgets_stdin(char *s, int size)
{
	char *result;
	console_cursor_show();
	result = safe_fgets(s, size, stdin);
	console_cursor_hide();
	return result;
}

int multiselect_question(char *array, int count)
{
	char *response, *lastchar;
	FILE *stream;
	size_t response_len = 64;

	if(config->noconfirm) {
		stream = stdout;
	} else {
		/* Use stderr so questions are always displayed when redirecting output */
		stream = stderr;
	}

	response = malloc(response_len);
	if(!response) {
		return -1;
	}
	lastchar = response + response_len - 1;
	/* sentinel byte to later see if we filled up the entire string */
	*lastchar = 1;

	while(1) {
		memset(array, 1, count);

		fprintf(stream, "\n");
		fprintf(stream, _("Enter a selection (default=all)"));
		fprintf(stream, ": ");
		fflush(stream);

		if(config->noconfirm) {
			fprintf(stream, "\n");
			break;
		}

		flush_term_input(fileno(stdin));

		if(safe_fgets_stdin(response, response_len)) {
			const size_t response_incr = 64;
			size_t len;
			/* handle buffer not being large enough to read full line case */
			while(*lastchar == '\0' && lastchar[-1] != '\n') {
				char *new_response;
				response_len += response_incr;
				new_response = realloc(response, response_len);
				if(!new_response) {
					free(response);
					return -1;
				}
				response = new_response;
				lastchar = response + response_len - 1;
				/* sentinel byte */
				*lastchar = 1;
				if(safe_fgets_stdin(response + response_len - response_incr - 1,
							response_incr + 1) == 0) {
					free(response);
					return -1;
				}
			}

			len = strtrim(response);
			if(len > 0) {
				if(multiselect_parse(array, count, response) == -1) {
					/* only loop if user gave an invalid answer */
					continue;
				}
			}
			break;
		} else {
			free(response);
			return -1;
		}
	}

	free(response);
	return 0;
}

int select_question(int count)
{
	char response[32];
	FILE *stream;
	int preset = 1;

	if(config->noconfirm) {
		stream = stdout;
	} else {
		/* Use stderr so questions are always displayed when redirecting output */
		stream = stderr;
	}

	while(1) {
		fprintf(stream, "\n");
		fprintf(stream, _("Enter a number (default=%d)"), preset);
		fprintf(stream, ": ");
		fflush(stream);

		if(config->noconfirm) {
			fprintf(stream, "\n");
			break;
		}

		flush_term_input(fileno(stdin));

		if(safe_fgets_stdin(response, sizeof(response))) {
			size_t len = strtrim(response);
			if(len > 0) {
				int n;
				if(parseindex(response, &n, 1, count) != 0) {
					continue;
				}
				return (n - 1);
			}
		}
		break;
	}

	return (preset - 1);
}

#define CMP(x, y) ((x) < (y) ? -1 : ((x) > (y) ? 1 : 0))

static int mbscasecmp(const char *s1, const char *s2)
{
	size_t len1 = strlen(s1), len2 = strlen(s2);
	wchar_t c1, c2;
	const char *p1 = s1, *p2 = s2;
	mbstate_t ps1, ps2;
	memset(&ps1, 0, sizeof(mbstate_t));
	memset(&ps2, 0, sizeof(mbstate_t));
	while(*p1 && *p2) {
		size_t b1 = mbrtowc(&c1, p1, len1, &ps1);
		size_t b2 = mbrtowc(&c2, p2, len2, &ps2);
		if(b1 == (size_t) -2 || b1 == (size_t) -1
				|| b2 == (size_t) -2 || b2 == (size_t) -1) {
			/* invalid multi-byte string, fall back to strcasecmp */
			return strcasecmp(p1, p2);
		}
		if(b1 == 0 || b2 == 0) {
			return CMP(c1, c2);
		}
		c1 = towlower(c1);
		c2 = towlower(c2);
		if(c1 != c2) {
			return CMP(c1, c2);
		}
		p1 += b1;
		p2 += b2;
		len1 -= b1;
		len2 -= b2;
	}
	return CMP(*p1, *p2);
}

/* presents a prompt and gets a Y/N answer */
__attribute__((format(printf, 2, 0)))
static int question(short preset, const char *format, va_list args)
{
	char response[32];
	FILE *stream;
	int fd_in = fileno(stdin);

	if(config->noconfirm) {
		stream = stdout;
	} else {
		/* Use stderr so questions are always displayed when redirecting output */
		stream = stderr;
	}

	/* ensure all text makes it to the screen before we prompt the user */
	fflush(stdout);
	fflush(stderr);

	fputs(config->colstr.colon, stream);
	vfprintf(stream, format, args);

	if(preset) {
		fprintf(stream, " %s ", _("[Y/n]"));
	} else {
		fprintf(stream, " %s ", _("[y/N]"));
	}

	fputs(config->colstr.nocolor, stream);
	fflush(stream);

	if(config->noconfirm) {
		fprintf(stream, "\n");
		return preset;
	}

	flush_term_input(fd_in);

	if(safe_fgets_stdin(response, sizeof(response))) {
		size_t len = strtrim(response);
		if(len == 0) {
			return preset;
		}

		/* if stdin is piped, response does not get printed out, and as a result
		 * a \n is missing, resulting in broken output */
		if(!isatty(fd_in)) {
			fprintf(stream, "%s\n", response);
		}

		if(mbscasecmp(response, _("Y")) == 0 || mbscasecmp(response, _("YES")) == 0) {
			return 1;
		} else if(mbscasecmp(response, _("N")) == 0 || mbscasecmp(response, _("NO")) == 0) {
			return 0;
		}
	}
	return 0;
}

int yesno(const char *format, ...)
{
	int ret;
	va_list args;

	va_start(args, format);
	ret = question(1, format, args);
	va_end(args);

	return ret;
}

int noyes(const char *format, ...)
{
	int ret;
	va_list args;

	va_start(args, format);
	ret = question(0, format, args);
	va_end(args);

	return ret;
}

int colon_printf(const char *fmt, ...)
{
	int ret;
	va_list args;

	va_start(args, fmt);
	fputs(config->colstr.colon, stdout);
	ret = vprintf(fmt, args);
	fputs(config->colstr.nocolor, stdout);
	va_end(args);

	fflush(stdout);
	return ret;
}

int pm_printf(alpm_loglevel_t level, const char *format, ...)
{
	int ret;
	va_list args;

	/* print the message using va_arg list */
	va_start(args, format);
	ret = pm_vfprintf(stderr, level, format, args);
	va_end(args);

	return ret;
}

int pm_asprintf(char **string, const char *format, ...)
{
	int ret = 0;
	va_list args;

	/* print the message using va_arg list */
	va_start(args, format);
	if(vasprintf(string, format, args) == -1) {
		pm_printf(ALPM_LOG_ERROR, _("failed to allocate string\n"));
		ret = -1;
	}
	va_end(args);

	return ret;
}

int pm_sprintf(char **string, alpm_loglevel_t level, const char *format, ...)
{
	int ret = 0;
	va_list args;

	/* print the message using va_arg list */
	va_start(args, format);
	ret = pm_vasprintf(string, level, format, args);
	va_end(args);

	return ret;
}

int pm_vasprintf(char **string, alpm_loglevel_t level, const char *format, va_list args)
{
	int ret = 0;
	char *msg = NULL;

	/* if current logmask does not overlap with level, do not print msg */
	if(!(config->logmask & level)) {
		return ret;
	}

	/* print the message using va_arg list */
	ret = vasprintf(&msg, format, args);

	/* print a prefix to the message */
	switch(level) {
		case ALPM_LOG_ERROR:
			pm_asprintf(string, "%s%s%s%s", config->colstr.err, _("error: "),
								config->colstr.nocolor, msg);
			break;
		case ALPM_LOG_WARNING:
			pm_asprintf(string, "%s%s%s%s", config->colstr.warn, _("warning: "),
								config->colstr.nocolor, msg);
			break;
		case ALPM_LOG_DEBUG:
			pm_asprintf(string, "debug: %s", msg);
			break;
		case ALPM_LOG_FUNCTION:
			pm_asprintf(string, "function: %s", msg);
			break;
		default:
			pm_asprintf(string, "%s", msg);
			break;
	}
	free(msg);

	return ret;
}

int pm_vfprintf(FILE *stream, alpm_loglevel_t level, const char *format, va_list args)
{
	int ret = 0;

	/* if current logmask does not overlap with level, do not print msg */
	if(!(config->logmask & level)) {
		return ret;
	}

#if defined(PACMAN_DEBUG)
	/* If debug is on, we'll timestamp the output */
	if(config->logmask & ALPM_LOG_DEBUG) {
		time_t t;
		struct tm *tmp;
		char timestr[10] = {0};

		t = time(NULL);
		tmp = localtime(&t);
		strftime(timestr, 9, "%H:%M:%S", tmp);
		timestr[8] = '\0';

		fprintf(stream, "[%s] ", timestr);
	}
#endif

	/* print a prefix to the message */
	switch(level) {
		case ALPM_LOG_ERROR:
			fprintf(stream, "%s%s%s", config->colstr.err, _("error: "),
					config->colstr.nocolor);
			break;
		case ALPM_LOG_WARNING:
			fprintf(stream, "%s%s%s", config->colstr.warn, _("warning: "),
					config->colstr.nocolor);
			break;
		case ALPM_LOG_DEBUG:
			fprintf(stream, "debug: ");
			break;
		case ALPM_LOG_FUNCTION:
			fprintf(stream, "function: ");
			break;
		default:
			break;
	}

	/* print the message using va_arg list */
	ret = vfprintf(stream, format, args);
	return ret;
}

char *arg_to_string(int argc, char *argv[])
{
	char *cl_text, *p;
	size_t size = 0;
	int i;
	for(i = 0; i < argc; i++) {
		size += strlen(argv[i]) + 1;
	}
	if(!size) {
		return NULL;
	}
	if(!(cl_text = malloc(size))) {
		return NULL;
	}
	for(p = cl_text, i = 0; i + 1 < argc; i++) {
		strcpy(p, argv[i]);
		p += strlen(argv[i]);
		*p++ = ' ';
	}
	strcpy(p, argv[i]);
	return cl_text;
}

/* Moves console cursor `lines` up */
void console_cursor_move_up(unsigned int lines)
{
	printf("\x1B[%dF", lines);
}

/* Moves console cursor `lines` down */
void console_cursor_move_down(unsigned int lines)
{
	printf("\x1B[%dE", lines);
}

/* Erases line from the current cursor position till the end of the line */
void console_erase_line(void)
{
	printf("\x1B[K");
}
