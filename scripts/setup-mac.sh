#!/bin/sh
set -e -u

command -v brew >/dev/null 2>&1 || {
        echo >&2 "Install homebrew first: http://brew.sh"
        exit 1
}

PACKAGES=""
PACKAGES="$PACKAGES bison"
PACKAGES="$PACKAGES cmake"
PACKAGES="$PACKAGES coreutils"
PACKAGES="$PACKAGES gawk"
PACKAGES="$PACKAGES gnu-sed --with-default-names"       # For busybox build.
PACKAGES="$PACKAGES gnu-tar"
PACKAGES="$PACKAGES lzip"
PACKAGES="$PACKAGES pkgconfig"
PACKAGES="$PACKAGES python3"
brew install $PACKAGES

# bison is keg-only, but we need updated 'bison' in path:
brew link bison --force

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data
