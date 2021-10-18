/*
 *  conf.c
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

#include <errno.h>
#include <limits.h>
#include <locale.h> /* setlocale */
#include <fcntl.h> /* open */
#include <glob.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h> /* strdup */
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/utsname.h> /* uname */
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>

/* pacman */
#include "conf.h"
#include "ini.h"
#include "util.h"
#include "callback.h"

/* global config variable */
config_t *config = NULL;

#define NOCOLOR       "\033[0m"

#define BOLD          "\033[0;1m"

#define BLACK         "\033[0;30m"
#define RED           "\033[0;31m"
#define GREEN         "\033[0;32m"
#define YELLOW        "\033[0;33m"
#define BLUE          "\033[0;34m"
#define MAGENTA       "\033[0;35m"
#define CYAN          "\033[0;36m"
#define WHITE         "\033[0;37m"

#define BOLDBLACK     "\033[1;30m"
#define BOLDRED       "\033[1;31m"
#define BOLDGREEN     "\033[1;32m"
#define BOLDYELLOW    "\033[1;33m"
#define BOLDBLUE      "\033[1;34m"
#define BOLDMAGENTA   "\033[1;35m"
#define BOLDCYAN      "\033[1;36m"
#define BOLDWHITE     "\033[1;37m"
#define GREY46        "\033[38;5;243m"

void enable_colors(int colors)
{
	colstr_t *colstr = &config->colstr;

	if(colors == PM_COLOR_ON) {
		colstr->colon   = BOLDBLUE "::" BOLD " ";
		colstr->title   = BOLD;
		colstr->repo    = BOLDMAGENTA;
		colstr->version = BOLDGREEN;
		colstr->groups  = BOLDBLUE;
		colstr->meta    = BOLDCYAN;
		colstr->warn    = BOLDYELLOW;
		colstr->err     = BOLDRED;
		colstr->faint   = GREY46;
		colstr->nocolor = NOCOLOR;
	} else {
		colstr->colon   = ":: ";
		colstr->title   = "";
		colstr->repo    = "";
		colstr->version = "";
		colstr->groups  = "";
		colstr->meta    = "";
		colstr->warn    = "";
		colstr->err     = "";
		colstr->faint   = "";
		colstr->nocolor = "";
	}
}

config_t *config_new(void)
{
	config_t *newconfig = calloc(1, sizeof(config_t));
	if(!newconfig) {
		pm_printf(ALPM_LOG_ERROR,
				_n("malloc failure: could not allocate %zu byte\n",
				   "malloc failure: could not allocate %zu bytes\n", sizeof(config_t)),
				sizeof(config_t));
		return NULL;
	}
	/* defaults which may get overridden later */
	newconfig->op = PM_OP_MAIN;
	newconfig->logmask = ALPM_LOG_ERROR | ALPM_LOG_WARNING;
	newconfig->configfile = strdup(CONFFILE);
	if(alpm_capabilities() & ALPM_CAPABILITY_SIGNATURES) {
		newconfig->siglevel = ALPM_SIG_PACKAGE | ALPM_SIG_PACKAGE_OPTIONAL |
			ALPM_SIG_DATABASE | ALPM_SIG_DATABASE_OPTIONAL;
		newconfig->localfilesiglevel = ALPM_SIG_USE_DEFAULT;
		newconfig->remotefilesiglevel = ALPM_SIG_USE_DEFAULT;
	}

	/* by default use 1 download stream */
	newconfig->parallel_downloads = 1;
	newconfig->colstr.colon   = ":: ";
	newconfig->colstr.title   = "";
	newconfig->colstr.repo    = "";
	newconfig->colstr.version = "";
	newconfig->colstr.groups  = "";
	newconfig->colstr.meta    = "";
	newconfig->colstr.warn    = "";
	newconfig->colstr.err     = "";
	newconfig->colstr.faint   = "";
	newconfig->colstr.nocolor = "";

	return newconfig;
}

int config_free(config_t *oldconfig)
{
	if(oldconfig == NULL) {
		return -1;
	}

	alpm_list_free(oldconfig->explicit_adds);
	alpm_list_free(oldconfig->explicit_removes);

	alpm_list_free_inner(config->repos, (alpm_list_fn_free) config_repo_free);
	alpm_list_free(config->repos);

	FREELIST(oldconfig->holdpkg);
	FREELIST(oldconfig->ignorepkg);
	FREELIST(oldconfig->ignoregrp);
	FREELIST(oldconfig->assumeinstalled);
	FREELIST(oldconfig->noupgrade);
	FREELIST(oldconfig->noextract);
	FREELIST(oldconfig->overwrite_files);
	free(oldconfig->configfile);
	free(oldconfig->rootdir);
	free(oldconfig->dbpath);
	free(oldconfig->logfile);
	free(oldconfig->gpgdir);
	FREELIST(oldconfig->hookdirs);
	FREELIST(oldconfig->cachedirs);
	free(oldconfig->xfercommand);
	free(oldconfig->print_format);
	FREELIST(oldconfig->architectures);
	wordsplit_free(oldconfig->xfercommand_argv);
	free(oldconfig);

	return 0;
}

