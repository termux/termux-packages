/*
 *  sync.c
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <unistd.h>
#include <errno.h>
#include <dirent.h>
#include <sys/stat.h>
#include <fnmatch.h>

#include <alpm.h>
#include <alpm_list.h>

/* pacman */
#include "pacman.h"
#include "util.h"
#include "package.h"
#include "callback.h"
#include "conf.h"

static int unlink_verbose(const char *pathname, int ignore_missing)
{
	int ret = unlink(pathname);
	if(ret) {
		if(ignore_missing && errno == ENOENT) {
			ret = 0;
		} else {
			pm_printf(ALPM_LOG_ERROR, _("could not remove %s: %s\n"),
					pathname, strerror(errno));
		}
	}
	return ret;
}

static int sync_cleandb(const char *dbpath)
{
	DIR *dir;
	struct dirent *ent;
	alpm_list_t *syncdbs;
	int ret = 0;

	dir = opendir(dbpath);
	if(dir == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("could not access database directory\n"));
		return 1;
	}

	syncdbs = alpm_get_syncdbs(config->handle);

	rewinddir(dir);
	/* step through the directory one file at a time */
	while((ent = readdir(dir)) != NULL) {
		char path[PATH_MAX];
		struct stat buf;
		int found = 0;
		const char *dname = ent->d_name;
		char *dbname;
		size_t len;
		alpm_list_t *i;

		if(strcmp(dname, ".") == 0 || strcmp(dname, "..") == 0) {
			continue;
		}

		/* build the full path */
		snprintf(path, PATH_MAX, "%s%s", dbpath, dname);

		/* remove all non-skipped directories and non-database files */
		if(stat(path, &buf) == -1) {
			pm_printf(ALPM_LOG_ERROR, _("could not remove %s: %s\n"),
					path, strerror(errno));
		}
		if(S_ISDIR(buf.st_mode)) {
			if(rmrf(path)) {
				pm_printf(ALPM_LOG_ERROR, _("could not remove %s: %s\n"),
						path, strerror(errno));
			}
			continue;
		}

		len = strlen(dname);
		if(len > 3 && strcmp(dname + len - 3, ".db") == 0) {
			dbname = strndup(dname, len - 3);
		} else if(len > 7 && strcmp(dname + len - 7, ".db.sig") == 0) {
			dbname = strndup(dname, len - 7);
		} else if(len > 6 && strcmp(dname + len - 6, ".files") == 0) {
			dbname = strndup(dname, len - 6);
		} else if(len > 10 && strcmp(dname + len - 10, ".files.sig") == 0) {
			dbname = strndup(dname, len - 10);
		} else {
			ret += unlink_verbose(path, 0);
			continue;
		}

		for(i = syncdbs; i && !found; i = alpm_list_next(i)) {
			alpm_db_t *db = i->data;
			found = !strcmp(dbname, alpm_db_get_name(db));
		}

		/* We have a file that doesn't match any syncdb. */
		if(!found) {
			ret += unlink_verbose(path, 0);
		}

		free(dbname);
	}
	closedir(dir);
	return ret;
}

static int sync_cleandb_all(void)
{
	const char *dbpath;
	char *syncdbpath;
	int ret = 0;

	dbpath = alpm_option_get_dbpath(config->handle);
	printf(_("Database directory: %s\n"), dbpath);
	if(!yesno(_("Do you want to remove unused repositories?"))) {
		return 0;
	}
	printf(_("removing unused sync repositories...\n"));

	if(asprintf(&syncdbpath, "%s%s", dbpath, "sync/") < 0) {
		ret += 1;
		return ret;
	}
	ret += sync_cleandb(syncdbpath);
	free(syncdbpath);

	return ret;
}

