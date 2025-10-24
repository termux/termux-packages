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
: ${TERMUX_DEBUG_BUILD:=""}
: ${TERMUX_INSTALL_DEPS:=""}

_show_usage() {
	echo "Usage: ./build-all.sh [-a ARCH] [-d] [-i] [-o DIR]"
	echo "Build all packages."
	echo "  -a The architecture to build for: aarch64(default), arm, i686, x86_64 or all."
	echo "  -d Build with debug symbols."
	echo "  -i Build dependencies."
	echo "  -o Specify deb directory. Default: debs/."
	exit 1
}

while getopts :a:hdio: option; do
case "$option" in
	a) TERMUX_ARCH="$OPTARG";;
	d) TERMUX_DEBUG_BUILD='-d';;
	i) TERMUX_INSTALL_DEPS='-i';;
	o) TERMUX_OUTPUT_DIR="$(realpath -m "$OPTARG")";;
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

exec >	>(tee -a "$BUILDALL_DIR"/ALL.out)
exec 2> >(tee -a "$BUILDALL_DIR"/ALL.err >&2)
trap 'echo ERROR: See $BUILDALL_DIR/${PKG}.err' ERR

while read -r PKG PKG_DIR; do
	# Check build status (grepping is a bit crude, but it works)
	if [ -e "$BUILDSTATUS_FILE" ] && grep "^$PKG\$" "$BUILDSTATUS_FILE" >/dev/null; then
		echo "Skipping $PKG"
		continue
	fi

	echo -n "Building $PKG... "
	BUILD_START=$(date "+%s")
	bash -x "$BUILDSCRIPT" -a "$TERMUX_ARCH" $TERMUX_DEBUG_BUILD \
		${TERMUX_OUTPUT_DIR+-o $TERMUX_OUTPUT_DIR} $TERMUX_INSTALL_DEPS "$PKG_DIR" \
		> "$BUILDALL_DIR"/"${PKG}".out 2> "$BUILDALL_DIR"/"${PKG}".err
	BUILD_END=$(date "+%s")
	BUILD_SECONDS=$(( BUILD_END - BUILD_START ))
	echo "done in $BUILD_SECONDS"

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
