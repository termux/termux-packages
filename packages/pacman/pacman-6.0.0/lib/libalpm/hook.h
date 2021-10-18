/*
 *  hook.h
 *
 *  Copyright (c) 2015-2021 Pacman Development Team <pacman-dev@archlinux.org>
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

#ifndef ALPM_HOOK_H
#define ALPM_HOOK_H

#include "alpm.h"

#define ALPM_HOOK_SUFFIX ".hook"

int _alpm_hook_run(alpm_handle_t *handle, alpm_hook_when_t when);

#endif /* ALPM_HOOK_H */
