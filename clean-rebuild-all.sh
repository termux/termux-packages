#!/bin/sh
# clean-rebuild-all.sh - clean everything and rebuild

# Read settings from .termuxrc if existing
test -f $HOME/.termuxrc && . $HOME/.termuxrc
: ${TERMUX_TOPDIR:="$HOME/.termux-build"}

rm -Rf /data/* $TERMUX_TOPDIR
bash -x build-all.sh
