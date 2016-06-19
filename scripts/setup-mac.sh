#!/bin/sh
set -e -u

# Remaining mac build issues:
# - perl does not build
# - strace does not build
# - dpkg calls ldconfig

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
# gettext is also key-only, but we need msgfmt for apt and glib:
brew link gettext --force

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data