static int sync_cleancache(int level)
{
	alpm_list_t *i;
	alpm_list_t *sync_dbs = alpm_get_syncdbs(config->handle);
	alpm_db_t *db_local = alpm_get_localdb(config->handle);
	alpm_list_t *cachedirs = alpm_option_get_cachedirs(config->handle);
	int ret = 0;

	if(!config->cleanmethod) {
		/* default to KeepInstalled if user did not specify */
		config->cleanmethod = PM_CLEAN_KEEPINST;
	}

	if(level == 1) {
		printf(_("Packages to keep:\n"));
		if(config->cleanmethod & PM_CLEAN_KEEPINST) {
			printf(_("  All locally installed packages\n"));
		}
		if(config->cleanmethod & PM_CLEAN_KEEPCUR) {
			printf(_("  All current sync database packages\n"));
		}
	}
	printf("\n");

	for(i = cachedirs; i; i = alpm_list_next(i)) {
		const char *cachedir = i->data;
		DIR *dir;
		struct dirent *ent;

		printf(_("Cache directory: %s\n"), (const char *)i->data);

		if(level == 1) {
			if(!yesno(_("Do you want to remove all other packages from cache?"))) {
				printf("\n");
				continue;
			}
			printf(_("removing old packages from cache...\n"));
		} else {
			if(!noyes(_("Do you want to remove ALL files from cache?"))) {
				printf("\n");
				continue;
			}
			printf(_("removing all files from cache...\n"));
		}

		dir = opendir(cachedir);
		if(dir == NULL) {
			pm_printf(ALPM_LOG_ERROR,
					_("could not access cache directory %s\n"), cachedir);
			ret++;
			continue;
		}

		rewinddir(dir);
		/* step through the directory one file at a time */
		while((ent = readdir(dir)) != NULL) {
			char path[PATH_MAX];
			int delete = 1;
			alpm_pkg_t *localpkg = NULL, *pkg = NULL;
			const char *local_name, *local_version;

			if(strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0) {
				continue;
			}

			if(level <= 1) {
				static const char *const glob_skips[] = {
					/* skip signature files - they are removed with their package file */
					"*.sig",
					/* skip package databases within the cache directory */
					"*.db*", "*.files*",
					/* skip source packages within the cache directory */
					"*.src.tar.*"
				};
				size_t j;

				for(j = 0; j < ARRAYSIZE(glob_skips); j++) {
					if(fnmatch(glob_skips[j], ent->d_name, 0) == 0) {
						delete = 0;
						break;
					}
				}
				if(delete == 0) {
					continue;
				}
			}

			/* build the full filepath */
			snprintf(path, PATH_MAX, "%s%s", cachedir, ent->d_name);

			/* short circuit for removing all files from cache */
			if(level > 1) {
				ret += unlink_verbose(path, 0);
				continue;
			}

			/* attempt to load the file as a package. if we cannot load the file,
			 * simply skip it and move on. we don't need a full load of the package,
			 * just the metadata. */
			if(alpm_pkg_load(config->handle, path, 0, 0, &localpkg) != 0) {
				pm_printf(ALPM_LOG_DEBUG, "skipping %s, could not load as package\n",
						path);
				continue;
			}
			local_name = alpm_pkg_get_name(localpkg);
			local_version = alpm_pkg_get_version(localpkg);

			if(config->cleanmethod & PM_CLEAN_KEEPINST) {
				/* check if this package is in the local DB */
				pkg = alpm_db_get_pkg(db_local, local_name);
				if(pkg != NULL && alpm_pkg_vercmp(local_version,
							alpm_pkg_get_version(pkg)) == 0) {
					/* package was found in local DB and version matches, keep it */
					pm_printf(ALPM_LOG_DEBUG, "package %s-%s found in local db\n",
							local_name, local_version);
					delete = 0;
				}
			}
			if(config->cleanmethod & PM_CLEAN_KEEPCUR) {
				alpm_list_t *j;
				/* check if this package is in a sync DB */
				for(j = sync_dbs; j && delete; j = alpm_list_next(j)) {
					alpm_db_t *db = j->data;
					pkg = alpm_db_get_pkg(db, local_name);
					if(pkg != NULL && alpm_pkg_vercmp(local_version,
								alpm_pkg_get_version(pkg)) == 0) {
						/* package was found in a sync DB and version matches, keep it */
						pm_printf(ALPM_LOG_DEBUG, "package %s-%s found in sync db\n",
								local_name, local_version);
						delete = 0;
					}
				}
			}
			/* free the local file package */
			alpm_pkg_free(localpkg);

			if(delete) {
				size_t pathlen = strlen(path);
				ret += unlink_verbose(path, 0);
				/* unlink a signature file if present too */
				if(PATH_MAX - 5 >= pathlen) {
					strcpy(path + pathlen, ".sig");
					ret += unlink_verbose(path, 1);
				}
			}
		}
		closedir(dir);
		printf("\n");
	}

	return ret;
}