void config_repo_free(config_repo_t *repo)
{
	if(repo == NULL) {
		return;
	}
	free(repo->name);
	FREELIST(repo->servers);
	free(repo);
}

/** Helper function for download_with_xfercommand() */
static char *get_filename(const char *url)
{
	char *filename = strrchr(url, '/');
	if(filename != NULL) {
		filename++;
	}
	return filename;
}

/** Helper function for download_with_xfercommand() */
static char *get_destfile(const char *path, const char *filename)
{
	char *destfile;
	/* len = localpath len + filename len + null */
	size_t len = strlen(path) + strlen(filename) + 1;
	destfile = calloc(len, sizeof(char));
	snprintf(destfile, len, "%s%s", path, filename);

	return destfile;
}

/** Helper function for download_with_xfercommand() */
static char *get_tempfile(const char *path, const char *filename)
{
	char *tempfile;
	/* len = localpath len + filename len + '.part' len + null */
	size_t len = strlen(path) + strlen(filename) + 6;
	tempfile = calloc(len, sizeof(char));
	snprintf(tempfile, len, "%s%s.part", path, filename);

	return tempfile;
}

/* system()/exec() hybrid function allowing exec()-style direct execution
 * of a command with the simplicity of system()
 * - not thread-safe
 * - errno may be set by fork(), pipe(), or execvp()
 */
static int systemvp(const char *file, char *const argv[])
{
	int pid, err = 0, ret = -1, err_fd[2];
	sigset_t oldblock;
	struct sigaction sa_ign = { .sa_handler = SIG_IGN }, oldint, oldquit;

	if(pipe(err_fd) != 0) {
		return -1;
	}

	sigaction(SIGINT, &sa_ign, &oldint);
	sigaction(SIGQUIT, &sa_ign, &oldquit);
	sigaddset(&sa_ign.sa_mask, SIGCHLD);
	sigprocmask(SIG_BLOCK, &sa_ign.sa_mask, &oldblock);

	pid = fork();

	/* child */
	if(pid == 0) {
		close(err_fd[0]);
		fcntl(err_fd[1], F_SETFD, FD_CLOEXEC);

		/* restore signal handling for the child to inherit */
		sigaction(SIGINT, &oldint, NULL);
		sigaction(SIGQUIT, &oldquit, NULL);
		sigprocmask(SIG_SETMASK, &oldblock, NULL);

		execvp(file, argv);

		/* execvp failed, pass the error back to the parent */
		while(write(err_fd[1], &errno, sizeof(errno)) == -1 && errno == EINTR);
		_Exit(127);
	}

	/* parent */
	close(err_fd[1]);

	if(pid != -1)  {
		int wret;
		while((wret = waitpid(pid, &ret, 0)) == -1 && errno == EINTR);
		if(wret > 0) {
			while(read(err_fd[0], &err, sizeof(err)) == -1 && errno == EINTR);
		}
	} else {
		/* fork failed, make sure errno is preserved after cleanup */
		err = errno;
	}

	close(err_fd[0]);

	sigaction(SIGINT, &oldint, NULL);
	sigaction(SIGQUIT, &oldquit, NULL);
	sigprocmask(SIG_SETMASK, &oldblock, NULL);

	if(err) {
		errno = err;
		ret = -1;
	}

	return ret;
}

/** External fetch callback */
static int download_with_xfercommand(void *ctx, const char *url,
		const char *localpath, int force)
{
	int ret = 0, retval;
	int usepart = 0;
	int cwdfd = -1;
	struct stat st;
	char *destfile, *tempfile, *filename;
	const char **argv;
	size_t i;

	(void)ctx;

	if(!config->xfercommand_argv) {
		return -1;
	}

	filename = get_filename(url);
	if(!filename) {
		return -1;
	}
	destfile = get_destfile(localpath, filename);
	tempfile = get_tempfile(localpath, filename);

	if(force && stat(tempfile, &st) == 0) {
		unlink(tempfile);
	}
	if(force && stat(destfile, &st) == 0) {
		unlink(destfile);
	}

	if((argv = calloc(config->xfercommand_argc + 1, sizeof(char*))) == NULL) {
		size_t bytes = (config->xfercommand_argc + 1) * sizeof(char*);
		pm_printf(ALPM_LOG_ERROR,
				_n("malloc failure: could not allocate %zu byte\n",
				   "malloc failure: could not allocate %zu bytes\n",
					 bytes),
				bytes);
		goto cleanup;
	}

	for(i = 0; i <= config->xfercommand_argc; i++) {
		const char *val = config->xfercommand_argv[i];
		if(val && strcmp(val, "%o") == 0) {
			usepart = 1;
			val = tempfile;
		} else if(val && strcmp(val, "%u") == 0) {
			val = url;
		}
		argv[i] = val;
	}

	/* save the cwd so we can restore it later */
	do {
		cwdfd = open(".", O_RDONLY);
	} while(cwdfd == -1 && errno == EINTR);
	if(cwdfd < 0) {
		pm_printf(ALPM_LOG_ERROR, _("could not get current working directory\n"));
	}

	/* cwd to the download directory */
	if(chdir(localpath)) {
		pm_printf(ALPM_LOG_WARNING, _("could not chdir to download directory %s\n"), localpath);
		ret = -1;
		goto cleanup;
	}

	if(config->logmask & ALPM_LOG_DEBUG) {
		char *cmd = arg_to_string(config->xfercommand_argc, (char**)argv);
		if(cmd) {
			pm_printf(ALPM_LOG_DEBUG, "running command: %s\n", cmd);
			free(cmd);
		}
	}
	retval = systemvp(argv[0], (char**)argv);

	if(retval == -1) {
		pm_printf(ALPM_LOG_WARNING, _("running XferCommand: fork failed!\n"));
		ret = -1;
	} else if(retval != 0) {
		/* download failed */
		pm_printf(ALPM_LOG_DEBUG, "XferCommand command returned non-zero status "
				"code (%d)\n", retval);
		ret = -1;
	} else {
		/* download was successful */
		ret = 0;
		if(usepart) {
			if(rename(tempfile, destfile)) {
				pm_printf(ALPM_LOG_ERROR, _("could not rename %s to %s (%s)\n"),
						tempfile, destfile, strerror(errno));
				ret = -1;
			}
		}
	}

cleanup:
	/* restore the old cwd if we have it */
	if(cwdfd >= 0) {
		if(fchdir(cwdfd) != 0) {
			pm_printf(ALPM_LOG_ERROR, _("could not restore working directory (%s)\n"),
					strerror(errno));
		}
		close(cwdfd);
	}

	if(ret == -1) {
		/* hack to let an user the time to cancel a download */
		sleep(2);
	}
	free(destfile);
	free(tempfile);
	free(argv);

	return ret;
}


