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

# Utility function to run binaries under termux environment via proot.
# shellcheck source=scripts/build/setup/termux_setup_proot.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_proot.sh"

# Utility function to setup blueprint-compiler (may be used by gnome-calculator and epiphany).
# shellcheck source=scripts/build/setup/termux_setup_bpc.sh.
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_bpc.sh"

# Installing packages if necessary for the full operation of CGCT.
# shellcheck source=scripts/build/termux_step_setup_cgct_environment.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_setup_cgct_environment.sh"

# Utility function to setup capnproto (may be used by bitcoin).
# shellcheck source=scripts/build/setup/termux_setup_capnp.sh.
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_capnp.sh"

# Utility function for setting up Cargo C-ABI helpers.
# shellcheck source=scripts/build/setup/termux_setup_cargo_c.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_cargo_c.sh"

# Utility function for setting up pkg-config wrapper.
# shellcheck source=scripts/build/setup/termux_setup_pkg_config_wrapper.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_pkg_config_wrapper.sh"

# Utility function for setting up Crystal toolchain.
# shellcheck source=scripts/build/setup/termux_setup_crystal.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_crystal.sh"

# Utility function for setting up DotNet toolchain.
# shellcheck source=scripts/build/setup/termux_setup_dotnet.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_dotnet.sh"

# Utility function for setting up Flang toolchain.
# shellcheck source=scripts/build/setup/termux_setup_flang.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_flang.sh"

# Utility function to setup a GHC cross-compiler toolchain targeting Android.
# shellcheck source=scripts/build/setup/termux_setup_ghc.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ghc.sh"

# Utility function to setup GHC iserv to cross-compile haskell-template.
# shellcheck source=scripts/build/setup/termux_setup_ghc_iserv.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ghc_iserv.sh"

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

# Utility function for setting up LDC cross environment.
# shellcheck source=scripts/build/setup/termux_setup_ldc.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_ldc.sh"

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

# Utility function to setup the current version of the tree-sitter CLI
# shellcheck source=scripts/build/setup/termux_setup_treesitter.sh
source "$TERMUX_SCRIPTDIR/scripts/build/setup/termux_setup_treesitter.sh"

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

# Cleans up files from already built packages. Not to be overridden by packages.
# shellcheck source=scripts/build/termux_step_start_build.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_cleanup_packages.sh"

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
# shellcheck source=scripts/build/toolchain/termux_setup_toolchain_28c.sh
source "$TERMUX_SCRIPTDIR/scripts/build/toolchain/termux_setup_toolchain_28c.sh"

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

# Setup configure args and run cabal. This function is called from termux_step_configure
# shellcheck source=scripts/build/configure/termux_step_configure_cabal.sh
source "$TERMUX_SCRIPTDIR/scripts/build/configure/termux_step_configure_cabal.sh"

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

# Install hooks (alpm-hooks) and hook-scripts into the pacman package
# shellcheck source=scripts/build/termux_step_install_pacman_hooks.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_install_pacman_hooks.sh"

# Add service scripts from array TERMUX_PKG_SERVICE_SCRIPT, if it is set
# shellcheck source=scripts/build/termux_step_install_service_scripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_install_service_scripts.sh"

# Link/copy the LICENSE for the package to $TERMUX_PREFIX/share/$TERMUX_PKG_NAME/
# shellcheck source=scripts/build/termux_step_install_license.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_install_license.sh"

# Function to cp (through tar) installed files to massage dir
# shellcheck source=scripts/build/termux_step_copy_into_massagedir.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_copy_into_massagedir.sh"

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

# Function to run strip symbols during termux_step_massage
# shellcheck source=scripts/build/termux_step_strip_elf_symbols.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_strip_elf_symbols.sh"

# Function to run termux-elf-cleaner during termux_step_massage
# shellcheck source=scripts/build/termux_step_elf_cleaner.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_elf_cleaner.sh"

# Hook for packages before massage step
termux_step_pre_massage() {
	return
}

# Hook for packages after massage step
termux_step_post_massage() {
	return
}

# Function to create {pre,post}install, {pre,post}rm-scripts and similar
# shellcheck source=scripts/build/termux_step_create_debscripts.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_create_debscripts.sh"

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

