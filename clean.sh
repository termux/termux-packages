#!/bin/bash
# clean.sh - clean everything.
set -e -u

TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; pwd)

# Store pid of current process in a file for docker__run_docker_exec_trap
. "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__create_docker_exec_pid_file

# Get variable CGCT_DIR
. "$TERMUX_SCRIPTDIR/scripts/properties.sh"

# Checking if script is running on Android with 2 different methods.
# Needed for safety to prevent execution of potentially dangerous
# operations such as 'rm -rf /data/*' on Android device.
if [ "$(uname -o)" = "Android" ] || [ -e "/system/bin/app_process" ]; then
	TERMUX_ON_DEVICE_BUILD=true
else
	TERMUX_ON_DEVICE_BUILD=false
fi

if [ "$(id -u)" = "0" ] && [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
	echo "On-device execution of this script as root is disabled."
	exit 1
fi

# Read settings from .termuxrc if existing
test -f "$HOME/.termuxrc" && . "$HOME/.termuxrc"
: "${TERMUX_TOPDIR:="$HOME/.termux-build"}"
: "${TMPDIR:=/tmp}"
export TMPDIR

# Lock file. Same as used in build-package.sh.
TERMUX_BUILD_LOCK_FILE="${TMPDIR}/.termux-build.lck"
if [ ! -e "$TERMUX_BUILD_LOCK_FILE" ]; then
	touch "$TERMUX_BUILD_LOCK_FILE"
fi

{
	if ! flock -n 5; then
		echo "Not cleaning build directory since you have unfinished build running."
		exit 1
	fi

	if [ -d "$TERMUX_TOPDIR" ]; then
		chmod +w -R "$TERMUX_TOPDIR" || true
	fi

	# For on-device build cleanup /data shouldn't be erased.
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		if [[ ! "$TERMUX_BASE_DIR" =~ ^(/[^/]+)+$ ]]; then
			echo "TERMUX_BASE_DIR '$TERMUX_BASE_DIR' is not an absolute path under rootfs '/'." 1>&2
			exit 1
		fi
		if [[ "$TERMUX_BASE_DIR" =~ ^/[^/]+$ ]]; then
			# Use `/rootfs` as is.
			rootfs_top_level_dir="$TERMUX_BASE_DIR"
		else
			# Get `/path/` from `/path/to/rootfs`.
			rootfs_top_level_dir="${TERMUX_BASE_DIR%"${TERMUX_BASE_DIR#/*/}"}"
		fi

		if [[ ! "$CGCT_DIR" =~ ^(/[^/]+)+$ ]] || [[ "$CGCT_DIR" == "$TERMUX_BASE_DIR" ]]; then
			echo "CGCT_DIR '$CGCT_DIR' is not an absolute path under rootfs '/' or equals TERMUX_BASE_DIR." 1>&2
			exit 1
		fi

		# Escape '\$[](){}|^.?+*' with backslashes
		cgct_dir_escaped="$(printf "%s" "$CGCT_DIR" | sed -zE -e 's/[][\.|$(){}?+*^]/\\&/g')"
		find "$rootfs_top_level_dir" -mindepth 1 -regextype posix-extended ! -regex "^$cgct_dir_escaped(/.*)?" -delete 2>/dev/null || true
	fi

	rm -Rf "$TERMUX_TOPDIR"
} 5< "$TERMUX_BUILD_LOCK_FILE"
