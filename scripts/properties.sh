# XXX: This file is sourced by repology-updater script
# So avoid doing things like executing commands except of those available in
# coreutils and are clearly not a default part of most Linux installations,
# or sourcing any other script in our build directories.

###
# Variables for the Termux build tools.
###

TERMUX_SDK_REVISION=9123335
TERMUX_ANDROID_BUILD_TOOLS_VERSION=33.0.1
# when changing the above:
# change TERMUX_PKG_VERSION (and remove TERMUX_PKG_REVISION if necessary) in:
#   apksigner, d8
# and trigger rebuild of them
: "${TERMUX_NDK_VERSION_NUM:="26"}"
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





###
# Variables for the Termux apps and packages for which to compile packages.
#
# Following is a list of `TERMUX_` variables that are safe to modify when forking.
# **DO NOT MODIFY ANY OTHER VARIABLE UNLESS YOU KNOW WHAT YOU ARE DOING.**
#
# Variables here need to be in sync with `termux-app` (`TermuxConstants` and `TermuxCoreConstants`),
# termux site and `termux-exec`.
# - https://github.com/termux/termux-app/blob/master/termux-shared/src/main/java/com/termux/shared/termux/TermuxConstants.java
# - https://github.com/termux/termux-app/blob/master/termux-shared/src/main/java/com/termux/shared/termux/core/TermuxCoreConstants.java
#
# - `TERMUX__NAME`, `TERMUX__LNAME`, `TERMUX__UNAME`
# - `TERMUX_APP__PACKAGE_NAME`
# - `TERMUX_APP__DATA_DIR`
# - `TERMUX__ROOT_SUBDIR`
# - `TERMUX__ROOTFS_SUBDIR`
# - `TERMUX__ROOTFS` and alternates
# - `TERMUX__PREFIX` and alternates
# - `TERMUX_ANDROID_HOME` and alternates
# - `TERMUX_APP__NAME`, `TERMUX_APP__LNAME`
# - `TERMUX_APP__IDENTIFIER`
# - `TERMUX_APP__NAMESPACE`
# - `TERMUX_APP__SHELL_ACTIVITY__*`
# - `TERMUX_APP__SHELL_SERVICE__*`
# - `TERMUX_APP__RUN_COMMAND_SERVICE__*`
###

##
# Termux project name.
#
# Default value: `Termux`
##
TERMUX__NAME="Termux"

##
# The lower case value for `TERMUX__NAME`.
#
# Default value: `termux`
##
TERMUX__LNAME="${TERMUX__NAME,,}"

##
# The upper case value for `TERMUX__NAME`.
#
# Default value: `TERMUX`
##
TERMUX__UNAME="${TERMUX__NAME^^}"



##
# Termux app package name for which to compile packages.
#
# Ideally package name should be `<= 21` characters and max `33` characters. If you have not yet
# chosen a package name, then it would be best to keep it to `<= 10` characters. Check
# https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits for why.
#
# Default value: `com.termux`
##
TERMUX_APP__PACKAGE_NAME="com.termux"
TERMUX_APP_PACKAGE="$TERMUX_APP__PACKAGE_NAME" # Alternate variable for `TERMUX_APP__PACKAGE_NAME`

##
# Termux app data directory path for which to compile packages.
#
# Default value: `/data/data/com.termux`
##
TERMUX_APP__DATA_DIR="/data/data/$TERMUX_APP__PACKAGE_NAME"





##
# Termux `TERMUX__ROOT_DIR` subdirectory path under `TERMUX_APP__DATA_DIR`.
#
# Default value: `termux`
##
TERMUX__ROOT_SUBDIR="termux"

##
# Termux project root directory path under `TERMUX_APP__DATA_DIR`.
#
# This is an exclusive directory for all termux files that includes core files, app and plugin
# app files and the rootfs. Currently, be default rootfs is not under it and is at the
# `/files` directory but there are plans to move it to `termux/rootfs/II` in future where `II`
# refers to rootfs id starting at `0` for multi-rootfs support.
#
# An exclusive directory is required so that all termux files exist under a single directory,
# especially for when termux is provided as a library, so that termux files do not interfere
# with other files of Termux app forks or apps that may use the termux library.
#
# Default value: `/data/data/com.termux/termux`
##
TERMUX__ROOT_DIR="$TERMUX_APP__DATA_DIR/$TERMUX__ROOT_SUBDIR"





