/*
 *  callback.c
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

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h> /* gettimeofday */
#include <sys/types.h> /* off_t */
#include <stdint.h> /* int64_t */
#include <time.h>
#include <unistd.h>
#include <wchar.h>
#include <limits.h> /* UINT_MAX */

#include <alpm.h>

/* pacman */
#include "pacman.h"
#include "callback.h"
#include "util.h"
#include "conf.h"

/* download progress bar */
static int total_enabled = 0;
static off_t list_total = 0.0;
static size_t list_total_pkgs = 0;
static struct pacman_progress_bar *totalbar;

/* delayed output during progress bar */
static int on_progress = 0;
static alpm_list_t *output = NULL;

/* update speed for the fill_progress based functions */
#define UPDATE_SPEED_MS 200

#if !defined(CLOCK_MONOTONIC_COARSE) && defined(CLOCK_MONOTONIC)
#define CLOCK_MONOTONIC_COARSE CLOCK_MONOTONIC
#endif

struct pacman_progress_bar {
	const char *filename;
	off_t xfered; /* Current amount of transferred data */
	off_t total_size;
	size_t downloaded;
	size_t howmany;
	uint64_t init_time; /* Time when this download started doing any progress */
	uint64_t sync_time; /* Last time we updated the bar info */
	off_t sync_xfered; /* Amount of transferred data at the `sync_time` timestamp. It can be
	                      smaller than `xfered` if we did not update bar UI for a while. */
	double rate;
	unsigned int eta; /* ETA in seconds */
	bool completed; /* transfer is completed */
};

/* This datastruct represents the state of multiline progressbar UI */
struct pacman_multibar_ui {
	/* List of active downloads handled by multibar UI.
	 * Once the first download in the list is completed it is removed
	 * from this list and we never redraw it anymore.
	 * If the download is in this list, then the UI can redraw the progress bar or change
	 * the order of the bars (e.g. moving completed bars to the top of the list)
	 */
	alpm_list_t *active_downloads; /* List of type 'struct pacman_progress_bar' */

	/* Number of active download bars that multibar UI handles. */
	size_t active_downloads_num;

	/* Specifies whether a completed progress bar need to be reordered and moved
	 * to the top of the list.
	 */
	bool move_completed_up;

	/* Cursor position relative to the first active progress bar,
	 * e.g. 0 means the first active progress bar, active_downloads_num-1 means the last bar,
	 * active_downloads_num - is the line below all progress bars.
	 */
	int cursor_lineno;
};

struct pacman_multibar_ui multibar_ui = {0};

static int dload_progressbar_enabled(void);
static void init_total_progressbar(void);
static void update_bar_finalstats(struct pacman_progress_bar *bar);
static void draw_pacman_progress_bar(struct pacman_progress_bar *bar);

void multibar_move_completed_up(bool value) {
	multibar_ui.move_completed_up = value;
}

static int64_t get_time_ms(void)
{
#if defined(_POSIX_TIMERS) && (_POSIX_TIMERS > 0) && defined(CLOCK_MONOTONIC_COARSE)
	struct timespec ts = {0, 0};
	clock_gettime(CLOCK_MONOTONIC_COARSE, &ts);
	return (ts.tv_sec * 1000) + (ts.tv_nsec / 1000000);
#else
	/* darwin doesn't support clock_gettime, fallback to gettimeofday */
	struct timeval tv = {0, 0};
	gettimeofday(&tv, NULL);
	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
#endif
}

/**
 * Silly little helper function, determines if the caller needs a visual update
 * since the last time this function was called.
 * This is made for the two progress bar functions, to prevent flicker.
 * @param first_call 1 on first call for initialization purposes, 0 otherwise
 * @return number of milliseconds since last call
 */
static int64_t get_update_timediff(int first_call)
{
	int64_t retval = 0;
	static int64_t last_time = 0;

	/* on first call, simply set the last time and return */
	if(first_call) {
		last_time = get_time_ms();
	} else {
		int64_t this_time = get_time_ms();
		retval = this_time - last_time;

		/* do not update last_time if interval was too short */
		if(retval < 0 || retval >= UPDATE_SPEED_MS) {
			last_time = this_time;
		}
	}

	return retval;
}

