#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
. "$SCRIPT_DIR"/properties.sh

check_package() { # path
	local path=$1
	local pkg=$(basename "$path")
	TERMUX_PKG_REVISION=0
	TERMUX_ARCH=aarch64
	. "$path"/build.sh
	if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_VERSION" != "${TERMUX_PKG_VERSION/-/}" ]; then
		TERMUX_PKG_VERSION+="-$TERMUX_PKG_REVISION"
	fi
	echo "$pkg=$TERMUX_PKG_VERSION"
}

for path in "${SCRIPT_DIR}"/../packages/*; do
(
	check_package "$path"
)
done
