#!/bin/bash
#
# Expected result:-
# Should not show result
set -e -u

echo_and_run() {
	echo "> $*"
	bash -c "$*"
}

#echo_and_run pkg install -y rust

PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
ERROR=0

echo_and_run "find $PREFIX/lib -mindepth 1 -maxdepth 1 -name "librustc_*" -xtype l"
if [[ -n "$(find "$PREFIX/lib" -mindepth 1 -maxdepth 1 -name "librustc_*" -xtype l)" ]]; then
	ERROR=1
fi

echo_and_run "find $PREFIX/lib -mindepth 1 -maxdepth 1 -name "libstd-*" -xtype l"
if [[ -n "$(find "$PREFIX/lib" -mindepth 1 -maxdepth 1 -name "libstd-*" -xtype l)" ]]; then
	ERROR=1
fi

if [[ "$ERROR" != 0 ]]; then
	echo "ERROR: Broken symlink found" 1>&2
	exit 1
fi