int config_add_architecture(char *arch)
{
	if(strcmp(arch, "auto") == 0) {
		struct utsname un;
		char *newarch;
		uname(&un);
		newarch = strdup(un.machine);
		free(arch);
		arch = newarch;
	}

	pm_printf(ALPM_LOG_DEBUG, "config: arch: %s\n", arch);
	config->architectures = alpm_list_add(config->architectures, arch);
	return 0;
}

/**
 * Parse a string into long number. The input string has to be non-empty
 * and represent a number that fits long type.
 * @param value the string to parse
 * @param result pointer to long where the final result will be stored.
 *   This result is modified if the input string parsed successfully.
 * @return 0 in case if value parsed successfully, 1 otherwise.
 */
static int parse_number(char *value, long *result) {
	char *endptr;
	long val;
	int invalid;

	errno = 0; /* To distinguish success/failure after call */
	val = strtol(value, &endptr, 10);
	invalid = (errno == ERANGE && (val == LONG_MAX || val == LONG_MIN))
		|| (*endptr != '\0')
		|| (endptr == value);

	if(!invalid) {
		*result = val;
	}

	return invalid;
}

/**
 * Parse a signature verification level line.
 * @param values the list of parsed option values
 * @param storage location to store the derived signature level; any existing
 * value here is used as a starting point
 * @param file path to the config file
 * @param linenum current line number in file
 * @return 0 on success, 1 on any parsing error
 */
static int process_siglevel(alpm_list_t *values, int *storage,
		int *storage_mask, const char *file, int linenum)
{
	int level = *storage, mask = *storage_mask;
	alpm_list_t *i;
	int ret = 0;

#define SLSET(sl) do { level |= (sl); mask |= (sl); } while(0)
#define SLUNSET(sl) do { level &= ~(sl); mask |= (sl); } while(0)

	/* Collapse the option names into a single bitmasked value */
	for(i = values; i; i = alpm_list_next(i)) {
		const char *original = i->data, *value;
		int package = 0, database = 0;

		if(strncmp(original, "Package", strlen("Package")) == 0) {
			/* only packages are affected, don't flip flags for databases */
			value = original + strlen("Package");
			package = 1;
		} else if(strncmp(original, "Database", strlen("Database")) == 0) {
			/* only databases are affected, don't flip flags for packages */
			value = original + strlen("Database");
			database = 1;
		} else {
			/* no prefix, so anything found will affect both packages and dbs */
			value = original;
			package = database = 1;
		}

		/* now parse out and store actual flag if it is valid */
		if(strcmp(value, "Never") == 0) {
			if(package) {
				SLUNSET(ALPM_SIG_PACKAGE);
			}
			if(database) {
				SLUNSET(ALPM_SIG_DATABASE);
			}
		} else if(strcmp(value, "Optional") == 0) {
			if(package) {
				SLSET(ALPM_SIG_PACKAGE | ALPM_SIG_PACKAGE_OPTIONAL);
			}
			if(database) {
				SLSET(ALPM_SIG_DATABASE | ALPM_SIG_DATABASE_OPTIONAL);
			}
		} else if(strcmp(value, "Required") == 0) {
			if(package) {
				SLSET(ALPM_SIG_PACKAGE);
				SLUNSET(ALPM_SIG_PACKAGE_OPTIONAL);
			}
			if(database) {
				SLSET(ALPM_SIG_DATABASE);
				SLUNSET(ALPM_SIG_DATABASE_OPTIONAL);
			}
		} else if(strcmp(value, "TrustedOnly") == 0) {
			if(package) {
				SLUNSET(ALPM_SIG_PACKAGE_MARGINAL_OK | ALPM_SIG_PACKAGE_UNKNOWN_OK);
			}
			if(database) {
				SLUNSET(ALPM_SIG_DATABASE_MARGINAL_OK | ALPM_SIG_DATABASE_UNKNOWN_OK);
			}
		} else if(strcmp(value, "TrustAll") == 0) {
			if(package) {
				SLSET(ALPM_SIG_PACKAGE_MARGINAL_OK | ALPM_SIG_PACKAGE_UNKNOWN_OK);
			}
			if(database) {
				SLSET(ALPM_SIG_DATABASE_MARGINAL_OK | ALPM_SIG_DATABASE_UNKNOWN_OK);
			}
		} else {
			pm_printf(ALPM_LOG_ERROR,
					_("config file %s, line %d: invalid value for '%s' : '%s'\n"),
					file, linenum, "SigLevel", original);
			ret = 1;
		}
		level &= ~ALPM_SIG_USE_DEFAULT;
	}

#undef SLSET
#undef SLUNSET

	/* ensure we have sig checking ability and are actually turning it on */
	if(!(alpm_capabilities() & ALPM_CAPABILITY_SIGNATURES) &&
			level & (ALPM_SIG_PACKAGE | ALPM_SIG_DATABASE)) {
		pm_printf(ALPM_LOG_ERROR,
				_("config file %s, line %d: '%s' option invalid, no signature support\n"),
				file, linenum, "SigLevel");
		ret = 1;
	}

	if(!ret) {
		*storage = level;
		*storage_mask = mask;
	}
	return ret;
}

