#!/bin/sh
# check-pie.sh - script to detect non-PIE binaries (which does not work on Android)

. $(dirname "$(realpath "$0")")/properties.sh

cd ${TERMUX_PREFIX}/bin

for file in *; do
	if readelf -h $file 2>/dev/null | grep -q 'Type:[[:space:]]*EXEC'; then
		echo $file
	fi
done