# Process 'update-alternatives' entries from `.alternatives` files.
# Not to be overridden by package scripts.
# shellcheck source=scripts/build/termux_step_update_alternatives.sh
source "$TERMUX_SCRIPTDIR/scripts/build/termux_step_update_alternatives.sh"

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
	[[ ! -f "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH" ]] && \
		termux_error_exit "file '$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH' not found."
	# slightly faster than `grep -q $word $file`
	[[ " $(< "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH") " == *" $1 "* ]]
	return $?
}

# Adds a package to the list of built packages if it is not in the list
termux_add_package_to_built_packages_list() {
	if ! termux_check_package_in_built_packages_list "$1"; then
		echo -n "$1 " >> "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH"
	fi
}

# Check if the package is in the compiling list
termux_check_package_in_building_packages_list() {
	[[ ! -f "$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH" ]] && \
		termux_error_exit "file '$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH' not found."
	# slightly faster than `grep -q $word $file`
	[[ $'\n'"$(<"$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH")"$'\n' == *$'\n'"$1"$'\n'* ]]
	return $?
}

# Configure variables (TERMUX_ARCH, TERMUX__PREFIX__INCLUDE_DIR, TERMUX__PREFIX__LIB_DIR) for multilib-compilation
termux_conf_multilib_vars() {
	# Change the 64-bit architecture type to its 32-bit counterpart in the `TERMUX_ARCH` variable
	case $TERMUX_ARCH in
		"aarch64") TERMUX_ARCH="arm";;
		"x86_64") TERMUX_ARCH="i686";;
		*) termux_error_exit "It is impossible to set multilib arch for ${TERMUX_ARCH} arch."
	esac
	TERMUX__PREFIX__INCLUDE_SUBDIR="$TERMUX__PREFIX__MULTI_INCLUDE_SUBDIR"
	TERMUX__PREFIX__INCLUDE_DIR="$TERMUX__PREFIX__MULTI_INCLUDE_DIR"
	TERMUX__PREFIX__LIB_SUBDIR="$TERMUX__PREFIX__MULTI_LIB_SUBDIR"
	TERMUX__PREFIX__LIB_DIR="$TERMUX__PREFIX__MULTI_LIB_DIR"
}

# Run functions for normal compilation and multilib-compilation
termux_run_base_and_multilib_build_step() {
	case "${1}" in
		termux_step_configure|termux_step_make|termux_step_make_install) local func="${1}";;
		*) termux_error_exit "Unsupported function '${1}'."
	esac
	cd "$TERMUX_PKG_BUILDDIR"
	if [ "$TERMUX_PKG_BUILD_ONLY_MULTILIB" = "false" ]; then
		"${func}"
	fi
	if [ "$TERMUX_PKG_BUILD_MULTILIB" = "true" ]; then
		(
			termux_step_setup_multilib_environment
			"${func}_multilib"
		)
	fi
}

# Sets up TERMUX_PKG_BUILDER_DIR and TERMUX_PKG_BUILDER_SCRIPT
termux_step_get_build_script_directory() {
	TERMUX_PKG_NAME="${1}"
	if [[ ${TERMUX_PKG_NAME} == *"/"* ]]; then
		# Path to directory which may be outside this repo:
		if [ ! -d "${TERMUX_PKG_NAME}" ]; then termux_error_exit "'${TERMUX_PKG_NAME}' seems to be a path but is not a directory"; fi
		export TERMUX_PKG_BUILDER_DIR=$(realpath "${TERMUX_PKG_NAME}")
		TERMUX_PKG_NAME=$(basename "${TERMUX_PKG_NAME}")
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
}

