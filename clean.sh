#!/bin/sh
# clean.sh - clean everything.
set -e -u

# Read settings from .termuxrc if existing
test -f $HOME/.termuxrc && . $HOME/.termuxrc
: ${TERMUX_TOPDIR:="$HOME/.termux-build"}


# Lock file. Same as used in build-package.sh.
TERMUX_BUILD_LOCK_FILE="/tmp/.termux-build.lck"
if [ ! -e "$TERMUX_BUILD_LOCK_FILE" ]; then
	touch "$TERMUX_BUILD_LOCK_FILE"
fi

{
	if ! flock -n 5; then
		echo "Not cleaning build directory since you have unfinished build running."
		exit 1
	fi

	if [ -d "$TERMUX_TOPDIR" ]; then
		chmod +w -R $TERMUX_TOPDIR
	fi
	rm -Rf /data/* $TERMUX_TOPDIR
} 5< "$TERMUX_BUILD_LOCK_FILE"
