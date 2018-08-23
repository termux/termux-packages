#!/usr/bin/env bash
# scripts/get-version.sh: A script to find out the current version of a package.
# Usage: ./scripts/get-version.sh $package_name

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
cd $SCRIPT_DIR/..

. scripts/properties.sh

if [ -z "$1" ]; then
	echo "get-version.sh: No package name specified"
	exit 1
fi

pkg=$1
path=packages/$1
TERMUX_PKG_REVISION=0
TERMUX_ARCH=aarch64

if [ -f $path/build.sh ]; then
	. $path/build.sh
else
	# Check for subpackage
	subpackage_path=`find . -name ${pkg}.subpackage.sh`
	if [ -z "$subpackage_path" ]; then
		echo "get-version.sh: No package with name $pkg found"
		exit 1
	fi
	. `dirname $subpackage_path`/build.sh
fi

if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_VERSION" != "${TERMUX_PKG_VERSION/-/}" ]; then
	TERMUX_PKG_VERSION+="-$TERMUX_PKG_REVISION"
fi

echo "$TERMUX_PKG_VERSION"
