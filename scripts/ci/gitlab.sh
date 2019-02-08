#!/bin/bash
##
##  Determine updated packages, build them and upload to bintray.com
##  if requested. This script should be used with GitLab CI.
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

REPO_DIR=$(realpath "$(dirname "$(realpath "$0")")/../../")
DEBS_DIR="$REPO_DIR/deb-packages"
cd "$REPO_DIR" || {
    echo "[!] Failed to cd into '$REPO_DIR'."
    exit 1
}

## Create directory where *.deb files will be placed.
if ! mkdir -p "$DEBS_DIR" > /dev/null 2>&1; then
    echo "[!] Failed to create directory '$DEBS_DIR'."
    exit 1
fi

## Verify that script is running under CI (GitLab).
if [ -z "${CI_COMMIT_BEFORE_SHA}" ]; then
    echo "[!] CI_COMMIT_BEFORE_SHA is not set !"
    exit 1
fi
if [ -z "${CI_COMMIT_SHA}" ]; then
    echo "[!] CI_COMMIT_SHA is not set !"
    exit 1
fi

## Check for updated files.
if [ "$CI_COMMIT_BEFORE_SHA" = "0000000000000000000000000000000000000000" ]; then
    UPDATED_FILES=$(git diff-tree --no-commit-id --name-only -r "${CI_COMMIT_SHA}" | grep -P "packages/")
else
    UPDATED_FILES=$(git diff-tree --no-commit-id --name-only -r "${CI_COMMIT_BEFORE_SHA}..${CI_COMMIT_SHA}" | grep -P "packages/")
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
    echo "[*] No modified packages found."
    exit 0
fi

## Handle arguments.
## Script expects only one command line argument.
## It should be either architecture (aarch64, arm, i686, x86_64)
## or '--upload'.
if [ $# -ge 1 ]; then
    if [ "$1" = "--upload" ]; then
        exec "$REPO_DIR/scripts/bintray-add-package.sh" --path "$DEBS_DIR" $PACKAGE_NAMES
    else
        TERMUX_ARCH="$1"
        unset BINTRAY_USERNAME
        unset BINTRAY_API_KEY
    fi
else
    TERMUX_ARCH="aarch64"
fi

echo "[@] Building packages for architecture '$TERMUX_ARCH':"
build_log="$DEBS_DIR/build-$TERMUX_ARCH.log"

for pkg in $PACKAGE_NAMES; do
    pkg=$(basename "$pkg")
    echo "[+]   Processing $pkg:"

    for dep_pkg in $(./scripts/buildorder.py "./packages/$pkg"); do
        dep_pkg=$(basename "$dep_pkg")
        echo -n "[+]     Compiling dependency $dep_pkg... "
        if ./build-package.sh -o "$DEBS_DIR" -a "$TERMUX_ARCH" -s "$dep_pkg" >> "$build_log" 2>&1; then
            echo "ok"
        else
            echo "fail"
            echo "[=] LAST 1000 LINES OF BUILD LOG:"
            echo
            tail -n 1000 "$build_log"
            echo
            exit 1
        fi
    done

    echo -n "[+]     Compiling $pkg... "
    if ./build-package.sh -f -o "$DEBS_DIR" -a "$TERMUX_ARCH" "$pkg" >> "$build_log" 2>&1; then
        echo "ok"
    else
        echo "fail"
        echo "[=] LAST 1000 LINES OF BUILD LOG:"
        echo
        tail -n 1000 "$build_log"
        echo
        exit 1
    fi

    echo "[+]   Successfully built $pkg."
done
echo "[@] Finished successfully."
