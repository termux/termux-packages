/*
 *  pacman.c
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

/* special handling of package version for GIT */
#if defined(GIT_VERSION)
#undef PACKAGE_VERSION
#define PACKAGE_VERSION GIT_VERSION
#endif

#include <stdlib.h> /* atoi */
#include <stdio.h>
#include <ctype.h> /* isspace */
#include <limits.h>
#include <getopt.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/utsname.h> /* uname */
#include <locale.h> /* setlocale */
#include <errno.h>

/* alpm */
#include <alpm.h>
#include <alpm_list.h>

/* pacman */
#include "pacman.h"
#include "util.h"
#include "conf.h"
#include "sighandler.h"

/* list of targets specified on command line */
static alpm_list_t *pm_targets;

/* Used to sort the options in --help */
static int options_cmp(const void *p1, const void *p2)
{
	const char *s1 = p1;
	const char *s2 = p2;

	if(s1 == s2) return 0;
	if(!s1) return -1;
	if(!s2) return 1;
	/* First skip all spaces in both strings */
	while(isspace((unsigned char)*s1)) {
		s1++;
	}
	while(isspace((unsigned char)*s2)) {
		s2++;
	}
	/* If we compare a long option (--abcd) and a short one (-a),
	 * the short one always wins */
	if(*s1 == '-' && *s2 == '-') {
		s1++;
		s2++;
		if(*s1 == '-' && *s2 == '-') {
			/* two long -> strcmp */
			s1++;
			s2++;
		} else if(*s2 == '-') {
			/* s1 short, s2 long */
			return -1;
		} else if(*s1 == '-') {
			/* s1 long, s2 short */
			return 1;
		}
		/* two short -> strcmp */
	}

	return strcmp(s1, s2);
}

/** Display usage/syntax for the specified operation.
 * @param op     the operation code requested
 * @param myname basename(argv[0])
 */
