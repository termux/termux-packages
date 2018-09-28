#!/bin/sh
##
##  Script for querying latest version of package.
##

if [ -z "${1}" ]; then
    echo "Usage: check-pkg-version.sh [package name]"
    echo
    echo "This script retrieves current package version"
    echo "from https://www.archlinux.org."
fi

for repo in extra community core; do
    for arch in x86_64 any; do
        VERSION=$(curl -s https://www.archlinux.org/packages/${repo}/${arch}/${1}/ | grep 'itemprop="version"' | cut -d'"' -f4 | cut -d- -f1)
        if [ -n "${VERSION}" ]; then
            echo "${1}: ${VERSION}"
            exit 0
        fi
    done
done

exit 1