/* refactored from cb_trans_progress */
static void fill_progress(const int bar_percent, const int disp_percent,
		const int proglen)
{
	/* 8 = 1 space + 1 [ + 1 ] + 5 for percent */
	const int hashlen = proglen > 8 ? proglen - 8 : 0;
	const int hash = bar_percent * hashlen / 100;
	static int lasthash = 0, mouth = 0;
	int i;

	if(bar_percent == 0) {
		lasthash = 0;
		mouth = 0;
	}

	if(hashlen > 0) {
		fputs(" [", stdout);
		for(i = hashlen; i > 0; --i) {
			/* if special progress bar enabled */
			if(config->chomp) {
				if(i > hashlen - hash) {
					putchar('-');
				} else if(i == hashlen - hash) {
					if(lasthash == hash) {
						if(mouth) {
							fputs("\033[1;33mC\033[m", stdout);
						} else {
							fputs("\033[1;33mc\033[m", stdout);
						}
					} else {
						lasthash = hash;
						mouth = mouth == 1 ? 0 : 1;
						if(mouth) {
							fputs("\033[1;33mC\033[m", stdout);
						} else {
							fputs("\033[1;33mc\033[m", stdout);
						}
					}
				} else if(i % 3 == 0) {
					fputs("\033[0;37mo\033[m", stdout);
				} else {
					fputs("\033[0;37m \033[m", stdout);
				}
			} /* else regular progress bar */
			else if(i > hashlen - hash) {
				putchar('#');
			} else {
				putchar('-');
			}
		}
		putchar(']');
	}
	/* print display percent after progress bar */
	/* 5 = 1 space + 3 digits + 1 % */
	if(proglen >= 5) {
		printf(" %3d%%", disp_percent);
	}

	putchar('\r');
	fflush(stdout);
}

static void flush_output_list(void) {
	alpm_list_t *i = NULL;
	fflush(stdout);
	for(i = output; i; i = i->next) {
		fputs((const char *)i->data, stderr);
	}
	fflush(stderr);
	FREELIST(output);
}

static int number_length(size_t n)
{
	int digits = 1;
	while((n /= 10)) {
		++digits;
	}

	return digits;
}