static void usage(int op, const char * const myname)
{
#define addlist(s) (list = alpm_list_add(list, s))
	alpm_list_t *list = NULL, *i;
	/* prefetch some strings for usage below, which moves a lot of calls
	 * out of gettext. */
	char const *const str_opt  = _("options");
	char const *const str_file = _("file(s)");
	char const *const str_pkg  = _("package(s)");
	char const *const str_usg  = _("usage");
	char const *const str_opr  = _("operation");

	/* please limit your strings to 80 characters in width */
	if(op == PM_OP_MAIN) {
		printf("%s:  %s <%s> [...]\n", str_usg, myname, str_opr);
		printf(_("operations:\n"));
		printf("    %s {-h --help}\n", myname);
		printf("    %s {-V --version}\n", myname);
		printf("    %s {-D --database} <%s> <%s>\n", myname, str_opt, str_pkg);
		printf("    %s {-F --files}    [%s] [%s]\n", myname, str_opt, str_file);
		printf("    %s {-Q --query}    [%s] [%s]\n", myname, str_opt, str_pkg);
		printf("    %s {-R --remove}   [%s] <%s>\n", myname, str_opt, str_pkg);
		printf("    %s {-S --sync}     [%s] [%s]\n", myname, str_opt, str_pkg);
		printf("    %s {-T --deptest}  [%s] [%s]\n", myname, str_opt, str_pkg);
		printf("    %s {-U --upgrade}  [%s] <%s>\n", myname, str_opt, str_file);
		printf(_("\nuse '%s {-h --help}' with an operation for available options\n"),
				myname);
	} else {
		if(op == PM_OP_REMOVE) {
			printf("%s:  %s {-R --remove} [%s] <%s>\n", str_usg, myname, str_opt, str_pkg);
			printf("%s:\n", str_opt);
			addlist(_("  -c, --cascade        remove packages and all packages that depend on them\n"));
			addlist(_("  -n, --nosave         remove configuration files\n"));
			addlist(_("  -s, --recursive      remove unnecessary dependencies\n"
			          "                       (-ss includes explicitly installed dependencies)\n"));
			addlist(_("  -u, --unneeded       remove unneeded packages\n"));
		} else if(op == PM_OP_UPGRADE) {
			printf("%s:  %s {-U --upgrade} [%s] <%s>\n", str_usg, myname, str_opt, str_file);
			addlist(_("      --needed         do not reinstall up to date packages\n"));
			printf("%s:\n", str_opt);
		} else if(op == PM_OP_QUERY) {
			printf("%s:  %s {-Q --query} [%s] [%s]\n", str_usg, myname, str_opt, str_pkg);
			printf("%s:\n", str_opt);
			addlist(_("  -c, --changelog      view the changelog of a package\n"));
			addlist(_("  -d, --deps           list packages installed as dependencies [filter]\n"));
			addlist(_("  -e, --explicit       list packages explicitly installed [filter]\n"));
			addlist(_("  -g, --groups         view all members of a package group\n"));
			addlist(_("  -i, --info           view package information (-ii for backup files)\n"));
			addlist(_("  -k, --check          check that package files exist (-kk for file properties)\n"));
			addlist(_("  -l, --list           list the files owned by the queried package\n"));
			addlist(_("  -m, --foreign        list installed packages not found in sync db(s) [filter]\n"));
			addlist(_("  -n, --native         list installed packages only found in sync db(s) [filter]\n"));
			addlist(_("  -o, --owns <file>    query the package that owns <file>\n"));
			addlist(_("  -p, --file <package> query a package file instead of the database\n"));
			addlist(_("  -q, --quiet          show less information for query and search\n"));
			addlist(_("  -s, --search <regex> search locally-installed packages for matching strings\n"));
			addlist(_("  -t, --unrequired     list packages not (optionally) required by any\n"
			          "                       package (-tt to ignore optdepends) [filter]\n"));
			addlist(_("  -u, --upgrades       list outdated packages [filter]\n"));
		} else if(op == PM_OP_SYNC) {
			printf("%s:  %s {-S --sync} [%s] [%s]\n", str_usg, myname, str_opt, str_pkg);
			printf("%s:\n", str_opt);
			addlist(_("  -c, --clean          remove old packages from cache directory (-cc for all)\n"));
			addlist(_("  -g, --groups         view all members of a package group\n"
			          "                       (-gg to view all groups and members)\n"));
			addlist(_("  -i, --info           view package information (-ii for extended information)\n"));
			addlist(_("  -l, --list <repo>    view a list of packages in a repo\n"));
			addlist(_("  -q, --quiet          show less information for query and search\n"));
			addlist(_("  -s, --search <regex> search remote repositories for matching strings\n"));
			addlist(_("  -u, --sysupgrade     upgrade installed packages (-uu enables downgrades)\n"));
			addlist(_("  -y, --refresh        download fresh package databases from the server\n"
			          "                       (-yy to force a refresh even if up to date)\n"));
			addlist(_("      --needed         do not reinstall up to date packages\n"));
		} else if(op == PM_OP_DATABASE) {
			printf("%s:  %s {-D --database} <%s> <%s>\n", str_usg, myname, str_opt, str_pkg);
			printf("%s:\n", str_opt);
			addlist(_("      --asdeps         mark packages as non-explicitly installed\n"));
			addlist(_("      --asexplicit     mark packages as explicitly installed\n"));
			addlist(_("  -k, --check          test local database for validity (-kk for sync databases)\n"));
			addlist(_("  -q, --quiet          suppress output of success messages\n"));
		} else if(op == PM_OP_DEPTEST) {
			printf("%s:  %s {-T --deptest} [%s] [%s]\n", str_usg, myname, str_opt, str_pkg);
			printf("%s:\n", str_opt);
		} else if(op == PM_OP_FILES) {
			printf("%s:  %s {-F --files} [%s] [%s]\n", str_usg, myname, str_opt, str_file);
			printf("%s:\n", str_opt);
			addlist(_("  -l, --list           list the files owned by the queried package\n"));
			addlist(_("  -q, --quiet          show less information for query and search\n"));
			addlist(_("  -x, --regex          enable searching using regular expressions\n"));
			addlist(_("  -y, --refresh        download fresh package databases from the server\n"
			          "                       (-yy to force a refresh even if up to date)\n"));
			addlist(_("      --machinereadable\n"
			          "                       produce machine-readable output\n"));
		}
		switch(op) {
			case PM_OP_SYNC:
			case PM_OP_UPGRADE:
				addlist(_("  -w, --downloadonly   download packages but do not install/upgrade anything\n"));
				addlist(_("      --overwrite <glob>\n"
				          "                       overwrite conflicting files (can be used more than once)\n"));
				addlist(_("      --asdeps         install packages as non-explicitly installed\n"));
				addlist(_("      --asexplicit     install packages as explicitly installed\n"));
				addlist(_("      --ignore <pkg>   ignore a package upgrade (can be used more than once)\n"));
				addlist(_("      --ignoregroup <grp>\n"
				          "                       ignore a group upgrade (can be used more than once)\n"));
				__attribute__((fallthrough));
			case PM_OP_REMOVE:
				addlist(_("  -d, --nodeps         skip dependency version checks (-dd to skip all checks)\n"));
				addlist(_("      --assume-installed <package=version>\n"
				          "                       add a virtual package to satisfy dependencies\n"));
				addlist(_("      --dbonly         only modify database entries, not package files\n"));
				addlist(_("      --noprogressbar  do not show a progress bar when downloading files\n"));
				addlist(_("      --noscriptlet    do not execute the install scriptlet if one exists\n"));
				addlist(_("  -p, --print          print the targets instead of performing the operation\n"));
				addlist(_("      --print-format <string>\n"
				          "                       specify how the targets should be printed\n"));
				break;
		}

		addlist(_("  -b, --dbpath <path>  set an alternate database location\n"));
		addlist(_("  -r, --root <path>    set an alternate installation root\n"));
		addlist(_("  -v, --verbose        be verbose\n"));
		addlist(_("      --arch <arch>    set an alternate architecture\n"));
		addlist(_("      --sysroot        operate on a mounted guest system (root-only)\n"));
		addlist(_("      --cachedir <dir> set an alternate package cache location\n"));
		addlist(_("      --hookdir <dir>  set an alternate hook location\n"));
		addlist(_("      --color <when>   colorize the output\n"));
		addlist(_("      --config <path>  set an alternate configuration file\n"));
		addlist(_("      --debug          display debug messages\n"));
		addlist(_("      --gpgdir <path>  set an alternate home directory for GnuPG\n"));
		addlist(_("      --logfile <path> set an alternate log file\n"));
		addlist(_("      --noconfirm      do not ask for any confirmation\n"));
		addlist(_("      --confirm        always ask for confirmation\n"));
		addlist(_("      --disable-download-timeout\n"
		          "                       use relaxed timeouts for download\n"));
	}
	list = alpm_list_msort(list, alpm_list_count(list), options_cmp);
	for(i = list; i; i = alpm_list_next(i)) {
		fputs((const char *)i->data, stdout);
	}
	alpm_list_free(list);
#undef addlist
}

/** Output pacman version and copyright.
 */
