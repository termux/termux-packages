#!/bin/bash
# clean.sh - Clean everything safely.

set -euo pipefail

TERMUX_SCRIPTDIR=$(cd "$(dirname "$(realpath "$0")")"; pwd)

# Load required scripts and properties
source "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"
source "$TERMUX_SCRIPTDIR/scripts/properties.sh"

docker__create_docker_exec_pid_file

# Prevent execution on Android for safety
if [[ "$(uname -o)" == "Android" ]] || [[ -e "/system/bin/app_process" ]]; then
    echo "On-device execution of this script is disabled."
    exit 1
fi

# Load settings from .termuxrc if available
[[ -f "$HOME/.termuxrc" ]] && source "$HOME/.termuxrc"

# Default configurations
TERMUX_TOPDIR="${TERMUX_TOPDIR:-$HOME/.termux-build}"
TMPDIR="${TMPDIR:-/tmp}"
export TMPDIR

# Lock file for safe cleanup
TERMUX_BUILD_LOCK_FILE="${TMPDIR}/.termux-build.lck"
touch "$TERMUX_BUILD_LOCK_FILE"

{
    if ! flock -n 5; then
        echo "Cleanup aborted: another build process is running."
        exit 1
    fi

    # Adjust permissions for the build directory
    [[ -d "$TERMUX_TOPDIR" ]] && chmod -R +w "$TERMUX_TOPDIR" || true

    # Skip on-device builds
    if [[ "${TERMUX_ON_DEVICE_BUILD:=false}" == "false" ]]; then
        # Validate paths for TERMUX__PREFIX and TERMUX_APP__DATA_DIR
        for var_name in TERMUX__PREFIX TERMUX_APP__DATA_DIR CGCT_DIR; do
            var_value="${!var_name:-}"
            if [[ ! "$var_value" =~ ^/ ]]; then
                echo "Invalid path for $var_name: $var_value" >&2
                exit 1
            fi
        done

        # Determine the deletion directory
        deletion_dir="$TERMUX__PREFIX"
       