/*
 *  util.h
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
#ifndef PM_UTIL_H
#define PM_UTIL_H

#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include <alpm_list.h>

#include "util-common.h"

#define CURSOR_HIDE_ANSICODE "\x1B[?25l"
#define CURSOR_SHOW_ANSICODE "\x1B[?25h"

#ifdef ENABLE_NLS
#include <libintl.h> /* here so it doesn't need to be included elsewhere */
/* define _() as shortcut for gettext() */
#define _(str) gettext(str)
#define _n(str1, str2, ct) ngettext(str1, str2, ct)
#else
#define _(str) (char *)str
#define _n(str1, str2, ct) (char *)(ct == 1 ? str1 : str2)
#endif

typedef struct _pm_target_t {
	alpm_pkg_t *remove;
	alpm_pkg_t *install;
	int is_explicit;
} pm_target_t;

void trans_init_error(void);
/* flags is a bitfield of alpm_transflag_t flags */
int trans_init(int flags, int check_valid);
int trans_release(void);
int needs_root(void);
int check_syncdbs(size_t need_repos, int check_valid);
int sync_syncdbs(int level, alpm_list_t *syncs);
unsigned short getcols(void);
void columns_cache_reset(void);
int rmrf(const char *path);
void indentprint(const char *str, unsigned short indent, unsigned short cols);
char *strreplace(const char *str, const char *needle, const char *replace);
void string_display(const char *title, const char *string, unsigned short cols);
double humanize_size(off_t bytes, const char target_unit, int precision,
		const char **label);
void list_display(const char *title, const alpm_list_t *list,
		unsigned short maxcols);
void list_display_linebreak(const char *title, const alpm_list_t *list,
		unsigned short maxcols);
void signature_display(const char *title, alpm_siglist_t *siglist,
		unsigned short maxcols);
void display_targets(void);
int str_cmp(const void *s1, const void *s2);
void display_new_optdepends(alpm_pkg_t *oldpkg, alpm_pkg_t *newpkg);
void display_optdepends(alpm_pkg_t *pkg);
void print_packages(const alpm_list_t *packages);
void select_display(const alpm_list_t *pkglist);
int select_question(int count);
int multiselect_question(char *array, int count);
int colon_printf(const char *format, ...) __attribute__((format(printf, 1, 2)));
int yesno(const char *format, ...) __attribute__((format(printf, 1, 2)));
int noyes(const char *format, ...) __attribute__((format(printf, 1, 2)));
char *arg_to_string(int argc, char *argv[]);
char *safe_fgets_stdin(char *s, int size);
void console_cursor_hide(void);
void console_cursor_show(void);
void console_cursor_move_up(unsigned int lines);
void console_cursor_move_down(unsigned int lines);
void console_cursor_move_end(void);
/* Erases line from the current cursor position till the end of the line */
void console_erase_line(void);

int pm_printf(alpm_loglevel_t level, const char *format, ...) __attribute__((format(printf,2,3)));
int pm_asprintf(char **string, const char *format, ...) __attribute__((format(printf,2,3)));
int pm_vfprintf(FILE *stream, alpm_loglevel_t level, const char *format, va_list args) __attribute__((format(printf,3,0)));
int pm_sprintf(char **string, alpm_loglevel_t level, const char *format, ...) __attribute__((format(printf,3,4)));
int pm_vasprintf(char **string, alpm_loglevel_t level, const char *format, va_list args) __attribute__((format(printf,3,0)));

#endif /* PM_UTIL_H */