static void version(void)
{
	printf("\n");
	printf(" .--.                  Pacman v%s - libalpm v%s\n", PACKAGE_VERSION, alpm_version());
	printf("/ _.-' .-.  .-.  .-.   Copyright (C) 2006-2021 Pacman Development Team\n");
	printf("\\  '-. '-'  '-'  '-'   Copyright (C) 2002-2006 Judd Vinet\n");
	printf(" '--'\n");
	printf(_("                       This program may be freely redistributed under\n"
	         "                       the terms of the GNU General Public License.\n"));
	printf("\n");
}

/** Sets up gettext localization. Safe to call multiple times.
 */
/* Inspired by the monotone function localize_monotone. */
#if defined(ENABLE_NLS)
static void localize(void)
{
	static int init = 0;
	if(!init) {
		setlocale(LC_ALL, "");
		bindtextdomain(PACKAGE, LOCALEDIR);
		textdomain(PACKAGE);
		init = 1;
	}
}
#endif

/** Set user agent environment variable.
 */
static void setuseragent(void)
{
	char agent[100];
	struct utsname un;
	int len;

	uname(&un);
	len = snprintf(agent, 100, "pacman/%s (%s %s) libalpm/%s",
			PACKAGE_VERSION, un.sysname, un.machine, alpm_version());
	if(len >= 100) {
		pm_printf(ALPM_LOG_WARNING, _("HTTP_USER_AGENT truncated\n"));
	}

	setenv("HTTP_USER_AGENT", agent, 0);
}

/** Free the resources.
 *
 * @param ret the return value
 */
static void cleanup(int ret)
{
	remove_soft_interrupt_handler();
	if(config) {
		/* free alpm library resources */
		if(config->handle && alpm_release(config->handle) == -1) {
			pm_printf(ALPM_LOG_ERROR, "error releasing alpm library\n");
		}

		config_free(config);
		config = NULL;
	}

	/* free memory */
	FREELIST(pm_targets);
	console_cursor_show();
	exit(ret);
}

static void invalid_opt(int used, const char *opt1, const char *opt2)
{
	if(used) {
		pm_printf(ALPM_LOG_ERROR,
				_("invalid option: '%s' and '%s' may not be used together\n"),
				opt1, opt2);
		cleanup(1);
	}
}

static int parsearg_util_addlist(alpm_list_t **list)
{
	char *i, *save = NULL;

	for(i = strtok_r(optarg, ",", &save); i; i = strtok_r(NULL, ",", &save)) {
		*list = alpm_list_add(*list, strdup(i));
	}

	return 0;
}

/** Helper function for parsing operation from command-line arguments.
 * @param opt Keycode returned by getopt_long
 * @param dryrun If nonzero, application state is NOT changed
 * @return 0 if opt was handled, 1 if it was not handled
 */
static int parsearg_op(int opt, int dryrun)
{
	switch(opt) {
		/* operations */
		case 'D':
			if(dryrun) break;
			config->op = (config->op != PM_OP_MAIN ? 0 : PM_OP_DATABASE); break;
		case 'F':
			if(dryrun) break;
			config->op = (config->op != PM_OP_MAIN ? 0 : PM_OP_FILES); break;
		case 'Q':
			if(dryrun) break;
			config->op = (config->op != PM_OP_MAIN ? 0 : PM_OP_QUERY); break;
		case 'R':
			if(dryrun) break;
			config->op = (config->op != PM_OP_MAIN ? 0 : PM_OP_REMOVE); break;
		case 'S':
			if(dryrun) break;
			config->op = (config->op != PM_OP_MAIN ? 0 : PM_OP_SYNC); break;
		case 'T':
			if(dryrun) break;
			config->op = (config->op != PM_OP_MAIN ? 0 : PM_OP_DEPTEST); break;
		case 'U':
			if(dryrun) break;
			config->op = (config->op != PM_OP_MAIN ? 0 : PM_OP_UPGRADE); break;
		case 'V':
			if(dryrun) break;
			config->version = 1; break;
		case 'h':
			if(dryrun) break;
			config->help = 1; break;
		default:
			return 1;
	}
	return 0;
}

/** Helper functions for parsing command-line arguments.
 * @param opt Keycode returned by getopt_long
 * @return 0 on success, 1 on failure
 */