/* callback to handle messages/notifications from libalpm transactions */
void cb_event(void *ctx, alpm_event_t *event)
{
	(void)ctx;
	if(config->print) {
		console_cursor_move_end();
		return;
	}
	switch(event->type) {
		case ALPM_EVENT_HOOK_START:
			if(event->hook.when == ALPM_HOOK_PRE_TRANSACTION) {
				colon_printf(_("Running pre-transaction hooks...\n"));
			} else {
				colon_printf(_("Running post-transaction hooks...\n"));
			}
			break;
		case ALPM_EVENT_HOOK_RUN_START:
			{
				alpm_event_hook_run_t *e = &event->hook_run;
				int digits = number_length(e->total);
				printf("(%*zu/%*zu) %s\n", digits, e->position,
						digits, e->total, 
						e->desc ? e->desc : e->name);
			}
			break;
		case ALPM_EVENT_CHECKDEPS_START:
			printf(_("checking dependencies...\n"));
			break;
		case ALPM_EVENT_FILECONFLICTS_START:
			if(config->noprogressbar) {
				printf(_("checking for file conflicts...\n"));
			}
			break;
		case ALPM_EVENT_RESOLVEDEPS_START:
			printf(_("resolving dependencies...\n"));
			break;
		case ALPM_EVENT_INTERCONFLICTS_START:
			printf(_("looking for conflicting packages...\n"));
			break;
		case ALPM_EVENT_TRANSACTION_START:
			colon_printf(_("Processing package changes...\n"));
			break;
		case ALPM_EVENT_PACKAGE_OPERATION_START:
			if(config->noprogressbar) {
				alpm_event_package_operation_t *e = &event->package_operation;
				switch(e->operation) {
					case ALPM_PACKAGE_INSTALL:
						printf(_("installing %s...\n"), alpm_pkg_get_name(e->newpkg));
						break;
					case ALPM_PACKAGE_UPGRADE:
						printf(_("upgrading %s...\n"), alpm_pkg_get_name(e->newpkg));
						break;
					case ALPM_PACKAGE_REINSTALL:
						printf(_("reinstalling %s...\n"), alpm_pkg_get_name(e->newpkg));
						break;
					case ALPM_PACKAGE_DOWNGRADE:
						printf(_("downgrading %s...\n"), alpm_pkg_get_name(e->newpkg));
						break;
					case ALPM_PACKAGE_REMOVE:
						printf(_("removing %s...\n"), alpm_pkg_get_name(e->oldpkg));
						break;
				}
			}
			break;
		case ALPM_EVENT_PACKAGE_OPERATION_DONE:
			{
				alpm_event_package_operation_t *e = &event->package_operation;
				switch(e->operation) {
					case ALPM_PACKAGE_INSTALL:
						display_optdepends(e->newpkg);
						break;
					case ALPM_PACKAGE_UPGRADE:
					case ALPM_PACKAGE_DOWNGRADE:
						display_new_optdepends(e->oldpkg, e->newpkg);
						break;
					case ALPM_PACKAGE_REINSTALL:
					case ALPM_PACKAGE_REMOVE:
						break;
				}
			}
			break;
		case ALPM_EVENT_INTEGRITY_START:
			if(config->noprogressbar) {
				printf(_("checking package integrity...\n"));
			}
			break;
		case ALPM_EVENT_KEYRING_START:
			if(config->noprogressbar) {
				printf(_("checking keyring...\n"));
			}
			break;
		case ALPM_EVENT_KEY_DOWNLOAD_START:
			printf(_("downloading required keys...\n"));
			break;
		case ALPM_EVENT_LOAD_START:
			if(config->noprogressbar) {
				printf(_("loading package files...\n"));
			}
			break;
		case ALPM_EVENT_SCRIPTLET_INFO:
			fputs(event->scriptlet_info.line, stdout);
			break;
		case ALPM_EVENT_DB_RETRIEVE_START:
			on_progress = 1;
			break;
		case ALPM_EVENT_PKG_RETRIEVE_START:
			colon_printf(_("Retrieving packages...\n"));
			on_progress = 1;
			list_total_pkgs = event->pkg_retrieve.num;
			list_total = event->pkg_retrieve.total_size;
			total_enabled = list_total && list_total_pkgs > 1 && dload_progressbar_enabled();

			if(total_enabled) {
				init_total_progressbar();
			}
			break;
		case ALPM_EVENT_DISKSPACE_START:
			if(config->noprogressbar) {
				printf(_("checking available disk space...\n"));
			}
			break;
		case ALPM_EVENT_OPTDEP_REMOVAL:
			{
				alpm_event_optdep_removal_t *e = &event->optdep_removal;
				char *dep_string = alpm_dep_compute_string(e->optdep);
				colon_printf(_("%s optionally requires %s\n"),
						alpm_pkg_get_name(e->pkg),
						dep_string);
				free(dep_string);
			}
			break;
		case ALPM_EVENT_DATABASE_MISSING:
			if(!config->op_s_sync) {
				pm_printf(ALPM_LOG_WARNING,
						"database file for '%s' does not exist (use '%s' to download)\n",
						event->database_missing.dbname,
						config->op == PM_OP_FILES ? "-Fy": "-Sy");
			}
			break;
		case ALPM_EVENT_PACNEW_CREATED:
			{
				alpm_event_pacnew_created_t *e = &event->pacnew_created;
				if(on_progress) {
					char *string = NULL;
					pm_sprintf(&string, ALPM_LOG_WARNING, _("%s installed as %s.pacnew\n"),
							e->file, e->file);
					if(string != NULL) {
						output = alpm_list_add(output, string);
					}
				} else {
					pm_printf(ALPM_LOG_WARNING, _("%s installed as %s.pacnew\n"),
							e->file, e->file);
				}
			}
			break;
		case ALPM_EVENT_PACSAVE_CREATED:
			{
				alpm_event_pacsave_created_t *e = &event->pacsave_created;
				if(on_progress) {
					char *string = NULL;
					pm_sprintf(&string, ALPM_LOG_WARNING, _("%s saved as %s.pacsave\n"),
							e->file, e->file);
					if(string != NULL) {
						output = alpm_list_add(output, string);
					}
				} else {
					pm_printf(ALPM_LOG_WARNING, _("%s saved as %s.pacsave\n"),
							e->file, e->file);
				}
			}
			break;
		case ALPM_EVENT_DB_RETRIEVE_DONE:
		case ALPM_EVENT_DB_RETRIEVE_FAILED:
		case ALPM_EVENT_PKG_RETRIEVE_DONE:
		case ALPM_EVENT_PKG_RETRIEVE_FAILED:
			console_cursor_move_end();
			if(total_enabled) {
				update_bar_finalstats(totalbar);
				draw_pacman_progress_bar(totalbar);
				free(totalbar);
				printf("\n");
			}
			total_enabled = 0;
			flush_output_list();
			on_progress = 0;
			break;
		/* all the simple done events, with fallthrough for each */
		case ALPM_EVENT_FILECONFLICTS_DONE:
		case ALPM_EVENT_CHECKDEPS_DONE:
		case ALPM_EVENT_RESOLVEDEPS_DONE:
		case ALPM_EVENT_INTERCONFLICTS_DONE:
		case ALPM_EVENT_TRANSACTION_DONE:
		case ALPM_EVENT_INTEGRITY_DONE:
		case ALPM_EVENT_KEYRING_DONE:
		case ALPM_EVENT_KEY_DOWNLOAD_DONE:
		case ALPM_EVENT_LOAD_DONE:
		case ALPM_EVENT_DISKSPACE_DONE:
		case ALPM_EVENT_HOOK_DONE:
		case ALPM_EVENT_HOOK_RUN_DONE:
			/* nothing */
			break;
	}
	fflush(stdout);
}

