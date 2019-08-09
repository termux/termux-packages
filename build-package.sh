#!/bin/bash
# shellcheck disable=SC1117

set -e -o pipefail -u

: "${TMPDIR:=/tmp}"
export TMPDIR

if [ "$(uname -o)" = "Android" ] || [ -e "/system/bin/app_process" ]; then
	if [ "$(id -u)" = "0" ]; then
		echo "On-device execution of this script as root is disabled."
		exit 1
	fi

	# This variable tells all parts of build system that build
	# is performed on device.
	export TERMUX_ON_DEVICE_BUILD=true
else
	export TERMUX_ON_DEVICE_BUILD=
fi

# Lock file to prevent parallel running in the same environment.
TERMUX_BUILD_LOCK_FILE="${TMPDIR}/.termux-build.lck"
if [ ! -e "$TERMUX_BUILD_LOCK_FILE" ]; then
	touch "$TERMUX_BUILD_LOCK_FILE"
fi

# Special variable for internal use. It forces script to ignore
# lock file.
: "${TERMUX_BUILD_IGNORE_LOCK:=false}"

# Utility function to log an error message and exit with an error code.
source scripts/build/termux_error_exit.sh

# Utility function to download a resource with an expected checksum.
source scripts/build/termux_download.sh

# Utility function for golang-using packages to setup a go toolchain.
source scripts/build/setup/termux_setup_golang.sh

# Utility function for rust-using packages to setup a rust toolchain.
source scripts/build/setup/termux_setup_rust.sh

# Utility function to setup a current ninja build system.
source scripts/build/setup/termux_setup_ninja.sh

# Utility function to setup a current meson build system.
source scripts/build/setup/termux_setup_meson.sh

# Utility function to setup a current cmake build system
source scripts/build/setup/termux_setup_cmake.sh

# Utility function to setup protobuf:
source scripts/build/setup/termux_setup_protobuf.sh

# Setup variables used by the build. Not to be overridden by packages.
source scripts/build/termux_step_setup_variables.sh

# Save away and restore build setups which may change between builds.
source scripts/build/termux_step_handle_buildarch.sh

# Function to get TERMUX_PKG_VERSION from build.sh
source scripts/build/termux_extract_dep_info.sh

# Function that downloads a .deb (using the termux_download function)
source scripts/build/termux_download_deb.sh

# Script to download InRelease, verify it's signature and then download Packages.xz by hash
source scripts/build/termux_get_repo_files.sh

# Source the package build script and start building. No to be overridden by packages.
source scripts/build/termux_step_start_build.sh

# Run just after sourcing $TERMUX_PKG_BUILDER_SCRIPT. May be overridden by packages.
source scripts/build/termux_step_extract_package.sh

# Hook for packages to act just after the package has been extracted.
# Invoked in $TERMUX_PKG_SRCDIR.
termux_step_post_extract_package() {
	return
}

# Optional host build. Not to be overridden by packages.
source scripts/build/termux_step_handle_hostbuild.sh

# Perform a host build. Will be called in $TERMUX_PKG_HOSTBUILD_DIR.
# After termux_step_post_extract_package() and before termux_step_patch_package()
source scripts/build/termux_step_host_build.sh

# Setup a standalone Android NDK toolchain. Not to be overridden by packages.
source scripts/build/termux_step_setup_toolchain.sh

# Apply all *.patch files for the package. Not to be overridden by packages.
source scripts/build/termux_step_patch_package.sh

# Replace autotools build-aux/config.{sub,guess} with ours to add android targets.
source scripts/build/termux_step_replace_guess_scripts.sh

# For package scripts to override. Called in $TERMUX_PKG_BUILDDIR.
termux_step_pre_configure() {
	return
}

# Setup configure args and run $TERMUX_PKG_SRCDIR/configure. This function is called from termux_step_configure
source scripts/build/configure/termux_step_configure_autotools.sh

# Setup configure args and run cmake. This function is called from termux_step_configure
source scripts/build/configure/termux_step_configure_cmake.sh

# Setup configure args and run meson. This function is called from termux_step_configure
source scripts/build/configure/termux_step_configure_meson.sh

# Configure the package
source scripts/build/configure/termux_step_configure.sh

# Hook for packages after configure step
termux_step_post_configure() {
	return
}

# Make package, either with ninja or make
source scripts/build/termux_step_make.sh

# Make install, either with ninja, make of cargo
source scripts/build/termux_step_make_install.sh

# Hook function for package scripts to override.
termux_step_post_make_install() {
	return
}

# Link/copy the LICENSE for the package to $TERMUX_PREFIX/share/$TERMUX_PKG_NAME/
source scripts/build/termux_step_install_license.sh

# Function to cp (through tar) installed files to massage dir
source scripts/build/termux_step_extract_into_massagedir.sh

# Create all subpackages. Run from termux_step_massage
source scripts/build/termux_create_subpackages.sh

# Function to run various cleanup/fixes
source scripts/build/termux_step_massage.sh

# Hook for packages after massage step
termux_step_post_massage() {
	return
}

# Create data.tar.gz with files to package. Not to be overridden by package scripts.
source scripts/build/termux_step_create_datatar.sh

# Hook function to create {pre,post}install, {pre,post}rm-scripts and similar
termux_step_create_debscripts() {
	return
}

# Create the build deb file. Not to be overridden by package scripts.
source scripts/build/termux_step_create_debfile.sh

# Finish the build. Not to be overridden by package scripts.
source scripts/build/termux_step_finish_build.sh

################################################################################

TERMUX_SCRIPTDIR=$(cd "$(dirname "$0")"; pwd)
export TERMUX_SCRIPTDIR