##
# Termux `TERMUX__CORE_DIR` subdirectory path under `TERMUX__ROOT_DIR`.
#
# Default value: `core`
##
TERMUX__CORE_SUBDIR="core"

##
# Termux core directory path.
#
# Default value: `/data/data/com.termux/termux/core`
##
TERMUX__CORE_DIR="$TERMUX__ROOT_DIR/$TERMUX__CORE_SUBDIR"





##
# Termux `TERMUX__APPS_DIR` subdirectory path under `TERMUX__ROOT_DIR`.
#
# Default value: `apps`
##
TERMUX__APPS_SUBDIR="apps"

##
# Termux apps directory path.
#
# Default value: `/data/data/com.termux/termux/apps`
##
TERMUX__APPS_DIR="$TERMUX__ROOT_DIR/$TERMUX__APPS_SUBDIR"

##
# The max length for the `TERMUX__APPS_DIR` including the null '\0' terminator.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `84` is chosen.
#
# Default value: `84`
##
TERMUX__APPS_DIR_MAX_LEN=84



##
# Termux `TERMUX__APPS_DIR_BY_NAME` subdirectory path under `TERMUX__APPS_DIR`.
#
# Default value: `n`
##
TERMUX__APPS_DIR_BY_NAME_SUBDIR="n"

##
# Termux apps directory path by name.
#
# Default value: `/data/data/com.termux/termux/apps/n`
##
TERMUX__APPS_DIR_BY_NAME="$TERMUX__APPS_DIR/$TERMUX__APPS_DIR_BY_NAME_SUBDIR"

##
# The max length for a subdirectory name under the `TERMUX__APPS_DIR_BY_NAME` excluding the
# null '\0' terminator that represents an app identifier.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `11` is chosen.
#
# Default value: `11`
##
TERMUX__APPS_APP_IDENTIFIER_MAX_LEN=11



##
# Termux `TERMUX__APPS_DIR_BY_PACKAGE` subdirectory path under `TERMUX__APPS_DIR`.
#
# Default value: `p`
##
TERMUX__APPS_DIR_BY_PACKAGE_SUBDIR="p"

##
# Termux apps directory path by package.
#
# Default value: `/data/data/com.termux/termux/apps/p`
##
TERMUX__APPS_DIR_BY_PACKAGE="$TERMUX__APPS_DIR/$TERMUX__APPS_DIR_BY_PACKAGE_SUBDIR"





##
# The `termux-am-socket` sub path under an app directory of `TERMUX__APPS_DIR_BY_NAME`.
#
# Default value: `termux-am`
##
TERMUX__AM_SOCKET_SERVER_SUBFILE="termux-am"





##
# Termux `TERMUX__CACHE_DIR` subdirectory path under `TERMUX__ROOT_DIR`.
#
# Default value: `cache`
##
TERMUX__CACHE_SUBDIR="cache"

##
# Termux app cache directory path.
#
# Default value: `/data/data/com.termux/cache`
##
TERMUX__CACHE_DIR="$TERMUX_APP__DATA_DIR/$TERMUX__CACHE_SUBDIR"
TERMUX_CACHE_DIR="$TERMUX__CACHE_DIR" # Alternate variable for `TERMUX__CACHE_DIR`





##
# Termux `TERMUX__ROOTFS` subdirectory path under `TERMUX_APP__DATA_DIR`.
#
# Default value: `files`
##
TERMUX__ROOTFS_SUBDIR="files"


###########
# Uncomment if you want to place `TERMUX__ROOTFS`  under `TERMUX__ROOT_DIR` instead of at `files`.
# This may be used for future multi-rootfs design.

##
# Termux `TERMUX__ROOTFS` id.
#
# Default value: `0`
##
#TERMUX__ROOTFS_ID="0"