/* callback to handle questions from libalpm transactions (yes/no) */
void cb_question(void *ctx, alpm_question_t *question)
{
	(void)ctx;
	if(config->print) {
		switch(question->type) {
			case ALPM_QUESTION_INSTALL_IGNOREPKG:
			case ALPM_QUESTION_REPLACE_PKG:
				question->any.answer = 1;
				break;
			default:
				question->any.answer = 0;
				break;
		}
		return;
	}
	switch(question->type) {
		case ALPM_QUESTION_INSTALL_IGNOREPKG:
			{
				alpm_question_install_ignorepkg_t *q = &question->install_ignorepkg;
				if(!config->op_s_downloadonly) {
					q->install = yesno(_("%s is in IgnorePkg/IgnoreGroup. Install anyway?"),
							alpm_pkg_get_name(q->pkg));
				} else {
					q->install = 1;
				}
			}
			break;
		case ALPM_QUESTION_REPLACE_PKG:
			{
				alpm_question_replace_t *q = &question->replace;
				q->replace = yesno(_("Replace %s with %s/%s?"),
						alpm_pkg_get_name(q->oldpkg),
						alpm_db_get_name(q->newdb),
						alpm_pkg_get_name(q->newpkg));
			}
			break;
		case ALPM_QUESTION_CONFLICT_PKG:
			{
				alpm_question_conflict_t *q = &question->conflict;
				/* print conflict only if it contains new information */
				if(strcmp(q->conflict->package1, q->conflict->reason->name) == 0
						|| strcmp(q->conflict->package2, q->conflict->reason->name) == 0) {
					q->remove = noyes(_("%s and %s are in conflict. Remove %s?"),
							q->conflict->package1,
							q->conflict->package2,
							q->conflict->package2);
				} else {
					q->remove = noyes(_("%s and %s are in conflict (%s). Remove %s?"),
							q->conflict->package1,
							q->conflict->package2,
							q->conflict->reason->name,
							q->conflict->package2);
				}
			}
			break;
		case ALPM_QUESTION_REMOVE_PKGS:
			{
				alpm_question_remove_pkgs_t *q = &question->remove_pkgs;
				alpm_list_t *namelist = NULL, *i;
				size_t count = 0;
				for(i = q->packages; i; i = i->next) {
					namelist = alpm_list_add(namelist,
							(char *)alpm_pkg_get_name(i->data));
					count++;
				}
				colon_printf(_n(
							"The following package cannot be upgraded due to unresolvable dependencies:\n",
							"The following packages cannot be upgraded due to unresolvable dependencies:\n",
							count));
				list_display("     ", namelist, getcols());
				printf("\n");
				q->skip = noyes(_n(
							"Do you want to skip the above package for this upgrade?",
							"Do you want to skip the above packages for this upgrade?",
							count));
				alpm_list_free(namelist);
			}
			break;
		case ALPM_QUESTION_SELECT_PROVIDER:
			{
				alpm_question_select_provider_t *q = &question->select_provider;
				size_t count = alpm_list_count(q->providers);
				char *depstring = alpm_dep_compute_string(q->depend);
				colon_printf(_n("There is %zu provider available for %s\n",
						"There are %zu providers available for %s:\n", count),
						count, depstring);
				free(depstring);
				select_display(q->providers);
				q->use_index = select_question(count);
			}
			break;
		case ALPM_QUESTION_CORRUPTED_PKG:
			{
				alpm_question_corrupted_t *q = &question->corrupted;
				q->remove = yesno(_("File %s is corrupted (%s).\n"
							"Do you want to delete it?"),
						q->filepath,
						alpm_strerror(q->reason));
			}
			break;
		case ALPM_QUESTION_IMPORT_KEY:
			{
				alpm_question_import_key_t *q = &question->import_key;
				/* the uid is unknown with db signatures */
				if (q->key->uid == NULL) {
					q->import = yesno(_("Import PGP key %s?"),
							q->key->fingerprint);
				} else {
					q->import = yesno(_("Import PGP key %s, \"%s\"?"),
							q->key->fingerprint, q->key->uid);
				}
			}
			break;
	}
	if(config->noask) {
		if(config->ask & question->type) {
			/* inverse the default answer */
			question->any.answer = !question->any.answer;
		}
	}
}

