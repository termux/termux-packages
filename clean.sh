#!/bin/sh
# clean.sh - clean everything.
set -e -u

# Read settings from .termuxrc if existing
test -f $HOME/.termuxrc && . $HOME/.termuxrc
: ${TERMUX_TOPDIR:="$HOME/.termux-build"}

[ -d "$TERMUX_TOPDIR" ] && chmod +w -R $TERMUX_TOPDIR
rm -Rf /data/* $TERMUX_TOPDIR