/**
 * Merge the package entries of two signature verification levels.
 * @param base initial siglevel
 * @param over overriding siglevel
 * @return merged siglevel
 */
static int merge_siglevel(int base, int over, int mask)
{
	return mask ? (over & mask) | (base & ~mask) : over;
}

static int process_cleanmethods(alpm_list_t *values,
		const char *file, int linenum)
{
	alpm_list_t *i;
	for(i = values; i; i = alpm_list_next(i)) {
		const char *value = i->data;
		if(strcmp(value, "KeepInstalled") == 0) {
			config->cleanmethod |= PM_CLEAN_KEEPINST;
		} else if(strcmp(value, "KeepCurrent") == 0) {
			config->cleanmethod |= PM_CLEAN_KEEPCUR;
		} else {
			pm_printf(ALPM_LOG_ERROR,
					_("config file %s, line %d: invalid value for '%s' : '%s'\n"),
					file, linenum, "CleanMethod", value);
			return 1;
		}
	}
	return 0;
}

/** Add repeating options such as NoExtract, NoUpgrade, etc to libalpm
 * settings. Refactored out of the parseconfig code since all of them did
 * the exact same thing and duplicated code.
 * @param ptr a pointer to the start of the multiple options
 * @param option the string (friendly) name of the option, used for messages
 * @param list the list to add the option to
 */
static void setrepeatingoption(char *ptr, const char *option,
		alpm_list_t **list)
{
	char *val, *saveptr = NULL;

	val = strtok_r(ptr, " ", &saveptr);
	while(val) {
		*list = alpm_list_add(*list, strdup(val));
		pm_printf(ALPM_LOG_DEBUG, "config: %s: %s\n", option, val);
		val = strtok_r(NULL, " ", &saveptr);
	}
}