/* search the sync dbs for a matching package */
static int sync_search(alpm_list_t *syncs, alpm_list_t *targets)
{
	alpm_list_t *i;
	int found = 0;

	for(i = syncs; i; i = alpm_list_next(i)) {
		alpm_db_t *db = i->data;
		int ret = dump_pkg_search(db, targets, 1);

		if(ret == -1) {
			alpm_errno_t err = alpm_errno(config->handle);
			pm_printf(ALPM_LOG_ERROR, "search failed: %s\n", alpm_strerror(err));
			return 1;
		}

		found += !ret;
	}

	return (found == 0);
}

static int sync_group(int level, alpm_list_t *syncs, alpm_list_t *targets)
{
	alpm_list_t *i, *j, *k, *s = NULL;
	int ret = 0;

	if(targets) {
		size_t found;
		for(i = targets; i; i = alpm_list_next(i)) {
			found = 0;
			const char *grpname = i->data;
			for(j = syncs; j; j = alpm_list_next(j)) {
				alpm_db_t *db = j->data;
				alpm_group_t *grp = alpm_db_get_group(db, grpname);

				if(grp) {
					found++;
					/* get names of packages in group */
					for(k = grp->packages; k; k = alpm_list_next(k)) {
						if(!config->quiet) {
							printf("%s %s\n", grpname,
									alpm_pkg_get_name(k->data));
						} else {
							printf("%s\n", alpm_pkg_get_name(k->data));
						}
					}
				}
			}
			if(!found) {
				ret = 1;
			}
		}
	} else {
		ret = 1;
		for(i = syncs; i; i = alpm_list_next(i)) {
			alpm_db_t *db = i->data;

			for(j = alpm_db_get_groupcache(db); j; j = alpm_list_next(j)) {
				alpm_group_t *grp = j->data;
				ret = 0;

				if(level > 1) {
					for(k = grp->packages; k; k = alpm_list_next(k)) {
						printf("%s %s\n", grp->name,
								alpm_pkg_get_name(k->data));
					}
				} else {
					/* print grp names only, no package names */
					if(!alpm_list_find_str (s, grp->name)) {
						s = alpm_list_add (s, grp->name);
						printf("%s\n", grp->name);
					}
				}
			}
		}
		alpm_list_free(s);
	}

	return ret;
}

