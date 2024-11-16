#!/bin/bash
# shellcheck disable=SC1117

# Setting the TMPDIR variable
: "${TMPDIR:=/tmp}"
export TMPDIR

# Set the build-package.sh call depth
# If its the root call, then create a file to store the list of packages and their dependencies
# that have been compiled at any instant by recursive calls to build-package.sh
if [[ ! "$TERMUX_BUILD_PACKAGE_CALL_DEPTH" =~ ^[0-9]+$ ]]; then
	export TERMUX_BUILD_PACKAGE_CALL_DEPTH=0
	export TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH="${TMPDIR}/build-package-call-built-packages-list-$(date +"%Y-%m-%d-%H.%M.%S.")$((RANDOM%1000))"
	export TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH="${TMPDIR}/build-package-call-building-packages-list-$(date +"%Y-%m-%d-%H.%M.%S.")$((RANDOM%1000))"
	echo -n " " > "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH"
	touch "$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH"
else
	export TERMUX_BUILD_PACKAGE_CALL_DEPTH=$((TERMUX_BUILD_PACKAGE_CALL_DEPTH+1))
fi

set -e -o pipefail -u

cd "$(realpath "$(dirname "$0")")"
TERMUX_SCRIPTDIR=$(pwd)
export TERMUX_SCRIPTDIR

# Store pid of current process in a file for docker__run_docker_exec_trap
source "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__create_docker_exec_pid_file

# Source the `termux_package` library.
source "$TERMUX_SCRIPTDIR/scripts/utils/termux/package/termux_package.sh"

export SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH:-$(git -c log.showSignature=false log -1 --pretty=%ct 2>/dev/null || date "+%s")}

if [ "$(uname -o)" = "Android" ] || [ -e "/system/bin/app_process" ]; then
	if [ "$(id -u)" = "0" ]; then
		echo "On-device execution of this script as root is disabled."
		exit 1
	fi

	# This variable tells all parts of build system that build
	# is performed on device.
	export TERMUX_ON_DEVICE_BUILD=true
else
	export TERMUX_ON_DEVICE_BUILD=false
fi

# Automatically enable offline set of sources and build tools.
# Offline termux-packages bundle can be created by executing
# script ./scripts/setup-offline-bundle.sh.
if [ -f "${TERMUX_SCRIPTDIR}/build-tools/.installed" ]; then
	export TERMUX_PACKAGES_OFFLINE=true
fi

# Lock file to prevent parallel running in the same environment.
TERMUX_BUILD_LOCK_FILE="${TMPDIR}/.termux-build.lck"
if [ ! -e "$TERMUX_BUILD_LOCK_FILE" ]; then
	touch "$TERMUX_BUILD_LOCK_FILE"
fi

export TERMUX_REPO_PKG_FORMAT=$(jq --raw-output '.pkg_format // "debian"' ${TERMUX_SCRIPTDIR}/repo.json)

# Special variable for internal use. It forces script to ignore
# lock file.
: "${TERMUX_BUILD_IGNORE_LOCK:=false}"

# Utility function to log an error message and exit with an error code.
# shellcheck source=scripts/build/termux_error_exit.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_error_exit.sh"

# Utility function to download a resource with an expected checksum.
# shellcheck source=scripts/build/termux_download.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_download.sh"

# Installing packages if necessary for the full operation of CGCT.
# shellcheck source=scripts/build/termux_step_setup_cgct_environment.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_cgct_environment.sh"

# Utility function for setting up Cargo C-ABI helpers.
# shellcheck source=scripts/build/setup/termux_setup_cargo_c.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_cargo_c.sh"

# Utility function for setting up pkg-config wrapper.
# shellcheck source=scripts/build/setup/termux_setup_pkg_config_wrapper.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_pkg_config_wrapper.sh"

# Utility function for setting up Crystal toolchain.
# shellcheck source=scripts/build/setup/termux_setup_crystal.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_crystal.sh"

# Utility function for setting up Flang toolchain.
# shellcheck source=scripts/build/setup/termux_setup_flang.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_flang.sh"

# Utility function for setting up GHC toolchain.
# shellcheck source=scripts/build/setup/termux_setup_ghc.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ghc.sh"

