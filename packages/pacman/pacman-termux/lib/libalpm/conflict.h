/*
 *  conflict.h
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
#ifndef ALPM_CONFLICT_H
#define ALPM_CONFLICT_H

#include "alpm.h"
#include "db.h"
#include "package.h"

alpm_conflict_t *_alpm_conflict_dup(const alpm_conflict_t *conflict);
alpm_list_t *_alpm_innerconflicts(alpm_handle_t *handle, alpm_list_t *packages);
alpm_list_t *_alpm_outerconflicts(alpm_db_t *db, alpm_list_t *packages);
alpm_list_t *_alpm_db_find_fileconflicts(alpm_handle_t *handle,
		alpm_list_t *upgrade, alpm_list_t *remove);

#endif /* ALPM_CONFLICT_H */
