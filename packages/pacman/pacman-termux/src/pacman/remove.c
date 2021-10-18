/*
 *  remove.c
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

#include <fnmatch.h>
#include <stdlib.h>
#include <stdio.h>

#include <alpm.h>
#include <alpm_list.h>

/* pacman */
#include "pacman.h"
#include "util.h"
#include "conf.h"

static int fnmatch_cmp(const void *pattern, const void *string)
{
	return fnmatch(pattern, string, 0);
}

static int remove_target(const char *target)
{
	alpm_pkg_t *pkg;
	alpm_db_t *db_local = alpm_get_localdb(config->handle);
	alpm_list_t *p;

	if((pkg = alpm_db_get_pkg(db_local, target)) != NULL) {
		if(alpm_remove_pkg(config->handle, pkg) == -1) {
			alpm_errno_t err = alpm_errno(config->handle);
			pm_printf(ALPM_LOG_ERROR, "'%s': %s\n", target, alpm_strerror(err));
			return -1;
		}
		config->explicit_removes = alpm_list_add(config->explicit_removes, pkg);
		return 0;
	}

		/* fallback to group */
	alpm_group_t *grp = alpm_db_get_group(db_local, target);
	if(grp == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("target not found: %s\n"), target);
		return -1;
	}
	for(p = grp->packages; p; p = alpm_list_next(p)) {
		pkg = p->data;
		if(alpm_remove_pkg(config->handle, pkg) == -1) {
			pm_printf(ALPM_LOG_ERROR, "'%s': %s\n", target,
					alpm_strerror(alpm_errno(config->handle)));
			return -1;
		}
		config->explicit_removes = alpm_list_add(config->explicit_removes, pkg);
	}
	return 0;
}

/**
 * @brief Remove a specified list of packages.
 *
 * @param targets a list of packages (as strings) to remove from the system
 *
 * @return 0 on success, 1 on failure
 */
int pacman_remove(alpm_list_t *targets)
{
	int retval = 0;
	alpm_list_t *i, *data = NULL;

	if(targets == NULL) {
		pm_printf(ALPM_LOG_ERROR, _("no targets specified (use -h for help)\n"));
		return 1;
	}

	/* Step 0: create a new transaction */
	if(trans_init(config->flags, 0) == -1) {
		return 1;
	}

	/* Step 1: add targets to the created transaction */
	for(i = targets; i; i = alpm_list_next(i)) {
		char *target = i->data;
		if(strncmp(target, "local/", 6) == 0) {
			target += 6;
		}
		if(remove_target(target) == -1) {
			retval = 1;
		}
	}

	if(retval == 1) {
		goto cleanup;
	}

	/* Step 2: prepare the transaction based on its type, targets and flags */
	if(alpm_trans_prepare(config->handle, &data) == -1) {
		alpm_errno_t err = alpm_errno(config->handle);
		pm_printf(ALPM_LOG_ERROR, _("failed to prepare transaction (%s)\n"),
		        alpm_strerror(err));
		switch(err) {
			case ALPM_ERR_UNSATISFIED_DEPS:
				for(i = data; i; i = alpm_list_next(i)) {
					alpm_depmissing_t *miss = i->data;
					char *depstring = alpm_dep_compute_string(miss->depend);
					colon_printf(_("removing %s breaks dependency '%s' required by %s\n"),
							miss->causingpkg, depstring, miss->target);
					free(depstring);
					alpm_depmissing_free(miss);
				}
				break;
			default:
				break;
		}
		alpm_list_free(data);
		retval = 1;
		goto cleanup;
	}

	/* Search for holdpkg in target list */
	int holdpkg = 0;
	for(i = alpm_trans_get_remove(config->handle); i; i = alpm_list_next(i)) {
		alpm_pkg_t *pkg = i->data;
		if(alpm_list_find(config->holdpkg, alpm_pkg_get_name(pkg), fnmatch_cmp)) {
			pm_printf(ALPM_LOG_WARNING, _("%s is designated as a HoldPkg.\n"),
							alpm_pkg_get_name(pkg));
			holdpkg = 1;
		}
	}
	if(holdpkg && (noyes(_("HoldPkg was found in target list. Do you want to continue?")) == 0)) {
		retval = 1;
		goto cleanup;
	}

	/* Step 3: actually perform the removal */
	alpm_list_t *pkglist = alpm_trans_get_remove(config->handle);
	if(pkglist == NULL) {
		printf(_(" there is nothing to do\n"));
		goto cleanup; /* we are done */
	}

	if(config->print) {
		print_packages(pkglist);
		goto cleanup;
	}

	/* print targets and ask user confirmation */
	display_targets();
	printf("\n");
	if(yesno(_("Do you want to remove these packages?")) == 0) {
		retval = 1;
		goto cleanup;
	}

	if(alpm_trans_commit(config->handle, &data) == -1) {
		pm_printf(ALPM_LOG_ERROR, _("failed to commit transaction (%s)\n"),
		        alpm_strerror(alpm_errno(config->handle)));
		retval = 1;
	}

	FREELIST(data);

	/* Step 4: release transaction resources */
cleanup:
	if(trans_release() == -1) {
		retval = 1;
	}
	return retval;
}
