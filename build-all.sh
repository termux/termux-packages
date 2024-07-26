#!/bin/bash
# build-all.sh - script to build all packages with a build order specified by buildorder.py

set -e -u -o pipefail

TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; pwd)

# Store pid of current process in a file for docker__run_docker_exec_trap
source "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__create_docker_exec_pid_file

if [ "$(uname -o)" = "Android" ] || [ -e "/system/bin/app_process" ]; then
	echo "On-device execution of this script is not supported."
	exit 1
fi

# Read settings from .termuxrc if existing
test -f "$HOME"/.termuxrc && . "$HOME"/.termuxrc
: ${TERMUX_TOPDIR:="$HOME/.termux-build"}
: ${TERMUX_ARCH:="aarch64"}
: ${TERMUX_FORMAT:="debian"}
: ${TERMUX_DEBUG_BUILD:=""}
: ${TERMUX_INSTALL_DEPS:=""}

_show_usage() {
	echo "Usage: ./build-all.sh [-a ARCH] [-d] [-i] [-o DIR] [-f FORMAT]"
	echo "Build all packages."
	echo "  -a The architecture to build for: aarch64(default), arm, i686, x86_64 or all."
	echo "  -d Build with debug symbols."
	echo "  -i Build dependencies."
	echo "  -o Specify deb directory. Default: debs/."
	echo "  -f Specify format pkg. Default: debian."
	exit 1
}

while getopts :a:hdio:f: option; do
case "$option" in
	a) TERMUX_ARCH="$OPTARG";;
	d) TERMUX_DEBUG_BUILD='-d';;
	i) TERMUX_INSTALL_DEPS='-i';;
	o) TERMUX_OUTPUT_DIR="$(realpath -m "$OPTARG")";;
	f) TERMUX_FORMAT="$OPTARG";;
	h) _show_usage;;
	*) _show_usage >&2 ;;
esac
done
shift $((OPTIND-1))
if [ "$#" -ne 0 ]; then _show_usage; fi

if [[ ! "$TERMUX_ARCH" =~ ^(all|aarch64|arm|i686|x86_64)$ ]]; then
	echo "ERROR: Invalid arch '$TERMUX_ARCH'" 1>&2
	exit 1
fi

if [[ ! "$TERMUX_FORMAT" =~ ^(debian|pacman)$ ]]; then
	echo "ERROR: Invalid format '$TERMUX_FORMAT'" 1>&2
	exit 1
fi

BUILDSCRIPT=$(dirname "$0")/build-package.sh
BUILDALL_DIR=$TERMUX_TOPDIR/_buildall-$TERMUX_ARCH
BUILDORDER_FILE=$BUILDALL_DIR/buildorder.txt
BUILDSTATUS_FILE=$BUILDALL_DIR/buildstatus.txt

if [ -e "$BUILDORDER_FILE" ]; then
	echo "Using existing buildorder file: $BUILDORDER_FILE"
else
	mkdir -p "$BUILDALL_DIR"
	"$TERMUX_SCRIPTDIR/scripts/buildorder.py" > "$BUILDORDER_FILE"
fi
if [ -e "$BUILDSTATUS_FILE" ]; then
	echo "Continuing build-all from: $BUILDSTATUS_FILE"
fi

exec &>	>(tee -a "$BUILDALL_DIR"/ALL.out)
trap 'echo ERROR: See $BUILDALL_DIR/${PKG}.out' ERR

while read -r PKG PKG_DIR; do
	# Check build status (grepping is a bit crude, but it works)
	if [ -e "$BUILDSTATUS_FILE" ] && grep -q "^$PKG\$" "$BUILDSTATUS_FILE"; then
		echo "Skipping $PKG"
		continue
	fi

	# Start building
	if [ -n "${TERMUX_DEBUG_BUILD}" ]; then
		echo "\"$BUILDSCRIPT\" -a \"$TERMUX_ARCH\" $TERMUX_DEBUG_BUILD --format \"$TERMUX_FORMAT\" --library $(test "${PKG_DIR%/*}" = "gpkg" && echo "glibc" || echo "bionic") ${TERMUX_OUTPUT_DIR+-o $TERMUX_OUTPUT_DIR} $TERMUX_INSTALL_DEPS \"$PKG_DIR\""
	fi
	echo -n "Building $PKG... "
	BUILD_START=$(date "+%s")
	"$BUILDSCRIPT" -a "$TERMUX_ARCH" $TERMUX_DEBUG_BUILD --format "$TERMUX_FORMAT" \
		--library $(test "${PKG_DIR%/*}" = "gpkg" && echo "glibc" || echo "bionic") \
		${TERMUX_OUTPUT_DIR+-o $TERMUX_OUTPUT_DIR} $TERMUX_INSTALL_DEPS "$PKG_DIR" \
		&> "$BUILDALL_DIR"/"${PKG}".out
	BUILD_END=$(date "+%s")
	BUILD_SECONDS=$(( BUILD_END - BUILD_START ))
	echo "done in $BUILD_SECONDS sec"

	# Update build status
	echo "$PKG" >> "$BUILDSTATUS_FILE"

	# Check which packages were also compiled
	if [ -z "$TERMUX_INSTALL_DEPS" ]; then
		for build_pkg in ~/.termux-build/*; do
                        pkgname="${build_pkg##*/}"
			(grep -q '^_' <<< "${pkgname}" || grep -q "^${pkgname}\$" "$BUILDSTATUS_FILE") && continue
			echo "The \"${pkgname}\" package was also compiled"
			echo "${pkgname}" >> "$BUILDSTATUS_FILE"
		done
	fi
done<"${BUILDORDER_FILE}"

# Update build status
rm -f "$BUILDSTATUS_FILE"
echo "Finished"
