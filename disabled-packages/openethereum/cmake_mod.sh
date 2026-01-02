#!/bin/bash
set -x

if [ $# -eq 0 ]; then
	cmake --version
elif [ $1 = "--build" ]; then
	cmake "$@"
else
	_CACHE="$1/defaultcache.cmake"
	cp $TERMUX_COMMON_CACHEDIR/defaultcache.cmake "$_CACHE"

	for var in "$@"; do
		case "$var" in
			"-DCMAKE_C_COMPILER"*|"-DCMAKE_CXX_COMPILER"*|"-DCMAKE_C_FLAGS="*|"-DCMAKE_CXX_FLAGS="*)
				;;
			"-D"*"="*)
				echo "${var/-D/}" >> "$_CACHE"
				;;
		esac
	done

	sed -i 's/\"//g' "$_CACHE"
	ARG=()
	while read -r arg; do
		if [ ! -z "$arg" ]; then
			ARG+=("-D$arg")
		fi
	done < "$_CACHE"
	cmake "$1" "${ARG[@]}"
	rm "$_CACHE"
fi