static int _parse_options(const char *key, char *value,
		const char *file, int linenum)
{
	if(value == NULL) {
		/* options without settings */
		if(strcmp(key, "UseSyslog") == 0) {
			config->usesyslog = 1;
			pm_printf(ALPM_LOG_DEBUG, "config: usesyslog\n");
		} else if(strcmp(key, "ILoveCandy") == 0) {
			config->chomp = 1;
			pm_printf(ALPM_LOG_DEBUG, "config: chomp\n");
		} else if(strcmp(key, "VerbosePkgLists") == 0) {
			config->verbosepkglists = 1;
			pm_printf(ALPM_LOG_DEBUG, "config: verbosepkglists\n");
		} else if(strcmp(key, "CheckSpace") == 0) {
			config->checkspace = 1;
		} else if(strcmp(key, "Color") == 0) {
			if(config->color == PM_COLOR_UNSET) {
				config->color = isatty(fileno(stdout)) ? PM_COLOR_ON : PM_COLOR_OFF;
				enable_colors(config->color);
			}
		} else if(strcmp(key, "NoProgressBar") == 0) {
			config->noprogressbar = 1;
		} else if(strcmp(key, "DisableDownloadTimeout") == 0) {
			config->disable_dl_timeout = 1;
		} else {
			pm_printf(ALPM_LOG_WARNING,
					_("config file %s, line %d: directive '%s' in section '%s' not recognized.\n"),
					file, linenum, key, "options");
		}
	} else {
		/* options with settings */
		if(strcmp(key, "NoUpgrade") == 0) {
			setrepeatingoption(value, "NoUpgrade", &(config->noupgrade));
		} else if(strcmp(key, "NoExtract") == 0) {
			setrepeatingoption(value, "NoExtract", &(config->noextract));
		} else if(strcmp(key, "IgnorePkg") == 0) {
			setrepeatingoption(value, "IgnorePkg", &(config->ignorepkg));
		} else if(strcmp(key, "IgnoreGroup") == 0) {
			setrepeatingoption(value, "IgnoreGroup", &(config->ignoregrp));
		} else if(strcmp(key, "HoldPkg") == 0) {
			setrepeatingoption(value, "HoldPkg", &(config->holdpkg));
		} else if(strcmp(key, "CacheDir") == 0) {
			setrepeatingoption(value, "CacheDir", &(config->cachedirs));
		} else if(strcmp(key, "HookDir") == 0) {
			setrepeatingoption(value, "HookDir", &(config->hookdirs));
		} else if(strcmp(key, "Architecture") == 0) {
			alpm_list_t *i, *arches = NULL;
			setrepeatingoption(value, "Architecture", &arches);
			for(i = arches; i; i = alpm_list_next(i)) {
				config_add_architecture(i->data);
			}
			alpm_list_free(arches);
		} else if(strcmp(key, "DBPath") == 0) {
			/* don't overwrite a path specified on the command line */
			if(!config->dbpath) {
				config->dbpath = strdup(value);
				pm_printf(ALPM_LOG_DEBUG, "config: dbpath: %s\n", value);
			}
		} else if(strcmp(key, "RootDir") == 0) {
			/* don't overwrite a path specified on the command line */
			if(!config->rootdir) {
				config->rootdir = strdup(value);
				pm_printf(ALPM_LOG_DEBUG, "config: rootdir: %s\n", value);
			}
		} else if(strcmp(key, "GPGDir") == 0) {
			if(!config->gpgdir) {
				config->gpgdir = strdup(value);
				pm_printf(ALPM_LOG_DEBUG, "config: gpgdir: %s\n", value);
			}
		} else if(strcmp(key, "LogFile") == 0) {
			if(!config->logfile) {
				config->logfile = strdup(value);
				pm_printf(ALPM_LOG_DEBUG, "config: logfile: %s\n", value);
			}
		} else if(strcmp(key, "XferCommand") == 0) {
			char **c;
			if((config->xfercommand_argv = wordsplit(value)) == NULL) {
				pm_printf(ALPM_LOG_ERROR,
						_("config file %s, line %d: invalid value for '%s' : '%s'\n"),
						file, linenum, "XferCommand", value);
				return 1;
			}
			config->xfercommand_argc = 0;
			for(c = config->xfercommand_argv; *c; c++) {
				config->xfercommand_argc++;
			}
			config->xfercommand = strdup(value);
			pm_printf(ALPM_LOG_DEBUG, "config: xfercommand: %s\n", value);
		} else if(strcmp(key, "CleanMethod") == 0) {
			alpm_list_t *methods = NULL;
			setrepeatingoption(value, "CleanMethod", &methods);
			if(process_cleanmethods(methods, file, linenum)) {
				FREELIST(methods);
				return 1;
			}
			FREELIST(methods);
		} else if(strcmp(key, "SigLevel") == 0) {
			alpm_list_t *values = NULL;
			setrepeatingoption(value, "SigLevel", &values);
			if(process_siglevel(values, &config->siglevel,
						&config->siglevel_mask, file, linenum)) {
				FREELIST(values);
				return 1;
			}
			FREELIST(values);
		} else if(strcmp(key, "LocalFileSigLevel") == 0) {
			alpm_list_t *values = NULL;
			setrepeatingoption(value, "LocalFileSigLevel", &values);
			if(process_siglevel(values, &config->localfilesiglevel,
						&config->localfilesiglevel_mask, file, linenum)) {
				FREELIST(values);
				return 1;
			}
			FREELIST(values);
		} else if(strcmp(key, "RemoteFileSigLevel") == 0) {
			alpm_list_t *values = NULL;
			setrepeatingoption(value, "RemoteFileSigLevel", &values);
			if(process_siglevel(values, &config->remotefilesiglevel,
						&config->remotefilesiglevel_mask, file, linenum)) {
				FREELIST(values);
				return 1;
			}
			FREELIST(values);
		} else if(strcmp(key, "ParallelDownloads") == 0) {
			long number;
			int err;

			err = parse_number(value, &number);
			if(err) {
				pm_printf(ALPM_LOG_ERROR,
						_("config file %s, line %d: invalid value for '%s' : '%s'\n"),
						file, linenum, "ParallelDownloads", value);
				return 1;
			}

			if(number < 1) {
				pm_printf(ALPM_LOG_ERROR,
						_("config file %s, line %d: value for '%s' has to be positive : '%s'\n"),
						file, linenum, "ParallelDownloads", value);
				return 1;
			}

			if(number > INT_MAX) {
				pm_printf(ALPM_LOG_ERROR,
						_("config file %s, line %d: value for '%s' is too large : '%s'\n"),
						file, linenum, "ParallelDownloads", value);
				return 1;
			}

			config->parallel_downloads = number;
		} else {
			pm_printf(ALPM_LOG_WARNING,
					_("config file %s, line %d: directive '%s' in section '%s' not recognized.\n"),
					file, linenum, key, "options");
		}

	}
	return 0;
}