/* callback to handle display of transaction progress */
void cb_progress(void *ctx, alpm_progress_t event, const char *pkgname,
		int percent, size_t howmany, size_t current)
{
	static int prevpercent;
	static size_t prevcurrent;
	/* size of line to allocate for text printing (e.g. not progressbar) */
	int infolen;
	int digits, textlen;
	char *opr = NULL;
	/* used for wide character width determination and printing */
	int len, wclen, wcwid, padwid;
	wchar_t *wcstr;

	const unsigned short cols = getcols();

	(void)ctx;

	if(config->noprogressbar || cols == 0) {
		return;
	}

	if(percent == 0) {
		get_update_timediff(1);
	} else if(percent == 100) {
		/* no need for timediff update, but unconditionally continue unless we
		 * already completed on a previous call */
		if(prevpercent == 100) {
			return;
		}
	} else {
		if(current != prevcurrent) {
			/* update always */
		} else if(!pkgname || percent == prevpercent ||
				get_update_timediff(0) < UPDATE_SPEED_MS) {
			/* only update the progress bar when we have a package name, the
			 * percentage has changed, and it has been long enough. */
			return;
		}
	}

	prevpercent = percent;
	prevcurrent = current;

	/* set text of message to display */
	switch(event) {
		case ALPM_PROGRESS_ADD_START:
			opr = _("installing");
			break;
		case ALPM_PROGRESS_UPGRADE_START:
			opr = _("upgrading");
			break;
		case ALPM_PROGRESS_DOWNGRADE_START:
			opr = _("downgrading");
			break;
		case ALPM_PROGRESS_REINSTALL_START:
			opr = _("reinstalling");
			break;
		case ALPM_PROGRESS_REMOVE_START:
			opr = _("removing");
			break;
		case ALPM_PROGRESS_CONFLICTS_START:
			opr = _("checking for file conflicts");
			break;
		case ALPM_PROGRESS_DISKSPACE_START:
			opr = _("checking available disk space");
			break;
		case ALPM_PROGRESS_INTEGRITY_START:
			opr = _("checking package integrity");
			break;
		case ALPM_PROGRESS_KEYRING_START:
			opr = _("checking keys in keyring");
			break;
		case ALPM_PROGRESS_LOAD_START:
			opr = _("loading package files");
			break;
		default:
			return;
	}

	infolen = cols * 6 / 10;
	if(infolen < 50) {
		infolen = 50;
	}

	/* find # of digits in package counts to scale output */
	digits = number_length(howmany);

	/* determine room left for non-digits text [not ( 1/12) part] */
	textlen = infolen - 3 /* (/) */ - (2 * digits) - 1 /* space */;

	/* In order to deal with characters from all locales, we have to worry
	 * about wide characters and their column widths. A lot of stuff is
	 * done here to figure out the actual number of screen columns used
	 * by the output, and then pad it accordingly so we fill the terminal.
	 */
	/* len = opr len + pkgname len (if available) + space + null */
	len = strlen(opr) + ((pkgname) ? strlen(pkgname) : 0) + 2;
	wcstr = calloc(len, sizeof(wchar_t));
	/* print our strings to the alloc'ed memory */
#if defined(HAVE_SWPRINTF)
	wclen = swprintf(wcstr, len, L"%s %s", opr, pkgname);
#else
	/* because the format string was simple, we can easily do this without
	 * using swprintf, although it is probably not as safe/fast. The max
	 * chars we can copy is decremented each time by subtracting the length
	 * of the already printed/copied wide char string. */
	wclen = mbstowcs(wcstr, opr, len);
	wclen += mbstowcs(wcstr + wclen, " ", len - wclen);
	wclen += mbstowcs(wcstr + wclen, pkgname, len - wclen);
#endif
	wcwid = wcswidth(wcstr, wclen);
	padwid = textlen - wcwid;
	/* if padwid is < 0, we need to trim the string so padwid = 0 */
	if(padwid < 0) {
		int i = textlen - 3;
		wchar_t *p = wcstr;
		/* grab the max number of char columns we can fill */
		while(i > wcwidth(*p)) {
			i -= wcwidth(*p);
			p++;
		}
		/* then add the ellipsis and fill out any extra padding */
		wcscpy(p, L"...");
		padwid = i;

	}

	printf("(%*zu/%*zu) %ls%-*s", digits, current,
			digits, howmany, wcstr, padwid, "");

	free(wcstr);

	/* call refactored fill progress function */
	fill_progress(percent, percent, cols - infolen);

	if(percent == 100) {
		putchar('\n');
		flush_output_list();
		on_progress = 0;
	} else {
		on_progress = 1;
	}
}

static int dload_progressbar_enabled(void)
{
	return !config->noprogressbar && (getcols() != 0);
}