# Removes included sources in a virtual package
# Should only be run on error or when the script exits.
termux_remove_include_virtual_files() {
	[ -z "${TERMUX_VIRTUAL_PKG-}" ] || [ "$TERMUX_VIRTUAL_PKG" = "false" ] || [ "$TERMUX_VIRTUAL_PKG_INCLUDE" = "false" ] && return
	for file in $TERMUX_VIRTUAL_PKG_INCLUDE; do
		rm -fr "${TERMUX_VIRTUAL_PKG_BUILDER_DIR}/${file}"
	done
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
	[ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && echo "  -a The architecture to build for: aarch64(default), arm, i686, x86_64 or all."
	echo "  -c Continue previous build."
	echo "  -C Cleanup already built packages on low disk space."
	echo "  -d Build with debug symbols."
	echo "  -D Build a disabled package in disabled-packages/."
	echo "  -f Force build even if package has already been built."
	echo "  -F Force build even if package and its dependencies have already been built."
	[ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && echo "  -i Download and extract dependencies instead of building them."
	echo "  -I Download and extract dependencies instead of building them, keep existing $TERMUX_BASE_DIR files."
	echo "  -L The package and its dependencies will be based on the same library."
	echo "  -q Quiet build."
	echo "  -Q Loud build -- set -x debug output."
	echo "  -r Remove all package build dependent dirs that '-f/-F'"
	echo "     flags alone would not remove, like cache dir containing "
	echo "     package sources and host build dir. Ignored if '-f/-F'"
	echo "     flags are not passed."
	echo "  -w Install dependencies without version binding."
	echo "  -s Skip dependency check."
	echo "  -b Fix circular dependencies using virtual packages only."
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
			else
				export TERMUX_INSTALL_DEPS=true
			fi
			;;
		-I)
			export TERMUX_INSTALL_DEPS=true
			export TERMUX_PKGS__BUILD__RM_ALL_PKGS_BUILT_MARKER_AND_INSTALL_FILES=false
			;;
		-L) export TERMUX_GLOBAL_LIBRARY=true;;
		-q) export TERMUX_QUIET_BUILD=true;;
		-Q) set -x;;
		-r) export TERMUX_PKGS__BUILD__RM_ALL_PKG_BUILD_DEPENDENT_DIRS=true;;
		-w) export TERMUX_WITHOUT_DEPVERSION_BINDING=true;;
		-s) export TERMUX_SKIP_DEPCHECK=true;;
		-b) export TERMUX_FIX_CYCLIC_DEPS_WITH_VIRTUAL_PKGS=true;;
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
		-C) TERMUX_CLEANUP_BUILT_PACKAGES_ON_LOW_DISK_SPACE=true;;
		-*) termux_error_exit "./build-package.sh: illegal option '$1'";;
		*) PACKAGE_LIST+=("$1");;
	esac
	shift 1
done
unset -f _show_usage

# Dependencies should be used from repo only if they are built for
# same package name.
if [ "$TERMUX_REPO_APP__PACKAGE_NAME" != "$TERMUX_APP_PACKAGE" ]; then
	echo "Ignoring -i option to download dependencies since repo package name ($TERMUX_REPO_APP__PACKAGE_NAME) does not equal app package name ($TERMUX_APP_PACKAGE)"
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

