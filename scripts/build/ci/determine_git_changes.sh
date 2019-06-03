#!/bin/bash
##
##  Script for detecting modified packages.
##  Designed for use with Cirrus, Gitlab or Travis CI.
##
##  Leonid Plyushch <leonid.plyushch@gmail.com> (C) 2019
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

REPO_DIR=$(realpath "$(dirname "$(realpath "$0")")/../../../")
cd "$REPO_DIR" || {
	echo "[!] Failed to cd into '$REPO_DIR'." >&2
	exit 1
}

if [ -n "$TRAVIS_COMMIT_RANGE" ]; then
	# We are on Travis CI.
	UPDATED_FILES=$(git diff-tree --no-commit-id --name-only -r "${TRAVIS_COMMIT_RANGE//.../..}" 2>/dev/null | grep -P "packages/")
elif [ -n "$CI_COMMIT_SHA" ]; then
	# We are on Gitlab CI.

	# Make sure that we can use commit range.
	if [ -z "$CI_COMMIT_BEFORE_SHA" ]; then
		echo "[!] CI_COMMIT_BEFORE_SHA is not set." >&2
		exit 1
	fi

	if [ "$CI_COMMIT_BEFORE_SHA" = "0000000000000000000000000000000000000000" ]; then
		UPDATED_FILES=$(git diff-tree --no-commit-id --name-only -r "$CI_COMMIT_SHA" 2>/dev/null | grep -P "packages/")
	else
		UPDATED_FILES=$(git diff-tree --no-commit-id --name-only -r "${CI_COMMIT_BEFORE_SHA}..${CI_COMMIT_SHA}" 2>/dev/null | grep -P "packages/")
	fi
elif [ -n "$CIRRUS_CI" ]; then
	# We are on Cirrus CI.
	if [ -z "$CIRRUS_PR" ]; then
		if [ -z "$CIRRUS_LAST_GREEN_CHANGE" ]; then
			UPDATED_FILES=$(git diff-tree --no-commit-id --name-only -r "$CIRRUS_CHANGE_IN_REPO" 2>/dev/null | grep -P "packages/")
		else
			UPDATED_FILES=$(git diff-tree --no-commit-id --name-only -r "${CIRRUS_LAST_GREEN_CHANGE}..${CIRRUS_CHANGE_IN_REPO}" 2>/dev/null | grep -P "packages/")
		fi
	else
		# Pull requests are handled in a bit different way.
		UPDATED_FILES=$(git diff-tree --no-commit-id --name-only -r "${CIRRUS_BASE_SHA}..${CIRRUS_CHANGE_IN_REPO}" 2>/dev/null | grep -P "packages/")
	fi
else
	# Something wrong.
	echo "[!] Cannot determine git commit range." >&2
	echo "    Did you executed this script under CI ?" >&2
	exit 1
fi

## Determine modified packages.
existing_dirs=""
for dir in $(echo "$UPDATED_FILES" | grep -oP "packages/[a-z0-9+._-]+" | sort | uniq); do
	if [ -d "$REPO_DIR/$dir" ]; then
		existing_dirs+=" $dir"
	fi
done
PACKAGE_DIRS="$existing_dirs"
unset dir existing_dirs

## Get names of modified packages.
PACKAGE_NAMES=$(echo "$PACKAGE_DIRS" | sed 's/packages\///g')
if [ -z "$PACKAGE_NAMES" ]; then
	echo "[*] No modified packages found." >&2
	exit 0
fi

## Print names of modified packages.
for pkg in $PACKAGE_NAMES; do
	case "$pkg" in
		# Skip packages that known to have long build time.
		rust|texlive)
			{
				echo
				echo "Package '$pkg' cannot be built via CI because it has"
				echo "long build time."
				echo
			} >&2
			continue
			;;
		*)
			echo "$pkg"
			;;
	esac
done