/* Goto the line that corresponds to num-th active download */
static void console_cursor_goto_bar(int num)
{
	if(num > multibar_ui.cursor_lineno) {
		console_cursor_move_down(num - multibar_ui.cursor_lineno);
	} else if(num < multibar_ui.cursor_lineno) {
		console_cursor_move_up(multibar_ui.cursor_lineno - num);
	}
	multibar_ui.cursor_lineno = num;
}

/* Goto the line *after* the last active progress bar */
void console_cursor_move_end(void)
{
	console_cursor_goto_bar(multibar_ui.active_downloads_num);
}

/* Returns true if element with the specified name is found, false otherwise */
static bool find_bar_for_filename(const char *filename, int *index, struct pacman_progress_bar **bar)
{
	int i = 0;
	alpm_list_t *listitem = multibar_ui.active_downloads;
	for(; listitem; listitem = listitem->next, i++) {
		struct pacman_progress_bar *b = listitem->data;
		if (strcmp(b->filename, filename) == 0) {
			/* we found a progress bar with the given name */
			*index = i;
			*bar = b;
			return true;
		}
	}

	return false;
}

static void init_total_progressbar(void)
{
	totalbar = calloc(1, sizeof(struct pacman_progress_bar));
	assert(totalbar);
	totalbar->filename = _("Total");
	totalbar->init_time = get_time_ms();
	totalbar->total_size = list_total;
	totalbar->howmany = list_total_pkgs;
	totalbar->rate = 0.0;
}

static char *clean_filename(const char *filename)
{
	int len = strlen(filename);
	char *p;
	char *fname = malloc(len + 1);
	memcpy(fname, filename, len + 1);
	/* strip package or DB extension for cleaner look */
	if((p = strstr(fname, ".pkg")) || (p = strstr(fname, ".db")) || (p = strstr(fname, ".files"))) {
		len = p - fname;
		fname[len] = '\0';
	}

	return fname;
}

static void draw_pacman_progress_bar(struct pacman_progress_bar *bar)
{
	int infolen, len;
	int filenamelen;
	char *fname;
	/* used for wide character width determination and printing */
	int wclen, wcwid, padwid;
	wchar_t *wcfname;
	unsigned int eta_h = 0, eta_m = 0, eta_s = bar->eta;
	double rate_human, xfered_human;
	const char *rate_label, *xfered_label;
	int file_percent = 0;

	const unsigned short cols = getcols();

	if(bar->total_size) {
		file_percent = (bar->sync_xfered * 100) / bar->total_size;
	} else {
		file_percent = 100;
	}

	/* fix up time for display */
	eta_h = eta_s / 3600;
	eta_s -= eta_h * 3600;
	eta_m = eta_s / 60;
	eta_s -= eta_m * 60;

	fname = clean_filename(bar->filename);

	if(bar->howmany > 0) {
		short digits = number_length(bar->howmany);
		// fname + digits +  ( /) + \0
		size_t needed = strlen(fname) + (digits * 2) + 4 + 1;
		char *name = malloc(needed);
		sprintf(name, "%s (%*zu/%*zu)", fname, digits, bar->downloaded, digits, bar->howmany);
		free(fname);
		fname = name;
	}

	len = strlen(fname);
	infolen = cols * 6 / 10;
	if(infolen < 50) {
		infolen = 50;
	}

	/* 1 space + filenamelen + 1 space + 6 for size + 1 space + 3 for label +
	 * + 2 spaces + 4 for rate + 1 space + 3 for label + 2 for /s + 1 space +
	 * 5 for eta, gives us the magic 30 */
	filenamelen = infolen - 30;

	/* In order to deal with characters from all locales, we have to worry
	 * about wide characters and their column widths. A lot of stuff is
	 * done here to figure out the actual number of screen columns used
	 * by the output, and then pad it accordingly so we fill the terminal.
	 */
	/* len = filename len + null */
	wcfname = calloc(len + 1, sizeof(wchar_t));
	wclen = mbstowcs(wcfname, fname, len);
	wcwid = wcswidth(wcfname, wclen);
	padwid = filenamelen - wcwid;
	/* if padwid is < 0, we need to trim the string so padwid = 0 */
	if(padwid < 0) {
		int i = filenamelen - 3;
		wchar_t *wcp = wcfname;
		/* grab the max number of char columns we can fill */
		while(wcwidth(*wcp) < i) {
			i -= wcwidth(*wcp);
			wcp++;
		}
		/* then add the ellipsis and fill out any extra padding */
		wcscpy(wcp, L"...");
		padwid = i;

	}

	rate_human = humanize_size((off_t)bar->rate, '\0', -1, &rate_label);
	xfered_human = humanize_size(bar->sync_xfered, '\0', -1, &xfered_label);

	printf(" %ls%-*s ", wcfname, padwid, "");
	/* We will show 1.62 MiB/s, 11.6 MiB/s, but 116 KiB/s and 1116 KiB/s */
	if(rate_human < 9.995) {
		printf("%6.1f %3s  %4.2f %3s/s ",
				xfered_human, xfered_label, rate_human, rate_label);
	} else if(rate_human < 99.95) {
		printf("%6.1f %3s  %4.1f %3s/s ",
				xfered_human, xfered_label, rate_human, rate_label);
	} else {
		printf("%6.1f %3s  %4.f %3s/s ",
				xfered_human, xfered_label, rate_human, rate_label);
	}
	if(eta_h == 0) {
		printf("%02u:%02u", eta_m, eta_s);
	} else if(eta_h == 1 && eta_m < 40) {
		printf("%02u:%02u", eta_m + 60, eta_s);
	} else {
		fputs("--:--", stdout);
	}

	free(fname);
	free(wcfname);

	fill_progress(file_percent, file_percent, cols - infolen);
	return;
}

