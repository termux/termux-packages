/*
 *  sync.h
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2005, 2006 by Miklos Vajna <vmiklos@frugalware.org>
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
#ifndef ALPM_SYNC_H
#define ALPM_SYNC_H

#include "alpm.h"

int _alpm_sync_prepare(alpm_handle_t *handle, alpm_list_t **data);
int _alpm_sync_load(alpm_handle_t *handle, alpm_list_t **data);
int _alpm_sync_check(alpm_handle_t *handle, alpm_list_t **data);
int _alpm_sync_commit(alpm_handle_t *handle);

#endif /* ALPM_SYNC_H */