# Utility function to setup a GHC cross-compiler toolchain targeting Android.
# shellcheck source=scripts/build/setup/termux_setup_ghc_cross_compiler.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ghc_cross_compiler.sh"

# Utility function to setup cabal-install (may be used by ghc toolchain).
# shellcheck source=scripts/build/setup/termux_setup_cabal.sh.
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_cabal.sh"

# Utility function to setup jailbreak-cabal. It is used to remove version constraints
# from Cabal packages.
# shellcheck source=scripts/build/setup/termux_setup_jailbreak_cabal.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_jailbreak_cabal.sh"

# Utility function for setting up GObject Introspection cross environment.
# shellcheck source=scripts/build/setup/termux_setup_gir.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_gir.sh"

# Utility function for setting up GN toolchain.
# shellcheck source=scripts/build/setup/termux_setup_gn.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_gn.sh"

# Utility function for golang-using packages to setup a go toolchain.
# shellcheck source=scripts/build/setup/termux_setup_golang.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_golang.sh"

# Utility function for setting up no-integrated (GNU Binutils) as.
# shellcheck source=scripts/build/setup/termux_setup_no_integrated_as.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_no_integrated_as.sh"

# Utility function for python packages to setup a python.
# shellcheck source=scripts/build/setup/termux_setup_python_pip.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_python_pip.sh"

# Utility function for rust-using packages to setup a rust toolchain.
# shellcheck source=scripts/build/setup/termux_setup_rust.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_rust.sh"

# Utility function for swift-using packages to setup a swift toolchain
# shellcheck source=scripts/build/setup/termux_setup_swift.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_swift.sh"

# Utility function to setup a current xmake build system.
# shellcheck source=scripts/build/setup/termux_setup_xmake.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_xmake.sh"

# Utility function for zig-using packages to setup a zig toolchain.
# shellcheck source=scripts/build/setup/termux_setup_zig.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_zig.sh"

# Utility function to setup a current ninja build system.
# shellcheck source=scripts/build/setup/termux_setup_ninja.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ninja.sh"

# Utility function to setup Node.js JavaScript Runtime
# shellcheck source=scripts/build/setup/termux_setup_nodejs.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_nodejs.sh"

# Utility function to setup a current meson build system.
# shellcheck source=scripts/build/setup/termux_setup_meson.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_meson.sh"

# Utility function to setup a current cmake build system
# shellcheck source=scripts/build/setup/termux_setup_cmake.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_cmake.sh"

# Utility function to setup protobuf:
# shellcheck source=scripts/build/setup/termux_setup_protobuf.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_protobuf.sh"

# Setup variables used by the build. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_setup_variables.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_variables.sh"

# Save away and restore build setups which may change between builds.
# shellcheck source=scripts/build/termux_step_handle_buildarch.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_handle_buildarch.sh"

# Function to get TERMUX_PKG_VERSION from build.sh
# shellcheck source=scripts/build/termux_extract_dep_info.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_extract_dep_info.sh"

# Function that downloads a .deb (using the termux_download function)
# shellcheck source=scripts/build/termux_download_deb_pac.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_download_deb_pac.sh"

# Script to download InRelease, verify it's signature and then download Packages.xz by hash
# shellcheck source=scripts/build/termux_get_repo_files.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_get_repo_files.sh"

# Download or build dependencies. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_get_dependencies.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_get_dependencies.sh"

# Download python dependency modules for compilation.
# shellcheck source=scripts/build/termux_step_get_dependencies_python.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_get_dependencies_python.sh"

# Handle config scripts that needs to be run during build. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_override_config_scripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_override_config_scripts.sh"

# Remove old src and build folders and create new ones
# shellcheck source=scripts/build/termux_step_setup_build_folders.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_build_folders.sh"

# Source the package build script and start building. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_start_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_start_build.sh"

# Download or build dependencies. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_create_timestamp_file.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_timestamp_file.sh"

# Run just after sourcing $TERMUX_PKG_BUILDER_SCRIPT. Can be overridden by packages.
# shellcheck source=scripts/build/get_source/termux_step_get_source.sh
source "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_step_get_source.sh"

