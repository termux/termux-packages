#!/usr/bin/bash
#
#   lint_config.sh - functions for checking for makepkg.conf errors
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

[[ -n "$LIBMAKEPKG_LINT_CONFIG_SH" ]] && return
LIBMAKEPKG_LINT_CONFIG_SH=1

LIBRARY=${LIBRARY:-'/usr/share/makepkg'}

source "$LIBRARY/util/message.sh"
source "$LIBRARY/util/util.sh"


declare -a lint_config_functions

for lib in "$LIBRARY/lint_config/"*.sh; do
	source "$lib"
done

readonly -a lint_config_functions


lint_config() {
	local ret=0

	for func in ${lint_config_functions[@]}; do
		$func || ret=1
	done
	return $ret
}
