/*
 *  deps.h
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2006 by Miklos Vajna <vmiklos@frugalware.org>
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
#ifndef ALPM_DEPS_H
#define ALPM_DEPS_H

#include "db.h"
#include "sync.h"
#include "package.h"
#include "alpm.h"

alpm_depend_t *_alpm_dep_dup(const alpm_depend_t *dep);
alpm_list_t *_alpm_sortbydeps(alpm_handle_t *handle,
		alpm_list_t *targets, alpm_list_t *ignore, int reverse);
int _alpm_recursedeps(alpm_db_t *db, alpm_list_t **targs, int include_explicit);
int _alpm_resolvedeps(alpm_handle_t *handle, alpm_list_t *localpkgs, alpm_pkg_t *pkg,
		alpm_list_t *preferred, alpm_list_t **packages, alpm_list_t *remove,
		alpm_list_t **data);
int _alpm_depcmp_literal(alpm_pkg_t *pkg, alpm_depend_t *dep);
int _alpm_depcmp_provides(alpm_depend_t *dep, alpm_list_t *provisions);
int _alpm_depcmp(alpm_pkg_t *pkg, alpm_depend_t *dep);

#endif /* ALPM_DEPS_H */
