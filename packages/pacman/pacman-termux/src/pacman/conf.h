/*
 *  conf.h
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
#ifndef PM_CONF_H
#define PM_CONF_H

#include <alpm.h>

typedef struct __colstr_t {
	const char *colon;
	const char *title;
	const char *repo;
	const char *version;
	const char *groups;
	const char *meta;
	const char *warn;
	const char *err;
	const char *faint;
	const char *nocolor;
} colstr_t;

typedef struct __config_repo_t {
	char *name;
	alpm_list_t *servers;
	int usage;
	int siglevel;
	int siglevel_mask;
} config_repo_t;

typedef struct __config_t {
	unsigned short op;
	unsigned short quiet;
	unsigned short verbose;
	unsigned short version;
	unsigned short help;
	unsigned short noconfirm;
	unsigned short noprogressbar;
	unsigned short logmask;
	unsigned short print;
	unsigned short checkspace;
	unsigned short usesyslog;
	unsigned short color;
	unsigned short disable_dl_timeout;
	char *print_format;
	/* unfortunately, we have to keep track of paths both here and in the library
	 * because they can come from both the command line or config file, and we
	 * need to ensure we get the order of preference right. */
	char *configfile;
	char *rootdir;
	char *dbpath;
	char *logfile;
	char *gpgdir;
	char *sysroot;
	alpm_list_t *hookdirs;
	alpm_list_t *cachedirs;
	alpm_list_t *architectures;

	unsigned short op_q_isfile;
	unsigned short op_q_info;
	unsigned short op_q_list;
	unsigned short op_q_unrequired;
	unsigned short op_q_deps;
	unsigned short op_q_explicit;
	unsigned short op_q_owns;
	unsigned short op_q_search;
	unsigned short op_q_changelog;
	unsigned short op_q_upgrade;
	unsigned short op_q_check;
	unsigned short op_q_locality;

	unsigned short op_s_clean;
	unsigned short op_s_downloadonly;
	unsigned short op_s_info;
	unsigned short op_s_sync;
	unsigned short op_s_search;
	unsigned short op_s_upgrade;

	unsigned short op_f_regex;
	unsigned short op_f_machinereadable;

	unsigned short group;
	unsigned short noask;
	unsigned int ask;
	/* Bitfield of alpm_transflag_t */
	int flags;
	/* Bitfields of alpm_siglevel_t */
	int siglevel;
	int localfilesiglevel;
	int remotefilesiglevel;

	int siglevel_mask;
	int localfilesiglevel_mask;
	int remotefilesiglevel_mask;

	/* conf file options */
	/* I Love Candy! */
	unsigned short chomp;
	/* format target pkg lists as table */
	unsigned short verbosepkglists;
	/* number of parallel download streams */
	unsigned int parallel_downloads;
	/* select -Sc behavior */
	unsigned short cleanmethod;
	alpm_list_t *holdpkg;
	alpm_list_t *ignorepkg;
	alpm_list_t *ignoregrp;
	alpm_list_t *assumeinstalled;
	alpm_list_t *noupgrade;
	alpm_list_t *noextract;
	alpm_list_t *overwrite_files;
	char *xfercommand;
	char **xfercommand_argv;
	size_t xfercommand_argc;

	/* our connection to libalpm */
	alpm_handle_t *handle;

	alpm_list_t *explicit_adds;
	alpm_list_t *explicit_removes;

	/* Color strings for output */
	colstr_t colstr;

	alpm_list_t *repos;
} config_t;

/* Operations */
enum {
	PM_OP_MAIN = 1,
	PM_OP_REMOVE,
	PM_OP_UPGRADE,
	PM_OP_QUERY,
	PM_OP_SYNC,
	PM_OP_DEPTEST,
	PM_OP_DATABASE,
	PM_OP_FILES
};

/* Long Operations */
enum {
	OP_LONG_FLAG_MIN = 1000,
	OP_NOCONFIRM,
	OP_CONFIRM,
	OP_CONFIG,
	OP_IGNORE,
	OP_DEBUG,
	OP_NOPROGRESSBAR,
	OP_NOSCRIPTLET,
	OP_ASK,
	OP_CACHEDIR,
	OP_HOOKDIR,
	OP_ASDEPS,
	OP_LOGFILE,
	OP_IGNOREGROUP,
	OP_NEEDED,
	OP_ASEXPLICIT,
	OP_ARCH,
	OP_PRINTFORMAT,
	OP_GPGDIR,
	OP_DBONLY,
	OP_FORCE,
	OP_OVERWRITE_FILES,
	OP_COLOR,
	OP_DBPATH,
	OP_CASCADE,
	OP_CHANGELOG,
	OP_CLEAN,
	OP_NODEPS,
	OP_DEPS,
	OP_EXPLICIT,
	OP_GROUPS,
	OP_HELP,
	OP_INFO,
	OP_CHECK,
	OP_LIST,
	OP_FOREIGN,
	OP_NATIVE,
	OP_NOSAVE,
	OP_OWNS,
	OP_FILE,
	OP_PRINT,
	OP_QUIET,
	OP_ROOT,
	OP_SYSROOT,
	OP_RECURSIVE,
	OP_SEARCH,
	OP_REGEX,
	OP_MACHINEREADABLE,
	OP_UNREQUIRED,
	OP_UPGRADES,
	OP_SYSUPGRADE,
	OP_UNNEEDED,
	OP_VERBOSE,
	OP_DOWNLOADONLY,
	OP_REFRESH,
	OP_ASSUMEINSTALLED,
	OP_DISABLEDLTIMEOUT
};

/* clean method */
enum {
	PM_CLEAN_KEEPINST = 1,
	PM_CLEAN_KEEPCUR = (1 << 1)
};

/** package locality */
enum {
	PKG_LOCALITY_UNSET = 0,
	PKG_LOCALITY_NATIVE = (1 << 0),
	PKG_LOCALITY_FOREIGN = (1 << 1)
};

enum {
	PM_COLOR_UNSET = 0,
	PM_COLOR_OFF,
	PM_COLOR_ON
};

/* global config variable */
extern config_t *config;

void enable_colors(int colors);
config_t *config_new(void);
int config_free(config_t *oldconfig);

void config_repo_free(config_repo_t *repo);

int config_add_architecture(char *arch);
int parseconfig(const char *file);
int parseconfigfile(const char *file);
int setdefaults(config_t *c);
#endif /* PM_CONF_H */
