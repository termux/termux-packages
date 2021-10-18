/*
 *  deptest.c
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

#include <alpm.h>
#include <alpm_list.h>

/* pacman */
#include "pacman.h"
#include "conf.h"

int pacman_deptest(alpm_list_t *targets)
{
	alpm_list_t *i;
	alpm_list_t *deps = NULL;
	alpm_db_t *localdb = alpm_get_localdb(config->handle);
	alpm_list_t *pkgcache = alpm_db_get_pkgcache(localdb);

	for(i = targets; i; i = alpm_list_next(i)) {
		char *target = i->data;

		if(!alpm_db_get_pkg(localdb, target) &&
				!alpm_find_satisfier(pkgcache, target)) {
			deps = alpm_list_add(deps, target);
		}
	}

	if(deps == NULL) {
		return 0;
	}

	for(i = deps; i; i = alpm_list_next(i)) {
		const char *dep = i->data;

		printf("%s\n", dep);
	}
	alpm_list_free(deps);
	return 127;
}