static int sync_info(alpm_list_t *syncs, alpm_list_t *targets)
{
	alpm_list_t *i, *j, *k;
	int ret = 0;

	if(targets) {
		for(i = targets; i; i = alpm_list_next(i)) {
			const char *target = i->data;
			char *name = strdup(target);
			char *repo, *pkgstr;
			int foundpkg = 0, founddb = 0;

			pkgstr = strchr(name, '/');
			if(pkgstr) {
				repo = name;
				*pkgstr = '\0';
				++pkgstr;
			} else {
				repo = NULL;
				pkgstr = name;
			}

			for(j = syncs; j; j = alpm_list_next(j)) {
				alpm_db_t *db = j->data;
				if(repo && strcmp(repo, alpm_db_get_name(db)) != 0) {
					continue;
				}
				founddb = 1;

				for(k = alpm_db_get_pkgcache(db); k; k = alpm_list_next(k)) {
					alpm_pkg_t *pkg = k->data;

					if(strcmp(alpm_pkg_get_name(pkg), pkgstr) == 0) {
						dump_pkg_full(pkg, config->op_s_info > 1);
						foundpkg = 1;
						break;
					}
				}
			}

			if(!founddb) {
				pm_printf(ALPM_LOG_ERROR,
						_("repository '%s' does not exist\n"), repo);
				ret++;
			}
			if(!foundpkg) {
				pm_printf(ALPM_LOG_ERROR,
						_("package '%s' was not found\n"), target);
				ret++;
			}
			free(name);
		}
	} else {
		for(i = syncs; i; i = alpm_list_next(i)) {
			alpm_db_t *db = i->data;

			for(j = alpm_db_get_pkgcache(db); j; j = alpm_list_next(j)) {
				alpm_pkg_t *pkg = j->data;
				dump_pkg_full(pkg, config->op_s_info > 1);
			}
		}
	}

	return ret;
}

static int sync_list(alpm_list_t *syncs, alpm_list_t *targets)
{
	alpm_list_t *i, *j, *ls = NULL;
	alpm_db_t *db_local = alpm_get_localdb(config->handle);
	int ret = 0;

	if(targets) {
		for(i = targets; i; i = alpm_list_next(i)) {
			const char *repo = i->data;
			alpm_db_t *db = NULL;

			for(j = syncs; j; j = alpm_list_next(j)) {
				alpm_db_t *d = j->data;

				if(strcmp(repo, alpm_db_get_name(d)) == 0) {
					db = d;
					break;
				}
			}

			if(db == NULL) {
				pm_printf(ALPM_LOG_ERROR,
					_("repository \"%s\" was not found.\n"), repo);
				ret = 1;
			}

			ls = alpm_list_add(ls, db);
		}
	} else {
		ls = syncs;
	}

	for(i = ls; i; i = alpm_list_next(i)) {
		alpm_db_t *db = i->data;

		for(j = alpm_db_get_pkgcache(db); j; j = alpm_list_next(j)) {
			alpm_pkg_t *pkg = j->data;

			if(!config->quiet) {
				const colstr_t *colstr = &config->colstr;
				printf("%s%s %s%s %s%s%s", colstr->repo, alpm_db_get_name(db),
						colstr->title, alpm_pkg_get_name(pkg),
						colstr->version, alpm_pkg_get_version(pkg), colstr->nocolor);
				print_installed(db_local, pkg);
				printf("\n");
			} else {
				printf("%s\n", alpm_pkg_get_name(pkg));
			}
		}
	}

	if(targets) {
		alpm_list_free(ls);
	}

	return ret;
}

static alpm_db_t *get_db(const char *dbname)
{
	alpm_list_t *i;
	for(i = alpm_get_syncdbs(config->handle); i; i = i->next) {
		alpm_db_t *db = i->data;
		if(strcmp(alpm_db_get_name(db), dbname) == 0) {
			return db;
		}
	}
	return NULL;
}

static int process_pkg(alpm_pkg_t *pkg)
{
	int ret = alpm_add_pkg(config->handle, pkg);

	if(ret == -1) {
		alpm_errno_t err = alpm_errno(config->handle);
		pm_printf(ALPM_LOG_ERROR, "'%s': %s\n", alpm_pkg_get_name(pkg), alpm_strerror(err));
		return 1;
	}
	config->explicit_adds = alpm_list_add(config->explicit_adds, pkg);
	return 0;
}

static int group_exists(alpm_list_t *dbs, const char *name)
{
	alpm_list_t *i;
	for(i = dbs; i; i = i->next) {
		alpm_db_t *db = i->data;

		if(alpm_db_get_group(db, name)) {
			return 1;
		}
	}

	return 0;
}