if [ "$TERMUX_REPO_APP__PACKAGE_NAME" = "$TERMUX_APP_PACKAGE" ]; then
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
			for arch in 'aarch64' 'arm' 'i686' 'x86_64'; do
				env TERMUX_ARCH="$arch" TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
					 $(test "${TERMUX_CLEANUP_BUILT_PACKAGES_ON_LOW_DISK_SPACE:-}" = "true" && echo "-C") \
					 $(test "${TERMUX_DEBUG_BUILD:-}" = "true" && echo "-d") \
					 $(test "${TERMUX_IS_DISABLED:-}" = "true" && echo "-D") \
					 $({ test "${TERMUX_FORCE_BUILD:-}" = "true" && test "${TERMUX_FORCE_BUILD_DEPENDENCIES:-}" != "true"; } && echo "-f") \
					 $({ test "${TERMUX_FORCE_BUILD:-}" = "true" && test "${TERMUX_FORCE_BUILD_DEPENDENCIES:-}" = "true"; } && echo "-F") \
					 $({ test "${TERMUX_INSTALL_DEPS:-}" = "true" && test "${TERMUX_PKGS__BUILD__RM_ALL_PKGS_BUILT_MARKER_AND_INSTALL_FILES:-}" != "false"; } && echo "-i") \
					 $({ test "${TERMUX_INSTALL_DEPS:-}" = "true" && test "${TERMUX_PKGS__BUILD__RM_ALL_PKGS_BUILT_MARKER_AND_INSTALL_FILES:-}" = "false"; } && echo "-I") \
					 $(test "${TERMUX_GLOBAL_LIBRARY:-}" = "true" && echo "-L") \
					 $(test -n "${TERMUX_OUTPUT_DIR:-}" && echo "-o $TERMUX_OUTPUT_DIR") \
					 $(test "${TERMUX_PKGS__BUILD__RM_ALL_PKG_BUILD_DEPENDENT_DIRS:-}" = "true" && echo "-r") \
					 $(test "${TERMUX_WITHOUT_DEPVERSION_BINDING:-}" = "true" && echo "-w") \
					 $(test -n "${TERMUX_PACKAGE_FORMAT:-}" && echo "--format $TERMUX_PACKAGE_FORMAT") \
					 $(test -n "${TERMUX_PACKAGE_LIBRARY:-}" && echo "--library $TERMUX_PACKAGE_LIBRARY") \
					"${PACKAGE_LIST[i]}"
			done
			exit
		fi

		# Check the package to build:
		export TERMUX_PKG_BUILDER_DIR=
		termux_step_get_build_script_directory "${PACKAGE_LIST[i]}"

		# Add trap to remove included sources in virtual package
		trap 'termux_remove_include_virtual_files' ERR EXIT

		termux_step_setup_variables
		termux_step_handle_buildarch

		termux_step_cleanup_packages
		termux_step_start_build

		TERMUX_PKG_PATH="${TERMUX_PKG_BUILDER_DIR#${TERMUX_SCRIPTDIR}/}"
		if ! termux_check_package_in_building_packages_list "$TERMUX_PKG_PATH"; then
			echo "$TERMUX_PKG_PATH" >> $TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH
		else
			cat -n $TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH
			termux_error_exit "A cyclic dependency was detected that was not resolved during the assembly of packages. Abort."
		fi

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			termux_step_get_dependencies
			if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
				termux_step_setup_cgct_environment
			fi
			termux_step_override_config_scripts
		fi

		if [ "$TERMUX_VIRTUAL_PKG" == "false" ]; then
			termux_step_create_timestamp_file
		fi

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
		termux_run_base_and_multilib_build_step termux_step_configure

		if [ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			cd "$TERMUX_PKG_BUILDDIR"
			termux_step_post_configure
		fi
		termux_run_base_and_multilib_build_step termux_step_make
		termux_run_base_and_multilib_build_step termux_step_make_install
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_post_make_install
		termux_step_install_pacman_hooks
		termux_step_install_service_scripts
		termux_step_install_license
		if [ "$TERMUX_VIRTUAL_PKG" == "false" ]; then
			cd "$TERMUX_PKG_MASSAGEDIR"
			termux_step_copy_into_massagedir
			cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
			termux_step_pre_massage
			cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
			termux_step_massage
			cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
			termux_step_post_massage
			# At the final stage (when the package is archiving) it is better to use commands from the system
			if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
				export PATH="/usr/bin:$PATH"
			fi
			cd "$TERMUX_PKG_MASSAGEDIR"
			if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ]; then
				termux_step_create_debian_package
			elif [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
				termux_step_create_pacman_package
			else
				termux_error_exit "Unknown packaging format '$TERMUX_PACKAGE_FORMAT'."
			fi
			# Saving a list of compiled packages for further work with it
			termux_add_package_to_built_packages_list "$TERMUX_PKG_NAME"
		fi
		if termux_check_package_in_building_packages_list "$TERMUX_PKG_PATH"; then
			sed -i "\|^${TERMUX_PKG_PATH}$|d" "$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH"
		fi
		termux_step_finish_build
	) 5< "$TERMUX_BUILD_LOCK_FILE"
done

# Removing a file to store a list of compiled packages
if [ "$TERMUX_BUILD_PACKAGE_CALL_DEPTH" = "0" ]; then
	rm "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST_FILE_PATH"
	rm "$TERMUX_BUILD_PACKAGE_CALL_BUILDING_PACKAGES_LIST_FILE_PATH"
fi