# Run from termux_step_get_source if TERMUX_PKG_SRCURL begins with "git+".
# shellcheck source=scripts/build/get_source/termux_step_get_source.sh
source "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_git_clone_src.sh"

# Run from termux_step_get_source if TERMUX_PKG_SRCURL does not begin with "git+".
# shellcheck source=scripts/build/get_source/termux_download_src_archive.sh
source "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_download_src_archive.sh"

# Run from termux_step_get_source after termux_download_src_archive.
# shellcheck source=scripts/build/get_source/termux_unpack_src_archive.sh
source "$TERMUX_SCRIPTDIR/scripts/build/get_source/termux_unpack_src_archive.sh"

# Hook for packages to act just after the package sources have been obtained.
# Invoked from $TERMUX_PKG_SRCDIR.
termux_step_post_get_source() {
	return
}

# Optional host build. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_handle_host_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_handle_host_build.sh"

# Perform a host build. Will be called in $TERMUX_PKG_HOSTBUILD_DIR.
# After termux_step_post_get_source() and before termux_step_patch_package()
# shellcheck source=scripts/build/termux_step_host_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_host_build.sh"

# Setup a standalone Android NDK toolchain. Called from termux_step_setup_toolchain.
# shellcheck source=scripts/build/toolchain/termux_setup_toolchain_27c.sh
source "$TERMUX_SCRIPTDIR/scripts/build/toolchain/termux_setup_toolchain_27c.sh"

# Setup a standalone Android NDK 23c toolchain. Called from termux_step_setup_toolchain.
# shellcheck source=scripts/build/toolchain/termux_setup_toolchain_23c.sh
source "$TERMUX_SCRIPTDIR/scripts/build/toolchain/termux_setup_toolchain_23c.sh"

# Setup a standalone Glibc GNU toolchain. Called from termux_step_setup_toolchain.
# shellcheck source=scripts/build/toolchain/termux_setup_toolchain_gnu.sh
source "$TERMUX_SCRIPTDIR/scripts/build/toolchain/termux_setup_toolchain_gnu.sh"

# Runs termux_step_setup_toolchain_${TERMUX_NDK_VERSION}. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_setup_toolchain.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_toolchain.sh"

# Apply all *.patch files for the package. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_patch_package.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_patch_package.sh"

# Replace autotools build-aux/config.{sub,guess} with ours to add android targets.
# shellcheck source=scripts/build/termux_step_replace_guess_scripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_replace_guess_scripts.sh"

# For package scripts to override. Called in $TERMUX_PKG_BUILDDIR.
termux_step_pre_configure() {
	return
}

# Setup configure args and run $TERMUX_PKG_SRCDIR/configure. This function is called from termux_step_configure
# shellcheck source=scripts/build/configure/termux_step_configure_autotools.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_autotools.sh"

# Setup configure args and run cmake. This function is called from termux_step_configure
# shellcheck source=scripts/build/configure/termux_step_configure_cmake.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_cmake.sh"

# Setup configure args and run meson. This function is called from termux_step_configure
# shellcheck source=scripts/build/configure/termux_step_configure_meson.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_meson.sh"

# Setup configure args and run haskell build system. This function is called from termux_step_configure.
# shellcheck source=scripts/build/configure/termux_step_configure_haskell_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_haskell_build.sh"

# Configure the package
# shellcheck source=scripts/build/configure/termux_step_configure.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure.sh"

# Hook for packages after configure step
termux_step_post_configure() {
	return
}

# Make package, either with ninja or make
# shellcheck source=scripts/build/termux_step_make.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_make.sh"

# Make install, either with ninja, make of cargo
# shellcheck source=scripts/build/termux_step_make_install.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_make_install.sh"

# Hook function for package scripts to override.
termux_step_post_make_install() {
	return
}

# Add service scripts from array TERMUX_PKG_SERVICE_SCRIPT, if it is set
# shellcheck source=scripts/build/termux_step_install_service_scripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_install_service_scripts.sh"

# Link/copy the LICENSE for the package to $TERMUX_PREFIX/share/$TERMUX_PKG_NAME/
# shellcheck source=scripts/build/termux_step_install_license.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_install_license.sh"