static char *replace_server_vars(config_t *c, config_repo_t *r, const char *s)
{
	if(c->architectures == NULL && strstr(s, "$arch")) {
		pm_printf(ALPM_LOG_ERROR,
				_("mirror '%s' contains the '%s' variable, but no '%s' is defined.\n"),
				s, "$arch", "Architecture");
		return NULL;
	}

	/* use first specified architecture */
	if(c->architectures) {
		char *temp, *replaced;
		alpm_list_t *i = config->architectures;
		const char *arch = i->data;

		replaced = strreplace(s, "$arch", arch);

		temp = replaced;
		replaced = strreplace(temp, "$repo", r->name);
		free(temp);

		return replaced;
	} else {
		return strreplace(s, "$repo", r->name);
	}
}

static int _add_mirror(alpm_db_t *db, char *value)
{
	if(alpm_db_add_server(db, value) != 0) {
		/* pm_errno is set by alpm_db_setserver */
		pm_printf(ALPM_LOG_ERROR, _("could not add server URL to database '%s': %s (%s)\n"),
				alpm_db_get_name(db), value, alpm_strerror(alpm_errno(config->handle)));
		return 1;
	}

	return 0;
}

static int register_repo(config_repo_t *repo)
{
	alpm_list_t *i;
	alpm_db_t *db;

	db = alpm_register_syncdb(config->handle, repo->name, repo->siglevel);
	if(db == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("could not register '%s' database (%s)\n"),
				repo->name, alpm_strerror(alpm_errno(config->handle)));
		return 1;
	}

	pm_printf(ALPM_LOG_DEBUG, "setting usage of %d for %s repository\n",
			repo->usage, repo->name);
	alpm_db_set_usage(db, repo->usage);

	for(i = repo->servers; i; i = alpm_list_next(i)) {
		if(_add_mirror(db, i->data) != 0) {
			return 1;
		}
	}

	return 0;
}

/** Sets up libalpm global stuff in one go. Called after the command line
 * and initial config file parsing. Once this is complete, we can see if any
 * paths were defined. If a rootdir was defined and nothing else, we want all
 * of our paths to live under the rootdir that was specified. Safe to call
 * multiple times (will only do anything the first time).
 */
static int setup_libalpm(void)
{
	int ret = 0;
	alpm_errno_t err;
	alpm_handle_t *handle;
	alpm_list_t *i;

	pm_printf(ALPM_LOG_DEBUG, "setup_libalpm called\n");

	/* initialize library */
	handle = alpm_initialize(config->rootdir, config->dbpath, &err);
	if(!handle) {
		pm_printf(ALPM_LOG_ERROR, _("failed to initialize alpm library:\n(root: %s, dbpath: %s)\n%s\n"),
		        config->rootdir, config->dbpath, alpm_strerror(err));
		if(err == ALPM_ERR_DB_VERSION) {
			fprintf(stderr, _("try running pacman-db-upgrade\n"));
		}
		return -1;
	}
	config->handle = handle;

	alpm_option_set_logcb(handle, cb_log, NULL);
	alpm_option_set_dlcb(handle, cb_download, NULL);
	alpm_option_set_eventcb(handle, cb_event, NULL);
	alpm_option_set_questioncb(handle, cb_question, NULL);
	alpm_option_set_progresscb(handle, cb_progress, NULL);

	if(config->op == PM_OP_FILES) {
		alpm_option_set_dbext(handle, ".files");
	}

	ret = alpm_option_set_logfile(handle, config->logfile);
	if(ret != 0) {
		pm_printf(ALPM_LOG_ERROR, _("problem setting logfile '%s' (%s)\n"),
				config->logfile, alpm_strerror(alpm_errno(handle)));
		return ret;
	}

	/* Set GnuPG's home directory. This is not relative to rootdir, even if
	 * rootdir is defined. Reasoning: gpgdir contains configuration data. */
	ret = alpm_option_set_gpgdir(handle, config->gpgdir);
	if(ret != 0) {
		pm_printf(ALPM_LOG_ERROR, _("problem setting gpgdir '%s' (%s)\n"),
				config->gpgdir, alpm_strerror(alpm_errno(handle)));
		return ret;
	}

	/* Set user hook directory. This is not relative to rootdir, even if
	 * rootdir is defined. Reasoning: hookdir contains configuration data. */
	/* add hook directories 1-by-1 to avoid overwriting the system directory */
	for(i = config->hookdirs; i; i = alpm_list_next(i)) {
		if((ret = alpm_option_add_hookdir(handle, i->data)) != 0) {
			pm_printf(ALPM_LOG_ERROR, _("problem adding hookdir '%s' (%s)\n"),
					(char *) i->data, alpm_strerror(alpm_errno(handle)));
			return ret;
		}
	}

	alpm_option_set_cachedirs(handle, config->cachedirs);

	alpm_option_set_overwrite_files(handle, config->overwrite_files);

	alpm_option_set_default_siglevel(handle, config->siglevel);

	alpm_option_set_local_file_siglevel(handle, config->localfilesiglevel);
	alpm_option_set_remote_file_siglevel(handle, config->remotefilesiglevel);

	for(i = config->repos; i; i = alpm_list_next(i)) {
		register_repo(i->data);
	}

	if(config->xfercommand) {
		alpm_option_set_fetchcb(handle, download_with_xfercommand, NULL);
	} else if(!(alpm_capabilities() & ALPM_CAPABILITY_DOWNLOADER)) {
		pm_printf(ALPM_LOG_WARNING, _("no '%s' configured\n"), "XferCommand");
	}

	alpm_option_set_architectures(handle, config->architectures);
	alpm_option_set_checkspace(handle, config->checkspace);
	alpm_option_set_usesyslog(handle, config->usesyslog);

	alpm_option_set_ignorepkgs(handle, config->ignorepkg);
	alpm_option_set_ignoregroups(handle, config->ignoregrp);
	alpm_option_set_noupgrades(handle, config->noupgrade);
	alpm_option_set_noextracts(handle, config->noextract);

	alpm_option_set_disable_dl_timeout(handle, config->disable_dl_timeout);
	alpm_option_set_parallel_downloads(handle, config->parallel_downloads);

	for(i = config->assumeinstalled; i; i = i->next) {
		char *entry = i->data;
		alpm_depend_t *dep = alpm_dep_from_string(entry);
		if(!dep) {
			return 1;
		}
		pm_printf(ALPM_LOG_DEBUG, "parsed assume installed: %s %s\n", dep->name, dep->version);

		ret = alpm_option_add_assumeinstalled(handle, dep);
		alpm_dep_free(dep);
		if(ret) {
			pm_printf(ALPM_LOG_ERROR, _("Failed to pass %s entry to libalpm"), "assume-installed");
			return ret;
		}
	 }

	return 0;
}

