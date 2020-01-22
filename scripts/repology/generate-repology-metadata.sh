#!/usr/bin/env bash
#
#  Script for generating metadata for Repology in json format.
#
#  Copyright 2018 Fredrik Fornwall <fredrik@fornwall.net> @fornwall
#  Copyright 2019 Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

set -e

BASEDIR=$(dirname "$(realpath "$0")")
export TERMUX_ARCH=aarch64

check_package() { # path
	# Avoid ending on errors such as $(which prog)
	# where prog is not installed.
	set +e

	local path=$1
	local pkg=$(basename $path)
	TERMUX_PKG_MAINTAINER="Fredrik Fornwall @fornwall"
	TERMUX_PKG_API_LEVEL=24
	. $path/build.sh

	echo "  {"
	echo "    \"name\": \"$pkg\","
	echo "    \"version\": \"$TERMUX_PKG_VERSION\","
	DESC=$(echo "$TERMUX_PKG_DESCRIPTION" | head -n 1)
	echo "    \"description\": \"$DESC\","
	echo "    \"homepage\": \"$TERMUX_PKG_HOMEPAGE\","

	echo -n "    \"depends\": ["
	FIRST_DEP=yes
	for p in ${TERMUX_PKG_DEPENDS//,/ }; do
		if [ $FIRST_DEP = yes ]; then
			FIRST_DEP=no
		else
			echo -n ", "
		fi
		echo -n "\"$p\""
	done
	echo "],"

	if [ "$TERMUX_PKG_SRCURL" != "" ]; then
		echo "    \"srcurl\": \"$TERMUX_PKG_SRCURL\","
	fi

	echo "    \"maintainer\": \"$TERMUX_PKG_MAINTAINER\""
	echo -n "  }"
}

check_excluded() {
	if grep -q "^$1\$" "$BASEDIR/excluded_packages.txt"; then
		return 0
	else
		return 1
	fi
}

if [ $# -eq 0 ]; then
	echo "Usage: generate-repology-metadata.sh [./path/to/pkg/dir] ..."
	echo "Generate package metadata for Repology."
	exit 1
fi

export FIRST=yes
echo '['
for path in "$@"; do
	if check_excluded $(basename "$path"); then
		continue
	fi

	if [ $FIRST = yes ]; then
		FIRST=no
	else
		echo -n ","
		echo ""
	fi

	# Run each package in separate process since we include their environment variables:
	( check_package $path)
done
echo ""
echo ']'