# Function to cp (through tar) installed files to massage dir
# shellcheck source=scripts/build/termux_step_extract_into_massagedir.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_extract_into_massagedir.sh"

# Hook function to create {pre,post}install, {pre,post}rm-scripts for subpkgs
# shellcheck source=scripts/build/termux_step_create_subpkg_debscripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_subpkg_debscripts.sh"

# Create all subpackages. Run from termux_step_massage
# shellcheck source=scripts/build/termux_create_debian_subpackages.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_create_debian_subpackages.sh"

# Create all subpackages. Run from termux_step_massage
# shellcheck source=scripts/build/termux_create_pacman_subpackages.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_create_pacman_subpackages.sh"

# Function to run various cleanup/fixes
# shellcheck source=scripts/build/termux_step_massage.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_massage.sh"

# Hook for packages after massage step
termux_step_post_massage() {
	return
}

# Hook function to create {pre,post}install, {pre,post}rm-scripts and similar
termux_step_create_debscripts() {
	return
}

# Convert Debian maintainer scripts into pacman-compatible installation hooks.
# This is used only when creating pacman packages.
# shellcheck source=scripts/build/termux_step_create_pacman_install_hook.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_pacman_install_hook.sh"

# Create the build deb file. Not to be overridden by package scripts.
# shellcheck source=scripts/build/termux_step_create_debian_package.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_debian_package.sh"

# Create the build .pkg.tar.xz file. Not to be overridden by package scripts.
# shellcheck source=scripts/build/termux_step_create_pacman_package.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_pacman_package.sh"

# Finish the build. Not to be overridden by package scripts.
# shellcheck source=scripts/build/termux_step_finish_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_finish_build.sh"

################################################################################

# shellcheck source=scripts/properties.sh
. "$TERMUX_SCRIPTDIR/scripts/properties.sh"

if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
	# Setup TERMUX_APP_PACKAGE_MANAGER
	source "$TERMUX_PREFIX/bin/termux-setup-package-manager"

	# For on device builds cross compiling is not supported.
	# Target architecture must be same as for environment used currently.
	case "$TERMUX_APP_PACKAGE_MANAGER" in
		"apt") TERMUX_ARCH=$(dpkg --print-architecture);;
		"pacman") TERMUX_ARCH=$(pacman-conf Architecture);;
	esac
	export TERMUX_ARCH
fi

# Check if the package is in the compiled list
termux_check_package_in_built_packages_list() {
	[ ! -f "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH" ] && termux_error_exit "ERROR: file '$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH' not found."
	cat "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH" | grep -q " $1 "
	return $?
}

# Adds a package to the list of built packages if it is not in the list
termux_add_package_to_built_packages_list() {
	if ! termux_check_package_in_built_packages_list "$1"; then
		echo -n "$1 " >> $TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH
	fi
}

# Check if the package is in the compiling list
termux_check_package_in_building_packages_list() {
	[ ! -f "$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH" ] && termux_error_exit "ERROR: file '$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH' not found."
	grep -q "^${1}$" "$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH"
	return $?
}

# Special hook to prevent use of "sudo" inside package build scripts.
# build-package.sh shouldn't perform any privileged operations.
sudo() {
	termux_error_exit "Do not use 'sudo' inside build scripts. Build environment should be configured through ./scripts/setup-ubuntu.sh."
}