static int parsearg_global(int opt)
{
	switch(opt) {
		case OP_ARCH:
			config_add_architecture(strdup(optarg));
			break;
		case OP_ASK:
			config->noask = 1;
			config->ask = (unsigned int)atoi(optarg);
			break;
		case OP_CACHEDIR:
			config->cachedirs = alpm_list_add(config->cachedirs, strdup(optarg));
			break;
		case OP_COLOR:
			if(strcmp("never", optarg) == 0) {
				config->color = PM_COLOR_OFF;
			} else if(strcmp("auto", optarg) == 0) {
				config->color = isatty(fileno(stdout)) ? PM_COLOR_ON : PM_COLOR_OFF;
			} else if(strcmp("always", optarg) == 0) {
				config->color = PM_COLOR_ON;
			} else {
				pm_printf(ALPM_LOG_ERROR, _("invalid argument '%s' for %s\n"),
						optarg, "--color");
				return 1;
			}
			enable_colors(config->color);
			break;
		case OP_CONFIG:
			free(config->configfile);
			config->configfile = strndup(optarg, PATH_MAX);
			break;
		case OP_DEBUG:
			/* debug levels are made more 'human readable' than using a raw logmask
			 * here, error and warning are set in config_new, though perhaps a
			 * --quiet option will remove these later */
			if(optarg) {
				unsigned short debug = (unsigned short)atoi(optarg);
				switch(debug) {
					case 2:
						config->logmask |= ALPM_LOG_FUNCTION;
						__attribute__((fallthrough));
					case 1:
						config->logmask |= ALPM_LOG_DEBUG;
						break;
					default:
						pm_printf(ALPM_LOG_ERROR, _("'%s' is not a valid debug level\n"),
								optarg);
						return 1;
				}
			} else {
				config->logmask |= ALPM_LOG_DEBUG;
			}
			/* progress bars get wonky with debug on, shut them off */
			config->noprogressbar = 1;
			break;
		case OP_GPGDIR:
			free(config->gpgdir);
			config->gpgdir = strdup(optarg);
			break;
		case OP_HOOKDIR:
			config->hookdirs = alpm_list_add(config->hookdirs, strdup(optarg));
			break;
		case OP_LOGFILE:
			free(config->logfile);
			config->logfile = strndup(optarg, PATH_MAX);
			break;
		case OP_NOCONFIRM:
			config->noconfirm = 1;
			break;
		case OP_CONFIRM:
			config->noconfirm = 0;
			break;
		case OP_DBPATH:
		case 'b':
			free(config->dbpath);
			config->dbpath = strdup(optarg);
			break;
		case OP_ROOT:
		case 'r':
			free(config->rootdir);
			config->rootdir = strdup(optarg);
			break;
		case OP_SYSROOT:
			free(config->sysroot);
			config->sysroot = strdup(optarg);
			break;
		case OP_DISABLEDLTIMEOUT:
			config->disable_dl_timeout = 1;
			break;
		case OP_VERBOSE:
		case 'v':
			(config->verbose)++;
			break;
		default:
			return 1;
	}
	return 0;
}

static int parsearg_database(int opt)
{
	switch(opt) {
		case OP_ASDEPS:
			config->flags |= ALPM_TRANS_FLAG_ALLDEPS;
			break;
		case OP_ASEXPLICIT:
			config->flags |= ALPM_TRANS_FLAG_ALLEXPLICIT;
			break;
		case OP_CHECK:
		case 'k':
			(config->op_q_check)++;
			break;
		case OP_QUIET:
		case 'q':
			config->quiet = 1;
		break;
		default:
			return 1;
	}
	return 0;
}

static void checkargs_database(void)
{
	invalid_opt(config->flags & ALPM_TRANS_FLAG_ALLDEPS
			&& config->flags & ALPM_TRANS_FLAG_ALLEXPLICIT,
			"--asdeps", "--asexplicit");

	if(config->op_q_check) {
		invalid_opt(config->flags & ALPM_TRANS_FLAG_ALLDEPS,
				"--asdeps", "--check");
		invalid_opt(config->flags & ALPM_TRANS_FLAG_ALLEXPLICIT,
				"--asexplicit", "--check");
	}
}

static int parsearg_query(int opt)
{
	switch(opt) {
		case OP_CHANGELOG:
		case 'c':
			config->op_q_changelog = 1;
			break;
		case OP_DEPS:
		case 'd':
			config->op_q_deps = 1;
			break;
		case OP_EXPLICIT:
		case 'e':
			config->op_q_explicit = 1;
			break;
		case OP_GROUPS:
		case 'g':
			(config->group)++;
			break;
		case OP_INFO:
		case 'i':
			(config->op_q_info)++;
			break;
		case OP_CHECK:
		case 'k':
			(config->op_q_check)++;
			break;
		case OP_LIST:
		case 'l':
			config->op_q_list = 1;
			break;
		case OP_FOREIGN:
		case 'm':
			config->op_q_locality |= PKG_LOCALITY_FOREIGN;
			break;
		case OP_NATIVE:
		case 'n':
			config->op_q_locality |= PKG_LOCALITY_NATIVE;
			break;
		case OP_OWNS:
		case 'o':
			config->op_q_owns = 1;
			break;
		case OP_FILE:
		case 'p':
			config->op_q_isfile = 1;
			break;
		case OP_QUIET:
		case 'q':
			config->quiet = 1;
			break;
		case OP_SEARCH:
		case 's':
			config->op_q_search = 1;
			break;
		case OP_UNREQUIRED:
		case 't':
			(config->op_q_unrequired)++;
			break;
		case OP_UPGRADES:
		case 'u':
			config->op_q_upgrade = 1;
			break;
		default:
			return 1;
	}
	return 0;
}

static void checkargs_query_display_opts(const char *opname) {
	invalid_opt(config->op_q_changelog, opname, "--changelog");
	invalid_opt(config->op_q_check, opname, "--check");
	invalid_opt(config->op_q_info, opname, "--info");
	invalid_opt(config->op_q_list, opname, "--list");
}

static void checkargs_query_filter_opts(const char *opname) {
	invalid_opt(config->op_q_deps, opname, "--deps");
	invalid_opt(config->op_q_explicit, opname, "--explicit");
	invalid_opt(config->op_q_upgrade, opname, "--upgrade");
	invalid_opt(config->op_q_unrequired, opname, "--unrequired");
	invalid_opt(config->op_q_locality & PKG_LOCALITY_NATIVE, opname, "--native");
	invalid_opt(config->op_q_locality & PKG_LOCALITY_FOREIGN, opname, "--foreign");
}

