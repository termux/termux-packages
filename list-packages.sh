#!/usr/bin/env bash
# list-packages.sh - tool to list all package with home pages and descriptions

for path in packages/*; do (
	pkg=`basename $path`	
	. $path/build.sh
	echo "$pkg($TERMUX_PKG_VERSION): $TERMUX_PKG_HOMEPAGE"
        echo "       $TERMUX_PKG_DESCRIPTION"
) done