_show_usage() {
	echo "Usage: ./build-package.sh [options] PACKAGE_1 PACKAGE_2 ..."
	echo
	echo "Build a package by creating a .deb file in the debs/ folder."
	echo
	echo "Available options:"
	[ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && echo "  -a The architecture to build for: aarch64 (default), arm, i686, x86_64, riscv64 or all."
	echo "  -d Build with debug symbols."
	echo "  -D Build a disabled package in disabled-packages/."
	echo "  -f Force build even if package has already been built."
	echo "  -F Force build even if package and its dependencies have already been built."
	[ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && echo "  -i Download and extract dependencies instead of building them."
	echo "  -I Download and extract dependencies instead of building them, keep existing $TERMUX_BASE_DIR files."
	echo "  -L The package and its dependencies will be based on the same library."
	echo "  -q Quiet build."
	echo "  -w Install dependencies without version binding."
	echo "  -s Skip dependency check."
	echo "  -o Specify directory where to put built packages. Default: output/."
	echo "  --format Specify package output format (debian, pacman)."
	echo "  --library Specify library of package (bionic, glibc)."
	exit 1
}

declare -a PACKAGE_LIST=()

if [ "$#" -lt 1 ]; then _show_usage; fi
while (($# >= 1)); do
	case "$1" in
		--) shift 1; break;;
		-h|--help) _show_usage;;
		--format)
			if [ $# -ge 2 ]; then
				shift 1
				if [ -z "$1" ]; then
					termux_error_exit "./build-package.sh: argument to '--format' should not be empty"
				fi
				export TERMUX_PACKAGE_FORMAT="$1"
			else
				termux_error_exit "./build-package.sh: option '--format' requires an argument"
			fi
			;;
		--library)
			if [ $# -ge 2 ]; then
				shift
				if [ -z "$1" ]; then
					termux_error_exit "./build-package.sh: argument to '--library' should not be empty"
				fi
				export TERMUX_PACKAGE_LIBRARY="$1"
			else
				termux_error_exit "./build-package.sh: option '--library' requires an argument"
			fi
			;;
		-a)
			if [ $# -ge 2 ]; then
				shift 1
				if [ -z "$1" ]; then
					termux_error_exit "Argument to '-a' should not be empty."
				fi
				if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
					termux_error_exit "./build-package.sh: option '-a' is not available for on-device builds"
				else
					export TERMUX_ARCH="$1"
				fi
			else
				termux_error_exit "./build-package.sh: option '-a' requires an argument"
			fi
			;;
		-d) export TERMUX_DEBUG_BUILD=true;;
		-D) TERMUX_IS_DISABLED=true;;
		-f) TERMUX_FORCE_BUILD=true;;
		-F) TERMUX_FORCE_BUILD_DEPENDENCIES=true && TERMUX_FORCE_BUILD=true;;
		-i)
			if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
				termux_error_exit "./build-package.sh: option '-i' is not available for on-device builds"
			elif [ "$TERMUX_PREFIX" != "/data/data/com.termux/files/usr" ]; then
				termux_error_exit "./build-package.sh: option '-i' is available only when TERMUX_APP_PACKAGE is 'com.termux'"
			else
				export TERMUX_INSTALL_DEPS=true
			fi
			;;
		-I)
			if [ "$TERMUX_PREFIX" != "/data/data/com.termux/files/usr" ]; then
				termux_error_exit "./build-package.sh: option '-I' is available only when TERMUX_APP_PACKAGE is 'com.termux'"
			else
				export TERMUX_INSTALL_DEPS=true
				export TERMUX_NO_CLEAN=true
			fi
			;;
		-L) export TERMUX_GLOBAL_LIBRARY=true;;
		-q) export TERMUX_QUIET_BUILD=true;;
		-w) export TERMUX_WITHOUT_DEPVERSION_BINDING=true;;
		-s) export TERMUX_SKIP_DEPCHECK=true;;
		-o)
			if [ $# -ge 2 ]; then
				shift 1
				if [ -z "$1" ]; then
					termux_error_exit "./build-package.sh: argument to '-o' should not be empty"
				fi
				TERMUX_OUTPUT_DIR=$(realpath -m "$1")
			else
				termux_error_exit "./build-package.sh: option '-o' requires an argument"
			fi
			;;
		-c) TERMUX_CONTINUE_BUILD=true;;
		-*) termux_error_exit "./build-package.sh: illegal option '$1'";;
		*) PACKAGE_LIST+=("$1");;
	esac
	shift 1
done
unset -f _show_usage

# Dependencies should be used from repo only if they are built for
# same package name.
if [ "$TERMUX_REPO_PACKAGE" != "$TERMUX_APP_PACKAGE" ]; then
	echo "Ignoring -i option to download dependencies since repo package name ($TERMUX_REPO_PACKAGE) does not equal app package name ($TERMUX_APP_PACKAGE)"
	TERMUX_INSTALL_DEPS=false