static void checkargs_query(void)
{
	if(config->op_q_isfile) {
		invalid_opt(config->group, "--file", "--groups");
		invalid_opt(config->op_q_search, "--file", "--search");
		invalid_opt(config->op_q_owns, "--file", "--owns");
	} else if(config->op_q_search) {
		invalid_opt(config->group, "--search", "--groups");
		invalid_opt(config->op_q_owns, "--search", "--owns");
		checkargs_query_display_opts("--search");
		checkargs_query_filter_opts("--search");
	} else if(config->op_q_owns) {
		invalid_opt(config->group, "--owns", "--groups");
		checkargs_query_display_opts("--owns");
		checkargs_query_filter_opts("--owns");
	} else if(config->group) {
		checkargs_query_display_opts("--groups");
	}

	invalid_opt(config->op_q_deps && config->op_q_explicit, "--deps", "--explicit");
	invalid_opt((config->op_q_locality & PKG_LOCALITY_NATIVE) &&
				 (config->op_q_locality & PKG_LOCALITY_FOREIGN),
			"--native", "--foreign");
}

/* options common to -S -R -U */
static int parsearg_trans(int opt)
{
	switch(opt) {
		case OP_NODEPS:
		case 'd':
			if(config->flags & ALPM_TRANS_FLAG_NODEPVERSION) {
				config->flags |= ALPM_TRANS_FLAG_NODEPS;
			} else {
				config->flags |= ALPM_TRANS_FLAG_NODEPVERSION;
			}
			break;
		case OP_DBONLY:
			config->flags |= ALPM_TRANS_FLAG_DBONLY;
			config->flags |= ALPM_TRANS_FLAG_NOSCRIPTLET;
			break;
		case OP_NOPROGRESSBAR:
			config->noprogressbar = 1;
			break;
		case OP_NOSCRIPTLET:
			config->flags |= ALPM_TRANS_FLAG_NOSCRIPTLET;
			break;
		case OP_PRINT:
		case 'p':
			config->print = 1;
			break;
		case OP_PRINTFORMAT:
			config->print = 1;
			free(config->print_format);
			config->print_format = strdup(optarg);
			break;
		case OP_ASSUMEINSTALLED:
			parsearg_util_addlist(&(config->assumeinstalled));
			break;
		default:
			return 1;
	}
	return 0;
}

static void checkargs_trans(void)
{
	if(config->print) {
		invalid_opt(config->flags & ALPM_TRANS_FLAG_DBONLY,
				"--print", "--dbonly");
		invalid_opt(config->flags & ALPM_TRANS_FLAG_NOSCRIPTLET,
				"--print", "--noscriptlet");
	}
}

static int parsearg_remove(int opt)
{
	if(parsearg_trans(opt) == 0) {
		return 0;
	}
	switch(opt) {
		case OP_CASCADE:
		case 'c':
			config->flags |= ALPM_TRANS_FLAG_CASCADE;
			break;
		case OP_NOSAVE:
		case 'n':
			config->flags |= ALPM_TRANS_FLAG_NOSAVE;
			break;
		case OP_RECURSIVE:
		case 's':
			if(config->flags & ALPM_TRANS_FLAG_RECURSE) {
				config->flags |= ALPM_TRANS_FLAG_RECURSEALL;
			} else {
				config->flags |= ALPM_TRANS_FLAG_RECURSE;
			}
			break;
		case OP_UNNEEDED:
		case 'u':
			config->flags |= ALPM_TRANS_FLAG_UNNEEDED;
			break;
		default:
			return 1;
	}
	return 0;
}

static void checkargs_remove(void)
{
	checkargs_trans();
	if(config->flags & ALPM_TRANS_FLAG_NOSAVE) {
		invalid_opt(config->print, "--nosave", "--print");
		invalid_opt(config->flags & ALPM_TRANS_FLAG_DBONLY,
				"--nosave", "--dbonly");
	}
}

/* options common to -S -U */
static int parsearg_upgrade(int opt)
{
	if(parsearg_trans(opt) == 0) {
		return 0;
	}
	switch(opt) {
		case OP_OVERWRITE_FILES:
			parsearg_util_addlist(&(config->overwrite_files));
			break;
		case OP_ASDEPS:
			config->flags |= ALPM_TRANS_FLAG_ALLDEPS;
			break;
		case OP_ASEXPLICIT:
			config->flags |= ALPM_TRANS_FLAG_ALLEXPLICIT;
			break;
		case OP_NEEDED:
			config->flags |= ALPM_TRANS_FLAG_NEEDED;
			break;
		case OP_IGNORE:
			parsearg_util_addlist(&(config->ignorepkg));
			break;
		case OP_IGNOREGROUP:
			parsearg_util_addlist(&(config->ignoregrp));
			break;
		case OP_DOWNLOADONLY:
		case 'w':
			config->op_s_downloadonly = 1;
			config->flags |= ALPM_TRANS_FLAG_DOWNLOADONLY;
			config->flags |= ALPM_TRANS_FLAG_NOCONFLICTS;
			break;
		default: return 1;
	}
	return 0;
}

static void checkargs_upgrade(void)
{
	checkargs_trans();
	invalid_opt(config->flags & ALPM_TRANS_FLAG_ALLDEPS
			&& config->flags & ALPM_TRANS_FLAG_ALLEXPLICIT,
			"--asdeps", "--asexplicit");
}

static int parsearg_files(int opt)
{
	if(parsearg_trans(opt) == 0) {
		return 0;
	}
	switch(opt) {
		case OP_LIST:
		case 'l':
			config->op_q_list = 1;
			break;
		case OP_REFRESH:
		case 'y':
			(config->op_s_sync)++;
			break;
		case OP_REGEX:
		case 'x':
			config->op_f_regex = 1;
			break;
		case OP_MACHINEREADABLE:
			config->op_f_machinereadable = 1;
			break;
		case OP_QUIET:
		case 'q':
			config->quiet = 1;
			break;
		default:
			return 1;
	}
	return 0;
}

