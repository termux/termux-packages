/*
 *  pacman-conf.c - parse pacman configuration files
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

#include <getopt.h>
#include <string.h>
#include "conf.h"
#include "util.h"

const char *myname = "pacman-conf", *myver = "1.0.0";

alpm_list_t *directives = NULL;
char sep = '\n', *repo_name = NULL;
const char *config_file = NULL;
int repo_list = 0, verbose = 0;

static void cleanup(void)
{
	alpm_list_free(directives);
	config_free(config);
}

static void usage(int ret)
{
	FILE *stream = (ret ? stderr : stdout);
	fputs(_("pacman-conf - query pacman's configuration file\n"), stream);
	fputs(_("usage:  pacman-conf [options] [<directive>...]\n"), stream);
	fputs(_("        pacman-conf (--repo-list|--help|--version)\n"), stream);
	fputs(_("options:\n"), stream);
	fputs(_("  -c, --config=<path>  set an alternate configuration file\n"), stream);
	fputs(_("  -R, --rootdir=<path> set an alternate installation root\n"), stream);
	fputs(_("  -r, --repo=<remote>  query options for a specific repo\n"), stream);
	fputs(_("  -v, --verbose        always show directive names\n"), stream);
	fputs(_("  -l, --repo-list      list configured repositories\n"), stream);
	fputs(_("  -h, --help           display this help information\n"), stream);
	fputs(_("  -V, --version        display version information\n"), stream);
	cleanup();
	exit(ret);
}

static void parse_opts(int argc, char **argv)
{
	int c;
	config_file = CONFFILE;

	const char *short_opts = "c:hlR:r:Vv";
	struct option long_opts[] = {
		{ "config"    , required_argument , NULL , 'c' },
		{ "rootdir"   , required_argument , NULL , 'R' },
		{ "repo"      , required_argument , NULL , 'r' },
		{ "repo-list" , no_argument       , NULL , 'l' },
		{ "verbose"   , no_argument       , NULL , 'v' },
		{ "help"      , no_argument       , NULL , 'h' },
		{ "version"   , no_argument       , NULL , 'V' },
		{ 0, 0, 0, 0 },
	};

	while((c = getopt_long(argc, argv, short_opts, long_opts, NULL)) != -1) {
		switch(c) {
			case 'c':
				config_file = optarg;
				break;
			case 'R':
				free(config->rootdir);
				if ((config->rootdir = strdup(optarg)) == NULL) {
					fprintf(stderr, _("error setting rootdir '%s': out of memory\n"), optarg);
					cleanup();
					exit(1);
				}
				break;
			case 'l':
				repo_list = 1;
				break;
			case 'r':
				repo_name = optarg;
				break;
			case 'v':
				verbose = 1;
				break;
			case 'h':
				usage(0);
				break;
			case 'V':
				printf("%s v%s\n", myname, myver);
				cleanup();
				exit(0);
				break;
			case '?':
			default:
				usage(1);
				break;
		}
	}

	if(parseconfigfile(config_file) != 0 || setdefaults(config) != 0) {
		fprintf(stderr, _("error parsing '%s'\n"), config_file);
		cleanup();
		exit(1);
	}
}

static void list_repos(void)
{
	alpm_list_t *r;
	for(r = config->repos; r; r = r->next) {
		config_repo_t *repo = r->data;
		if(!repo_name || strcmp(repo->name, repo_name) == 0) {
			printf("%s%c", repo->name, sep);
		}
	}
}

static void show_bool(const char *directive, short unsigned int val)
{
	if(val) {
		printf("%s%c", directive, sep);
	}
}

static void show_str(const char *directive, const char *val)
{
	if(!val) {
		return;
	}
	if(verbose) {
		printf("%s = ", directive);
	}
	printf("%s%c", val, sep);
}

static void show_int(const char *directive, unsigned int val)
{
	if (verbose) {
		printf("%s = ", directive);
	}
	printf("%u%c", val, sep);
}

static void show_list_str(const char *directive, alpm_list_t *list)
{
	alpm_list_t *i;
	for(i = list; i; i = i->next) {
		show_str(directive, i->data);
	}
}

static void show_cleanmethod(const char *directive, unsigned int method)
{
	if(method & PM_CLEAN_KEEPINST) {
		show_str(directive, "KeepInstalled");
	}
	if(method & PM_CLEAN_KEEPCUR) {
		show_str(directive, "KeepCurrent");
	}
}

static void show_siglevel(const char *directive, alpm_siglevel_t level, int pkgonly)
{
	if(level == ALPM_SIG_USE_DEFAULT) {
		return;
	}

	if(level & ALPM_SIG_PACKAGE) {
		if(level & ALPM_SIG_PACKAGE_OPTIONAL) {
			show_str(directive, "PackageOptional");
		} else {
			show_str(directive, "PackageRequired");
		}

		if(level & ALPM_SIG_PACKAGE_UNKNOWN_OK) {
			show_str(directive, "PackageTrustAll");
		} else {
			show_str(directive, "PackageTrustedOnly");
		}
	} else {
		show_str(directive, "PackageNever");
	}

	if(pkgonly) {
		return;
	}

	if(level & ALPM_SIG_DATABASE) {
		if(level & ALPM_SIG_DATABASE_OPTIONAL) {
			show_str(directive, "DatabaseOptional");
		} else {
			show_str(directive, "DatabaseRequired");
		}

		if(level & ALPM_SIG_DATABASE_UNKNOWN_OK) {
			show_str(directive, "DatabaseTrustAll");
		} else {
			show_str(directive, "DatabaseTrustedOnly");
		}
	} else {
		show_str(directive, "DatabaseNever");
	}
}

static void show_usage(const char *directive, int usage)
{
	if(usage == ALPM_DB_USAGE_ALL) {
		show_str(directive, "All");
	} else {
		if(usage & ALPM_DB_USAGE_SYNC) {
			show_str(directive, "Sync");
		}
		if(usage & ALPM_DB_USAGE_SEARCH) {
			show_str(directive, "Search");
		}
		if(usage & ALPM_DB_USAGE_INSTALL) {
			show_str(directive, "Install");
		}
		if(usage & ALPM_DB_USAGE_UPGRADE) {
			show_str(directive, "Upgrade");
		}
	}
}

static void dump_repo(config_repo_t *repo)
{
	show_usage("Usage", repo->usage);
	show_siglevel("SigLevel", repo->siglevel, 0);
	show_list_str("Server", repo->servers);
}

static void dump_config(void)
{
	alpm_list_t *i;

	printf("[options]%c", sep);

	show_str("RootDir", config->rootdir);
	show_str("DBPath", config->dbpath);
	show_list_str("CacheDir", config->cachedirs);
	show_list_str("HookDir", config->hookdirs);
	show_str("GPGDir", config->gpgdir);
	show_str("LogFile", config->logfile);

	show_list_str("HoldPkg", config->holdpkg);
	show_list_str("IgnorePkg", config->ignorepkg);
	show_list_str("IgnoreGroup", config->ignoregrp);
	show_list_str("NoUpgrade", config->noupgrade);
	show_list_str("NoExtract", config->noextract);

	show_list_str("Architecture", config->architectures);
	show_str("XferCommand", config->xfercommand);

	show_bool("UseSyslog", config->usesyslog);
	show_bool("Color", config->color);
	show_bool("CheckSpace", config->checkspace);
	show_bool("VerbosePkgLists", config->verbosepkglists);
	show_bool("DisableDownloadTimeout", config->disable_dl_timeout);
	show_bool("ILoveCandy", config->chomp);
	show_bool("NoProgressBar", config->noprogressbar);

	show_int("ParallelDownloads", config->parallel_downloads);

	show_cleanmethod("CleanMethod", config->cleanmethod);

	show_siglevel("SigLevel", config->siglevel, 0);
	show_siglevel("LocalFileSigLevel", config->localfilesiglevel, 1);
	show_siglevel("RemoteFileSigLevel", config->remotefilesiglevel, 1);

	for(i = config->repos; i; i = i->next) {
		config_repo_t *repo = i->data;
		printf("[%s]%c", repo->name, sep);
		dump_repo(repo);
	}
}

static int list_repo_directives(void)
{
	int ret = 0;
	alpm_list_t *i;
	config_repo_t *repo = NULL;

	for(i = config->repos; i; i = i->next) {
		if(strcmp(repo_name, ((config_repo_t*) i->data)->name) == 0) {
			repo = i->data;
			break;
		}
	}

	if(!repo) {
		fprintf(stderr, _("error: repo '%s' not configured\n"), repo_name);
		return 1;
	}

	if(!directives) {
		dump_repo(repo);
		return 0;
	}

	for(i = directives; i; i = i->next) {
		if(strcasecmp(i->data, "Server") == 0) {
			show_list_str("Server", repo->servers);
		} else if(strcasecmp(i->data, "SigLevel") == 0) {
			show_siglevel("SigLevel", repo->siglevel, 0);
		} else if(strcasecmp(i->data, "Usage") == 0) {
			show_usage("Usage", repo->usage);
		} else if(strcasecmp(i->data, "Include") == 0) {
			fprintf(stderr,_("warning: '%s' directives cannot be queried\n"), "Include");
			ret = 1;
		} else {
			fprintf(stderr, _("warning: unknown directive '%s'\n"), (char*) i->data);
			ret = 1;
		}
	}

	return ret;
}

static int list_directives(void)
{
	int ret = 0;
	alpm_list_t *i;

	if(!directives) {
		dump_config();
		return 0;
	}

	for(i = directives; i; i = i->next) {
		if(strcasecmp(i->data, "RootDir") == 0) {
			show_str("RootDir", config->rootdir);
		} else if(strcasecmp(i->data, "DBPath") == 0) {
			show_str("DBPath", config->dbpath);
		} else if(strcasecmp(i->data, "CacheDir") == 0) {
			show_list_str("CacheDir", config->cachedirs);
		} else if(strcasecmp(i->data, "HookDir") == 0) {
			show_list_str("HookDir", config->hookdirs);
		} else if(strcasecmp(i->data, "GPGDir") == 0) {
			show_str("GPGDir", config->gpgdir);
		} else if(strcasecmp(i->data, "LogFile") == 0) {
			show_str("LogFile", config->logfile);

		} else if(strcasecmp(i->data, "HoldPkg") == 0) {
			show_list_str("HoldPkg", config->holdpkg);
		} else if(strcasecmp(i->data, "IgnorePkg") == 0) {
			show_list_str("IgnorePkg", config->ignorepkg);
		} else if(strcasecmp(i->data, "IgnoreGroup") == 0) {
			show_list_str("IgnoreGroup", config->ignoregrp);
		} else if(strcasecmp(i->data, "NoUpgrade") == 0) {
			show_list_str("NoUpgrade", config->noupgrade);
		} else if(strcasecmp(i->data, "NoExtract") == 0) {
			show_list_str("NoExtract", config->noextract);


		} else if(strcasecmp(i->data, "Architecture") == 0) {
			show_list_str("Architecture", config->architectures);
		} else if(strcasecmp(i->data, "XferCommand") == 0) {
			show_str("XferCommand", config->xfercommand);

		} else if(strcasecmp(i->data, "UseSyslog") == 0) {
			show_bool("UseSyslog", config->usesyslog);
		} else if(strcasecmp(i->data, "Color") == 0) {
			show_bool("Color", config->color);
		} else if(strcasecmp(i->data, "CheckSpace") == 0) {
			show_bool("CheckSpace", config->checkspace);
		} else if(strcasecmp(i->data, "VerbosePkgLists") == 0) {
			show_bool("VerbosePkgLists", config->verbosepkglists);
		} else if(strcasecmp(i->data, "DisableDownloadTimeout") == 0) {
			show_bool("DisableDownloadTimeout", config->disable_dl_timeout);
		} else if(strcasecmp(i->data, "ILoveCandy") == 0) {
			show_bool("ILoveCandy", config->chomp);
		} else if(strcasecmp(i->data, "NoProgressBar") == 0) {
			show_bool("NoProgressBar", config->noprogressbar);

		} else if(strcasecmp(i->data, "ParallelDownloads") == 0) {
			show_int("ParallelDownloads", config->parallel_downloads);

		} else if(strcasecmp(i->data, "CleanMethod") == 0) {
			show_cleanmethod("CleanMethod", config->cleanmethod);

		} else if(strcasecmp(i->data, "SigLevel") == 0) {
			show_siglevel("SigLevel", config->siglevel, 0);
		} else if(strcasecmp(i->data, "LocalFileSigLevel") == 0) {
			show_siglevel("LocalFileSigLevel", config->localfilesiglevel, 1);
		} else if(strcasecmp(i->data, "RemoteFileSigLevel") == 0) {
			show_siglevel("RemoteFileSigLevel", config->remotefilesiglevel, 1);

		} else if(strcasecmp(i->data, "Include") == 0) {
			fprintf(stderr, _("warning: '%s' directives cannot be queried\n"), "Include");
			ret = 1;
		} else {
			fprintf(stderr, _("warning: unknown directive '%s'\n"), (char*) i->data);
			ret = 1;
		}
	}

	return ret;
}

int main(int argc, char **argv)
{
	int ret = 0;

	if(!(config = config_new())) {
		/* config_new prints the appropriate error message */
		return 1;
	}
	parse_opts(argc, argv);
	if(!config) {
		ret = 1;
		goto cleanup;
	}

		/* i18n init */
#if defined(ENABLE_NLS)
	bindtextdomain(PACKAGE, LOCALEDIR);
#endif

	for(; optind < argc; optind++) {
		directives = alpm_list_add(directives, argv[optind]);
	}

	if(alpm_list_count(directives) != 1) {
		verbose = 1;
	}

	if(repo_list) {
		if(directives) {
			fprintf(stderr, _("error: directives may not be specified with %s\n"), "--repo-list");
			ret = 1;
			goto cleanup;
		}
		list_repos();
	} else if(repo_name) {
		ret = list_repo_directives();
	} else {
		ret = list_directives();
	}

cleanup:
	cleanup();

	return ret;
}

/* vim: set ts=2 sw=2 noet: */
