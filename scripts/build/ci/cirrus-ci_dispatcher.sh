#!/bin/bash
##
##  Determine modified packages and build/upload them.
##

set -e

## Some packages should be excluded from auto builds.
EXCLUDED_PACKAGES="rust texlive"

###############################################################################
##
##  Preparation.
##
###############################################################################

REPO_DIR=$(realpath "$(dirname "$(realpath "$0")")/../../../")
cd "$REPO_DIR" || {
	echo "[!] Failed to cd into '$REPO_DIR'."
	exit 1
}

###############################################################################
##
##  Determining changes.
##
###############################################################################

set +e

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
	echo "[*] Pull request: https://github.com/termux/termux-packages/pull/${CIRRUS_PR}"
fi

# Determine changes from commit range.
PACKAGE_NAMES=$(git diff-tree --no-commit-id --name-only -r "$GIT_CHANGES" packages/ 2>/dev/null | grep build.sh | sed -E 's@^packages/([^/]*)/build.sh@\1@')

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

if [ -z "$PACKAGE_NAMES" ]; then
	echo "[*] No modified packages found."
	exit 0
fi

set -e

###############################################################################
##
##  Building packages.
##
###############################################################################

echo "[*] Building packages: $PACKAGE_NAMES"
./build-package.sh -a "$TERMUX_ARCH" -I $PACKAGE_NAMES
