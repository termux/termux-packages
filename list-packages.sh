#!/bin/sh
# list-packages.sh - tool to list all package with home pages and descriptions

for path in packages/*; do
	export path
	export pkg=`basename $path`	
	bash -c '. $path/build.sh; echo "$pkg($TERMUX_PKG_VERSION): $TERMUX_PKG_HOMEPAGE"; echo "       $TERMUX_PKG_DESCRIPTION"'
done
