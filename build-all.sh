#!/bin/bash
# build-all.sh - Script to build all packages with a build order specified by buildorder.py

set -euo pipefail

TERMUX_SCRIPTDIR=$(cd "$(dirname "$(realpath "$0")")"; pwd)

# Ensure script is not run on-device
if [[ "$(uname -o)" == "Android" ]] || [[ -e "/system/bin/app_process" ]]; then
    echo "On-device execution of this script is not supported."
    exit 1
fi

# Load settings from .termuxrc if available
[[ -f "$HOME/.termuxrc" ]] && . "$HOME/.termuxrc"

# Default configurations
TERMUX_TOPDIR="${TERMUX_TOPDIR:-$HOME/.termux-build}"
TERMUX_ARCH="${TERMUX_ARCH:-aarch64}"
TERMUX_DEBUG_BUILD="${TERMUX_DEBUG_BUILD:-}"
TERMUX_INSTALL_DEPS="${TERMUX_INSTALL_DEPS:--s}"

# Usage instructions
show_usage() {
    cat <<EOF
Usage: ./build-all.sh [-a ARCH] [-d] [-i] [-o DIR]
Options:
  -a  Architecture to build (default: aarch64): aarch64, arm, i686, x86_64, or all.
  -d  Build with debug symbols.
  -i  Build dependencies.
  -o  Specify output directory for debs (default: debs/).
  -h  Show this help message.
EOF
    exit 1
}

# Parse options
while getopts ":a:dio:h" option; do
    case "$option" in
        a) TERMUX_ARCH="$OPTARG" ;;
        d) TERMUX_DEBUG_BUILD="-d" ;;
        i) TERMUX_INSTALL_DEPS="-i" ;;
        o) TERMUX_OUTPUT_DIR=$(realpath -m "$OPTARG") ;;
        h) show_usage ;;
        *) show_usage >&2 ;;
    esac
done
shift $((OPTIND - 1))
[[ "$#" -ne 0 ]] && show_usage

# Validate architecture
if [[ ! "$TERMUX_ARCH" =~ ^(all|aarch64|arm|i686|x86_64)$ ]]; then
    echo "ERROR: Invalid architecture '$TERMUX_ARCH'" >&2
    exit 1
fi

# File paths
BUILDALL_DIR="$TERMUX_TOPDIR/_buildall-$TERMUX_ARCH"
BUILDORDER_FILE="$BUILDALL_DIR/buildorder.txt"
BUILDSTATUS_FILE="$BUILDALL_DIR/buildstatus.txt"
BUILDSCRIPT="$TERMUX_SCRIPTDIR/build-package.sh"

# Generate build order if not already present
mkdir -p "$BUILDALL_DIR"
if [[ ! -e "$BUILDORDER_FILE" ]]; then
    "$TERMUX_SCRIPTDIR/scripts/buildorder.py" > "$BUILDORDER_FILE"
fi

# Setup logging and error handling
exec > >(tee -a "$BUILDALL_DIR/ALL.out")
exec 2> >(tee -a "$BUILDALL_DIR/ALL.err" >&2)
trap 'echo ERROR: See $BUILDALL_DIR/${PKG}.err' ERR

# Iterate through packages in build order
while read -r PKG PKG_DIR; do
    # Skip already built packages
    if [[ -e "$BUILDSTATUS_FILE" && $(grep -Fxq "$PKG" "$BUILDSTATUS_FILE") ]]; then
        echo "Skipping $PKG"
        continue
    fi

    echo -n "Building $PKG... "
    BUILD_START=$(date "+%s")
    bash -x "$BUILDSCRIPT" -a "$TERMUX_ARCH" $TERMUX_DEBUG_BUILD \
        ${TERMUX_OUTPUT_DIR+-o "$TERMUX_OUTPUT_DIR"} $TERMUX_INSTALL_DEPS "$PKG_DIR" \
        > "$BUILDALL_DIR/${PKG}.out" 2> "$BUILDALL_DIR/${PKG}.err"
    BUILD_SECONDS=$(( $(date "+%s") - BUILD_START ))
    echo "done in $BUILD_SECONDS seconds"

    # Update build status
    echo "$PKG" >> "$BUILDSTATUS_FILE"
done < "$BUILDORDER_FILE"

# Cleanup and completion message
rm -f "$BUILDSTATUS_FILE"
echo "Build process completed successfully."