fi

if [ "$TERMUX_REPO_PKG_FORMAT" != "debian" ] && [ "$TERMUX_REPO_PKG_FORMAT" != "pacman" ]; then
	termux_error_exit "'pkg_format' is incorrectly specified in repo.json file. Only 'debian' and 'pacman' formats are supported"
fi

if [ -n "${TERMUX_PACKAGE_FORMAT-}" ]; then
	case "${TERMUX_PACKAGE_FORMAT-}" in
		debian|pacman) :;;
		*) termux_error_exit "Unsupported package format \"${TERMUX_PACKAGE_FORMAT-}\". Only 'debian' and 'pacman' formats are supported";;
	esac
fi

if [ -n "${TERMUX_PACKAGE_LIBRARY-}" ]; then
	case "${TERMUX_PACKAGE_LIBRARY-}" in
		bionic|glibc) :;;
		*) termux_error_exit "Unsupported library \"${TERMUX_PACKAGE_LIBRARY-}\". Only 'bionic' and 'glibc' library are supported";;
	esac
fi

if [ "${TERMUX_INSTALL_DEPS-false}" = "true" ] || [ "${TERMUX_PACKAGE_LIBRARY-bionic}" = "glibc" ]; then
	# Setup PGP keys for verifying integrity of dependencies.
	# Keys are obtained from our keyring package.
	gpg --list-keys 2C7F29AE97891F6419A9E2CDB0076E490B71616B > /dev/null 2>&1 || {
		gpg --import "$TERMUX_SCRIPTDIR/packages/termux-keyring/grimler.gpg"
		gpg --no-tty --command-file <(echo -e "trust\n5\ny")  --edit-key 2C7F29AE97891F6419A9E2CDB0076E490B71616B
	}
	gpg --list-keys CC72CF8BA7DBFA0182877D045A897D96E57CF20C > /dev/null 2>&1 || {
		gpg --import "$TERMUX_SCRIPTDIR/packages/termux-keyring/termux-autobuilds.gpg"
		gpg --no-tty --command-file <(echo -e "trust\n5\ny")  --edit-key CC72CF8BA7DBFA0182877D045A897D96E57CF20C
	}
	gpg --list-keys 998DE27318E867EA976BA877389CEED64573DFCA > /dev/null 2>&1 || {
		gpg --import "$TERMUX_SCRIPTDIR/packages/termux-keyring/termux-pacman.gpg"
		gpg --no-tty --command-file <(echo -e "trust\n5\ny")  --edit-key 998DE27318E867EA976BA877389CEED64573DFCA
	}
fi