# shellcheck source=scripts/properties.sh
. "$TERMUX_SCRIPTDIR/scripts/properties.sh"

if [ -n "$TERMUX_ON_DEVICE_BUILD" ]; then
	# For on device builds cross compiling is not supported.
	# Target architecture must be same as for environment used currently.
	export TERMUX_ARCH=$(dpkg --print-architecture)
fi

_show_usage() {
    echo "Usage: ./build-package.sh [options] PACKAGE_1 PACKAGE_2 ..."
    echo
    echo "Build a package by creating a .deb file in the debs/ folder."
    echo
    echo "Available options:"
    [ -z "$TERMUX_ON_DEVICE_BUILD" ] && echo "  -a The architecture to build for: aarch64(default), arm, i686, x86_64 or all."
    echo "  -d Build with debug symbols."
    echo "  -D Build a disabled package in disabled-packages/."
    echo "  -f Force build even if package has already been built."
    [ -z "$TERMUX_ON_DEVICE_BUILD" ] && echo "  -i Download and extract dependencies instead of building them."
    echo "  -I Download and extract dependencies instead of building them, keep existing /data/data/com.termux files."
    echo "  -q Quiet build."
    echo "  -s Skip dependency check."
    echo "  -o Specify deb directory. Default: debs/."
    exit 1
}

while getopts :a:hdDfiIqso: option; do
	case "$option" in
		a)
			if [ -n "$TERMUX_ON_DEVICE_BUILD" ]; then
				termux_error_exit "./build-package.sh: option '-a' is not available for on-device builds"
			else
				export TERMUX_ARCH="$OPTARG"
			fi
			;;
		h) _show_usage;;
		d) export TERMUX_DEBUG=true;;
		D) local TERMUX_IS_DISABLED=true;;
		f) TERMUX_FORCE_BUILD=true;;
		i)
			if [ -n "$TERMUX_ON_DEVICE_BUILD" ]; then
				termux_error_exit "./build-package.sh: option '-i' is not available for on-device builds"
			else
				export TERMUX_INSTALL_DEPS=true
			fi
			;;
		I) export TERMUX_INSTALL_DEPS=true && export TERMUX_NO_CLEAN=true;;
		q) export TERMUX_QUIET_BUILD=true;;
		s) export TERMUX_SKIP_DEPCHECK=true;;
		o) TERMUX_DEBDIR="$(realpath -m $OPTARG)";;
		?) termux_error_exit "./build-package.sh: illegal option -$OPTARG";;
	esac
done
shift $((OPTIND-1))

if [ "$#" -lt 1 ]; then _show_usage; fi
unset -f _show_usage

while (($# > 0)); do
	# Following commands must be executed under lock to prevent running
	# multiple instances of "./build-package.sh".
	#
	# To provide sane environment for each package, builds are done
	# in subshell.
	(
		if ! $TERMUX_BUILD_IGNORE_LOCK; then
			flock -n 5 || termux_error_exit "Another build is already running within same environment."
		fi

		# Handle 'all' arch:
		if [ -z "$TERMUX_ON_DEVICE_BUILD" ] && [ -n "${TERMUX_ARCH+x}" ] && [ "${TERMUX_ARCH}" = 'all' ]; then
			for arch in 'aarch64' 'arm' 'i686' 'x86_64'; do
				env TERMUX_ARCH="$arch" TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
					${TERMUX_FORCE_BUILD+-f} ${TERMUX_INSTALL_DEPS+-i} ${TERMUX_IS_DISABLED+-D} \
					${TERMUX_DEBUG+-d} ${TERMUX_DEBDIR+-o $TERMUX_DEBDIR} "$1"
			done
			exit
		fi

		# Check the package to build:
		TERMUX_PKG_NAME=$(basename "$1")
		if [[ $1 == *"/"* ]]; then
			# Path to directory which may be outside this repo:
			if [ ! -d "$1" ]; then termux_error_exit "'$1' seems to be a path but is not a directory"; fi
			export TERMUX_PKG_BUILDER_DIR
			TERMUX_PKG_BUILDER_DIR=$(realpath "$1")
		else
			# Package name:
			if [ -n "${TERMUX_IS_DISABLED=""}" ]; then
				export TERMUX_PKG_BUILDER_DIR=$TERMUX_SCRIPTDIR/disabled-packages/$TERMUX_PKG_NAME
			else
				export TERMUX_PKG_BUILDER_DIR=$TERMUX_SCRIPTDIR/packages/$TERMUX_PKG_NAME
			fi
		fi
		TERMUX_PKG_BUILDER_SCRIPT=$TERMUX_PKG_BUILDER_DIR/build.sh
		if test ! -f "$TERMUX_PKG_BUILDER_SCRIPT"; then
			termux_error_exit "No build.sh script at package dir $TERMUX_PKG_BUILDER_DIR!"
		fi

		termux_step_setup_variables
		termux_step_handle_buildarch
		termux_step_start_build
		termux_step_extract_package
		cd "$TERMUX_PKG_SRCDIR"
		termux_step_post_extract_package
		termux_step_handle_hostbuild
		termux_step_setup_toolchain
		termux_step_patch_package
		termux_step_replace_guess_scripts
		cd "$TERMUX_PKG_SRCDIR"
		termux_step_pre_configure
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_configure
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_post_configure
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make_install
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_post_make_install
		termux_step_install_license
		cd "$TERMUX_PKG_MASSAGEDIR"
		termux_step_extract_into_massagedir
		cd "$TERMUX_PKG_MASSAGEDIR"
		termux_step_massage
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
		termux_step_post_massage
		termux_step_create_datatar
		termux_step_create_debfile
		termux_step_finish_build
	) 5< "$TERMUX_BUILD_LOCK_FILE"

	shift 1
done