static void dload_init_event(const char *filename, alpm_download_event_init_t *data)
{
	(void)data;
	char *cleaned_filename = clean_filename(filename);

	if(!dload_progressbar_enabled()) {
		printf(_(" %s downloading...\n"), cleaned_filename);
		free(cleaned_filename);
		return;
	}

	struct pacman_progress_bar *bar = calloc(1, sizeof(struct pacman_progress_bar));
	assert(bar);
	bar->filename = filename;
	bar->init_time = get_time_ms();
	bar->rate = 0.0;
	multibar_ui.active_downloads = alpm_list_add(multibar_ui.active_downloads, bar);

	console_cursor_move_end();
	printf(" %s\n", cleaned_filename);
	multibar_ui.cursor_lineno++;
	multibar_ui.active_downloads_num++;

	if(total_enabled) {
		/* redraw the total download progress bar */
		draw_pacman_progress_bar(totalbar);
		printf("\n");
		multibar_ui.cursor_lineno++;
	}
}

/* Update progress bar rate/eta stats.
 * Returns true if the bar redraw is required, false otherwise
 */
static bool update_bar_stats(struct pacman_progress_bar *bar)
{
	int64_t timediff;
	off_t last_chunk_amount;
	double last_chunk_rate;
	int64_t curr_time = get_time_ms();

	/* compute current average values */
	timediff = curr_time - bar->sync_time;

	if(timediff < UPDATE_SPEED_MS) {
		/* return if the calling interval was too short */
		return false;
	}
	last_chunk_amount = bar->xfered - bar->sync_xfered;
	bar->sync_xfered = bar->xfered;
	bar->sync_time = curr_time;

	last_chunk_rate = (double)last_chunk_amount * 1000 / timediff;
	/* average rate to reduce jumpiness */
	bar->rate = (last_chunk_rate + 2 * bar->rate) / 3;
	if(bar->rate > 0.0) {
		bar->eta = (bar->total_size - bar->sync_xfered) / bar->rate;
	} else {
		bar->eta = UINT_MAX;
	}

	return true;
}

static void update_bar_finalstats(struct pacman_progress_bar *bar)
{
	int64_t timediff;

	/* compute final values */
	bar->xfered = bar->total_size;
	bar->sync_xfered = bar->total_size;
	timediff = get_time_ms() - bar->init_time;

	/* if transfer was too fast, treat it as a 1ms transfer, for the sake
	* of the rate calculation */
	if(timediff < 1)
		timediff = 1;

	bar->rate = (double)bar->total_size * 1000 / timediff;
	/* round elapsed time (in ms) to the nearest second */
	bar->eta = (unsigned int)(timediff + 500) / 1000;
}

/* Handles download progress event */
static void dload_progress_event(const char *filename, alpm_download_event_progress_t *data)
{
	int index;
	struct pacman_progress_bar *bar;
	bool ok;
	off_t last_chunk_amount;

	if(!dload_progressbar_enabled()) {
		return;
	}

	ok = find_bar_for_filename(filename, &index, &bar);
	assert(ok);

	/* Total size is received after the download starts. */
	last_chunk_amount = data->downloaded - bar->xfered;
	bar->xfered = data->downloaded;
	bar->total_size = data->total;

	if(update_bar_stats(bar)) {
		console_cursor_goto_bar(index);
		draw_pacman_progress_bar(bar);
	}

	if(total_enabled) {
		totalbar->xfered += last_chunk_amount;
		if(update_bar_stats(totalbar)) {
			console_cursor_move_end();
			draw_pacman_progress_bar(totalbar);
		}
	}

	fflush(stdout);
}

