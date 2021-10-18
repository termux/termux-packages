#!/bin/bash
#
#   option.sh - functions to test if build/packaging options are enabled
#
#   Copyright (c) 2009-2021 Pacman Development Team <pacman-dev@archlinux.org>
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

[[ -n "$LIBMAKEPKG_UTIL_OPTION_SH" ]] && return
LIBMAKEPKG_UTIL_OPTION_SH=1


##
#  usage : in_opt_array( $needle, $haystack )
# return : 0   - enabled
#          1   - disabled
#          127 - not found
##
in_opt_array() {
	local needle=$1; shift

	local i opt
	for (( i = $#; i > 0; i-- )); do
		opt=${!i}
		if [[ $opt = "$needle" ]]; then
			# enabled
			return 0
		elif [[ $opt = "!$needle" ]]; then
			# disabled
			return 1
		fi
	done

	# not found
	return 127
}


##
#  usage : check_opt_array( $option, $expected_val, $haystack )
# return : 0   - matches expected
#          1   - does not match expected
#          127 - not found
##
check_opt_array() {
	local option=$1 expected=$2; shift 2

	in_opt_array "$option" "$@"
	case $? in
		0) # assert enabled
			[[ $expected = y ]]
			return ;;
		1) # assert disabled
			[[ $expected = n ]]
			return ;;
	esac

	# not found
	return 127
}


##
# Checks to see if options are present in makepkg.conf or PKGBUILD;
# PKGBUILD options always take precedence.
#
#  usage : check_option( $option, $expected_val )
# return : 0   - matches expected
#          1   - does not match expected
#          127 - not found
##
check_option() {
	check_opt_array "$@" "${OPTIONS[@]}" "${options[@]}"
}


##
# Check if option is present in BUILDENV
#
#  usage : check_buildenv( $option, $expected_val )
# return : 0   - matches expected
#          1   - does not match expected
#          127 - not found
##
check_buildenv() {
	check_opt_array "$@" "${BUILDENV[@]}"
}


##
# Checks to see if options are present in BUILDENV or PKGBUILD;
# PKGBUILD options always take precedence.
#
#  usage : check_buildoption( $option, $expected_val )
# return : 0   - matches expected
#          1   - does not match expected
#          127 - not found
##
check_buildoption() {
	check_opt_array "$@" "${BUILDENV[@]}" "${options[@]}"
}
