#!/usr/bin/env bash
# check-versions.sh - script to open packages in a browser for checking their versions

OPEN=xdg-open
if [ `uname` = Darwin ]; then OPEN=open; fi

# Run each package in separate process since we include their environment variables:
for path in packages/*; do
(
	pkg=`basename $path`	
	. $path/build.sh
	echo -n "$pkg - $TERMUX_PKG_VERSION - press Return to check homepage"
	read
	$OPEN $TERMUX_PKG_HOMEPAGE
)
done