static void checkargs_files(void)
{
	if(config->op_q_search) {
		invalid_opt(config->op_q_list, "--regex", "--list");
	}
}

static int parsearg_sync(int opt)
{
	if(parsearg_upgrade(opt) == 0) {
		return 0;
	}
	switch(opt) {
		case OP_CLEAN:
		case 'c':
			(config->op_s_clean)++;
			break;
		case OP_GROUPS:
		case 'g':
			(config->group)++;
			break;
		case OP_INFO:
		case 'i':
			(config->op_s_info)++;
			break;
		case OP_LIST:
		case 'l':
			config->op_q_list = 1;
			break;
		case OP_QUIET:
		case 'q':
			config->quiet = 1;
			break;
		case OP_SEARCH:
		case 's':
			config->op_s_search = 1;
			break;
		case OP_SYSUPGRADE:
		case 'u':
			(config->op_s_upgrade)++;
			break;
		case OP_REFRESH:
		case 'y':
			(config->op_s_sync)++;
			break;
		default:
			return 1;
	}
	return 0;
}

static void checkargs_sync(void)
{
	checkargs_upgrade();
	if(config->op_s_clean) {
		invalid_opt(config->group, "--clean", "--groups");
		invalid_opt(config->op_s_info, "--clean", "--info");
		invalid_opt(config->op_q_list, "--clean", "--list");
		invalid_opt(config->op_s_sync, "--clean", "--refresh");
		invalid_opt(config->op_s_search, "--clean", "--search");
		invalid_opt(config->op_s_upgrade, "--clean", "--sysupgrade");
		invalid_opt(config->op_s_downloadonly, "--clean", "--downloadonly");
	} else if(config->op_s_info) {
		invalid_opt(config->group, "--info", "--groups");
		invalid_opt(config->op_q_list, "--info", "--list");
		invalid_opt(config->op_s_search, "--info", "--search");
		invalid_opt(config->op_s_upgrade, "--info", "--sysupgrade");
		invalid_opt(config->op_s_downloadonly, "--info", "--downloadonly");
	} else if(config->op_s_search) {
		invalid_opt(config->group, "--search", "--groups");
		invalid_opt(config->op_q_list, "--search", "--list");
		invalid_opt(config->op_s_upgrade, "--search", "--sysupgrade");
		invalid_opt(config->op_s_downloadonly, "--search", "--downloadonly");
	} else if(config->op_q_list) {
		invalid_opt(config->group, "--list", "--groups");
		invalid_opt(config->op_s_upgrade, "--list", "--sysupgrade");
		invalid_opt(config->op_s_downloadonly, "--list", "--downloadonly");
	} else if(config->group) {
		invalid_opt(config->op_s_upgrade, "--groups", "--sysupgrade");
		invalid_opt(config->op_s_downloadonly, "--groups", "--downloadonly");
	}
}

/** Parse command-line arguments for each operation.
 * @param argc argc
 * @param argv argv
 * @return 0 on success, 1 on error
 */