/* download retried */
static void dload_retry_event(const char *filename, alpm_download_event_retry_t *data) {
	if(!dload_progressbar_enabled()) {
		return;
	}

	int index;
	struct pacman_progress_bar *bar;
	bool ok = find_bar_for_filename(filename, &index, &bar);
	assert(ok);

	if(!data->resume) {
		if(total_enabled) {
			/* note total download does not reflect partial downloads that are restarted */
			totalbar->xfered -= bar->xfered;
		}
	}

	bar->xfered = 0;
	bar->total_size = 0;
	bar->init_time = get_time_ms();
	bar->sync_time = 0;
	bar->sync_xfered = 0;
	bar->rate = 0.0;
	bar->eta = 0.0;
}


/* download completed */
static void dload_complete_event(const char *filename, alpm_download_event_completed_t *data)
{
	int index;
	struct pacman_progress_bar *bar;
	bool ok;

	if(!dload_progressbar_enabled()) {
		return;
	}

	if(total_enabled) {
		totalbar->downloaded++;
	}

	ok = find_bar_for_filename(filename, &index, &bar);
	assert(ok);
	bar->completed = true;

	/* This may not have been initialized if the download finished before
	 * an alpm_download_event_progress_t event happened */
	bar->total_size = data->total;

	if(data->result == 1) {
		console_cursor_goto_bar(index);
		char *cleaned_filename = clean_filename(filename);
		printf(_(" %s is up to date"), cleaned_filename);
		free(cleaned_filename);
		/* The line contains text from previous status. Erase these leftovers. */
		console_erase_line();
	} else if(data->result == 0) {
		update_bar_finalstats(bar);

		if(multibar_ui.move_completed_up && index != 0) {
			/* If this item completed then move it to the top.
			 * Swap 0-th bar data with `index`-th one
			 */
			struct pacman_progress_bar *former_topbar = multibar_ui.active_downloads->data;
			alpm_list_t *baritem = alpm_list_nth(multibar_ui.active_downloads, index);
			multibar_ui.active_downloads->data = bar;
			baritem->data = former_topbar;

			console_cursor_goto_bar(index);
			draw_pacman_progress_bar(former_topbar);

			index = 0;
		}

		console_cursor_goto_bar(index);
		draw_pacman_progress_bar(bar);
	} else {
		console_cursor_goto_bar(index);
		printf(_(" %s failed to download"), bar->filename);
		console_erase_line();
	}
	fflush(stdout);

	/* If the first bar is completed then there is no reason to keep it
	 * in the list as we are not going to redraw it anymore.
	 */
	while(multibar_ui.active_downloads) {
		alpm_list_t *head = multibar_ui.active_downloads;
		struct pacman_progress_bar *j = head->data;
		if(j->completed) {
			multibar_ui.cursor_lineno--;
			multibar_ui.active_downloads_num--;
			multibar_ui.active_downloads = alpm_list_remove_item(
				multibar_ui.active_downloads, head);
			free(head);
			free(j);
		} else {
			break;
		}
	}
}

static int strendswith(const char *haystack, const char *needle)
{
	size_t hlen = strlen(haystack), nlen = strlen(needle);
	return hlen >= nlen && strcmp(haystack + hlen - nlen, needle) == 0;
}

/* Callback to handle display of download progress */
void cb_download(void *ctx, const char *filename, alpm_download_event_type_t event, void *data)
{
	(void)ctx;

	/* do not print signature files progress bar */
	if(strendswith(filename, ".sig")) {
		return;
	}

	if(event == ALPM_DOWNLOAD_INIT) {
		dload_init_event(filename, data);
	} else if(event == ALPM_DOWNLOAD_PROGRESS) {
		dload_progress_event(filename, data);
	} else if(event == ALPM_DOWNLOAD_RETRY) {
		dload_retry_event(filename, data);
	} else if(event == ALPM_DOWNLOAD_COMPLETED) {
		dload_complete_event(filename, data);
	} else {
		pm_printf(ALPM_LOG_ERROR, _("unknown callback event type %d for %s\n"),
				event, filename);
	}
}

/* Callback to handle notifications from the library */
void cb_log(void *ctx, alpm_loglevel_t level, const char *fmt, va_list args)
{
	(void)ctx;
	if(!fmt || strlen(fmt) == 0) {
		return;
	}

	if(on_progress) {
		char *string = NULL;
		pm_vasprintf(&string, level, fmt, args);
		if(string != NULL) {
			output = alpm_list_add(output, string);
		}
	} else {
		pm_vfprintf(stderr, level, fmt, args);
	}
}