static int process_group(alpm_list_t *dbs, const char *group, int error)
{
	int ret = 0;
	alpm_list_t *i;
	alpm_list_t *pkgs = alpm_find_group_pkgs(dbs, group);
	int count = alpm_list_count(pkgs);

	if(!count) {
		if(group_exists(dbs, group)) {
			return 0;
		}

		pm_printf(ALPM_LOG_ERROR, _("target not found: %s\n"), group);
		return 1;
	}

	if(error) {
		/* we already know another target errored. there is no reason to prompt the
		 * user here; we already validated the group name so just move on since we
		 * won't actually be installing anything anyway. */
		goto cleanup;
	}

	if(config->print == 0) {
		char *array = malloc(count);
		int n = 0;
		const colstr_t *colstr = &config->colstr;
		colon_printf(_n("There is %d member in group %s%s%s:\n",
				"There are %d members in group %s%s%s:\n", count),
				count, colstr->groups, group, colstr->title);
		select_display(pkgs);
		if(!array) {
			ret = 1;
			goto cleanup;
		}
		if(multiselect_question(array, count)) {
			ret = 1;
			free(array);
			goto cleanup;
		}
		for(i = pkgs, n = 0; i; i = alpm_list_next(i)) {
			alpm_pkg_t *pkg = i->data;

			if(array[n++] == 0) {
				continue;
			}

			if(process_pkg(pkg) == 1) {
				ret = 1;
				free(array);
				goto cleanup;
			}
		}
		free(array);
	} else {
		for(i = pkgs; i; i = alpm_list_next(i)) {
			alpm_pkg_t *pkg = i->data;

			if(process_pkg(pkg) == 1) {
				ret = 1;
				goto cleanup;
			}
		}
	}

cleanup:
	alpm_list_free(pkgs);
	return ret;
}

static int process_targname(alpm_list_t *dblist, const char *targname,
		int error)
{
	alpm_pkg_t *pkg = alpm_find_dbs_satisfier(config->handle, dblist, targname);

	/* skip ignored packages when user says no */
	if(alpm_errno(config->handle) == ALPM_ERR_PKG_IGNORED) {
			pm_printf(ALPM_LOG_WARNING, _("skipping target: %s\n"), targname);
			return 0;
	}

	if(pkg) {
		return process_pkg(pkg);
	}
	/* fallback on group */
	return process_group(dblist, targname, error);
}

static int process_target(const char *target, int error)
{
	/* process targets */
	char *targstring = strdup(target);
	char *targname = strchr(targstring, '/');
	int ret = 0;
	alpm_list_t *dblist;

	if(targname && targname != targstring) {
		alpm_db_t *db;
		const char *dbname;
		int usage;

		*targname = '\0';
		targname++;
		dbname = targstring;
		db = get_db(dbname);
		if(!db) {
			pm_printf(ALPM_LOG_ERROR, _("database not found: %s\n"),
					dbname);
			ret = 1;
			goto cleanup;
		}

		/* explicitly mark this repo as valid for installs since
		 * a repo name was given with the target */
		alpm_db_get_usage(db, &usage);
		alpm_db_set_usage(db, usage|ALPM_DB_USAGE_INSTALL);

		dblist = alpm_list_add(NULL, db);
		ret = process_targname(dblist, targname, error);
		alpm_list_free(dblist);

		/* restore old usage so we don't possibly disturb later
		 * targets */
		alpm_db_set_usage(db, usage);
	} else {
		targname = targstring;
		dblist = alpm_get_syncdbs(config->handle);
		ret = process_targname(dblist, targname, error);
	}

cleanup:
	free(targstring);
	if(ret && access(target, R_OK) == 0) {
		pm_printf(ALPM_LOG_WARNING,
				_("'%s' is a file, did you mean %s instead of %s?\n"),
				target, "-U/--upgrade", "-S/--sync");
	}
	return ret;
}