static int parseargs(int argc, char *argv[])
{
	int opt;
	int option_index = 0;
	int result;
	const char *optstring = "DFQRSTUVb:cdefghiklmnopqr:stuvwxy";
	static const struct option opts[] =
	{
		{"database",   no_argument,       0, 'D'},
		{"files",      no_argument,       0, 'F'},
		{"query",      no_argument,       0, 'Q'},
		{"remove",     no_argument,       0, 'R'},
		{"sync",       no_argument,       0, 'S'},
		{"deptest",    no_argument,       0, 'T'}, /* used by makepkg */
		{"upgrade",    no_argument,       0, 'U'},
		{"version",    no_argument,       0, 'V'},
		{"help",       no_argument,       0, 'h'},

		{"dbpath",     required_argument, 0, OP_DBPATH},
		{"cascade",    no_argument,       0, OP_CASCADE},
		{"changelog",  no_argument,       0, OP_CHANGELOG},
		{"clean",      no_argument,       0, OP_CLEAN},
		{"nodeps",     no_argument,       0, OP_NODEPS},
		{"deps",       no_argument,       0, OP_DEPS},
		{"explicit",   no_argument,       0, OP_EXPLICIT},
		{"groups",     no_argument,       0, OP_GROUPS},
		{"info",       no_argument,       0, OP_INFO},
		{"check",      no_argument,       0, OP_CHECK},
		{"list",       no_argument,       0, OP_LIST},
		{"foreign",    no_argument,       0, OP_FOREIGN},
		{"native",     no_argument,       0, OP_NATIVE},
		{"nosave",     no_argument,       0, OP_NOSAVE},
		{"owns",       no_argument,       0, OP_OWNS},
		{"file",       no_argument,       0, OP_FILE},
		{"print",      no_argument,       0, OP_PRINT},
		{"quiet",      no_argument,       0, OP_QUIET},
		{"root",       required_argument, 0, OP_ROOT},
		{"sysroot",    required_argument, 0, OP_SYSROOT},
		{"recursive",  no_argument,       0, OP_RECURSIVE},
		{"search",     no_argument,       0, OP_SEARCH},
		{"regex",      no_argument,       0, OP_REGEX},
		{"machinereadable",      no_argument,       0, OP_MACHINEREADABLE},
		{"unrequired", no_argument,       0, OP_UNREQUIRED},
		{"upgrades",   no_argument,       0, OP_UPGRADES},
		{"sysupgrade", no_argument,       0, OP_SYSUPGRADE},
		{"unneeded",   no_argument,       0, OP_UNNEEDED},
		{"verbose",    no_argument,       0, OP_VERBOSE},
		{"downloadonly", no_argument,     0, OP_DOWNLOADONLY},
		{"refresh",    no_argument,       0, OP_REFRESH},
		{"noconfirm",  no_argument,       0, OP_NOCONFIRM},
		{"confirm",    no_argument,       0, OP_CONFIRM},
		{"config",     required_argument, 0, OP_CONFIG},
		{"ignore",     required_argument, 0, OP_IGNORE},
		{"assume-installed",     required_argument, 0, OP_ASSUMEINSTALLED},
		{"debug",      optional_argument, 0, OP_DEBUG},
		{"force",      no_argument,       0, OP_FORCE},
		{"overwrite",  required_argument, 0, OP_OVERWRITE_FILES},
		{"noprogressbar", no_argument,    0, OP_NOPROGRESSBAR},
		{"noscriptlet", no_argument,      0, OP_NOSCRIPTLET},
		{"ask",        required_argument, 0, OP_ASK},
		{"cachedir",   required_argument, 0, OP_CACHEDIR},
		{"hookdir",    required_argument, 0, OP_HOOKDIR},
		{"asdeps",     no_argument,       0, OP_ASDEPS},
		{"logfile",    required_argument, 0, OP_LOGFILE},
		{"ignoregroup", required_argument, 0, OP_IGNOREGROUP},
		{"needed",     no_argument,       0, OP_NEEDED},
		{"asexplicit",     no_argument,   0, OP_ASEXPLICIT},
		{"arch",       required_argument, 0, OP_ARCH},
		{"print-format", required_argument, 0, OP_PRINTFORMAT},
		{"gpgdir",     required_argument, 0, OP_GPGDIR},
		{"dbonly",     no_argument,       0, OP_DBONLY},
		{"color",      required_argument, 0, OP_COLOR},
		{"disable-download-timeout", no_argument, 0, OP_DISABLEDLTIMEOUT},
		{0, 0, 0, 0}
	};

	/* parse operation */
	while((opt = getopt_long(argc, argv, optstring, opts, &option_index)) != -1) {
		if(opt == 0) {
			continue;
		} else if(opt == '?') {
			/* unknown option, getopt printed an error */
			return 1;
		}
		parsearg_op(opt, 0);
	}

	if(config->op == 0) {
		pm_printf(ALPM_LOG_ERROR, _("only one operation may be used at a time\n"));
		return 1;
	}
	if(config->help) {
		usage(config->op, mbasename(argv[0]));
		cleanup(0);
	}
	if(config->version) {
		version();
		cleanup(0);
	}

	/* parse all other options */
	optind = 1;
	while((opt = getopt_long(argc, argv, optstring, opts, &option_index)) != -1) {
		if(opt == 0) {
			continue;
		} else if(opt == '?') {
			/* this should have failed during first pass already */
			return 1;
		} else if(parsearg_op(opt, 1) == 0) {
			/* opt is an operation */
			continue;
		}

		switch(config->op) {
			case PM_OP_DATABASE:
				result = parsearg_database(opt);
				break;
			case PM_OP_QUERY:
				result = parsearg_query(opt);
				break;
			case PM_OP_REMOVE:
				result = parsearg_remove(opt);
				break;
			case PM_OP_SYNC:
				result = parsearg_sync(opt);
				break;
			case PM_OP_UPGRADE:
				result = parsearg_upgrade(opt);
				break;
			case PM_OP_FILES:
				result = parsearg_files(opt);
				break;
			case PM_OP_DEPTEST:
			default:
				result = 1;
				break;
		}
		if(result == 0) {
			continue;
		}

		/* fall back to global options */
		result = parsearg_global(opt);
		if(result != 0) {
			/* global option parsing failed, abort */
			if(opt < OP_LONG_FLAG_MIN) {
				pm_printf(ALPM_LOG_ERROR, _("invalid option '-%c'\n"), opt);
			} else {
				pm_printf(ALPM_LOG_ERROR, _("invalid option '--%s'\n"),
						opts[option_index].name);
			}
			return result;
		}
	}

	while(optind < argc) {
		/* add the target to our target array */
		pm_targets = alpm_list_add(pm_targets, strdup(argv[optind]));
		optind++;
	}

	switch(config->op) {
		case PM_OP_DATABASE:
			checkargs_database();
			break;
		case PM_OP_DEPTEST:
			/* no conflicting options */
			break;
		case PM_OP_SYNC:
			checkargs_sync();
			break;
		case PM_OP_QUERY:
			checkargs_query();
			break;
		case PM_OP_REMOVE:
			checkargs_remove();
			break;
		case PM_OP_UPGRADE:
			checkargs_upgrade();
			break;
		case PM_OP_FILES:
			checkargs_files();
			break;
		default:
			break;
	}

	return 0;
}

/** Print command line to logfile.
 * @param argc
 * @param argv
 */
static void cl_to_log(int argc, char *argv[])
{
	char *cl_text = arg_to_string(argc, argv);
	if(cl_text) {
		alpm_logaction(config->handle, PACMAN_CALLER_PREFIX,
				"Running '%s'\n", cl_text);
		free(cl_text);
	}
}

/** Main function.
 * @param argc
 * @param argv
 * @return A return code indicating success, failure, etc.
 */
