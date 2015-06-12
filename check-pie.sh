#!/bin/sh
# check-pie.sh - script to detect non-PIE binaries (which does not work on Android)

cd /data/data/com.termux/files/usr/bin/
for file in *; do
	if readelf -h $file 2>/dev/null | grep -q 'Type:[[:space:]]*EXEC'; then
		echo $file
	fi
done
