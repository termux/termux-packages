#!/bin/bash
##
##  Determine modified packages and build/upload them.
##

set -e

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

# Process tag '%ci:no-build' that may be added as line to commit message.
# Will force CI to exit with status 'passed' without performing build.
if grep -qiP '^\s*%ci:no-build\s*$' <(git log --format="%B" -n 1 "$CIRRUS_CHANGE_IN_REPO"); then
	echo "[*] Exiting with status 'passed' (tag '%ci:no-build' applied)."
	exit 0
fi

# Process tag '%ci:reset-backlog' that may be added as line to commit message.
# Will force CI to build changes only for the current commit.
if grep -qiP '^\s*%ci:reset-backlog\s*$' <(git log --format="%B" -n 1 "$CIRRUS_CHANGE_IN_REPO"); then
	echo "[*] Building only last pushed commit (tag '%ci:reset-backlog' applied)."
	unset CIRRUS_LAST_GREEN_CHANGE
	unset CIRRUS_BASE_SHA
fi

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

## Determine modified packages.
existing_dirs=""
for dir in $(echo "$UPDATED_FILES" | grep -oP "packages/[a-z0-9+._-]+" | sort | uniq); do
	if [ -d "${REPO_DIR}/${dir}" ]; then
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


## Some packages should be excluded from auto builds.
EXCLUDED_PACKAGES="rust texlive"

for excluded_pkg in $EXCLUDED_PACKAGES; do
	PACKAGE_NAMES=$(echo "$PACKAGE_NAMES" | sed "s/\<${excluded_pkg}\>//g")
done
unset excluded_pkg

set -e

###############################################################################
##
##  Building packages.
##
###############################################################################

echo "[*] Building packages: $PACKAGE_NAMES"
if [ -n "$CIRRUS_PR" ]; then
	echo "    Pull request: https://github.com/termux/unstable-packages/pull/${CIRRUS_PR}"
else
	if [ -n "$CIRRUS_LAST_GREEN_CHANGE" ]; then
		echo "    Changes: ${CIRRUS_LAST_GREEN_CHANGE}..${CIRRUS_CHANGE_IN_REPO}"
	else
		echo "    Changes: ${CIRRUS_CHANGE_IN_REPO}"
	fi
fi

./build-package.sh -a "$TERMUX_ARCH" -I "$pkg" $PACKAGE_NAMES