static int sync_trans(alpm_list_t *targets)
{
	int retval = 0;
	alpm_list_t *i;

	/* Step 1: create a new transaction... */
	if(trans_init(config->flags, 1) == -1) {
		return 1;
	}

	/* process targets */
	for(i = targets; i; i = alpm_list_next(i)) {
		const char *targ = i->data;
		if(process_target(targ, retval) == 1) {
			retval = 1;
		}
	}

	if(retval) {
		trans_release();
		return retval;
	}

	if(config->op_s_upgrade) {
		if(!config->print) {
			colon_printf(_("Starting full system upgrade...\n"));
			alpm_logaction(config->handle, PACMAN_CALLER_PREFIX,
					"starting full system upgrade\n");
		}
		if(alpm_sync_sysupgrade(config->handle, config->op_s_upgrade >= 2) == -1) {
			pm_printf(ALPM_LOG_ERROR, "%s\n", alpm_strerror(alpm_errno(config->handle)));
			trans_release();
			return 1;
		}
	}

	return sync_prepare_execute();
}

static void print_broken_dep(alpm_depmissing_t *miss)
{
	char *depstring = alpm_dep_compute_string(miss->depend);
	alpm_list_t *trans_add = alpm_trans_get_add(config->handle);
	alpm_pkg_t *pkg;
	if(miss->causingpkg == NULL) {
		/* package being installed/upgraded has unresolved dependency */
		colon_printf(_("unable to satisfy dependency '%s' required by %s\n"),
				depstring, miss->target);
	} else if((pkg = alpm_pkg_find(trans_add, miss->causingpkg))) {
		/* upgrading a package breaks a local dependency */
		colon_printf(_("installing %s (%s) breaks dependency '%s' required by %s\n"),
				miss->causingpkg, alpm_pkg_get_version(pkg), depstring, miss->target);
	} else {
		/* removing a package breaks a local dependency */
		colon_printf(_("removing %s breaks dependency '%s' required by %s\n"),
				miss->causingpkg, depstring, miss->target);
	}
	free(depstring);
}

int sync_prepare_execute(void)
{
	alpm_list_t *i, *packages, *data = NULL;
	int retval = 0;

	/* Step 2: "compute" the transaction based on targets and flags */
	if(alpm_trans_prepare(config->handle, &data) == -1) {
		alpm_errno_t err = alpm_errno(config->handle);
		pm_printf(ALPM_LOG_ERROR, _("failed to prepare transaction (%s)\n"),
		        alpm_strerror(err));
		switch(err) {
			case ALPM_ERR_PKG_INVALID_ARCH:
				for(i = data; i; i = alpm_list_next(i)) {
					char *pkg = i->data;
					colon_printf(_("package %s does not have a valid architecture\n"), pkg);
					free(pkg);
				}
				break;
			case ALPM_ERR_UNSATISFIED_DEPS:
				for(i = data; i; i = alpm_list_next(i)) {
					print_broken_dep(i->data);
					alpm_depmissing_free(i->data);
				}
				break;
			case ALPM_ERR_CONFLICTING_DEPS:
				for(i = data; i; i = alpm_list_next(i)) {
					alpm_conflict_t *conflict = i->data;
					/* only print reason if it contains new information */
					if(conflict->reason->mod == ALPM_DEP_MOD_ANY) {
						colon_printf(_("%s and %s are in conflict\n"),
								conflict->package1, conflict->package2);
					} else {
						char *reason = alpm_dep_compute_string(conflict->reason);
						colon_printf(_("%s and %s are in conflict (%s)\n"),
								conflict->package1, conflict->package2, reason);
						free(reason);
					}
					alpm_conflict_free(conflict);
				}
				break;
			default:
				break;
		}
		retval = 1;
		goto cleanup;
	}

	packages = alpm_trans_get_add(config->handle);
	if(packages == NULL) {
		/* nothing to do: just exit without complaining */
		if(!config->print) {
			printf(_(" there is nothing to do\n"));
		}
		goto cleanup;
	}

	/* Step 3: actually perform the operation */
	if(config->print) {
		print_packages(packages);
		goto cleanup;
	}

	display_targets();
	printf("\n");

	int confirm;
	if(config->op_s_downloadonly) {
		confirm = yesno(_("Proceed with download?"));
	} else {
		confirm = yesno(_("Proceed with installation?"));
	}
	if(!confirm) {
		retval = 1;
		goto cleanup;
	}

	multibar_move_completed_up(true);
	if(alpm_trans_commit(config->handle, &data) == -1) {
		alpm_errno_t err = alpm_errno(config->handle);
		pm_printf(ALPM_LOG_ERROR, _("failed to commit transaction (%s)\n"),
		        alpm_strerror(err));
		switch(err) {
			case ALPM_ERR_FILE_CONFLICTS:
				for(i = data; i; i = alpm_list_next(i)) {
					alpm_fileconflict_t *conflict = i->data;
					switch(conflict->type) {
						case ALPM_FILECONFLICT_TARGET:
							printf(_("%s exists in both '%s' and '%s'\n"),
									conflict->file, conflict->target, conflict->ctarget);
							break;
						case ALPM_FILECONFLICT_FILESYSTEM:
							if(conflict->ctarget[0]) {
								printf(_("%s: %s exists in filesystem (owned by %s)\n"),
										conflict->target, conflict->file, conflict->ctarget);
							} else {
								printf(_("%s: %s exists in filesystem\n"),
										conflict->target, conflict->file);
							}
							break;
					}
					alpm_fileconflict_free(conflict);
				}
				break;
			case ALPM_ERR_PKG_INVALID:
			case ALPM_ERR_PKG_INVALID_CHECKSUM:
			case ALPM_ERR_PKG_INVALID_SIG:
				for(i = data; i; i = alpm_list_next(i)) {
					char *filename = i->data;
					printf(_("%s is invalid or corrupted\n"), filename);
					free(filename);
				}
				break;
			default:
				break;
		}
		/* TODO: stderr? */
		printf(_("Errors occurred, no packages were upgraded.\n"));
		retval = 1;
		goto cleanup;
	}

	/* Step 4: release transaction resources */
cleanup:
	alpm_list_free(data);
	if(trans_release() == -1) {
		retval = 1;
	}

	return retval;
}