##
# Termux `TERMUX__ROOTFS` subdirectory path under `TERMUX__ROOT_DIR`.
#
# Default value: `rootfs/0`
##
#TERMUX__ROOTFS_SUBDIR="rootfs/$TERMUX__ROOTFS_ID"
###########


##
# Termux rootfs directory path.
#
# Default value: `/data/data/com.termux/files`
##
TERMUX__ROOTFS="$TERMUX_APP__DATA_DIR/$TERMUX__ROOTFS_SUBDIR"
TERMUX_BASE_DIR="$TERMUX__ROOTFS" # Alternate variable for `TERMUX__ROOTFS`

##
# The max length for the `TERMUX__ROOTFS` including the null '\0' terminator.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `86` is chosen.
#
# Default value: `86`
##
TERMUX__ROOTFS_DIR_MAX_LEN=86



##
# Termux prefix directory path.
#
# Default value: `/data/data/com.termux/files/usr`
##
TERMUX__PREFIX="$TERMUX__ROOTFS/usr"
# glibc modifies `TERMUX_PREFIX` during compilation to append `/glibc` in `termux_step_setup_variables()`
# - https://github.com/termux/termux-packages/pull/16901
TERMUX_PREFIX="$TERMUX__PREFIX"
TERMUX_PREFIX_CLASSICAL="$TERMUX__PREFIX" # Alternate variable for `TERMUX__PREFIX`



##
# Termux home directory path.
#
# Default value: `/data/data/com.termux/files/home`
##
TERMUX__HOME="$TERMUX__ROOTFS/home"
TERMUX_ANDROID_HOME="$TERMUX__HOME" # Alternate variable for `TERMUX__HOME`

##
# Termux data directory path under `TERMUX__HOME`.
#
# Default value: `/data/data/com.termux/files/home/.termux`
##
TERMUX__DATA_HOME="$TERMUX__HOME/.termux"





##
# The max length for a filesystem socket file path (pathanme UNIX domain socket) for the
# `sockaddr_un.sun_path` field including the null `\0` terminator as per `UNIX_PATH_MAX`.
#
# All filesystem socket path lengths created by Termux apps and packages must be `< 108`.
#
# - https://man7.org/linux/man-pages/man7/unix.7.html
# - https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:bionic/libc/kernel/uapi/linux/un.h;l=22
#
# Default value: `108`
##
TERMUX__UNIX_PATH_MAX=108





##
# Termux environment variables root scope.
#
# Currently, only `termux-exec` supports modifying this, all other termux (internal) packages do not.
#
# Default value: `TERMUX_`
##
TERMUX_ENV__S_ROOT="TERMUX_"

##
# Termux environment variables Termux scope.
#
# Default value: `TERMUX__`
##
TERMUX_ENV__S_TERMUX="${TERMUX_ENV__S_ROOT}_"
TERMUX_ENV__SE_TERMUX="\$${TERMUX_ENV__S_TERMUX}"

##
# Termux environment variables Termux app scope.
#
# Default value: `TERMUX_APP__`
##
TERMUX_ENV__S_TERMUX_APP="${TERMUX_ENV__S_ROOT}APP__"
TERMUX_ENV__SE_TERMUX_APP="\$${TERMUX_ENV__S_TERMUX_APP}"

##
# Termux environment variables Termux:API app scope.
#
# Default value: `TERMUX_API_APP__`
##
TERMUX_ENV__S_TERMUX_API_APP="${TERMUX_ENV__S_ROOT}API_APP__"
TERMUX_ENV__SE_TERMUX_API_APP="\$${TERMUX_ENV__S_TERMUX_API_APP}"

##
# Termux environment variables `termux-exec` scope.
#
# Default value: `TERMUX_EXEC__`
##
TERMUX_ENV__S_TERMUX_EXEC="${TERMUX_ENV__S_ROOT}EXEC__"
TERMUX_ENV__SE_TERMUX_EXEC="\$${TERMUX_ENV__S_TERMUX_EXEC}"

