#!/bin/sh
# clean-rebuild-all.sh - clean everything and rebuild

rm -Rf /data/* $HOME/termux/* $HOME/lib/android-standalone-toolchain-*
bash -x build-all.sh