int pacman_sync(alpm_list_t *targets)
{
	alpm_list_t *sync_dbs = NULL;

	/* clean the cache */
	if(config->op_s_clean) {
		int ret = 0;

		if(trans_init(0, 0) == -1) {
			return 1;
		}

		ret += sync_cleancache(config->op_s_clean);
		ret += sync_cleandb_all();

		if(trans_release() == -1) {
			ret++;
		}

		return ret;
	}

	if(check_syncdbs(1, 0)) {
		return 1;
	}

	sync_dbs = alpm_get_syncdbs(config->handle);

	if(config->op_s_sync) {
		/* grab a fresh package list */
		colon_printf(_("Synchronizing package databases...\n"));
		alpm_logaction(config->handle, PACMAN_CALLER_PREFIX,
				"synchronizing package lists\n");
		if(!sync_syncdbs(config->op_s_sync, sync_dbs)) {
			return 1;
		}
	}

	if(check_syncdbs(1, 1)) {
		return 1;
	}

	/* search for a package */
	if(config->op_s_search) {
		return sync_search(sync_dbs, targets);
	}

	/* look for groups */
	if(config->group) {
		return sync_group(config->group, sync_dbs, targets);
	}

	/* get package info */
	if(config->op_s_info) {
		return sync_info(sync_dbs, targets);
	}

	/* get a listing of files in sync DBs */
	if(config->op_q_list) {
		return sync_list(sync_dbs, targets);
	}

	if(targets == NULL) {
		if(config->op_s_upgrade) {
			/* proceed */
		} else if(config->op_s_sync) {
			return 0;
		} else {
			/* don't proceed here unless we have an operation that doesn't require a
			 * target list */
			pm_printf(ALPM_LOG_ERROR, _("no targets specified (use -h for help)\n"));
			return 1;
		}
	}

	return sync_trans(targets);
}