##
# Termux environment variables `termux-exec-tests` scope.
#
# Default value: `TERMUX_EXEC_TESTS__`
##
TERMUX_ENV__S_TERMUX_EXEC_TESTS="${TERMUX_ENV__S_ROOT}EXEC_TESTS__"
TERMUX_ENV__SE_TERMUX_EXEC_TESTS="\$${TERMUX_ENV__S_TERMUX_EXEC_TESTS}"





###
# Variables for the Termux app that hosts the packages.
#
# - https://github.com/termux/termux-app
###

##
# Termux app name.
#
# Default value: `Termux`
##
TERMUX_APP__NAME="$TERMUX__NAME"


##
# The lower case value for `TERMUX_APP__NAME`.
#
# Default value: `termux`
##
TERMUX_APP__LNAME="${TERMUX_APP__NAME,,}"

##
# Termux app identifier for `TERMUX__APPS_DIR_BY_NAME` subdirectory.
#
# Default value: `termux`
# Max length: `TERMUX__APPS_APP_IDENTIFIER_MAX_LEN`
##
TERMUX_APP__IDENTIFIER="$TERMUX_APP__LNAME"



##
# Termux app namespace, i.e the Java package name under which Termux classes exists.
#
# - https://github.com/termux/termux-app/tree/master/app/src/main/java/com/termux/app
# - https://developer.android.com/build/configure-app-module#set-namespace
#
# Default value: `com.termux`
##
TERMUX_APP__NAMESPACE="$TERMUX_APP__PACKAGE_NAME"



##
# Termux app apps directory path under `TERMUX__APPS_DIR_BY_NAME`.
#
# Default value: `/data/data/com.termux/termux/apps/n/termux`
##
TERMUX_APP__APPS_DIR="$TERMUX__APPS_DIR_BY_NAME/$TERMUX_APP__IDENTIFIER"

##
# The `termux-am-socket` file path for the Termux app.
#
# Default value: `/data/data/com.termux/termux/apps/n/termux/termux-am`
##
TERMUX_APP__AM_SOCKET_SERVER_FILE="$TERMUX_APP__APPS_DIR/$TERMUX__AM_SOCKET_SERVER_SUBFILE"





##
# Termux app shell activity class name that hosts the shell/terminal views.
#
# Default value: `com.termux.app.TermuxActivity`
##
TERMUX_APP__SHELL_ACTIVITY__CLASS_NAME="$TERMUX_APP__NAMESPACE.app.TermuxActivity"

##
# Termux app shell activity component name for `TERMUX_APP__SHELL_ACTIVITY__CLASS_NAME`.
#
# Default value: `com.termux/com.termux.app.TermuxActivity`
##
TERMUX_APP__SHELL_ACTIVITY__COMPONENT_NAME="$TERMUX_APP__PACKAGE_NAME/$TERMUX_APP__SHELL_ACTIVITY__CLASS_NAME"



##
# Termux app shell service class name that manages the shells.
#
# Default value: `com.termux.app.TermuxService`
##
TERMUX_APP__SHELL_SERVICE__CLASS_NAME="$TERMUX_APP__NAMESPACE.app.TermuxService"

##
# Termux app shell service component name for `TERMUX_APP__SHELL_SERVICE__CLASS_NAME`.
#
# Default value: `com.termux/com.termux.app.TermuxService`
##
TERMUX_APP__SHELL_SERVICE__COMPONENT_NAME="$TERMUX_APP__PACKAGE_NAME/$TERMUX_APP__SHELL_SERVICE__CLASS_NAME"



##
# Termux app RUN_COMMAND service class name that receives commands via intents.
#
# - https://github.com/termux/termux-app/wiki/RUN_COMMAND-Intent
#
# Default value: `com.termux.app.RunCommandService`
##
TERMUX_APP__RUN_COMMAND_SERVICE__CLASS_NAME="$TERMUX_APP__NAMESPACE.app.RunCommandService"