for ((i=0; i<${#PACKAGE_LIST[@]}; i++)); do
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
		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && [ -n "${TERMUX_ARCH+x}" ] && [ "${TERMUX_ARCH}" = 'all' ]; then
			for arch in 'aarch64' 'arm' 'i686' 'x86_64' 'riscv64'; do
				env TERMUX_ARCH="$arch" TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
					${TERMUX_FORCE_BUILD+-f} ${TERMUX_INSTALL_DEPS+-i} ${TERMUX_IS_DISABLED+-D} \
					${TERMUX_DEBUG_BUILD+-d} ${TERMUX_OUTPUT_DIR+-o $TERMUX_OUTPUT_DIR} \
					${TERMUX_FORCE_BUILD_DEPENDENCIES+-F} ${TERMUX_GLOBAL_LIBRARY+-L} \
					${TERMUX_WITHOUT_DEPVERSION_BINDING+-w} \
					--format ${TERMUX_PACKAGE_FORMAT:=debian} \
					--library ${TERMUX_PACKAGE_LIBRARY:=bionic} "${PACKAGE_LIST[i]}"
			done
			exit
		fi

		# Check the package to build:
		TERMUX_PKG_NAME=$(basename "${PACKAGE_LIST[i]}")
		export TERMUX_PKG_BUILDER_DIR=
		if [[ ${PACKAGE_LIST[i]} == *"/"* ]]; then
			# Path to directory which may be outside this repo:
			if [ ! -d "${PACKAGE_LIST[i]}" ]; then termux_error_exit "'${PACKAGE_LIST[i]}' seems to be a path but is not a directory"; fi
			export TERMUX_PKG_BUILDER_DIR=$(realpath "${PACKAGE_LIST[i]}")
		else
			# Package name:
			for package_directory in $TERMUX_PACKAGES_DIRECTORIES; do
				if [ -d "${TERMUX_SCRIPTDIR}/${package_directory}/${TERMUX_PKG_NAME}" ]; then
					export TERMUX_PKG_BUILDER_DIR=${TERMUX_SCRIPTDIR}/$package_directory/$TERMUX_PKG_NAME
					break
				elif [ -n "${TERMUX_IS_DISABLED=""}" ] && [ -d "${TERMUX_SCRIPTDIR}/disabled-packages/${TERMUX_PKG_NAME}" ]; then
					export TERMUX_PKG_BUILDER_DIR=$TERMUX_SCRIPTDIR/disabled-packages/$TERMUX_PKG_NAME
					break
				fi
			done
			if [ -z "${TERMUX_PKG_BUILDER_DIR}" ]; then
				termux_error_exit "No package $TERMUX_PKG_NAME found in any of the enabled repositories. Are you trying to set up a custom repository?"
			fi
		fi
		TERMUX_PKG_BUILDER_SCRIPT=$TERMUX_PKG_BUILDER_DIR/build.sh
		if test ! -f "$TERMUX_PKG_BUILDER_SCRIPT"; then
			termux_error_exit "No build.sh script at package dir $TERMUX_PKG_BUILDER_DIR!"
		fi

		termux_step_setup_variables
		termux_step_handle_buildarch

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			termux_step_setup_build_folders
		fi

		termux_step_start_build

		if ! termux_check_package_in_building_packages_list "${TERMUX_PKG_BUILDER_DIR#${TERMUX_SCRIPTDIR}/}"; then
			echo "${TERMUX_PKG_BUILDER_DIR#${TERMUX_SCRIPTDIR}/}" >> $TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH
		fi

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			termux_step_get_dependencies
			if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
				termux_step_setup_cgct_environment
			fi
			termux_step_override_config_scripts
		fi

		termux_step_create_timestamp_file

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			cd "$TERMUX_PKG_CACHEDIR"
			termux_step_get_source
			cd "$TERMUX_PKG_SRCDIR"
			termux_step_post_get_source
			termux_step_handle_host_build
		fi

		termux_step_setup_toolchain

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			termux_step_get_dependencies_python
			termux_step_patch_package
			termux_step_replace_guess_scripts
			cd "$TERMUX_PKG_SRCDIR"
			termux_step_pre_configure
		fi

		# Even on continued build we might need to setup paths
		# to tools so need to run part of configure step
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_configure

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			cd "$TERMUX_PKG_BUILDDIR"
			termux_step_post_configure
		fi
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make_install
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_post_make_install
		termux_step_install_service_scripts
		termux_step_install_license
		cd "$TERMUX_PKG_MASSAGEDIR"
		termux_step_extract_into_massagedir
		termux_step_massage
		cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
		termux_step_post_massage
		cd "$TERMUX_PKG_MASSAGEDIR"
		if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ]; then
			termux_step_create_debian_package
		elif [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
			termux_step_create_pacman_package
		else
			termux_error_exit "Unknown packaging format '$TERMUX_PACKAGE_FORMAT'."
		fi
		# Saving a list of compiled packages for further work with it
		if termux_check_package_in_building_packages_list "${TERMUX_PKG_BUILDER_DIR#${TERMUX_SCRIPTDIR}/}"; then
			sed -i "\|^${TERMUX_PKG_BUILDER_DIR#${TERMUX_SCRIPTDIR}/}$|d" "$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH"
		fi
		termux_add_package_to_built_packages_list "$TERMUX_PKG_NAME"
		termux_step_finish_build
	) 5< "$TERMUX_BUILD_LOCK_FILE"
done

# Removing a file to store a list of compiled packages
if [ "$TERMUX_BUILD_PACKAGE_CALL_DEPTH" = "0" ]; then
	rm "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH"
	rm "$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH"
fi