/**
 * Allows parsing in advance of an entire config section before we start
 * calling library methods.
 */
struct section_t {
	const char *name;
	config_repo_t *repo;
	int depth;
};

static int process_usage(alpm_list_t *values, int *usage,
		const char *file, int linenum)
{
	alpm_list_t *i;
	int level = *usage;
	int ret = 0;

	for(i = values; i; i = i->next) {
		char *key = i->data;

		if(strcmp(key, "Sync") == 0) {
			level |= ALPM_DB_USAGE_SYNC;
		} else if(strcmp(key, "Search") == 0) {
			level |= ALPM_DB_USAGE_SEARCH;
		} else if(strcmp(key, "Install") == 0) {
			level |= ALPM_DB_USAGE_INSTALL;
		} else if(strcmp(key, "Upgrade") == 0) {
			level |= ALPM_DB_USAGE_UPGRADE;
		} else if(strcmp(key, "All") == 0) {
			level |= ALPM_DB_USAGE_ALL;
		} else {
			pm_printf(ALPM_LOG_ERROR,
					_("config file %s, line %d: '%s' option '%s' not recognized\n"),
					file, linenum, "Usage", key);
			ret = 1;
		}
	}

	*usage = level;

	return ret;
}


static int _parse_repo(const char *key, char *value, const char *file,
		int line, struct section_t *section)
{
	int ret = 0;
	config_repo_t *repo = section->repo;

#define CHECK_VALUE(val) do { \
	if(!val) { \
		pm_printf(ALPM_LOG_ERROR, _("config file %s, line %d: directive '%s' needs a value\n"), \
				file, line, key); \
		return 1; \
	} \
} while(0)

	if(strcmp(key, "Server") == 0) {
		CHECK_VALUE(value);
		repo->servers = alpm_list_add(repo->servers, strdup(value));
	} else if(strcmp(key, "SigLevel") == 0) {
		CHECK_VALUE(value);
		alpm_list_t *values = NULL;
		setrepeatingoption(value, "SigLevel", &values);
		if(values) {
			ret = process_siglevel(values, &repo->siglevel,
					&repo->siglevel_mask, file, line);
			FREELIST(values);
		}
	} else if(strcmp(key, "Usage") == 0) {
		CHECK_VALUE(value);
		alpm_list_t *values = NULL;
		setrepeatingoption(value, "Usage", &values);
		if(values) {
			if(process_usage(values, &repo->usage, file, line)) {
				FREELIST(values);
				return 1;
			}
			FREELIST(values);
		}
	} else {
		pm_printf(ALPM_LOG_WARNING,
				_("config file %s, line %d: directive '%s' in section '%s' not recognized.\n"),
				file, line, key, repo->name);
	}

#undef CHECK_VALUE

	return ret;
}

static int _parse_directive(const char *file, int linenum, const char *name,
		char *key, char *value, void *data);

static int process_include(const char *value, void *data,
		const char *file, int linenum)
{
	glob_t globbuf;
	int globret, ret = 0;
	size_t gindex;
	struct section_t *section = data;
	static const int config_max_recursion = 10;

	if(value == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("config file %s, line %d: directive '%s' needs a value\n"),
				file, linenum, "Include");
		return 1;
	}

	if(section->depth >= config_max_recursion) {
		pm_printf(ALPM_LOG_ERROR,
				_("config parsing exceeded max recursion depth of %d.\n"),
				config_max_recursion);
		return 1;
	}

	section->depth++;

	/* Ignore include failures... assume non-critical */
	globret = glob(value, GLOB_NOCHECK, NULL, &globbuf);
	switch(globret) {
		case GLOB_NOSPACE:
			pm_printf(ALPM_LOG_DEBUG,
					"config file %s, line %d: include globbing out of space\n",
					file, linenum);
			break;
		case GLOB_ABORTED:
			pm_printf(ALPM_LOG_DEBUG,
					"config file %s, line %d: include globbing read error for %s\n",
					file, linenum, value);
			break;
		case GLOB_NOMATCH:
			pm_printf(ALPM_LOG_DEBUG,
					"config file %s, line %d: no include found for %s\n",
					file, linenum, value);
			break;
		default:
			for(gindex = 0; gindex < globbuf.gl_pathc; gindex++) {
				pm_printf(ALPM_LOG_DEBUG, "config file %s, line %d: including %s\n",
						file, linenum, globbuf.gl_pathv[gindex]);
				ret = parse_ini(globbuf.gl_pathv[gindex], _parse_directive, data);
				if(ret) {
					goto cleanup;
				}
			}
			break;
	}

