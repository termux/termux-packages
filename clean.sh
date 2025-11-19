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

	# For on-device build cleanup Termux app data directory shouldn't be erased.
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		for variable_name in TERMUX__PREFIX TERMUX_APP__DATA_DIR CGCT_DIR; do
			variable_value="${!variable_name:-}"
			if [[ ! "$variable_value" =~ ^(/[^/]+)+$ ]]; then
				echo "The $variable_name '$variable_value' is not an absolute path under rootfs '/' while running 'clean.sh'." 1>&2
				exit 1
			fi
		done

		# If `TERMUX__PREFIX` is under `TERMUX_APP__DATA_DIR`, then
		# just delete the entire `TERMUX_APP__DATA_DIR`. Otherwise,
		# only delete `TERMUX__PREFIX` since its parent directories could
		# be a critical directory in `TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS`.
		# This should not be an issue as package files are only packed
		# from `TERMUX_PREFIX_CLASSICAL` via `termux_step_copy_into_massagedir()`.
		if [[ "$TERMUX__PREFIX" == "$TERMUX_APP__DATA_DIR" ]] || \
			[[ "$TERMUX__PREFIX" == "$TERMUX_APP__DATA_DIR/"* ]]; then
			deletion_dir="$TERMUX_APP__DATA_DIR"
		else
			deletion_dir="$TERMUX__PREFIX"
		fi

		if [[ -e "$deletion_dir" ]]; then
			if [[ ! -d "$deletion_dir" ]]; then
				echo "A non-directory file exists at deletion directory '$deletion_dir' for TERMUX__PREFIX while running 'clean.sh'." 1>&2
				exit 1
			fi

			# If deletion directory is under rootfs `/` or not accessible
			# by current user, like the `builder` user in Termux docker
			# cannot access root owned directories.
			if [[ ! -r "$deletion_dir" ]] || [[ ! -w "$deletion_dir" ]] || [[ ! -x "$deletion_dir" ]]; then
				echo "The deletion directory '$deletion_dir' for TERMUX__PREFIX is not readable, writable or searchable while running 'clean.sh'." 1>&2
				echo "Try running 'clean.sh' with 'sudo'." 1>&2
				exit 1
			fi

			# Escape '\$[](){}|^.?+*' with backslashes.
			cgct_dir_escaped="$(printf "%s" "$CGCT_DIR" | sed -zE -e 's/[][\.|$(){}?+*^]/\\&/g')"
			find "$deletion_dir" -mindepth 1 -regextype posix-extended ! -regex "^$cgct_dir_escaped(/.*)?" -delete 2>/dev/null || true
		fi

		# Remove list of built packages.
		rm -Rf "/data/data/.built-packages"
	fi

	rm -Rf "$TERMUX_TOPDIR"
} 5< "$TERMUX_BUILD_LOCK_FILE"
