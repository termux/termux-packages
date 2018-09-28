#!/bin/bash
##
##  Script for querying latest version of package.
##

if [ -z "${1}" ]; then
    echo "Usage: check-pkg-version.sh [package name]"
    echo
    echo "This script retrieves current package version"
    echo "from https://www.archlinux.org."
    exit 1
fi

check_if_update_needed() {
    local SCRIPT_DIR SCRIPT_PATH
    SCRIPT_PATH=$(realpath "${0}")
    SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")

    if [ -f "${SCRIPT_DIR}/${1}/build.sh" ]; then
        CURRENT_VERSION=$(grep 'TERMUX_PKG_VERSION=' "${SCRIPT_DIR}/${1}/build.sh" | cut -d= -f2)
        if [ "${CURRENT_VERSION}" != "${2}" ]; then
            echo "Current version: ${CURRENT_VERSION}"
            echo
            echo "[!] Package should be updated."
            echo
        fi
    elif [ -f "${SCRIPT_DIR}/lib${1}/build.sh" ]; then
        ## Same packages in ArchLinux and Termux may have different names.
        ## Example: GTK-2 in Termux has name 'libgtk2' but in ArchLinux it
        ## named as 'gtk2'.
        CURRENT_VERSION=$(grep 'TERMUX_PKG_VERSION=' "${SCRIPT_DIR}/lib${1}/build.sh" | cut -d= -f2)
        if [ "${CURRENT_VERSION}" != "${2}" ]; then
            echo "Current version: ${CURRENT_VERSION}"
            echo
            echo "[!] Package should be updated."
            echo
        fi
    else
        ## If no 'build.sh' script found, then do nothing.
        :
    fi
}

for repo in extra community core; do
    for arch in x86_64 any; do
        VERSION=$(curl -s "https://www.archlinux.org/packages/${repo}/${arch}/${1}/" | grep 'itemprop="version"' | cut -d'"' -f4 | cut -d- -f1)
        if [ -n "${VERSION}" ]; then
            echo "Package: ${1}"
            echo "Latest version: ${VERSION}"
            check_if_update_needed "${1}" "${VERSION}"
            exit 0
        fi
    done
done

exit 1