cleanup:
	section->depth--;
	globfree(&globbuf);
	return ret;
}

static int _parse_directive(const char *file, int linenum, const char *name,
		char *key, char *value, void *data)
{
	struct section_t *section = data;
	if(!name && !key && !value) {
		pm_printf(ALPM_LOG_ERROR, _("config file %s could not be read: %s\n"),
				file, strerror(errno));
		return 1;
	} else if(!key && !value) {
		section->name = name;
		pm_printf(ALPM_LOG_DEBUG, "config: new section '%s'\n", name);
		if(strcmp(name, "options") == 0) {
			section->repo = NULL;
		} else {
			section->repo = calloc(sizeof(config_repo_t), 1);
			section->repo->name = strdup(name);
			section->repo->siglevel = ALPM_SIG_USE_DEFAULT;
			section->repo->usage = 0;
			config->repos = alpm_list_add(config->repos, section->repo);
		}
		return 0;
	}

	if(strcmp(key, "Include") == 0) {
		return process_include(value, data, file, linenum);
	}

	if(section->name == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("config file %s, line %d: All directives must belong to a section.\n"),
				file, linenum);
		return 1;
	}

	if(!section->repo) {
		/* we are either in options ... */
		return _parse_options(key, value, file, linenum);
	} else {
		/* ... or in a repo section */
		return _parse_repo(key, value, file, linenum, section);
	}
}

int setdefaults(config_t *c)
{
	alpm_list_t *i;

#define SETDEFAULT(opt, val) if(!opt) { opt = val; if(!opt) { return -1; } }

	if(c->rootdir) {
		char path[PATH_MAX];
		if(!c->dbpath) {
			snprintf(path, PATH_MAX, "%s/%s", c->rootdir, &DBPATH[1]);
			SETDEFAULT(c->dbpath, strdup(path));
		}
		if(!c->logfile) {
			snprintf(path, PATH_MAX, "%s/%s", c->rootdir, &LOGFILE[1]);
			SETDEFAULT(c->logfile, strdup(path));
		}
	} else {
		SETDEFAULT(c->rootdir, strdup(ROOTDIR));
		SETDEFAULT(c->dbpath, strdup(DBPATH));
	}

	SETDEFAULT(c->logfile, strdup(LOGFILE));
	SETDEFAULT(c->gpgdir, strdup(GPGDIR));
	SETDEFAULT(c->cachedirs, alpm_list_add(NULL, strdup(CACHEDIR)));
	SETDEFAULT(c->hookdirs, alpm_list_add(NULL, strdup(HOOKDIR)));
	SETDEFAULT(c->cleanmethod, PM_CLEAN_KEEPINST);

	c->localfilesiglevel = merge_siglevel(c->siglevel,
			c->localfilesiglevel, c->localfilesiglevel_mask);
	c->remotefilesiglevel = merge_siglevel(c->siglevel,
			c->remotefilesiglevel, c->remotefilesiglevel_mask);

	for(i = c->repos; i; i = i->next) {
		config_repo_t *r = i->data;
		alpm_list_t *j;
		SETDEFAULT(r->usage, ALPM_DB_USAGE_ALL);
		r->siglevel = merge_siglevel(c->siglevel, r->siglevel, r->siglevel_mask);
		for(j = r->servers; j; j = j->next) {
			char *newurl = replace_server_vars(c, r, j->data);
			if(newurl == NULL) {
				return -1;
			} else {
				free(j->data);
				j->data = newurl;
			}
		}
	}

#undef SETDEFAULT

	return 0;
}

int parseconfigfile(const char *file)
{
	struct section_t section = {0};
	pm_printf(ALPM_LOG_DEBUG, "config: attempting to read file %s\n", file);
	return parse_ini(file, _parse_directive, &section);
}

/** Parse a configuration file.
 * @param file path to the config file
 * @return 0 on success, non-zero on error
 */
int parseconfig(const char *file)
{
	int ret;
	if((ret = parseconfigfile(file))) {
		return ret;
	}
	if((ret = setdefaults(config))) {
		return ret;
	}
	pm_printf(ALPM_LOG_DEBUG, "config: finished parsing %s\n", file);
	if((ret = setup_libalpm())) {
		return ret;
	}
	alpm_list_free_inner(config->repos, (alpm_list_fn_free) config_repo_free);
	alpm_list_free(config->repos);
	config->repos = NULL;
	return ret;
}
