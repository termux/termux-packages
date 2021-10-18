#!/bin/bash
#
#   executable.sh - confirm presence of dependent executables
#
#   Copyright (c) 2018-2021 Pacman Development Team <pacman-dev@archlinux.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

[[ -n "$LIBMAKEPKG_EXECUTABLE_SH" ]] && return
LIBMAKEPKG_EXECUTABLE_SH=1

declare -a executable_functions

for lib in "$LIBRARY/executable/"*.sh; do
	source "$lib"
done

readonly -a executable_functions

check_software() {
	local ret=0

	for func in ${executable_functions[@]}; do
		$func || ret=1
	done

	return $ret
}
