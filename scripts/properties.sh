# shellcheck shell=bash

# Title:          properties.sh
# Description:    The file to set variables for Termux packages infrastructure.

# XXX: This file is sourced by repology-updater script.
# So avoid doing things like executing commands except of those available in
# coreutils and are clearly not a default part of most Linux installations,
# or sourcing any other script in our build directories.

if [ -z "${BASH_VERSION:-}" ]; then
	echo "properties.sh file must be sourced from a bash shell." 1>&2
	exit 1
fi

__TERMUX_PROPS__REPO_ROOT_DIR="$(readlink -f -- "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")/..")" || exit $?



TERMUX_SDK_REVISION=9123335
TERMUX_ANDROID_BUILD_TOOLS_VERSION=33.0.1
# when changing the above:
# change TERMUX_PKG_VERSION (and remove TERMUX_PKG_REVISION if necessary) in:
#   apksigner, d8
# and trigger rebuild of them
: "${TERMUX_NDK_VERSION_NUM:="27"}"
: "${TERMUX_NDK_REVISION:="b"}"
TERMUX_NDK_VERSION=$TERMUX_NDK_VERSION_NUM$TERMUX_NDK_REVISION
# when changing the above:
# update version and hashsum in packages
#   libandroid-stub, libc++, ndk-multilib, ndk-sysroot, vulkan-loader-android
# and update SHA256 sums in scripts/setup-android-sdk.sh
# check all packages build and run correctly and bump if needed

: "${TERMUX_JAVA_HOME:=/usr/lib/jvm/java-17-openjdk-amd64}"
export JAVA_HOME=${TERMUX_JAVA_HOME}

if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
	export ANDROID_HOME=${TERMUX_SCRIPTDIR}/build-tools/android-sdk-$TERMUX_SDK_REVISION
	export NDK=${TERMUX_SCRIPTDIR}/build-tools/android-ndk-r${TERMUX_NDK_VERSION}
else
	: "${ANDROID_HOME:="${HOME}/lib/android-sdk-$TERMUX_SDK_REVISION"}"
	: "${NDK:="${HOME}/lib/android-ndk-r${TERMUX_NDK_VERSION}"}"
fi





unset TERMUX__SUPPORTED_ARCHITECTURES; declare -a TERMUX__SUPPORTED_ARCHITECTURES
##
# The supported Termux architectures.
##
TERMUX__SUPPORTED_ARCHITECTURES=("aarch64" "arm" "x86_64" "i686")


unset TERMUX__SUPPORTED_ARCHITECTURES_TO_ABIS_MAP; declare -A TERMUX__SUPPORTED_ARCHITECTURES_TO_ABIS_MAP
##
# The supported Termux architectures to ABIs map.
##
TERMUX__SUPPORTED_ARCHITECTURES_TO_ABIS_MAP=(
    ["aarch64"]="arm64-v8a"
    ["arm"]="armeabi-v7a"
    ["x86_64"]="x86_64"
    ["i686"]="x86"
)



unset TERMUX__SUPPORTED_PACKAGE_MANAGERS; declare -a TERMUX__SUPPORTED_PACKAGE_MANAGERS
##
# The supported Termux package managers.
##
TERMUX__SUPPORTED_PACKAGE_MANAGERS=("apt" "pacman")


unset TERMUX__SUPPORTED_PACKAGE_FORMATS; declare -a TERMUX__SUPPORTED_PACKAGE_FORMATS
##
# The supported Termux package formats.
##
TERMUX__SUPPORTED_PACKAGE_FORMATS=("debian" "pacman")


unset TERMUX__SUPPORTED_PACKAGE_MANAGERS_TO_PACKAGE_FORMAT_MAP; declare -A TERMUX__SUPPORTED_PACKAGE_MANAGERS_TO_PACKAGE_FORMAT_MAP
##
# The supported Termux package managers to package format map.
##
TERMUX__SUPPORTED_PACKAGE_MANAGERS_TO_PACKAGE_FORMAT_MAP=(
    ["apt"]="debian"
    ["pacman"]="pacman"
)


unset TERMUX__SUPPORTED_PACKAGE_LIBRARIES; declare -a TERMUX__SUPPORTED_PACKAGE_LIBRARIES
##
# The supported Termux package libraries.
##
TERMUX__SUPPORTED_PACKAGE_LIBRARIES=("bionic" "glibc")





# Termux packages configuration.
TERMUX__INTERNAL_NAME="termux"
TERMUX_APP__PACKAGE_NAME="com.termux"
TERMUX_APP__DATA_DIR="/data/data/$TERMUX_APP__PACKAGE_NAME"
TERMUX__PROJECT_SUBDIR="$TERMUX__INTERNAL_NAME"
TERMUX__PROJECT_DIR="$TERMUX_APP__DATA_DIR/$TERMUX__PROJECT_SUBDIR"
TERMUX__CORE_SUBDIR="core"
TERMUX__CORE_DIR="$TERMUX__PROJECT_DIR/$TERMUX__CORE_SUBDIR"
TERMUX__APPS_SUBDIR="app"
TERMUX__APPS_DIR="$TERMUX__PROJECT_DIR/$TERMUX__APPS_SUBDIR"
TERMUX__ROOTFS_SUBDIR="files"
TERMUX__ROOTFS="$TERMUX_APP__DATA_DIR/$TERMUX__ROOTFS_SUBDIR"
TERMUX__HOME="$TERMUX__ROOTFS/home"
TERMUX__PREFIX="$TERMUX__ROOTFS/usr"

TERMUX_APP_PACKAGE="$TERMUX_APP__PACKAGE_NAME"
TERMUX_BASE_DIR="$TERMUX__ROOTFS"
TERMUX_CACHE_DIR="$TERMUX_APP__DATA_DIR/cache"
TERMUX_ANDROID_HOME="$TERMUX__HOME"
TERMUX_APPS_DIR="$TERMUX_BASE_DIR/apps"
TERMUX_PREFIX="$TERMUX__PREFIX"
TERMUX_PREFIX_CLASSICAL="$TERMUX__PREFIX"

TERMUX_ETC_PREFIX_DIR_PATH="${TERMUX_PREFIX}/etc"
TERMUX_PROFILE_D_PREFIX_DIR_PATH="${TERMUX_ETC_PREFIX_DIR_PATH}/profile.d"
TERMUX_CONFIG_PREFIX_DIR_PATH="${TERMUX_ETC_PREFIX_DIR_PATH}/termux"
TERMUX_BOOTSTRAP_CONFIG_DIR_PATH="${TERMUX_CONFIG_PREFIX_DIR_PATH}/bootstrap"

# Path to CGCT tools
CGCT_DEFAULT_PREFIX="/data/data/com.termux/files/usr/glibc"
export CGCT_DIR="/data/data/com.termux/cgct"



# Set Termux repositories variables.
source "$__TERMUX_PROPS__REPO_ROOT_DIR/scripts/repo.sh" || exit $?



# Allow to override setup.
for f in "${HOME}/.config/termux/termuxrc.sh" "${HOME}/.termux/termuxrc.sh" "${HOME}/.termuxrc"; do
	if [ -f "$f" ]; then
		echo "Using builder configuration from '$f'..."
		. "$f"
		break
	fi
done
unset f

unset __TERMUX_PROPS__REPO_ROOT_DIR
