#!/usr/bin/env bash
##
##  Script for determining modified packages and building them.
##
##  Copyright 2019-2021 Leonid Plyushch <leonid.plyushch@gmail.com>
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##    http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
##

set -e

## Some packages should be excluded from auto builds.
EXCLUDED_PACKAGES=""

###############################################################################
##
##  Determining changes.
##
###############################################################################

set +e

REPO_DIR=$(realpath "$(dirname "$(realpath "$0")")/../../../")
cd "$REPO_DIR" || {
	echo "[!] Failed to cd into '$REPO_DIR'."
	exit 1
}

# Some environment variables are important for correct functionality
# of this script.
if [ -z "$CIRRUS_CHANGE_IN_REPO" ]; then
	echo "[!] CIRRUS_CHANGE_IN_REPO is not set."
	exit 1
fi

if [ -n "$CIRRUS_PR" ] && [ -z "$CIRRUS_BASE_SHA" ]; then
	echo "[!] CIRRUS_BASE_SHA is not set."
	exit 1
fi

# Process tag '%ci:no-build' that may be added as line to commit message.
# Will force CI to exit with status 'passed' without performing build.
if grep -qiP '^\s*%ci:no-build\s*$' <(git log --format="%B" -n 1 "$CIRRUS_CHANGE_IN_REPO"); then
	echo "[!] Exiting with status 'passed' (tag '%ci:no-build' applied)."
	exit 0
fi

# Process tag '%ci:reset-backlog' that may be added as line to commit message.
# Will force CI to build changes only for the current commit.
if grep -qiP '^\s*%ci:reset-backlog\s*$' <(git log --format="%B" -n 1 "$CIRRUS_CHANGE_IN_REPO"); then
	echo "[!] Building only last pushed commit (tag '%ci:reset-backlog' applied)."
	unset CIRRUS_LAST_GREEN_CHANGE
	unset CIRRUS_BASE_SHA
fi

if [ -z "$CIRRUS_PR" ]; then
	# Changes determined from the last commit where CI finished with status
	# 'passed' (green) and the top commit.
	if [ -z "$CIRRUS_LAST_GREEN_CHANGE" ]; then
		GIT_CHANGES="$CIRRUS_CHANGE_IN_REPO"
	else
		GIT_CHANGES="${CIRRUS_LAST_GREEN_CHANGE}..${CIRRUS_CHANGE_IN_REPO}"
	fi
	echo "[*] Changes: $GIT_CHANGES"
else
	# Changes in pull request are determined from commits between the
	# top commit of base branch and latest commit of PR's branch.
	GIT_CHANGES="${CIRRUS_BASE_SHA}..${CIRRUS_CHANGE_IN_REPO}"
	echo "[*] Pull request: https://github.com/termux/x11-packages/pull/${CIRRUS_PR}"
fi

# Determine changes from commit range.
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r "$GIT_CHANGES" 2>/dev/null)

# Modified packages.
PACKAGE_NAMES=$(sed -nE 's@^packages/([^/]*)/build.sh@\1@p' <<< "$CHANGED_FILES")

unset CHANGED_FILES

## Filter deleted packages.
for pkg in $PACKAGE_NAMES; do
	if [ ! -d "${REPO_DIR}/packages/${pkg}" ]; then
		PACKAGE_NAMES=$(sed -E "s/(^|\s\s*)${pkg}(\$|\s\s*)/ /g" <<< "$PACKAGE_NAMES")
	fi
done

## Filter excluded packages.
for pkg in $EXCLUDED_PACKAGES; do
	PACKAGE_NAMES=$(sed -E "s/(^|\s\s*)${pkg}(\$|\s\s*)/ /g" <<< "$PACKAGE_NAMES")
done
unset pkg

## Remove trailing spaces.
PACKAGE_NAMES=$(sed 's/[[:blank:]]*$//' <<< "$PACKAGE_NAMES")

set -e

if [ -n "$PACKAGE_NAMES" ]; then
	echo "[*] Building packages:" $PACKAGE_NAMES
	echo "[*] Copying packages to build environment:"
	for pkg in "${REPO_DIR}"/packages/*; do
		if [ ! -e "${REPO_DIR}/termux-packages/packages/$(basename "$pkg")" ]; then
			echo "    - $(basename "$pkg")"
			cp -a "$pkg" "${REPO_DIR}"/termux-packages/packages/
		else
			echo "    - $(basename "$pkg"): package already exist, skipping"
		fi
	done
	cd ./termux-packages && ./build-package.sh -a "$TERMUX_ARCH" -I $PACKAGE_NAMES
else
	echo "[*] No modified packages found."
	exit 0
fi
