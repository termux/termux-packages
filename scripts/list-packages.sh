#!/bin/bash
# list-packages.sh - tool to list all package with home pages and descriptions

show_package() {
	. $1/build.sh
	local pkg=$(basename $1)
	echo "$pkg($TERMUX_PKG_VERSION): $TERMUX_PKG_HOMEPAGE"
	echo "       $TERMUX_PKG_DESCRIPTION"
}

for path in packages/*; do
	( show_package $path )
done