int main(int argc, char *argv[])
{
	int ret = 0;
	uid_t myuid = getuid();

	console_cursor_hide();
	install_segv_handler();

	/* i18n init */
#if defined(ENABLE_NLS)
	localize();
#endif

	/* set user agent for downloading */
	setuseragent();

	/* init config data */
	if(!(config = config_new())) {
		/* config_new prints the appropriate error message */
		cleanup(1);
	}

	install_soft_interrupt_handler();

	if(!isatty(fileno(stdout))) {
		/* disable progressbar if the output is redirected */
		config->noprogressbar = 1;
	} else {
		/* install signal handler to update output width */
		install_winch_handler();
	}

	/* Priority of options:
	 * 1. command line
	 * 2. config file
	 * 3. compiled-in defaults
	 * However, we have to parse the command line first because a config file
	 * location can be specified here, so we need to make sure we prefer these
	 * options over the config file coming second.
	 */

	/* parse the command line */
	ret = parseargs(argc, argv);
	if(ret != 0) {
		cleanup(ret);
	}

	/* check if we have sufficient permission for the requested operation */
	if(myuid > 0 && needs_root()) {
		pm_printf(ALPM_LOG_ERROR, _("you cannot perform this operation unless you are root.\n"));
		cleanup(EXIT_FAILURE);
	}

	/* we support reading targets from stdin if a cmdline parameter is '-' */
	if(alpm_list_find_str(pm_targets, "-")) {
		if(!isatty(fileno(stdin))) {
			int target_found = 0;
			char *vdata, *line = NULL;
			size_t line_size = 0;
			ssize_t nread;

			/* remove the '-' from the list */
			pm_targets = alpm_list_remove_str(pm_targets, "-", &vdata);
			free(vdata);

			while((nread = getline(&line, &line_size, stdin)) != -1) {
				if(line[nread - 1] == '\n') {
					/* remove trailing newline */
					line[nread - 1] = '\0';
				}
				if(line[0] == '\0') {
					/* skip empty lines */
					continue;
				}
				if(!alpm_list_append_strdup(&pm_targets, line)) {
					break;
				}
				target_found = 1;
			}
			free(line);

			if(ferror(stdin)) {
				pm_printf(ALPM_LOG_ERROR,
						_("failed to read arguments from stdin: (%s)\n"), strerror(errno));
				cleanup(EXIT_FAILURE);
			}

			if(!freopen(ctermid(NULL), "r", stdin)) {
				pm_printf(ALPM_LOG_ERROR, _("failed to reopen stdin for reading: (%s)\n"),
						strerror(errno));
			}

			if(!target_found) {
				pm_printf(ALPM_LOG_ERROR, _("argument '-' specified with empty stdin\n"));
				cleanup(1);
			}
		} else {
			/* do not read stdin from terminal */
			pm_printf(ALPM_LOG_ERROR, _("argument '-' specified without input on stdin\n"));
			cleanup(1);
		}
	}

	if(config->sysroot && (chroot(config->sysroot) != 0 || chdir("/") != 0)) {
		pm_printf(ALPM_LOG_ERROR,
				_("chroot to '%s' failed: (%s)\n"), config->sysroot, strerror(errno));
		cleanup(EXIT_FAILURE);
	}

	pm_printf(ALPM_LOG_DEBUG, "pacman v%s - libalpm v%s\n", PACKAGE_VERSION, alpm_version());

	/* parse the config file */
	ret = parseconfig(config->configfile);
	if(ret != 0) {
		cleanup(ret);
	}

	/* noask is meant to be non-interactive */
	if(config->noask) {
		config->noconfirm = 1;
	}

	/* set up the print operations */
	if(config->print && !config->op_s_clean) {
		config->noconfirm = 1;
		config->flags |= ALPM_TRANS_FLAG_NOCONFLICTS;
		config->flags |= ALPM_TRANS_FLAG_NOLOCK;
		/* Display only errors */
		config->logmask &= ~ALPM_LOG_WARNING;
	}

	if(config->verbose > 0) {
		alpm_list_t *j;
		printf("Root      : %s\n", alpm_option_get_root(config->handle));
		printf("Conf File : %s\n", config->configfile);
		printf("DB Path   : %s\n", alpm_option_get_dbpath(config->handle));
		printf("Cache Dirs: ");
		for(j = alpm_option_get_cachedirs(config->handle); j; j = alpm_list_next(j)) {
			printf("%s  ", (const char *)j->data);
		}
		printf("\n");
		printf("Hook Dirs : ");
		for(j = alpm_option_get_hookdirs(config->handle); j; j = alpm_list_next(j)) {
			printf("%s  ", (const char *)j->data);
		}
		printf("\n");
		printf("Lock File : %s\n", alpm_option_get_lockfile(config->handle));
		printf("Log File  : %s\n", alpm_option_get_logfile(config->handle));
		printf("GPG Dir   : %s\n", alpm_option_get_gpgdir(config->handle));
		list_display("Targets   :", pm_targets, 0);
	}

	/* Log command line */
	if(needs_root()) {
		cl_to_log(argc, argv);
	}

	/* start the requested operation */
	switch(config->op) {
		case PM_OP_DATABASE:
			ret = pacman_database(pm_targets);
			break;
		case PM_OP_REMOVE:
			ret = pacman_remove(pm_targets);
			break;
		case PM_OP_UPGRADE:
			ret = pacman_upgrade(pm_targets);
			break;
		case PM_OP_QUERY:
			ret = pacman_query(pm_targets);
			break;
		case PM_OP_SYNC:
			ret = pacman_sync(pm_targets);
			break;
		case PM_OP_DEPTEST:
			ret = pacman_deptest(pm_targets);
			break;
		case PM_OP_FILES:
			ret = pacman_files(pm_targets);
			break;
		default:
			pm_printf(ALPM_LOG_ERROR, _("no operation specified (use -h for help)\n"));
			ret = EXIT_FAILURE;
	}

	cleanup(ret);
	/* not reached */
	return EXIT_SUCCESS;
}
