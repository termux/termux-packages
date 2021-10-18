#!/bin/bash
#
# vercmptest - a test suite for the vercmp/libalpm program
#
#   Copyright (c) 2009-2021 by Pacman Development Team <pacman-dev@archlinux.org>
#   Copyright (c) 2008 by Dan McGee <dan@archlinux.org>
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

source "$(dirname "$0")"/../tap.sh || exit 1

# default binary if one was not specified as $1
bin=${1:-${PMTEST_UTIL_DIR}vercmp}

# use first arg as our binary if specified
if ! type -p "$bin" &>/dev/null; then
	tap_bail "vercmp binary ($bin) could not be located"
	exit 1
fi

# args:
# runtest ver1 ver2 expected
tap_runtest() {
	local ver1=$1 ver2=$2 exp=$3
	tap_is_str "$($bin "$ver1" "$ver2")" "$exp" "$ver1 $ver2"
	# and run its mirror case just to be sure
	(( exp *= -1 ))
	tap_is_str "$($bin "$ver2" "$ver1")" "$exp" "$ver2 $ver1"
}

tap_plan 92

# all similar length, no pkgrel
tap_runtest 1.5.0 1.5.0  0
tap_runtest 1.5.1 1.5.0  1

# mixed length
tap_runtest 1.5.1 1.5    1

# with pkgrel, simple
tap_runtest 1.5.0-1 1.5.0-1  0
tap_runtest 1.5.0-1 1.5.0-2 -1
tap_runtest 1.5.0-1 1.5.1-1 -1
tap_runtest 1.5.0-2 1.5.1-1 -1

# with pkgrel, mixed lengths
tap_runtest 1.5-1   1.5.1-1 -1
tap_runtest 1.5-2   1.5.1-1 -1
tap_runtest 1.5-2   1.5.1-2 -1

# mixed pkgrel inclusion
tap_runtest 1.5   1.5-1 0
tap_runtest 1.5-1 1.5   0
tap_runtest 1.1-1 1.1   0
tap_runtest 1.0-1 1.1  -1
tap_runtest 1.1-1 1.0   1

# alphanumeric versions
tap_runtest 1.5b-1  1.5-1  -1
tap_runtest 1.5b    1.5    -1
tap_runtest 1.5b-1  1.5    -1
tap_runtest 1.5b    1.5.1  -1

# from the manpage
tap_runtest 1.0a     1.0alpha -1
tap_runtest 1.0alpha 1.0b     -1
tap_runtest 1.0b     1.0beta  -1
tap_runtest 1.0beta  1.0rc    -1
tap_runtest 1.0rc    1.0      -1

# going crazy? alpha-dotted versions
tap_runtest 1.5.a    1.5     1
tap_runtest 1.5.b    1.5.a   1
tap_runtest 1.5.1    1.5.b   1

# alpha dots and dashes
tap_runtest 1.5.b-1  1.5.b   0
tap_runtest 1.5-1    1.5.b  -1

# same/similar content, differing separators
tap_runtest 2.0    2_0     0
tap_runtest 2.0_a  2_0.a   0
tap_runtest 2.0a   2.0.a  -1
tap_runtest 2___a  2_a     1

# epoch included version comparisons
tap_runtest 0:1.0    0:1.0   0
tap_runtest 0:1.0    0:1.1  -1
tap_runtest 1:1.0    0:1.0   1
tap_runtest 1:1.0    0:1.1   1
tap_runtest 1:1.0    2:1.1  -1

# epoch + sometimes present pkgrel
tap_runtest 1:1.0    0:1.0-1  1
tap_runtest 1:1.0-1  0:1.1-1  1

# epoch included on one version
tap_runtest 0:1.0    1.0   0
tap_runtest 0:1.0    1.1  -1
tap_runtest 0:1.1    1.0   1
tap_runtest 1:1.0    1.0   1
tap_runtest 1:1.0    1.1   1
tap_runtest 1:1.1    1.1   1

tap_finish
