#!/bin/sh
# list-packages.sh - tool to list all package with home pages and descriptions

echo "<html><head><title>Termux packages</title></head><body>"
echo "<p>This is a list of packages available in Termux.</p>"

for path in packages/*; do
	export path
	export pkg=`basename $path`	
	bash -c '. $path/build.sh; echo -n "<li><a href=\"$TERMUX_PKG_HOMEPAGE\">$pkg</a>"; echo " - $TERMUX_PKG_DESCRIPTION</li>"'
done

echo "</body></html>"