##
# Termux app shell service component name for `TERMUX_APP__RUN_COMMAND_SERVICE__CLASS_NAME`.
#
# Default value: `com.termux/com.termux.app.RunCommandService`
##
TERMUX_APP__RUN_COMMAND_SERVICE__COMPONENT_NAME="$TERMUX_APP__PACKAGE_NAME/$TERMUX_APP__RUN_COMMAND_SERVICE__CLASS_NAME"





##
# Regex that matches an absolute path that starts with a `/` with at least one characters under
# rootfs `/` and that does not end with a `/`.
##
TERMUX_REGEX__ABSOLUTE_PATH='^(/[^/]+)+$'

##
# Regex that matches (rootfs `/`) or (an absolute path that starts with a `/ and that does not end
# with a `/`).
##
TERMUX_REGEX__ROOTFS_OR_ABSOLUTE_PATH='^((/)|((/[^/]+)+))$'

##
# Regex that matches a relative path that does not start with a `/` and that does not end with a `/`.
##
TERMUX_REGEX__RELATIVE_PATH='^[^/]+(/[^/]+)*$'




###
# Validate paths to ensure packages are not compiled for invalid values that are not supported.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
###

if [[ ! "$TERMUX__ROOT_SUBDIR" =~ $TERMUX_REGEX__RELATIVE_PATH ]]; then
	echo "The TERMUX__ROOT_SUBDIR '$TERMUX__ROOT_SUBDIR' with length ${#TERMUX__ROOT_SUBDIR} is invalid" 1>&2
	echo "The TERMUX__ROOT_SUBDIR must be a relative path that does not start with a '/'" 1>&2
	exit 1
fi

if [[ ! "$TERMUX__ROOT_DIR" =~ $TERMUX_REGEX__ROOTFS_OR_ABSOLUTE_PATH ]]; then
	echo "The TERMUX__ROOT_DIR '$TERMUX__ROOT_DIR' with length ${#TERMUX__ROOT_DIR} is invalid" 1>&2
	echo "The TERMUX__ROOT_DIR must be an absolute path starting with a '/'" 1>&2
	exit 1
fi

if [[ ! "$TERMUX__CORE_DIR" =~ $TERMUX_REGEX__ABSOLUTE_PATH ]]; then
	echo "The TERMUX__CORE_DIR '$TERMUX__CORE_DIR' with length ${#TERMUX__CORE_DIR} is invalid" 1>&2
	echo "The TERMUX__CORE_DIR must be an absolute path with length at least '1'" 1>&2
	exit 1
fi

if [ "${#TERMUX__APPS_DIR}" -ge $TERMUX__APPS_DIR_MAX_LEN ] || [[ ! "$TERMUX__APPS_DIR" =~ $TERMUX_REGEX__ABSOLUTE_PATH ]]; then
	echo "The TERMUX__APPS_DIR '$TERMUX__APPS_DIR' with length ${#TERMUX__APPS_DIR} is invalid" 1>&2
	echo "The TERMUX__APPS_DIR must be an absolute path starting with a '/' with max length '$TERMUX__APPS_DIR_MAX_LEN' including the null '\0' terminator" 1>&2
	exit 1
fi

if [ "${#TERMUX_APP__IDENTIFIER}" -gt $TERMUX__APPS_APP_IDENTIFIER_MAX_LEN ]; then
	echo "The TERMUX_APP__IDENTIFIER '$TERMUX_APP__IDENTIFIER' with length ${#TERMUX_APP__IDENTIFIER} is invalid" 1>&2
	echo "The TERMUX_APP__IDENTIFIER must have max length '$TERMUX__APPS_APP_IDENTIFIER_MAX_LEN'" 1>&2
	exit 1
fi

if [ "${#TERMUX_APP__AM_SOCKET_SERVER_FILE}" -ge $TERMUX__UNIX_PATH_MAX ] || [[ ! "$TERMUX_APP__AM_SOCKET_SERVER_FILE" =~ $TERMUX_REGEX__ABSOLUTE_PATH ]]; then
	echo "The TERMUX_APP__AM_SOCKET_SERVER_FILE '$TERMUX_APP__AM_SOCKET_SERVER_FILE' with length ${#TERMUX_APP__AM_SOCKET_SERVER_FILE} is invalid" 1>&2
	echo "The TERMUX_APP__AM_SOCKET_SERVER_FILE must be an absolute path starting with a '/' with max length '$TERMUX__UNIX_PATH_MAX' including the null '\0' terminator" 1>&2
	exit 1
