/*
 *  remove.h
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
#ifndef ALPM_REMOVE_H
#define ALPM_REMOVE_H

#include "db.h"
#include "alpm_list.h"
#include "trans.h"

int _alpm_remove_prepare(alpm_handle_t *handle, alpm_list_t **data);
int _alpm_remove_packages(alpm_handle_t *handle, int run_ldconfig);

int _alpm_remove_single_package(alpm_handle_t *handle,
		alpm_pkg_t *oldpkg, alpm_pkg_t *newpkg,
		size_t targ_count, size_t pkg_count);

#endif /* ALPM_REMOVE_H */
