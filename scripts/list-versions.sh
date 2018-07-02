#!/usr/bin/env bash

check_package() { # path
	local path=$1
	local pkg=`basename $path`
	TERMUX_PKG_REVISION=0
	TERMUX_ARCH=aarch64
	TERMUX_NDK_VERSION=17
	TERMUX_ANDROID_BUILD_TOOLS_VERSION=27.0.3
	. $path/build.sh
	if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_VERSION" != "${TERMUX_PKG_VERSION/-/}" ]; then
		TERMUX_PKG_VERSION+="-$TERMUX_PKG_REVISION"
	fi
	echo "$pkg=$TERMUX_PKG_VERSION"
}

for path in packages/*; do
(
	check_package $path
)
done