fi

if [[ ! "$TERMUX__ROOTFS_SUBDIR" =~ $TERMUX_REGEX__RELATIVE_PATH ]]; then
	echo "The TERMUX__ROOTFS_SUBDIR '$TERMUX__ROOTFS_SUBDIR' with length ${#TERMUX__ROOTFS_SUBDIR} is invalid" 1>&2
	echo "The TERMUX__ROOTFS_SUBDIR must be a relative path that does not start with a '/'" 1>&2
	exit 1
fi

if [ "${#TERMUX__ROOTFS}" -ge $TERMUX__ROOTFS_DIR_MAX_LEN ] || [[ ! "$TERMUX__ROOTFS" =~ $TERMUX_REGEX__ROOTFS_OR_ABSOLUTE_PATH ]]; then
	echo "The TERMUX__ROOTFS '$TERMUX__ROOTFS' with length ${#TERMUX__ROOTFS} is invalid" 1>&2
	echo "The TERMUX__ROOTFS must be an absolute path starting with a '/' with max length '$TERMUX__ROOTFS_DIR_MAX_LEN' including the null '\0' terminator" 1>&2
	exit 1
fi

if [[ ! "$TERMUX__PREFIX" =~ $TERMUX_REGEX__ROOTFS_OR_ABSOLUTE_PATH ]]; then
	echo "The TERMUX__PREFIX '$TERMUX__PREFIX' with length ${#TERMUX__PREFIX} is invalid" 1>&2
	echo "The TERMUX__PREFIX must be an absolute path starting with a '/'" 1>&2
	exit 1
fi

if [[ ! "$TERMUX__HOME" =~ $TERMUX_REGEX__ROOTFS_OR_ABSOLUTE_PATH ]]; then
	echo "The TERMUX__HOME '$TERMUX__HOME' with length ${#TERMUX__HOME} is invalid" 1>&2
	echo "The TERMUX__HOME must be an absolute path starting with a '/'" 1>&2
	exit 1
fi





###
# Variables for the Termux package repositories.
###

# Package name for the packages hosted on the repo.
# This must only equal TERMUX_APP__PACKAGE_NAME if using custom repo that
# has packages that were built with same package name and `TERMUX__APPS_DIR` and `TERMUX__ROOTFS`.
TERMUX_REPO_PACKAGE="com.termux"

# Termux repo urls.
TERMUX_REPO_URL=()
TERMUX_REPO_DISTRIBUTION=()
TERMUX_REPO_COMPONENT=()

for url in $(jq -r 'del(.pkg_format) | .[] | .url' ${TERMUX_SCRIPTDIR}/repo.json); do
	TERMUX_REPO_URL+=("$url")
done
for distribution in $(jq -r 'del(.pkg_format) | .[] | .distribution' ${TERMUX_SCRIPTDIR}/repo.json); do
	TERMUX_REPO_DISTRIBUTION+=("$distribution")
done
for component in $(jq -r 'del(.pkg_format) | .[] | .component' ${TERMUX_SCRIPTDIR}/repo.json); do
	TERMUX_REPO_COMPONENT+=("$component")
done





###
# Misc
###

# Path to CGCT tools
export CGCT_DIR="$TERMUX_APP__DATA_DIR/cgct"

# Allow to override setup.
for f in "${HOME}/.config/termux/termuxrc.sh" "${HOME}/.termux/termuxrc.sh" "${HOME}/.termuxrc"; do
	if [ -f "$f" ]; then
		echo "Using builder configuration from '$f'..."
		. "$f"
		break
	fi
done
unset f



# Uncomment to print `TERMUX_` variables set
#compgen -v TERMUX_ | while read v; do echo "${v}=${!v}"; done
