# shellcheck shell=bash
# shellcheck disable=SC2034

# XXX: This file is sourced by repology-updater script
# So avoid doing things like executing commands except of those available in
# coreutils and are clearly not a default part of most Linux installations,
# or sourcing any other script in our build directories.

if [ -z "${BASH_VERSION:-}" ]; then
    echo "The 'properties.sh' script must be run from a 'bash' shell."; return 64 2>/dev/null|| exit 64 # EX__USAGE
fi



###
# Variables for validation of Termux properties variables.
# Validation is done to ensure packages are not compiled for invalid
# values that are not supported, and values are as per Termux file
# path limits.
#
# Additionally, the Termux packages build system is an unsafe mess of
# unquoted variables in shell scripts, and so validation is necessary
# for important variables, especially specific path variables against
# `TERMUX_REGEX__SAFE_*_PATH` regexes to reduce any potential damage.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
###

##
# The map of variable names to their space separated list of validator
# actions to perform.
#
# Following are the supported validator actions.
# - `allow_unset_value`: Allow variable to be defined but unset, and
#    skip other validations.
# - `app_package_name`: Variable must match `TERMUX_REGEX__APP_PACKAGE_NAME`.
# - `invalid_termux_rootfs_paths`: Path variable must not match
#   `TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS`.
# - `invalid_termux_home_paths`: Path variable must not match
#   `TERMUX_REGEX__INVALID_TERMUX_HOME_PATHS`.
# - `invalid_termux_prefix_paths`: Path variable must not match
#   `TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS`.
# - `path_equal_to_or_under_termux_rootfs`: Path variable must be equal
#   to or be under `TERMUX__ROOTFS`.
# - `path_under_termux_rootfs`:Path variable must be under `TERMUX__ROOTFS`.
# - `safe_absolute_path`: Path variable must match
#   `TERMUX_REGEX__SAFE_ABSOLUTE_PATH` and must not match
#   `TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH`.
# - `safe_relative_path`: Path variable must match
#   `TERMUX_REGEX__SAFE_RELATIVE_PATH` and must not match
#   `TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH`.
# - `safe_rootfs_or_absolute_path`: Path variable must match
#   `TERMUX_REGEX__SAFE_ROOTFS_OR_ABSOLUTE_PATH` and must not match
#   `TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH`.
# - `apps_api_socket__server_parent_dir`: Path variable must have max
#    length `<= TERMUX__APPS_API_SOCKET__SERVER_PARENT_DIR___MAX_LEN`
#    including the null `\0` terminator.
# - `unix_path_max`: Path variable must have max length `<= TERMUX__UNIX_PATH_MAX`
#    including the null `\0` terminator.
# - `unsigned_int`: Variable must match `TERMUX_REGEX__UNSIGNED_INT`.
##
unset __TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_MAP; declare -A __TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_MAP=()

##
# The list of variable names added to `__TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_MAP`
# that maintains insertion order.
##
unset __TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_VARIABLE_NAMES; declare -a __TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_VARIABLE_NAMES=()

##
# Whether to validate max lengths of Termux paths. Set to `false` to skip validation.
##
__TERMUX_BUILD_PROPS__VALIDATE_PATHS_MAX_LEN="true"

##
# Whether to validate `usr` merge format for `TERMUX__PREFIX`. Set to `false` to skip validation.
# Check `TERMUX__PREFIX` variable docs for more info.
##
__TERMUX_BUILD_PROPS__VALIDATE_TERMUX_PREFIX_USR_MERGE_FORMAT="true"



##
# `__termux_build_props__add_variables_validator_actions` `<variable_name>` `<validator_actions>`
##
__termux_build_props__add_variables_validator_actions() {

    if [ $# -ne 2 ]; then
        echo "Invalid argument count '$#' to '__termux_build_props__add_variables_validator_actions'." 1>&2
        return 1
    fi

    local variable_name="$1"
    local validator_actions="$2"

    if [[ ! "$variable_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo "The variable_name '$variable_name' passed to '__termux_build_props__add_variables_validator_actions' is not a valid shell variable name." 1>&2
        return 1
    fi

    if [[ " ${__TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_VARIABLE_NAMES[*]} " != *" $variable_name "* ]]; then
        __TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_VARIABLE_NAMES+=("$variable_name")
    fi

    __TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_MAP["$variable_name"]+="$validator_actions"

}





####
# Variables for validating Termux variables.
####

##
# Regex that matches an absolute path that starts with a `/` with at
# least one characters under rootfs `/`. Duplicate or trailing path
# separators `/` are not allowed.
##
TERMUX_REGEX__ABSOLUTE_PATH='^(/[^/]+)+$'

##
# Regex that matches a relative path that does not start with a `/`.
# Duplicate or trailing path separators `/` are not allowed.
##
TERMUX_REGEX__RELATIVE_PATH='^[^/]+(/[^/]+)*$'

##
# Regex that matches (rootfs `/`) or (an absolute path that starts
# with a `/`). Duplicate or trailing path separators `/` are not
# allowed.
##
TERMUX_REGEX__ROOTFS_OR_ABSOLUTE_PATH='^((/)|((/[^/]+)+))$'


##
# Regex that matches a safe absolute path that starts with a `/` with
# at least one characters under rootfs `/`. Duplicate or trailing path
# separators `/` are not allowed. The path component characters must
# be in the range `[a-zA-Z0-9+,.=_-]`.
#
# The path must also be validated against
# `TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH`.
##
TERMUX_REGEX__SAFE_ABSOLUTE_PATH='^(/[a-zA-Z0-9+,.=_-]+)+$'

##
# Regex that matches a safe relative path that does not start with a
# `/`. Duplicate or trailing path separators `/` are not allowed. The
# path component characters must be in the range `[a-zA-Z0-9+,.=_-]`.
#
# The path must also be validated against
# `TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH`.
##
TERMUX_REGEX__SAFE_RELATIVE_PATH='^[a-zA-Z0-9+,.=_-]+(/[a-zA-Z0-9+,.=_-]+)*$'

##
# Regex that matches (rootfs `/`) or (a safe absolute path that starts
# with a `/`). Duplicate or trailing path separators `/` are not
# allowed. The path component characters must be in the range
# `[a-zA-Z0-9+,.=_-]`.
#
# The path must also be validated against
# `TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH`.
##
TERMUX_REGEX__SAFE_ROOTFS_OR_ABSOLUTE_PATH='^((/)|((/[a-zA-Z0-9+,.=_-]+)+))$'


##
# Regex that matches a path containing single `/./` or double `/../` dot components.
##
TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH='((^\./)|(^\.\./)|(/\.$)|(/\.\.$)|(/\./)|(/\.\./))'


##
# Regex that matches invalid Termux rootfs paths.
#
# The Termux rootfs or prefix paths must not be equal to or be under
# specific Filesystem Hierarchy Standard paths or paths used by Termux
# docker image/host OS for its own files, as Termux packages files
# must be kept separate from the build host. The Termux app data/prefix
# directories are also wiped by `clean.sh` when not running on-device,
# which wouldn't be possible if Termux and host directories are shared.
#
# The invalid paths list does not include the `/data` and `/mnt/expand`
# paths under which private app data directories are assigned to
# Android apps, or the `/data/local/tmp` directory assigned to `adb`
# `shell` user, or the `/system` directory for the Android system.
#
# - https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.html
# - https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-private-app-data-directory
##
TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS='^((/bin(/.*)?)|(/boot(/.*)?)|(/dev(/.*)?)|(/etc(/.*)?)|(/home)|(/lib(/.*)?)|(/lib[^/]+(/.*)?)|(/media)|(/mnt)|(/opt)|(/proc(/.*)?)|(/root)|(/run(/.*)?)|(/sbin(/.*)?)|(/srv(/.*)?)|(/sys(/.*)?)|(/tmp(/.*)?)|(/usr)|(/usr/local)|(((/usr/)|(/usr/local/))((bin)|(games)|(include)|(lib)|(libexec)|(lib[^/]+)|(sbin)|(share)|(src)|(X11R6))(/.*)?)|(/var(/.*)?)|(/bin.usr-is-merged)|(/lib.usr-is-merged)|(/sbin.usr-is-merged)|(/.dockerinit)|(/.dockerenv))$'

##
# Regex that matches invalid Termux home paths.
#
# Same reasoning as `TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS`,
# and invalid paths are the same as well except that `/home` is
# allowed, and `/` and all paths under `/usr` are not allowed.
#
# `/home` is allowed as package data files are not packaged from there.
##
TERMUX_REGEX__INVALID_TERMUX_HOME_PATHS='^((/)|(/bin(/.*)?)|(/boot(/.*)?)|(/dev(/.*)?)|(/etc(/.*)?)|(/lib(/.*)?)|(/lib[^/]+(/.*)?)|(/media)|(/mnt)|(/opt)|(/proc(/.*)?)|(/root)|(/run(/.*)?)|(/sbin(/.*)?)|(/srv(/.*)?)|(/sys(/.*)?)|(/tmp(/.*)?)|(/usr(/.*)?)|(/var(/.*)?)|(/bin.usr-is-merged)|(/lib.usr-is-merged)|(/sbin.usr-is-merged)|(/.dockerinit)|(/.dockerenv))$'

##
# Regex that matches invalid Termux prefix paths.
#
# Same reasoning as `TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS`,
# and invalid paths are the same as well except that `/` is not
# allowed.
##
TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS='^((/)|(/bin(/.*)?)|(/boot(/.*)?)|(/dev(/.*)?)|(/etc(/.*)?)|(/home)|(/lib(/.*)?)|(/lib[^/]+(/.*)?)|(/media)|(/mnt)|(/opt)|(/proc(/.*)?)|(/root)|(/run(/.*)?)|(/sbin(/.*)?)|(/srv(/.*)?)|(/sys(/.*)?)|(/tmp(/.*)?)|(/usr)|(/usr/local)|(((/usr/)|(/usr/local/))((bin)|(games)|(include)|(lib)|(libexec)|(lib[^/]+)|(sbin)|(share)|(src)|(X11R6))(/.*)?)|(/var(/.*)?)|(/bin.usr-is-merged)|(/lib.usr-is-merged)|(/sbin.usr-is-merged)|(/.dockerinit)|(/.dockerenv))$'


##
# Regex that matches an unsigned integer `>= 0`.
##
TERMUX_REGEX__UNSIGNED_INT='^[0-9]+$'


##
# Regex to match an android app package name.
#
# The package name must have at least two segments separated by a dot
# `.`, where each segment must start with at least one character in
# the range `[a-zA-Z]`, followed by zero or more characters in the
# range `[a-zA-Z0-9_]`. The package name length must also be
# `<= 255` (`NAME_MAX` for ext4 partitions). The length is not checked
# by this regex and it must be checked with `TERMUX__NAME_MAX`, as
# `bash` `=~` regex conditional does not support lookaround.
#
# Unlike Android, the Termux app package name max length is not `255`
# as its limited by `TERMUX__APPS_DIR___MAX_LEN` and `TERMUX__ROOTFS_DIR___MAX_LEN`.
#
# - https://developer.android.com/build/configure-app-module#set-application-id
# - https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:frameworks/base/core/java/android/content/pm/parsing/ApkLiteParseUtils.java;l=669-677
# - https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:frameworks/base/core/java/android/content/pm/parsing/FrameworkParsingPackageUtils.java;l=63-103
# - https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:frameworks/base/core/java/android/os/FileUtils.java;l=954-994
# - https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:frameworks/base/core/java/android/content/pm/PackageManager.java;l=2147-2155
##
TERMUX_REGEX__APP_PACKAGE_NAME="^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$"

##
# Regex to match an android app data path.
#
# The supported formats are:
# - `/data/data/<package_name>` (for primary user `0`) if app is to be
#   installed on internal sd.
# - `/data/user/<user_id>/<package_name>` (for all users) if app is to
#   be installed on internal sd.
# `/mnt/expand/<volume_uuid>/user/<user_id>/<package_name>` if app is
#  to be installed on a removable/portable volume/sd card being used as
#  adoptable storage.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-private-app-data-directory
##
TERMUX_REGEX__APP_DATA_DIR_PATH='^(((/data/data)|(/data/user/[0-9]+)|(/mnt/expand/[^/]+/user/[0-9]+))/[^/]+)$'





###
# Variables for the Termux build tools.
###

##
# The path to the `termux-packages` repo root directory.
##
TERMUX_PKGS__BUILD__REPO_ROOT_DIR="${TERMUX_PKGS__BUILD__REPO_ROOT_DIR:-}"

__termux_build_props__set_termux_builder__repo_root_dir() {

    local relative_path="${1:-}"
    local return_value=0
    if [[ -z "${TERMUX_PKGS__BUILD__REPO_ROOT_DIR:-}" ]]; then
        if [[ "$(readlink --help 2>&1 || true)" =~ [\ ]-f[,\ ] ]]; then
            TERMUX_PKGS__BUILD__REPO_ROOT_DIR="$(file="$(readlink -f -- "${BASH_SOURCE[0]}")" && \
                parent="$(dirname -- "$file")" && \
                readlink -f -- "${parent}${relative_path}")" || return_value=$?
        else
            TERMUX_PKGS__BUILD__REPO_ROOT_DIR="$(pwd)" || return_value=$? # macOS `< 12.3` compatibility.
        fi
    fi
    if [ $return_value -ne 0 ] || [[ ! "$TERMUX_PKGS__BUILD__REPO_ROOT_DIR" =~ ^(/[a-zA-Z0-9+,.=_-]+)+$ ]] || \
            [[ ! -f "$TERMUX_PKGS__BUILD__REPO_ROOT_DIR/scripts/properties.sh" ]]; then
        echo "The TERMUX_PKGS__BUILD__REPO_ROOT_DIR '$TERMUX_PKGS__BUILD__REPO_ROOT_DIR' not found or is not valid." 1>&2
        return 1;
    fi

}
__termux_build_props__set_termux_builder__repo_root_dir "/.." || exit $?
unset __termux_build_props__set_termux_builder__repo_root_dir
TERMUX_SCRIPTDIR="${TERMUX_SCRIPTDIR:-TERMUX_PKGS__BUILD__REPO_ROOT_DIR}" # Deprecated alternative variable for `TERMUX_PKGS__BUILD__REPO_ROOT_DIR`



TERMUX_SDK_REVISION=9123335
TERMUX_ANDROID_BUILD_TOOLS_VERSION=33.0.1
# when changing the above:
# change TERMUX_PKG_VERSION (and remove TERMUX_PKG_REVISION if necessary) in:
#   apksigner, d8
# and trigger rebuild of them
: "${TERMUX_NDK_VERSION_NUM:="27"}"
: "${TERMUX_NDK_REVISION:="c"}"
TERMUX_NDK_VERSION="${TERMUX_NDK_VERSION_NUM}${TERMUX_NDK_REVISION}"
# when changing the above:
# update version and hashsum in packages
#   libandroid-stub, libc++, ndk-multilib, ndk-sysroot, vulkan-loader-android
# and update SHA256 sums in scripts/setup-android-sdk.sh
# check all packages build and run correctly and bump if needed

: "${TERMUX_JAVA_HOME:=/usr/lib/jvm/java-17-openjdk-amd64}"
export JAVA_HOME="${TERMUX_JAVA_HOME}"

if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
    export ANDROID_HOME="${TERMUX_PKGS__BUILD__REPO_ROOT_DIR}/build-tools/android-sdk-${TERMUX_SDK_REVISION}"
    export NDK="${TERMUX_PKGS__BUILD__REPO_ROOT_DIR}/build-tools/android-ndk-r${TERMUX_NDK_VERSION}"
else
    : "${ANDROID_HOME:="${HOME}/lib/android-sdk-$TERMUX_SDK_REVISION"}"
    : "${NDK:="${HOME}/lib/android-ndk-r${TERMUX_NDK_VERSION}"}"
fi



###
# Variables for the Termux apps and packages for which to compile packages.
#
# Variables defined in this file need to be in sync with `termux-app`
# (`TermuxConstants` and `TermuxCoreConstants`), termux site and `termux-exec`.
# - https://github.com/termux/termux-app/blob/master/termux-shared/src/main/java/com/termux/shared/termux/TermuxConstants.java
# - https://github.com/termux/termux-app/blob/master/termux-shared/src/main/java/com/termux/shared/termux/core/TermuxCoreConstants.java
#
# Following is a list of `TERMUX_` variables that are safe to modify when forking.
# **DO NOT MODIFY ANY OTHER VARIABLE UNLESS YOU KNOW WHAT YOU ARE DOING.**
#
# - `TERMUX__NAME`, `TERMUX__LNAME` and `TERMUX__UNAME`.
# - `TERMUX__REPOS_HOST_ORG_NAME` and `TERMUX__REPOS_HOST_ORG_URL`.
# - `TERMUX_*__REPO_NAME` and `TERMUX_*__REPO_URL`.
# - `TERMUX_APP__PACKAGE_NAME`.
# - `TERMUX_APP__DATA_DIR`.
# - `TERMUX__PROJECT_SUBDIR`.
# - `TERMUX__ROOTFS_SUBDIR`.
# - `TERMUX__ROOTFS` and alternates.
# - `TERMUX__PREFIX` and alternates.
# - `TERMUX_ANDROID_HOME` and alternates.
# - `TERMUX_APP__NAME` and `TERMUX_APP__LNAME`.
# - `TERMUX_APP__APP_IDENTIFIER`.
# - `TERMUX_APP__NAMESPACE`.
# - `TERMUX_APP__SHELL_API__SHELL_API_ACTIVITY__*`.
# - `TERMUX_APP__SHELL_API__SHELL_API_SERVICE__*`.
# - `TERMUX_APP__RUN_COMMAND_API__RUN_COMMAND_API_SERVICE__*`.
# - `TERMUX_APP__DATA_SENDER_API__DATA_SENDER_API_RECEIVER__*`.
# - `TERMUX_API_APP__PACKAGE_NAME`.
# - `TERMUX_API_APP__NAME`.
# - `TERMUX_API_APP__APP_IDENTIFIER`.
# - `TERMUX_API_APP__NAMESPACE`.
# - `TERMUX_API_APP__ANDROID_API__ANDROID_API_RECEIVER__*`.
# - `TERMUX_AM_APP__NAMESPACE`.
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
# Termux internal project name.
#
# This is used internally for paths, filenames, and other internal use
# cases and must match the `TERMUX__INTERNAL_NAME_REGEX` regex and
# have max length `TERMUX__INTERNAL_NAME___MAX_LEN`.
#
# **This must not be changed unless doing a full fork of Termux where
# all Termux references are changed instead of just changing the
# `TERMUX__NAME`, `TERMUX_APP__PACKAGE_NAME` and urls.**
#
# Default value: `termux`
##
TERMUX__INTERNAL_NAME="termux"

##
# The regex to validate `TERMUX__INTERNAL_NAME`.
#
# The internal name must start with characters in the range
# `[a-z0-9]`, followed by at least one character in the range
# `[a-z0-9_-]`, and end with characters in the range `[a-z0-9]`. The
# min length is `3`. The max length `7` as per
# `TERMUX__INTERNAL_NAME___MAX_LEN` is not checked by this regex and
# must be checked separately.
#
#
# Constant value: `^[a-z0-9][a-z0-9_-]+[a-z0-9]$`
##
TERMUX__INTERNAL_NAME_REGEX="^[a-z0-9][a-z0-9_-]+[a-z0-9]$"

##
# The max length for the `TERMUX__INTERNAL_NAME`.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `7` is chosen.
#
# Constant value: `7`
##
TERMUX__INTERNAL_NAME___MAX_LEN=7



##
# Termux repositories host organization name.
#
# Default value: `termux`
##
TERMUX__REPOS_HOST_ORG_NAME="termux"

##
# Termux repositories host organization url.
#
# Default value: `https://github.com/termux`
##
TERMUX__REPOS_HOST_ORG_URL="https://github.com/$TERMUX__REPOS_HOST_ORG_NAME"



##
# Termux app package name used for `TERMUX_APP__DATA_DIR` and
# `TERMUX_APP__*_(ACTIVITY|RECEIVER|SERVICE)__*` variables.
#
# Ideally package name should be `<= 21` characters and max `33`
# characters. If package name has not yet been chosen, then it would
# be best to keep it to `<= 10` characters. Check
# https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why.
#
# **See Also:**
# - `TERMUX_APP__NAMESPACE`.
# - https://developer.android.com/build/configure-app-module#set-application-id
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-private-app-data-directory
#
# Default value: `com.termux`
##
TERMUX_APP__PACKAGE_NAME="com.termux"
TERMUX_APP_PACKAGE="$TERMUX_APP__PACKAGE_NAME" # Deprecated alternative variable for `TERMUX_APP__PACKAGE_NAME`

__termux_build_props__add_variables_validator_actions "TERMUX_APP__PACKAGE_NAME" "app_package_name"

##
# Termux app data directory path that is expected to be assigned by
# Android to the Termux app with `TERMUX_APP__PACKAGE_NAME` for all
# its app data, that will contain the Termux project directory
# (`TERMUX__PROJECT_DIR`), and optionally the Termux rootfs directory
# (`TERMUX__ROOTFS`).
#
# The path must match `TERMUX_REGEX__APP_DATA_DIR_PATH`.
#
# The directory set will be deleted by `clean.sh` if `TERMUX__PREFIX`
# is under `TERMUX_APP__DATA_DIR` and not running on-device, so make
# sure a safe path is set if running `clean.sh` in Termux docker or
# host OS build environment.
#
# Default value: `/data/data/com.termux`
##
TERMUX_APP__DATA_DIR="/data/data/$TERMUX_APP__PACKAGE_NAME"
__termux_build_props__add_variables_validator_actions "TERMUX_APP__DATA_DIR" "safe_absolute_path"

##
# The max length for the `TERMUX_APP__DATA_DIR` including the null '\0'
# terminator.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `69` is chosen.
#
# Constant value: `69`
##
TERMUX_APP__DATA_DIR___MAX_LEN=69





##
# Termux subdirectory path for `TERMUX__PROJECT_DIR`.
#
# Default value: `termux`
##
TERMUX__PROJECT_SUBDIR="$TERMUX__INTERNAL_NAME"
__termux_build_props__add_variables_validator_actions "TERMUX__PROJECT_SUBDIR" "safe_relative_path"

##
# Termux project directory path under `TERMUX_APP__DATA_DIR`.
#
# This is an exclusive directory for all Termux files that includes
# Termux core directory (`TERMUX__CORE_DIR`), Termux apps directory
# (`TERMUX__APPS_DIR`), and optionally the Termux rootfs directory
# (`TERMUX__ROOTFS`).
#
# Currently, the default Termux rootfs directory is not under it and
# is at the `/files`  subdirectory but there are plans to move it to
# `termux/rootfs/II` in future where `II` refers to rootfs id starting
# at `0` for multi-rootfs support.
#
# An exclusive directory is required so that all Termux files exist
# under a single directory, especially for when Termux is provided as
# a library, so that Termux files do not interfere with other files
# of Termux app forks or apps that may use the Termux library.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-project-directory
#
# Default value: `/data/data/com.termux/termux`
##
TERMUX__PROJECT_DIR="$TERMUX_APP__DATA_DIR/$TERMUX__PROJECT_SUBDIR"
__termux_build_props__add_variables_validator_actions "TERMUX__PROJECT_DIR" "safe_absolute_path"





##
# Termux subdirectory path for `TERMUX__CORE_DIR`.
#
# Constant value: `core`
##
TERMUX__CORE_SUBDIR="core"

##
# Termux core directory path under `TERMUX__PROJECT_DIR`.
#
# This contains Termux core files for the Termux app, like user settings and configs for the app,
# which and are independent of any specific rootfs.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-core-directory
#
# Default value: `/data/data/com.termux/termux/core`
##
TERMUX__CORE_DIR="$TERMUX__PROJECT_DIR/$TERMUX__CORE_SUBDIR"
__termux_build_props__add_variables_validator_actions "TERMUX__CORE_DIR" "safe_absolute_path"






##
# Termux subdirectory path for `TERMUX__APPS_DIR`.
#
# Constant value: `app`
##
TERMUX__APPS_SUBDIR="app"

##
# Termux apps directory path under `TERMUX__PROJECT_DIR`.
#
# This contains app specific files for the Termux app, its plugin
# apps, and third party apps, like used for app APIs and
# filesystem/pathname socket files of servers created by the apps.
# - https://man7.org/linux/man-pages/man7/unix.7.html
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-apps-directory
#
# Default value: `/data/data/com.termux/termux/app`
##
TERMUX__APPS_DIR="$TERMUX__PROJECT_DIR/$TERMUX__APPS_SUBDIR"
__termux_build_props__add_variables_validator_actions "TERMUX__APPS_DIR" "safe_absolute_path"

##
# The max length for the `TERMUX__APPS_DIR` including the null '\0'
# terminator.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `84` is chosen.
#
# Constant value: `84`
##
TERMUX__APPS_DIR___MAX_LEN=84

##
# The max length for the Termux apps api socket server parent directory
# including the null '\0' terminator.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `98` is chosen.
#
# Constant value: `98`
##
TERMUX__APPS_API_SOCKET__SERVER_PARENT_DIR___MAX_LEN=98



##
# Termux subdirectory path for `TERMUX__APPS_DIR_BY_IDENTIFIER`.
#
# Constant value: `i`
##
TERMUX__APPS_DIR_BY_IDENTIFIER_SUBDIR="i"

##
# Termux apps directory path by app identifier under `TERMUX__APPS_DIR`.
#
# Default value: `/data/data/com.termux/termux/app/i`
##
TERMUX__APPS_DIR_BY_IDENTIFIER="$TERMUX__APPS_DIR/$TERMUX__APPS_DIR_BY_IDENTIFIER_SUBDIR"

##
# The regex to validate a subdirectory name under the
# `TERMUX__APPS_DIR_BY_IDENTIFIER` excluding the null '\0' terminator
# that represents an app identifier.
#
# The app identifier must only contain characters in the range
# `[a-zA-Z0-9]` as segments, with `[._-]` as separators between
# segments, and with the first segment containing at least `3`
# characters. The max length `10` as per
# `TERMUX__APPS_APP_IDENTIFIER___MAX_LEN` is not checked by this regex
# and must be checked separately.
#
# Constant value: `^[a-zA-Z0-9]{3,}([._-][a-zA-Z0-9]+)*$`
##
TERMUX__APPS_APP_IDENTIFIER_REGEX="^[a-zA-Z0-9]{3,}([._-][a-zA-Z0-9]+)*$"

##
# The max length for a subdirectory name under the
# `TERMUX__APPS_DIR_BY_IDENTIFIER` excluding the null '\0' terminator
# that represents an app identifier.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `10` is chosen.
#
# Constant value: `10`
##
TERMUX__APPS_APP_IDENTIFIER___MAX_LEN=10





##
# Termux subdirectory path for `TERMUX__APPS_DIR_BY_UID`.
#
# Constant value: `u`
##
TERMUX__APPS_DIR_BY_UID_SUBDIR="u"

##
# Termux apps directory path by app uid (user_id + app_id) under
# `TERMUX__APPS_DIR`.
#
# Default value: `/data/data/com.termux/termux/app/u`
##
TERMUX__APPS_DIR_BY_UID="$TERMUX__APPS_DIR/$TERMUX__APPS_DIR_BY_UID_SUBDIR"

##
# The regex to validate a  subdirectory name under the
# `TERMUX__APPS_DIR_BY_UID` excluding the null '\0' terminator that
# represents an app uid.
#
# The app uid must only contains `5` to `9` characters that are
# numbers and must not start with a `0`.
#
# Constant value: `^[1-9][0-9]{4,8}$`
##
TERMUX__APPS_APP_UID_REGEX="^[1-9][0-9]{4,8}$"

##
# The max length for a subdirectory name under the
# `TERMUX__APPS_DIR_BY_UID` excluding the null '\0' terminator that
# represents an app uid.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `9` is chosen.
#
# Constant value: `9`
##
TERMUX__APPS_APP_UID___MAX_LEN=9





##
# Termux apps info environment subfile path under an app directory of
# `TERMUX__APPS_DIR_BY_IDENTIFIER`.
#
# Default value: `termux-apps-info.env`
##
TERMUX_CORE__APPS_INFO_ENV_SUBFILE="$TERMUX__INTERNAL_NAME-apps-info.env"

##
# Termux apps info json subfile path under an app directory of
# `TERMUX__APPS_DIR_BY_IDENTIFIER`.
#
# Default value: `termux-apps-info.json`
##
TERMUX_CORE__APPS_INFO_JSON_SUBFILE="$TERMUX__INTERNAL_NAME-apps-info.json"



##
# `termux-am-socket` server subfile path under an app directory of
# `TERMUX__APPS_DIR_BY_IDENTIFIER`.
#
# Default value: `termux-am`
##
TERMUX_AM_SOCKET__SERVER_SOCKET_SUBFILE="$TERMUX__INTERNAL_NAME-am"





##
# Termux `TERMUX__ROOTFS` id.
#
# Default value: `0`
##
TERMUX__ROOTFS_ID="0"
__termux_build_props__add_variables_validator_actions "TERMUX__ROOTFS_ID" "unsigned_int"

##
# Termux subdirectory path for `TERMUX__ROOTFS`.
#
# Default value: `files`
##
TERMUX__ROOTFS_SUBDIR="files"
__termux_build_props__add_variables_validator_actions "TERMUX__ROOTFS_SUBDIR" "allow_unset_value safe_relative_path"

###########
# Uncomment if to place `TERMUX__ROOTFS`  under `TERMUX__PROJECT_DIR`
# instead of at `files`. This may be used for future multi-rootfs
# design. Make sure to update `TERMUX__CACHE_SUBDIR` above as well.

##
# Termux subdirectory path for parent directory of all Termux rootfses
# including `TERMUX__ROOTFS`.
#
# Default value: `termux/rootfs`
##
#TERMUX__ROOTFSES_SUBDIR="$TERMUX__PROJECT_SUBDIR/rootfs"
###########

##
# Termux subdirectory path for `TERMUX__ROOTFS`.
#
# Default value: `termux/rootfs/0`
##
#TERMUX__ROOTFS_SUBDIR="$TERMUX__ROOTFSES_SUBDIR/$TERMUX__ROOTFS_ID"
###########


##
# Termux rootfs directory path under `TERMUX_APP__DATA_DIR` that
# contains the Linux environment rootfs provided by Termux.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-rootfs-directory
# - https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03.html
#
# The Termux rootfs must not be set to path in
# `TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS`. It can exist outside
# the `TERMUX_APP__DATA_DIR` if compiling packages for the Android
# system or `adb` `shell` user.
#
# Default value: `/data/data/com.termux/files`
##
TERMUX__ROOTFS="$TERMUX_APP__DATA_DIR/$TERMUX__ROOTFS_SUBDIR"
TERMUX_BASE_DIR="$TERMUX__ROOTFS" # Deprecated alternative variable for `TERMUX__ROOTFS`

__termux_build_props__add_variables_validator_actions "TERMUX__ROOTFS" "safe_rootfs_or_absolute_path invalid_termux_rootfs_paths"

# FIXME: Remove after updating Termux app and `termux-am-socket`
# package sources and use `TERMUX__APPS_DIR`.
TERMUX_APPS_DIR="$TERMUX__ROOTFS/apps"

##
# The max length for the `TERMUX__ROOTFS` including the null '\0'
# terminator.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `86` is chosen.
#
# Constant value: `86`
##
TERMUX__ROOTFS_DIR___MAX_LEN=86





####
# Variables for the Termux home.
####

##
# Termux subdirectory path for `TERMUX__HOME`.
#
# Default value: `home`
##
TERMUX__HOME_SUBDIR="home"
__termux_build_props__add_variables_validator_actions "TERMUX__HOME_SUBDIR" "safe_relative_path"

##
# Termux home directory path under `TERMUX__ROOTFS` used for `$HOME`.
#
# It serves the same purpose as the `/home` directory on Linux distros.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-home-directory
# - https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s08.html
#
# Check `TERMUX__PREFIX` variable docs for rules that apply depending
# on if `TERMUX__ROOTFS` is equal to Android/Linux rootfs `/` or not.
# The Termux home must not be set to Android/Linux rootfs `/` or any
# other path in `TERMUX_REGEX__INVALID_TERMUX_HOME_PATHS`.
#
# Default value: `/data/data/com.termux/files/home`
##
[[ "$TERMUX__ROOTFS" != "/" ]] && TERMUX__HOME="$TERMUX__ROOTFS/$TERMUX__HOME_SUBDIR" || \
    TERMUX__HOME="/$TERMUX__HOME_SUBDIR"
__termux_build_props__add_variables_validator_actions "TERMUX__HOME" "safe_absolute_path invalid_termux_home_paths path_under_termux_rootfs"

TERMUX_ANDROID_HOME="$TERMUX__HOME" # Deprecated alternative variable for `TERMUX__HOME`

##
# Termux legacy project user config directory path under `TERMUX__HOME`.
#
# Default value: `/data/data/com.termux/files/home/.termux`
##
TERMUX__LEGACY_PROJECT_USER_CONFIG_DIR="$TERMUX__HOME/.termux"





####
# Variables for the Termux prefix.
####

##
# Termux subdirectory path for `TERMUX__PREFIX`.
#
# Default value: `usr`
##
TERMUX__PREFIX_SUBDIR="usr"
__termux_build_props__add_variables_validator_actions "TERMUX__PREFIX_SUBDIR" "allow_unset_value safe_relative_path"

##
# Termux prefix directory path under or equal to `TERMUX__ROOTFS`
# where all Termux packages data is installed.
#
# It serves the same purpose as the `/usr` directory on Linux distros
# and contains the `bin`, `etc`, `include`, `lib`, `libexec`, `opt`,
# `share`, `tmp` and `var` sub directories.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-prefix-directory
# - https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04.html
#
# If `TERMUX__ROOTFS` is not equal to `/`, then by default Termux
# uses `usr` merge format, like used by `debian`, as per
# `__TERMUX_BUILD_PROPS__VALIDATE_TERMUX_PREFIX_USR_MERGE_FORMAT`
# being enabled by default. In the `usr` merge format, all packages
# are installed under the `usr` subdirectory under rootfs, like under
# `$TERMUX__ROOTFS/usr/bin` and `$TERMUX__ROOTFS/usr/lib`,
# instead of under `$TERMUX__ROOTFS/bin` and `$TERMUX__ROOTFS/lib`.
# So if `usr` merge format is enabled, then DO NOT change the default
# value of `TERMUX__PREFIX_SUBDIR` from `usr`.
# The `$TERMUX__ROOTFS/usr-staging` directory is also used as a
# temporary directory for extracting bootstrap zip by the Termux app,
# before its renamed to `$TERMUX__ROOTFS/usr`.
# Additionally, `TERMUX__PREFIX` must not be equal to `TERMUX__HOME`
# and they must not be under each other, as Termux app requires that
# prefix and home are separate directories as prefix gets wiped during
# bootstrap installation or if `termux-reset` is run, and backup
# scripts require the same. Package data also needs to be kept
# separate from `home`, so it does not make sense for them to be
# equal to or be under each other.
# However, if a Termux app fork is using a modified bootstrap
# installation that does not use the `usr` merge format, then
# `__TERMUX_BUILD_PROPS__VALIDATE_TERMUX_PREFIX_USR_MERGE_FORMAT` can
# be set to `false` and `TERMUX__PREFIX_SUBDIR` could optionally be
# set to an empty string if `TERMUX__ROOTFS` should be equal to
# `TERMUX__PREFIX`, or a custom directory other than `usr`. In this
# case `TERMUX__HOME` can optionally be under `TERMUX__PREFIX`, but
# not be equal to it.
#
# - https://wiki.debian.org/UsrMerge
# - https://lists.debian.org/debian-devel-announce/2019/03/msg00001.html
# - https://dep-team.pages.debian.net/deps/dep17/
#
# If `TERMUX__ROOTFS` is equal to Android/Linux rootfs `/`, then
# `TERMUX__PREFIX_SUBDIR` must not be set to an empty string as
# `TERMUX__PREFIX` must be a subdirectory under rootfs `/`, and must
# not be set to `usr` either or or any other path in
# `TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS`. Check the
# `TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS` variable docs for why
# some paths like `/usr`, etc are now allowed.
#
# Basically, the following rules apply for `TERMUX__PREFIX`.
# - If `TERMUX__ROOTFS` is not equal to `/`:
#     - If `usr` merge format is enabled:
#         - `TERMUX__PREFIX` must be equal to `$TERMUX__ROOTFS/usr`.
#         - `TERMUX__PREFIX` must not be equal to `TERMUX__HOME` and
#            they must not be under each other.
#     - If `usr` merge format is disabled:
#         - `TERMUX__PREFIX` must be equal to or be under `$TERMUX__ROOTFS`.
#         - `TERMUX__PREFIX` must not be equal to or be under `TERMUX__HOME`.
# - If `TERMUX__ROOTFS` is equal to `/`:
#     - If `usr` merge format is enabled or disabled:
#         - `TERMUX__PREFIX` must be under `$TERMUX__ROOTFS` and not
#           equal to `/usr` or other paths in `TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS`.
#         - `TERMUX__PREFIX` must not be equal to or be under `TERMUX__HOME`.
#
# The directory set will be deleted by `clean.sh` if not running
# on-device, so make sure a safe path is set if running `clean.sh` in
# Termux docker or host OS build environment.
#
# At runtime, `TERMUX__PREFIX` may be overridden and set to
# `TERMUX__PREFIX_GLIBC` when compiling `glibc` packages by calling
# `termux_build_props__set_termux_prefix_dir_and_sub_variables` in
# `termux_step_setup_variables` if `TERMUX_PACKAGE_LIBRARY` equals `glibc`.
# However, `TERMUX__PREFIX_CLASSICAL` retains the original value
# set below for `TERMUX__PREFIX`.
# - https://github.com/termux/termux-packages/pull/16901
# - https://github.com/termux/termux-packages/pull/20864
#
# Default value: `/data/data/com.termux/files/usr`
##
[[ "$TERMUX__ROOTFS" != "/" ]] && TERMUX__PREFIX="$TERMUX__ROOTFS${TERMUX__PREFIX_SUBDIR:+"/$TERMUX__PREFIX_SUBDIR"}" || \
    TERMUX__PREFIX="/$TERMUX__PREFIX_SUBDIR"
__termux_build_props__add_variables_validator_actions "TERMUX__PREFIX" "safe_absolute_path invalid_termux_prefix_paths"

if [[ "$TERMUX__ROOTFS" != "/" ]] && [[ "$__TERMUX_BUILD_PROPS__VALIDATE_TERMUX_PREFIX_USR_MERGE_FORMAT" != "true" ]]; then
    __termux_build_props__add_variables_validator_actions "TERMUX__PREFIX" " path_equal_to_or_under_termux_rootfs"
else
    __termux_build_props__add_variables_validator_actions "TERMUX__PREFIX" " path_under_termux_rootfs"
fi

TERMUX_PREFIX="$TERMUX__PREFIX" # Deprecated alternative variable for `TERMUX__PREFIX`



##
# The original value for `TERMUX__PREFIX` set above, as `TERMUX__PREFIX`
# can be overridden at runtime, like when compiling `glibc` packages.
# Checks variable docs of `TERMUX__PREFIX` for more info.
#
# Default value: `/data/data/com.termux/files/usr`
##
TERMUX__PREFIX_CLASSICAL="$TERMUX__PREFIX"
TERMUX_PREFIX_CLASSICAL="$TERMUX__PREFIX" # Deprecated alternative variable for `TERMUX__PREFIX_CLASSICAL`



##
# Termux subdirectory path for `TERMUX__PREFIX_GLIBC`.
#
# Default value: `glibc`
##
TERMUX__PREFIX_GLIBC_SUBDIR="glibc"

##
# Termux `glibc` prefix directory path under `TERMUX__PREFIX`
# where all Termux `glibc` packages data is installed.
#
# **See Also:**
# - https://github.com/termux-pacman/glibc-packages
# - https://github.com/termux/glibc-packages (mirror)
#
# Default value: `/data/data/com.termux/files/usr/glibc`
##
TERMUX__PREFIX_GLIBC="$TERMUX__PREFIX/$TERMUX__PREFIX_GLIBC_SUBDIR"
__termux_build_props__add_variables_validator_actions "TERMUX__PREFIX_GLIBC" "safe_absolute_path invalid_termux_prefix_paths path_under_termux_rootfs"



##
# The max length for the `TERMUX__PREFIX` including the null '\0'
# terminator.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `90` is chosen.
#
# Constant value: `90`
##
TERMUX__PREFIX_DIR___MAX_LEN="$((TERMUX__ROOTFS_DIR___MAX_LEN + 1 + 3))" # "/usr" (90)


##
# The max length for the `TERMUX__BIN_DIR` including the null '\0' terminator.
#
# Constant value: `94`
##
TERMUX__PREFIX__BIN_DIR___MAX_LEN="$((TERMUX__PREFIX_DIR___MAX_LEN + 1 + 3))" # "/bin" (94)

##
# The max safe length for a sub file path under the `TERMUX__BIN_DIR`
# including the null '\0' terminator.
#
# This allows for a filename with max length `33` so that the path
# length is under `128` (`BINPRM_BUF_SIZE`) for Linux kernel `< 5.1`,
# and ensures `argv[0]` length is `< 128` on Android `< 6`, otherwise
# commands will fail with exit code 1 without any error on `stderr`,
# but with the `library name "<library_name>" too long` error in
# `logcat` if linker debugging is enabled.
#
# **See Also:**
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# - https://github.com/termux/termux-core-package/blob/master/lib/termux-core_nos_c/tre/include/termux/termux_core__nos__c/v1/termux/file/TermuxFile.h
# - https://github.com/termux/termux-exec-package/blob/master/lib/termux-exec_nos_c/tre/include/termux/termux_exec__nos__c/v1/termux/api/termux_exec/service/ld_preload/direct/exec/ExecIntercept.h
#
# Constant value: `127`
##
TERMUX__PREFIX__BIN_FILE___SAFE_MAX_LEN="$((TERMUX__PREFIX__BIN_DIR___MAX_LEN + 1 + 33))" # "/<filename_with_len_33>" (127)

##
# The max length for entire shebang line for `termux-exec`.
#
# **See Also:**
# - https://github.com/termux/termux-exec-package/blob/master/lib/termux-exec_nos_c/tre/include/termux/termux_exec__nos__c/v1/termux/api/termux_exec/service/ld_preload/direct/exec/ExecIntercept.h
#
# Default value: `340`
##
TERMUX__FILE_HEADER__BUFFER_SIZE="340"




##
# `termux_build_props__set_termux_prefix_dir_and_sub_variables` `<termux__prefix>` [`<skip_validation>`]
##
termux_build_props__set_termux_prefix_dir_and_sub_variables() {

local termux__prefix="${1:-}"
local skip_validation="${2:-}"

if [[ "$skip_validation" != "true" ]]; then
    if [[ ! "$termux__prefix" =~ ${TERMUX_REGEX__SAFE_ABSOLUTE_PATH:?} ]] || \
            [[ "$termux__prefix" =~ ${TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH:?} ]]; then
        echo "The termux__prefix '$termux__prefix' passed to 'termux_build_props__set_termux_prefix_dir_and_sub_variables' with length ${#termux__prefix} is invalid." 1>&2
        echo "The termux__prefix must match a safe absolute path that starts with a \`/\` with at least one \
characters under rootfs \`/\`. Duplicate or trailing path separators \`/\` are not allowed. \
The path component characters must be in the range \`[a-zA-Z0-9+,.=_-]\`. The path must not contain single \`/./\` or \
double \`/../\` dot components." 1>&2
        return 1
    fi

    if [[ "$termux__prefix" =~ ${TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS:?} ]]; then
        echo "The termux__prefix '$termux__prefix' passed to 'termux_build_props__set_termux_prefix_dir_and_sub_variables' with length ${#termux__prefix} is invalid." 1>&2
        echo "The termux__prefix must not match one of the invalid paths \
in TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS \`$TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS\`." 1>&2
        return 1
    fi
fi


# Override `TERMUX__PREFIX`, but keep original value in `TERMUX__PREFIX_CLASSICAL`.
TERMUX__PREFIX="$termux__prefix"
TERMUX_PREFIX="$termux__prefix"



##
# Termux subdirectory path for `TERMUX__PREFIX__BIN_DIR`.
#
# Constant value: `bin`
##
TERMUX__PREFIX__BIN_SUBDIR="bin"

##
# Termux bin directory path under `TERMUX__PREFIX`.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-bin-directory
#
# Default value: `/data/data/com.termux/files/usr/bin`
##
TERMUX__PREFIX__BIN_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__BIN_SUBDIR"



##
# Termux subdirectory path for `TERMUX__PREFIX__ETC_DIR`.
#
# Constant value: `etc`
##
TERMUX__PREFIX__ETC_SUBDIR="etc"

##
# Termux etc directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/etc`
##
TERMUX__PREFIX__ETC_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__ETC_SUBDIR"



##
# Termux subdirectory path for `TERMUX__PREFIX__BASE_INCLUDE_DIR`.
#
# Constant value: `include`
##
TERMUX__PREFIX__BASE_INCLUDE_SUBDIR="include"

##
# Termux base include directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/include`
##
TERMUX__PREFIX__BASE_INCLUDE_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__BASE_INCLUDE_SUBDIR"


##
# Termux subdirectory path for `TERMUX__PREFIX__MULTI_INCLUDE_DIR`.
#
# Constant value: `include32`
##
TERMUX__PREFIX__MULTI_INCLUDE_SUBDIR="include32"

##
# Termux multi include directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/include32`
##
TERMUX__PREFIX__MULTI_INCLUDE_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__MULTI_INCLUDE_SUBDIR"


##
# Termux include directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/include` (`$TERMUX__PREFIX__BASE_INCLUDE_DIR`)
##
TERMUX__PREFIX__INCLUDE_DIR="$TERMUX__PREFIX__BASE_INCLUDE_DIR"



##
# Termux subdirectory path for `TERMUX__PREFIX__BASE_LIB_DIR`.
#
# Constant value: `lib`
##
TERMUX__PREFIX__BASE_LIB_SUBDIR="lib"

##
# Termux base lib directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/lib`
##
TERMUX__PREFIX__BASE_LIB_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__BASE_LIB_SUBDIR"


##
# Termux subdirectory path for `TERMUX__PREFIX__MULTI_LIB_DIR`.
#
# Constant value: `lib32`
##
TERMUX__PREFIX__MULTI_LIB_SUBDIR="lib32"

##
# Termux multi lib directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/lib32`
##
TERMUX__PREFIX__MULTI_LIB_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__MULTI_LIB_SUBDIR"


##
# Termux lib directory path under `TERMUX__PREFIX`.
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-lib-directory
#
# Default value: `/data/data/com.termux/files/usr/lib` (`$TERMUX__PREFIX__BASE_LIB_DIR`)
##
TERMUX__PREFIX__LIB_DIR="$TERMUX__PREFIX__BASE_LIB_DIR"



##
# Termux subdirectory path for `TERMUX__PREFIX__LIBEXEC_DIR`.
#
# Constant value: `libexec`
##
TERMUX__PREFIX__LIBEXEC_SUBDIR="libexec"

##
# Termux libexec directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/libexec`
##
TERMUX__PREFIX__LIBEXEC_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__LIBEXEC_SUBDIR"



##
# Termux subdirectory path for `TERMUX__PREFIX__OPT_DIR`.
#
# Constant value: `opt`
##
TERMUX__PREFIX__OPT_SUBDIR="opt"

##
# Termux opt directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/opt`
##
TERMUX__PREFIX__OPT_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__OPT_SUBDIR"



##
# Termux subdirectory path for `TERMUX__PREFIX__SHARE_DIR`.
#
# Constant value: `share`
##
TERMUX__PREFIX__SHARE_SUBDIR="share"

##
# Termux share directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/share`
##
TERMUX__PREFIX__SHARE_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__SHARE_SUBDIR"



##
# Termux subdirectory path for `TERMUX__PREFIX__VAR_DIR`.
#
# Constant value: `var`
##
TERMUX__PREFIX__VAR_SUBDIR="var"

##
# Termux var directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/var`
##
TERMUX__PREFIX__VAR_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__VAR_SUBDIR"

}

# Set Termux prefix sub variables to be under the original value of
# `TERMUX__PREFIX` set in `TERMUX__PREFIX_CLASSICAL` by default,
# which is set earlier in this file.
# Skip validation as it will be done below by `__termux_build_props__validate_variables`.
termux_build_props__set_termux_prefix_dir_and_sub_variables "$TERMUX__PREFIX" "true" || exit $?





# The following variables must always be under the original value of
# `TERMUX__PREFIX` set in `TERMUX__PREFIX_CLASSICAL` by default.

##
# Termux subdirectory path for `TERMUX__PREFIX__TMP_DIR`.
#
# Constant value: `tmp`
##
TERMUX__PREFIX__TMP_SUBDIR="tmp"

##
# Termux tmp directory path under `TERMUX__PREFIX`.
#
# Default value: `/data/data/com.termux/files/usr/tmp`
##
TERMUX__PREFIX__TMP_DIR="$TERMUX__PREFIX/$TERMUX__PREFIX__TMP_SUBDIR"

##
# The max length for the `TERMUX__PREFIX__TMP_DIR` including the null
# '\0' terminator.
#
# Check https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#file-path-limits
# for why the value `94` is chosen.
#
# Constant value: `94`
##
TERMUX__PREFIX__TMP_DIR___MAX_LEN=94



##
# Termux `profile.d` directory path under `TERMUX__PREFIX__ETC_DIR`.
#
# Default value: `/data/data/com.termux/files/usr/etc/profile.d`
##
TERMUX__PREFIX__PROFILE_D_DIR="$TERMUX__PREFIX__ETC_DIR/profile.d"


##
# Termux project system config directory path under `TERMUX__PREFIX__ETC_DIR`.
#
# Default value: `/data/data/com.termux/files/usr/etc/termux`
##
TERMUX__PROJECT_SYSTEM_CONFIG_DIR="$TERMUX__PREFIX__ETC_DIR/$TERMUX__INTERNAL_NAME"





####
# Variables for the Termux cache.
####

##
# Termux subdirectory path for `TERMUX__CACHE_DIR`.
#
# Constant value: `cache`
##
TERMUX__CACHE_SUBDIR="cache"

###########
# Uncomment if to place `TERMUX__ROOTFS`  under `TERMUX__PROJECT_DIR`
# instead of at `files`. This may be used for future multi-rootfs
# design. This will also ensure `termux` files are not mixed with
# other cached files of an app, especially if Termux is forked or
# used as a library in other apps. Make sure to update
# `TERMUX__ROOTFS_SUBDIR` above as well.

##
# Termux subdirectory path for `TERMUX__CACHE_DIR`.
#
# Default value: `cache/termux/rootfs/0`
##
#TERMUX__CACHE_SUBDIR="cache/$TERMUX__INTERNAL_NAME/rootfs/$TERMUX__ROOTFS_ID"
###########

##
# Termux app cache directory path under `TERMUX_APP__DATA_DIR`
# contains cache files that are safe to be deleted by Android or
# Termux if required.
#
# The `cache` subdirectory is hardcoded in Android and must not be
# changed.
#
# Currently this is primarily used for packages cache files of package
# managers (`apt`/`pacman`).
#
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-app-cache-directory
#
# Default value: `/data/data/com.termux/cache`
##
TERMUX__CACHE_DIR="$TERMUX_APP__DATA_DIR/$TERMUX__CACHE_SUBDIR"
__termux_build_props__add_variables_validator_actions "TERMUX__CACHE_DIR" "safe_absolute_path"

TERMUX_CACHE_DIR="$TERMUX__CACHE_DIR" # Deprecated alternative variable for `TERMUX__CACHE_DIR`





####
# Variables for the Termux bootstrap.
####

##
# Termux bootstrap system config directory path under `TERMUX__PROJECT_SYSTEM_CONFIG_DIR`.
#
# Default value: `/data/data/com.termux/files/usr/etc/termux/termux-bootstrap`
##
TERMUX_BOOTSTRAP__BOOTSTRAP_SYSTEM_CONFIG_DIR="$TERMUX__PROJECT_SYSTEM_CONFIG_DIR/termux-bootstrap"


##
# Termux subdirectory path for `TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR`.
#
# Constant value: `second-stage`
##
TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_SUBDIR="second-stage"

##
# Termux bootstrap second stage directory path under `TERMUX_BOOTSTRAP__BOOTSTRAP_SYSTEM_CONFIG_DIR`.
#
# Default value: `/data/data/com.termux/files/usr/etc/termux/termux-bootstrap/second-stage`
##
TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR="$TERMUX_BOOTSTRAP__BOOTSTRAP_SYSTEM_CONFIG_DIR/$TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_SUBDIR"


##
# Termux bootstrap second stage entry point subfile path path under `TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_DIR`.
#
# Default value: `termux-bootstrap-second-stage.sh`
##
TERMUX_BOOTSTRAP__BOOTSTRAP_SECOND_STAGE_ENTRY_POINT_SUBFILE="termux-bootstrap-second-stage.sh"





##
# Max size in bytes for a path component or file name without the
# terminating `null` byte `\0`.
#
# On unix systems, any path component length of a path cannot be
# greater than what is supported by the filesystem under which the
# path is mounted.
#
# The common filesystems like `ext4`/`f2fs`/`btrfs`/`erofs`/`fat32`/`exfat`/`ntfs`
# all support max path component length of `255`. Check
# [filesystems limits wiki page] for more info on limits.
#
# The [POSIX standard requires `NAME_MAX` to be defined in `limits.h`] (not `c` standard).
#
# [`NAME_MAX`]: https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:bionic/libc/kernel/uapi/linux/limits.h;l=27
# [`readdir`]: https://www.man7.org/linux/man-pages/man3/readdir.3.html
# [`readdir_r`]: https://www.man7.org/linux/man-pages/man3/readdir_r.3.html
# [filesystems limits wiki page]: https://en.wikipedia.org/wiki/Comparison_of_file_systems#Limits
# [POSIX standard requires `NAME_MAX` to be defined in `limits.h`]: https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/limits.h.html
# [path component length greater than `NAME_MAX` should be considered an error]: https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap04.html#4.13
# [`NAME_MAX` value should normally be set to `255`]: https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:bionic/libc/kernel/uapi/linux/limits.h;l=27
# [the `NAME_MAX` value may not always be enforced, like by the GNU C library]: https://www.gnu.org/software/libc/manual/html_node/Limits-for-Files.html
# [`_PC_NAME_MAX` defined by POSIX]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/pathconf.html
# [`glibc` `_PC_NAME_MAX` source]: https://github.com/bminor/glibc/blob/569cfcc6/sysdeps/posix/fpathconf.c#L65
# [`bionic` `_PC_NAME_MAX` source]: https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:bionic/libc/bionic/pathconf.cpp;l=91
# [`pathconf`]: https://man7.org/linux/man-pages/man3/pathconf.3.html
# [`statvfs.f_namemax`]: https://man7.org/linux/man-pages/man3/statvfs.3.html
# [`realpath(1)`]: https://man7.org/linux/man-pages/man1/realpath.1.html
# [`realpath(3)`]: https://man7.org/linux/man-pages/man3/realpath.3.html
# [To what extent does Linux support file names longer than 255 bytes?]: https://unix.stackexchange.com/questions/619625/to-what-extent-does-linux-support-file-names-longer-than-255-bytes
# [Extending ext4 File system's filename size limit to 1012 characters]: https://stackoverflow.com/questions/34980895/extending-ext4-file-systems-filename-size-limit-to-1012-characters
# [Limit on file name length in bash]: https://stackoverflow.com/questions/6571435/limit-on-file-name-length-in-bash
#
# Constant value: `255`
##
TERMUX__NAME_MAX=255

##
# The max length for a filesystem socket file path (pathanme UNIX domain socket)
# for the `sockaddr_un.sun_path` field including the null `\0`
# terminator as per `UNIX_PATH_MAX`.
#
# All filesystem socket path lengths created by Termux apps and packages must be `< 108`.
#
# - https://man7.org/linux/man-pages/man7/unix.7.html
# - https://cs.android.com/android/platform/superproject/+/android-13.0.0_r18:bionic/libc/kernel/uapi/linux/un.h;l=22
#
# Constant value: `108`
##
TERMUX__UNIX_PATH_MAX=108





##
# Termux environment variables root scope.
#
# The name of this variable `TERMUX_ENV__S_ROOT` is considered a
# constant for Termux execution environment that's exported by Termux
# app containing the root scope and **must not be changed even for
# forks**. It can be used to check if running under Termux or any of
# its forks, and should be used to generate all Termux variable names
# that may need to be read, since Termux app forks may not export
# variables under the `TERMUX_` root scope and may do it under a
# different root scope like `FOO_`, so the `TERMUX__PREFIX` variable
# would be `FOO__PREFIX` instead.
#
# The `TERMUX_ENV__S_APP` environment variable will be exported at
# runtime for the scope of the current Termux app running the shell.
#
# Termux packages and external programs can use the
# `termux-scoped-env-variable` util from the `termux-core`
# package to get variable names and values for Termux. It uses the
# root scope from the `$TERMUX_ENV__S_ROOT` environment variable
# exported by the Termux app to dynamically generate the Termux
# variable names and/or get their values, with support for fallback
# to the build values defined here if `$TERMUX_ENV__S_ROOT` variable
# is not exported.**
# - https://github.com/termux/termux-core-package/blob/master/site/pages/en/projects/docs/usage/utils/termux/shell/command/environment/termux-scoped-env-variable.md
#
# The value of this variable `TERMUX_ENV__S_ROOT` may be modified,
# although not advisable since external programs would be using
# hardcoded `TERMUX_` value for reading Termux environment variables,
# and so changing variable names to say `FOO_*` would result in
# `TERMUX_*` ones being unset during execution, which would change
# external programs behaviour and may break them.
# **If the value is changed here, it must also be set to the same
# value in Termux app that is exported.**
#
# Moreover, currently, only `termux-exec` supports modifying this, all
# other termux (internal) packages, like `termux-tools`, etc do not.
# So forks should not modify it at least until all termux packages
# support modifying it.
#
# Default value: `TERMUX_`
##
TERMUX_ENV__S_ROOT="TERMUX_"



##
# Termux environment variables Termux sub scope for primary variables
# or variables for currently running Termux config.
#
# **Do not modify this!** This is considered a constant Termux sub
# scope for Termux execution environment that's used by external
# programs that do not use the termux packages building infrastructure
# and rely on `$TERMUX_ENV__S_ROOT` environment variable exported by
# Termux app containing the root scope to generate the value for
# `$TERMUX_ENV__S_TERMUX` and variable names under it.**
#
# Default value: `_`
##
TERMUX_ENV__SS_TERMUX="_"

##
# Termux environment variables Termux scope for primary variables or
# variables for currently running Termux config.
#
# **Do not modify this!**
#
# Default value: `TERMUX__`
##
TERMUX_ENV__S_TERMUX="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX}"



##
# Termux environment variables Termux app sub scope.
#
# **Do not modify this!** This is considered a constant Termux app sub
# scope for Termux execution environment that's used by external
# programs that do not use the termux packages building infrastructure
# and rely on `$TERMUX_ENV__S_ROOT` environment variable exported by
# Termux app containing the root scope to generate the value for
# `$TERMUX_ENV__S_TERMUX_APP` and variable names under it.**
#
# Default value: `APP__`
##
TERMUX_ENV__SS_TERMUX_APP="APP__"

##
# Termux environment variables Termux app scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_APP__`
##
TERMUX_ENV__S_TERMUX_APP="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_APP}"



##
# Termux environment variables Termux:API sub scope.
#
# **Do not modify this!** This is considered a constant Termux:API
# sub scope for Termux execution environment that's used by external
# programs that do not use the termux packages building infrastructure
# and rely on `$TERMUX_ENV__S_ROOT` environment variable exported by
# Termux app containing the root scope to generate the value for
# `$TERMUX_ENV__S_TERMUX_API` and variable names under it.**
#
# Default value: `API__`
##
TERMUX_ENV__SS_TERMUX_API="API__"

##
# Termux environment variables Termux:API scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_API__`
##
TERMUX_ENV__S_TERMUX_API="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_API}"



##
# Termux environment variables Termux:API app sub scope.
#
# This may be allowed to be modified, in case APIs are provided under
# a different app name or under the main Termux app itself by a fork.
# Consequences for changing this haven't been fully looked at yet.
#
# Default value: `API_APP__`
##
TERMUX_ENV__SS_TERMUX_API_APP="API_APP__"

##
# Termux environment variables Termux:API app scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_API_APP__`
##
TERMUX_ENV__S_TERMUX_API_APP="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_API_APP}"



##
# Termux environment variables Termux rootfs sub scope.
#
# **Do not modify this!** This is considered a constant Termux rootfs
# sub scope for Termux execution environment that's used by external
# programs that do not use the termux packages building infrastructure
# and rely on `$TERMUX_ENV__S_ROOT` environment variable exported by
# Termux app containing the root scope to generate the value for
# `$TERMUX_ENV__S_TERMUX_ROOTFS` and variable names under it.**
#
# Default value: `ROOTFS__`
##
TERMUX_ENV__SS_TERMUX_ROOTFS="ROOTFS__"

##
# Termux environment variables Termux rootfs scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_ROOTFS__`
##
TERMUX_ENV__S_TERMUX_ROOTFS="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_ROOTFS}"



##
# Termux environment variables `termux-core` sub scope.
#
# **Do not modify this!** This is considered a constant `termux-core`
# sub scope for Termux execution environment that's used by external
# programs that do not use the termux packages building infrastructure
# and rely on `$TERMUX_ENV__S_ROOT` environment variable exported by
# Termux app containing the root scope to generate the value for
# `$TERMUX_ENV__S_TERMUX_CORE` and variable names under it.**
#
# Default value: `CORE__`
##
TERMUX_ENV__SS_TERMUX_CORE="CORE__"

##
# Termux environment variables `termux-core` scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_CORE__`
##
TERMUX_ENV__S_TERMUX_CORE="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_CORE}"


##
# Termux environment variables `termux-core-tests` sub scope.
#
# **Do not modify this!** This is considered a constant
# `termux-core-tests` sub scope for Termux execution environment
#  that's used by `termux-core` package to generate the value for
# `$TERMUX_ENV__S_TERMUX_CORE__TESTS` and variable names under it.**
#
# Default value: `TERMUX_CORE__TESTS__`
##
TERMUX_ENV__SS_TERMUX_CORE__TESTS="CORE__TESTS__"

##
# Termux environment variables `termux-core-tests` scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_CORE__TESTS__`
##
TERMUX_ENV__S_TERMUX_CORE__TESTS="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_CORE__TESTS}"



##
# Termux environment variables `termux-exec` sub scope.
#
# **Do not modify this!** This is considered a constant `termux-exec`
# sub scope for Termux execution environment that's used by external
# programs that do not use the termux packages building infrastructure
# and rely on `$TERMUX_ENV__S_ROOT` environment variable exported by
# Termux app containing the root scope to generate the value for
# `$TERMUX_ENV__S_TERMUX_EXEC` and variable names under it.**
#
# Default value: `EXEC__`
##
TERMUX_ENV__SS_TERMUX_EXEC="EXEC__"

##
# Termux environment variables `termux-exec` scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_EXEC__`
##
TERMUX_ENV__S_TERMUX_EXEC="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_EXEC}"


##
# Termux environment variables `termux-exec-tests` sub scope.
#
# **Do not modify this!** This is considered a constant
# `termux-exec-tests` sub scope for Termux execution environment
#  that's used by `termux-exec` package to generate the value for
# `$TERMUX_ENV__S_TERMUX_EXEC__TESTS` and variable names under it.**
#
# Default value: `TERMUX_EXEC__TESTS__`
##
TERMUX_ENV__SS_TERMUX_EXEC__TESTS="EXEC__TESTS__"

##
# Termux environment variables `termux-exec-tests` scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_EXEC__TESTS__`
##
TERMUX_ENV__S_TERMUX_EXEC__TESTS="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_EXEC__TESTS}"



##
# Termux environment variables `termux-am-socket` sub scope.
#
# **Do not modify this!** This is considered a constant `termux-am-socket`
# sub scope for Termux execution environment that's used by external
# programs that do not use the termux packages building infrastructure
# and rely on `$TERMUX_ENV__S_ROOT` environment variable exported by
# Termux app containing the root scope to generate the value for
# `$TERMUX_ENV__S_TERMUX_AM_SOCKET` and variable names under it.**
#
# Default value: `AM_SOCKET__`
##
TERMUX_ENV__SS_TERMUX_AM_SOCKET="AM_SOCKET__"

##
# Termux environment variables `termux-am-socket` scope.
#
# **Do not modify this!**
#
# Default value: `TERMUX_AM_SOCKET__`
##
TERMUX_ENV__S_TERMUX_AM_SOCKET="${TERMUX_ENV__S_ROOT}${TERMUX_ENV__SS_TERMUX_AM_SOCKET}"





####
# Variables for the Termux packages.
#
# - https://github.com/termux/termux-packages
####

##
# Termux packages repo name.
#
# Default value: `termux-packages`
##
TERMUX_PKGS__REPO_NAME="termux-packages"

##
# Termux packages repo url.
#
# Default value: `https://github.com/termux/termux-packages`
##
TERMUX_PKGS__REPO_URL="$TERMUX__REPOS_HOST_ORG_URL/$TERMUX_PKGS__REPO_NAME"





####
# Variables for the Termux app that hosts the packages.
#
# - https://github.com/termux/termux-app
####

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
# Termux app identifier for `TERMUX__APPS_DIR_BY_IDENTIFIER` subdirectory.
#
# Default value: `termux`
# Validation regex: `TERMUX__APPS_APP_IDENTIFIER_REGEX`
# Max length: `TERMUX__APPS_APP_IDENTIFIER___MAX_LEN`
##
TERMUX_APP__APP_IDENTIFIER="termux"



##
# Termux app repo name.
#
# Default value: `termux-app`
##
TERMUX_APP__REPO_NAME="termux-app"

##
# Termux app repo url.
#
# Default value: `https://github.com/termux/termux-app`
##
TERMUX_APP__REPO_URL="$TERMUX__REPOS_HOST_ORG_URL/$TERMUX_APP__REPO_NAME"



##
# Termux app namespace, i.e the Java package name under which Termux
# classes exists used for `TERMUX_APP__*_CLASS__*` and
# `TERMUX_APP__*_(ACTIVITY|RECEIVER|SERVICE)__*` variables.
#
# **See Also:**
# - `TERMUX_APP__PACKAGE_NAME`.
# - https://developer.android.com/build/configure-app-module#set-namespace
# - https://github.com/termux/termux-app/tree/master/app/src/main/java/com/termux
#
# Default value: `com.termux`
##
TERMUX_APP__NAMESPACE="com.termux"

__termux_build_props__add_variables_validator_actions "TERMUX_APP__NAMESPACE" "app_package_name"



##
# Termux app apps directory path under `TERMUX__APPS_DIR_BY_IDENTIFIER`.
#
# Default value: `/data/data/com.termux/termux/app/i/termux`
##
TERMUX_APP__APP_DIR="$TERMUX__APPS_DIR_BY_IDENTIFIER/$TERMUX_APP__APP_IDENTIFIER"
__termux_build_props__add_variables_validator_actions "TERMUX_APP__APP_DIR" "safe_absolute_path"



##
# Termux app shell API `Activity` class name that hosts the
# shell/terminal views.
#
# **See Also:**
# - https://github.com/termux/termux-app/blob/master/app/src/main/java/com/termux/app/TermuxActivity.java
#
# Default value: `com.termux.app.TermuxActivity`
##
TERMUX_APP__SHELL_API__SHELL_API_ACTIVITY__CLASS_NAME="$TERMUX_APP__NAMESPACE.app.TermuxActivity"



##
# Termux app shell API `Service` class name that hosts the
# shell/terminal sessions.
#
# **See Also:**
# - https://github.com/termux/termux-app/blob/master/app/src/main/java/com/termux/app/TermuxService.java
#
# Default value: `com.termux.app.TermuxService`
##
TERMUX_APP__SHELL_API__SHELL_API_SERVICE__CLASS_NAME="$TERMUX_APP__NAMESPACE.app.TermuxService"



##
# Termux app `RUN_COMMAND` API `Service` class name that receives
# commands sent by 3rd party apps via intents.
#
# **See Also:**
# - https://github.com/termux/termux-app/blob/master/app/src/main/java/com/termux/app/RunCommandService.java
# - https://github.com/termux/termux-app/wiki/RUN_COMMAND-Intent
#
# Default value: `com.termux.app.RunCommandService`
##
TERMUX_APP__RUN_COMMAND_API__RUN_COMMAND_API_SERVICE__CLASS_NAME="$TERMUX_APP__NAMESPACE.app.RunCommandService"



##
# Termux app data sender API `BroadcastReceiver` class name that
# receives data view broadcasts and sends the data with `ACTION_SEND`
# and `ACTION_VIEW` intents to other apps, like by `termux-open`.
#
# **See Also:**
# - https://github.com/termux/termux-app/blob/master/app/src/main/java/com/termux/app/TermuxOpenReceiver.java
# - https://github.com/termux/termux-tools/blob/master/scripts/termux-open.in
#
# Default value: `com.termux.app.TermuxOpenReceiver`
##
TERMUX_APP__DATA_SENDER_API__DATA_SENDER_API_RECEIVER__CLASS_NAME="$TERMUX_APP__NAMESPACE.app.TermuxOpenReceiver"





##
# Termux apps info environment file path for the Termux app under `TERMUX_APP__APP_DIR`.
#
# Default value: `/data/data/com.termux/termux/app/i/termux/termux-apps-info.env`
##
TERMUX_APP__CORE__APPS_INFO_ENV_FILE="$TERMUX_APP__APP_DIR/$TERMUX_CORE__APPS_INFO_ENV_SUBFILE"
__termux_build_props__add_variables_validator_actions "TERMUX_APP__CORE__APPS_INFO_ENV_FILE" "safe_absolute_path"

##
# Termux apps info json file path for the Termux app under `TERMUX_APP__APP_DIR`.
#
# Default value: `/data/data/com.termux/termux/app/i/termux/termux-apps-info.json`
##
TERMUX_APP__CORE__APPS_INFO_JSON_FILE="$TERMUX_APP__APP_DIR/$TERMUX_CORE__APPS_INFO_JSON_SUBFILE"
__termux_build_props__add_variables_validator_actions "TERMUX_APP__CORE__APPS_INFO_JSON_FILE" "safe_absolute_path"

##
# `termux-am-socket` server file path for the Termux app under `TERMUX_APP__APP_DIR`.
#
# Default value: `/data/data/com.termux/termux/app/i/termux/termux-am`
##
TERMUX_APP__AM_SOCKET__SERVER_SOCKET_FILE="$TERMUX_APP__APP_DIR/$TERMUX_AM_SOCKET__SERVER_SOCKET_SUBFILE"
__termux_build_props__add_variables_validator_actions "TERMUX_APP__AM_SOCKET__SERVER_SOCKET_FILE" "safe_absolute_path unix_path_max"





####
# Variables for the Termux:API app that hosts the packages.
#
# - https://github.com/termux/termux-api
####

##
# Termux:API app package name used for
# `TERMUX_API_APP__*_(ACTIVITY|RECEIVER|SERVICE)__*` variables.
#
# **See Also:**
# - `TERMUX_API_APP__NAMESPACE`.
# - https://developer.android.com/build/configure-app-module#set-application-id
# - https://github.com/termux/termux-packages/wiki/Termux-file-system-layout#termux-private-app-data-directory
#
# Default value: `com.termux.api`
##
TERMUX_API_APP__PACKAGE_NAME="com.termux.api"

__termux_build_props__add_variables_validator_actions "TERMUX_API_APP__PACKAGE_NAME" "app_package_name"



##
# Termux:API app name.
#
# Default value: `Termux:API`
##
TERMUX_API_APP__NAME="$TERMUX__NAME:API"

##
# Termux:API app identifier for `TERMUX__APPS_DIR_BY_IDENTIFIER` subdirectory.
#
# Default value: `termuxapi`
# Validation regex: `TERMUX__APPS_APP_IDENTIFIER_REGEX`
# Max length: `TERMUX__APPS_APP_IDENTIFIER___MAX_LEN`
##
TERMUX_API_APP__APP_IDENTIFIER="termuxapi"



##
# Termux:API app repo name.
#
# Default value: `termux-api`
##
TERMUX_API_APP__REPO_NAME="termux-api"

##
# Termux:API app repo url.
#
# Default value: `https://github.com/termux/termux-api`
##
TERMUX_API_APP__REPO_URL="$TERMUX__REPOS_HOST_ORG_URL/$TERMUX_API_APP__REPO_NAME"



##
# Termux:API app namespace, i.e the Java package name under which
# Termux:API classes exists used for `TERMUX_API_APP__*_CLASS__*` and
# `TERMUX_API_APP__*_(ACTIVITY|RECEIVER|SERVICE)__*` variables.
#
# **See Also:**
# - `TERMUX_API_APP__PACKAGE_NAME`.
# - https://developer.android.com/build/configure-app-module#set-namespace
# - https://github.com/termux/termux-api/tree/master/app/src/main/java/com/termux/api
#
# Default value: `com.termux.api`
##
TERMUX_API_APP__NAMESPACE="com.termux.api"

__termux_build_props__add_variables_validator_actions "TERMUX_API_APP__NAMESPACE" "app_package_name"



##
# Termux:API app apps directory path under `TERMUX__APPS_DIR_BY_IDENTIFIER`.
#
# Default value: `/data/data/com.termux/termux/app/i/termuxapi`
##
TERMUX_API_APP__APP_DIR="$TERMUX__APPS_DIR_BY_IDENTIFIER/$TERMUX_API_APP__APP_IDENTIFIER"
__termux_build_props__add_variables_validator_actions "TERMUX_API_APP__APP_DIR" "safe_absolute_path"



##
# Termux:API app Android API `BroadcastReceiver` class name that
# receives and processes API requests from command line via `termux-api`
# native exec entry point.
#
# **See Also:**
# - https://github.com/termux/termux-api/blob/master/app/src/main/java/com/termux/api/TermuxApiReceiver.java
# - https://github.com/termux/termux-api-package/blob/master/termux-api.c
#
# Default value: `com.termux.api.TermuxApiReceiver`
##
TERMUX_API_APP__ANDROID_API__ANDROID_API_RECEIVER__CLASS_NAME="$TERMUX_API_APP__NAMESPACE.TermuxApiReceiver"





####
# Variables for the `termux-api` package.
#
# - https://github.com/termux/termux-api-package
####

##
# The `termux-api` package repo name.
#
# Default value: `termux-api-package`
##
TERMUX_API_PKG__REPO_NAME="termux-api-package"

##
# The `termux-api` package repo url.
#
# Default value: `https://github.com/termux/termux-api-package`
##
TERMUX_API_PKG__REPO_URL="$TERMUX__REPOS_HOST_ORG_URL/$TERMUX_API_PKG__REPO_NAME"










####
# Variables for the `termux-core` package.
#
# - https://github.com/termux/termux-core-package
####

##
# The `termux-core` package repo name.
#
# Default value: `termux-core-package`
##
TERMUX_CORE_PKG__REPO_NAME="termux-core-package"

##
# The `termux-core` package repo url.
#
# Default value: `https://github.com/termux/termux-core-package`
##
TERMUX_CORE_PKG__REPO_URL="$TERMUX__REPOS_HOST_ORG_URL/$TERMUX_CORE_PKG__REPO_NAME"





####
# Variables for the `termux-am` package.
#
# - https://github.com/termux/TermuxAm
####

##
# The `termux-am` package repo name.
#
# Default value: `TermuxAm`
##
TERMUX_AM_PKG__REPO_NAME="TermuxAm"

##
# The `termux-am` package repo url.
#
# Default value: `https://github.com/termux/TermuxAm`
##
TERMUX_AM_PKG__REPO_URL="$TERMUX__REPOS_HOST_ORG_URL/$TERMUX_AM_PKG__REPO_NAME"



##
# TermuxAm namespace, i.e the Java package name under which Termux
# classes exists used for `TERMUX_AM__*_CLASS__*` variables.
#
# This must not be changed unless the classes in the `TermuxAm` repo
# are moved to a different Java package name (in forks).
#
# **See Also:**
# - https://developer.android.com/build/configure-app-module#set-namespace
# - https://github.com/termux/TermuxAm/tree/master/app/src/main/java/com/termux/termuxam
#
# Constant value: `com.termux.termuxam`
##
TERMUX_AM_APP__NAMESPACE="com.termux.termuxam"

__termux_build_props__add_variables_validator_actions "TERMUX_AM_APP__NAMESPACE" "app_package_name"



##
# TermuxAm main class that is passed as `start-class-name` to
# `/system/bin/app_process` when running `am.apk` set in `$CLASSPATH`.
#
# - https://github.com/termux/TermuxAm/blob/master/app/src/main/java/com/termux/termuxam/Am.java
# - https://github.com/termux/TermuxAm/blob/v0.8.0/am-libexec-packaged#L30
# - https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:frameworks/base/cmds/app_process/app_main.cpp;l=31
#
# Default value: `com.termux.termuxam.Am`
##
TERMUX_AM_APP__AM_CLASS__CLASS_NAME="$TERMUX_AM_APP__NAMESPACE.Am"





###
# Variables for the Termux package repositories.
###

# The core variable values for which the packages hosted on the
# package repos defined in `repo.json` are compiled for.
# If a custom repo is not being hosted, and official Termux repos are
# still defined in `repo.json`, then DO NOT change these values. If a
# custom repo is being hosted whose variable values equal
# `TERMUX_APP__PACKAGE_NAME`, `TERMUX_APP__DATA_DIR`,
# `TERMUX__CORE_DIR`, `TERMUX__APPS_DIR`, `TERMUX__ROOTFS`,
# `TERMUX__HOME`, and `TERMUX__PREFIX` values defined above, then
# update these values respectively to the same values.
# These values are used for the `-i/-I` flags to `build-package.sh`,
# and if respective values do not match, then those flags are ignored
# and dependency packages are not downloaded from the package repos
# and are compiled locally.
# FIXME: Checking for all variables will be added later in repo
# changes pull, currently only `TERMUX_REPO_APP__PACKAGE_NAME` is checked.
TERMUX_REPO_APP__PACKAGE_NAME="com.termux"
TERMUX_REPO_APP__DATA_DIR="/data/data/com.termux"
TERMUX_REPO__CORE_DIR="/data/data/com.termux/termux/core"
TERMUX_REPO__APPS_DIR="/data/data/com.termux/termux/app"
TERMUX_REPO__ROOTFS="/data/data/com.termux/files"
TERMUX_REPO__HOME="/data/data/com.termux/files/home"
TERMUX_REPO__PREFIX="/data/data/com.termux/files/usr"



####
# Variables loaded from `repo.json` file for Termux package repositories.
####

TERMUX_REPO_URL=()
TERMUX_REPO_DISTRIBUTION=()
TERMUX_REPO_COMPONENT=()

# FIXME: Move `repo.json` file to under `scripts/` directory and COPY it to `/tmp/termux-packages` in `Dockerfile`.
if [[ ! -f "$TERMUX_PKGS__BUILD__REPO_ROOT_DIR/repo.json" ]]; then
    if [[ "${TERMUX_PKGS__BUILD__IS_DOCKER_BUILD:-}" != "true" ]]; then
        echo "The 'repo.json' file not found at the '$TERMUX_PKGS__BUILD__REPO_ROOT_DIR/repo.json' path." 1>&2
        exit 1
    fi
else
    export TERMUX_PACKAGES_DIRECTORIES
    TERMUX_PACKAGES_DIRECTORIES=$(jq --raw-output 'del(.pkg_format) | keys | .[]' "$TERMUX_PKGS__BUILD__REPO_ROOT_DIR/repo.json")

    for url in $(jq -r 'del(.pkg_format) | .[] | .url' "$TERMUX_PKGS__BUILD__REPO_ROOT_DIR/repo.json"); do
        TERMUX_REPO_URL+=("$url")
    done
    for distribution in $(jq -r 'del(.pkg_format) | .[] | .distribution' "$TERMUX_PKGS__BUILD__REPO_ROOT_DIR/repo.json"); do
        TERMUX_REPO_DISTRIBUTION+=("$distribution")
    done
    for component in $(jq -r 'del(.pkg_format) | .[] | .component' "$TERMUX_PKGS__BUILD__REPO_ROOT_DIR/repo.json"); do
        TERMUX_REPO_COMPONENT+=("$component")
    done
fi





###
# Misc
###

TERMUX_CLEANUP_BUILT_PACKAGES_THRESHOLD="$(( 5 * 1024 ** 3 ))" # 5 GiB
__termux_build_props__add_variables_validator_actions "TERMUX_CLEANUP_BUILT_PACKAGES_THRESHOLD" "unsigned_int"

# Path to CGCT tools
CGCT_DEFAULT_PREFIX="/data/data/com.termux/files/usr/glibc"
__termux_build_props__add_variables_validator_actions "CGCT_DEFAULT_PREFIX" "safe_absolute_path invalid_termux_prefix_paths"

export CGCT_DIR="/data/data/com.termux/cgct"
__termux_build_props__add_variables_validator_actions "CGCT_DIR" "safe_absolute_path invalid_termux_prefix_paths"

# Allow to override setup.
for f in "${HOME}/.config/termux/termuxrc.sh" "${HOME}/.termux/termuxrc.sh" "${HOME}/.termuxrc"; do
    if [ -f "$f" ]; then
        echo "Using builder configuration from '$f'..."
        # shellcheck source=/dev/null
        . "$f"
        break
    fi
done
unset f





###
# Run Termux properties variable values validation.
###

# Uncomment to print `TERMUX_` variables set
#compgen -v TERMUX_ | while read v; do echo "${v}=${!v}"; done

##
# `__termux_build_props__validate_variables`
##
__termux_build_props__validate_variables() {

    local is_value_defined
    local validator_action
    local validator_actions
    local variable_name
    local variable_value

    if [[ ! "$TERMUX__INTERNAL_NAME" =~ ${TERMUX__INTERNAL_NAME_REGEX:?} ]]; then
        echo "The TERMUX__INTERNAL_NAME '$TERMUX__INTERNAL_NAME' with length ${#TERMUX__INTERNAL_NAME} is invalid." 1>&2
        echo "Check 'TERMUX__INTERNAL_NAME_REGEX' variable docs for info on what is a valid internal name." 1>&2
        return 1
    fi

    if [ "${#TERMUX__INTERNAL_NAME}" -gt ${TERMUX__INTERNAL_NAME___MAX_LEN:?} ]; then
        echo "The TERMUX__INTERNAL_NAME '$TERMUX__INTERNAL_NAME' with length ${#TERMUX__INTERNAL_NAME} is invalid." 1>&2
        echo "The TERMUX__INTERNAL_NAME must have max length \`<= TERMUX__INTERNAL_NAME___MAX_LEN ($TERMUX__INTERNAL_NAME___MAX_LEN)\`." 1>&2
        return 1
    fi

    if [[ ! "$TERMUX_APP__DATA_DIR" =~ ${TERMUX_REGEX__APP_DATA_DIR_PATH:?} ]]; then
        echo "The TERMUX_APP__DATA_DIR '$TERMUX_APP__DATA_DIR' with length ${#TERMUX_APP__DATA_DIR} is invalid." 1>&2
        echo "The TERMUX_APP__DATA_DIR must match \`/data/data/<package_name>\`, \`/data/user/<user_id>/<package_name>\` \
or \`/mnt/expand/<volume_uuid>/user/<user_id>/<package_name>\` formats." 1>&2
        return 1
    fi


    for variable_name in "${__TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_VARIABLE_NAMES[@]}"; do
        if [[ ! "$variable_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            echo "The variable_name '$variable_name' in Termux properties variables validator actions is not a valid shell variable name." 1>&2
            return 1
        fi

        variable_value="${!variable_name:-}"
        validator_actions="${__TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_MAP["$variable_name"]}"
        [[ -z "$validator_actions" ]] && continue

        if [[ -n "$variable_value" ]]; then
            :
        else
            is_value_defined=0
            eval '[ -n "${'"$variable_name"'+x}" ] && is_value_defined=1'

            # If not defined.
            if [[ "$is_value_defined" = "0" ]]; then
                echo "The variable_name '$variable_name' in Termux properties variables validator actions is not defined." 1>&2
                return 1
            fi

            # If defined but unset.
            [[ " ${validator_actions[*]} " == *" allow_unset_value "* ]] && continue

            echo "The Termux properties variable value for variable name '$variable_name' is not set." 1>&2
            return 1
        fi

        for validator_action in $validator_actions; do
            case "$validator_action" in
                allow_unset_value)
                    :
                    ;;
                app_package_name)
                    if [[ ! "$variable_value" =~ ${TERMUX_REGEX__APP_PACKAGE_NAME:?} ]] || \
                            [ "${#variable_value}" -gt "${TERMUX__NAME_MAX:?}" ]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must be a valid android app package name with \
max length \`<= TERMUX__NAME_MAX ($TERMUX__NAME_MAX)\`." 1>&2
                        echo "- https://developer.android.com/build/configure-app-module#set-application-id" 1>&2
                        return 1
                    fi
                    ;;
                invalid_termux_rootfs_paths)
                    if [[ "$variable_value" =~ ${TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS:?} ]]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must not match one of the invalid paths \
in TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS \`$TERMUX_REGEX__INVALID_TERMUX_ROOTFS_PATHS\`." 1>&2
                        return 1
                    fi
                    ;;
                invalid_termux_home_paths)
                    if [[ "$variable_value" =~ ${TERMUX_REGEX__INVALID_TERMUX_HOME_PATHS:?} ]]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must not match one of the invalid paths \
in TERMUX_REGEX__INVALID_TERMUX_HOME_PATHS \`$TERMUX_REGEX__INVALID_TERMUX_HOME_PATHS\`." 1>&2
                        return 1
                    fi
                    ;;
                invalid_termux_prefix_paths)
                    if [[ "$variable_value" =~ ${TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS:?} ]]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must not match one of the invalid paths \
in TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS \`$TERMUX_REGEX__INVALID_TERMUX_PREFIX_PATHS\`." 1>&2
                        return 1
                    fi
                    ;;
                path_equal_to_or_under_termux_rootfs)
                    if [[ "$variable_value" != "${TERMUX__ROOTFS:?}" ]] && \
                            {
                                { [[ "${TERMUX__ROOTFS:?}" != "/" ]] && [[ "$variable_value" != "${TERMUX__ROOTFS}/"* ]]; } || \
                                { [[ "${TERMUX__ROOTFS:?}" == "/" ]] && [[ "$variable_value" != "/"* ]]; };
                            }; then
                        echo "The $variable_name '$variable_value' is invalid." 1>&2
                        echo "The $variable_name must be equal to or be under TERMUX__ROOTFS \`$TERMUX__ROOTFS\`." 1>&2
                        return 1
                    fi
                    ;;
                path_under_termux_rootfs)
                    if { [[ "${TERMUX__ROOTFS:?}" != "/" ]] && [[ "$variable_value" != "${TERMUX__ROOTFS}/"* ]]; } || \
                        { [[ "${TERMUX__ROOTFS:?}" == "/" ]] && [[ "$variable_value" != "/"* ]]; }; then
                        echo "The $variable_name '$variable_value' is invalid." 1>&2
                        echo "The $variable_name must be under TERMUX__ROOTFS \`$TERMUX__ROOTFS\`." 1>&2
                        return 1
                    fi
                    ;;
                safe_absolute_path)
                    if [[ ! "$variable_value" =~ ${TERMUX_REGEX__SAFE_ABSOLUTE_PATH:?} ]] || \
                            [[ "$variable_value" =~ ${TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH:?} ]]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must match a safe absolute path that starts with a \`/\` with at least one \
characters under rootfs \`/\`. Duplicate or trailing path separators \`/\` are not allowed. \
The path component characters must be in the range \`[a-zA-Z0-9+,.=_-]\`. The path must not contain single \`/./\` or \
double \`/../\` dot components." 1>&2
                        return 1
                    fi
                    ;;
                safe_relative_path)
                    if [[ ! "$variable_value" =~ ${TERMUX_REGEX__SAFE_RELATIVE_PATH:?} ]] || \
                            [[ "$variable_value" =~ ${TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH:?} ]]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must match a safe relative path that does not start with a \`/\`. \
Duplicate or trailing path separators \`/\` are not allowed. The path component characters must be in the \
range \`[a-zA-Z0-9+,.=_-]\`. The path must not contain single \`/./\` or double \`/../\` dot components." 1>&2
                        return 1
                    fi
                    ;;
                safe_rootfs_or_absolute_path)
                    if [[ ! "$variable_value" =~ ${TERMUX_REGEX__SAFE_ROOTFS_OR_ABSOLUTE_PATH:?} ]] || \
                            [[ "$variable_value" =~ ${TERMUX_REGEX__SINGLE_OR_DOUBLE_DOT_CONTAINING_PATH:?} ]]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must match (rootfs \`/\`) or (a safe absolute path that starts with a \`/\`). \
Duplicate or trailing path separators \`/\` are not allowed. The path component characters must be in the \
range \`[a-zA-Z0-9+,.=_-]\`. The path must not contain single \`/./\` or double \`/../\` dot components." 1>&2
                        return 1
                    fi
                    ;;
                apps_api_socket__server_parent_dir)
                    if [[ "${#variable_value}" -ge "${TERMUX__APPS_API_SOCKET__SERVER_PARENT_DIR___MAX_LEN:?}" ]]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must have max length \`<= TERMUX__APPS_API_SOCKET__SERVER_PARENT_DIR___MAX_LEN \
($TERMUX__APPS_API_SOCKET__SERVER_PARENT_DIR___MAX_LEN)\` including the null \`\0\` terminator." 1>&2
                        return 1
                    fi
                    ;;
                unix_path_max)
                    if [[ "${#variable_value}" -ge "${TERMUX__UNIX_PATH_MAX:?}" ]]; then
                        echo "The $variable_name '$variable_value' with length ${#variable_value} is invalid." 1>&2
                        echo "The $variable_name must have max length \`<= TERMUX__UNIX_PATH_MAX ($TERMUX__UNIX_PATH_MAX)\` \
including the null \`\0\` terminator." 1>&2
                        return 1
                    fi
                    ;;
                unsigned_int)
                    if [[ ! "$variable_value" =~ ${TERMUX_REGEX__UNSIGNED_INT:?} ]]; then
                        echo "The $variable_name '$variable_value' is invalid." 1>&2
                        echo "The $variable_name must be an unsigned integer \`>= 0\`." 1>&2
                        return 1
                    fi
                    ;;
                *)
                    echo "The Termux properties variables validator action '$validator_action' for \
variable name '$variable_name' is invalid." 1>&2
                    return 1
                    ;;
            esac
        done
    done


    if [[ "$__TERMUX_BUILD_PROPS__VALIDATE_PATHS_MAX_LEN" == "true" ]] && \
            [ "${#TERMUX_APP__DATA_DIR}" -ge ${TERMUX_APP__DATA_DIR___MAX_LEN:?} ]; then
        echo "The TERMUX_APP__DATA_DIR '$TERMUX_APP__DATA_DIR' with length ${#TERMUX_APP__DATA_DIR} is invalid." 1>&2
        echo "The TERMUX_APP__DATA_DIR must have max length \`<= TERMUX_APP__DATA_DIR___MAX_LEN ($TERMUX_APP__DATA_DIR___MAX_LEN)\` \
including the null \`\0\` terminator." 1>&2
        return 1
    fi

    if [[ "$__TERMUX_BUILD_PROPS__VALIDATE_PATHS_MAX_LEN" == "true" ]] && \
            [ "${#TERMUX__APPS_DIR}" -ge ${TERMUX__APPS_DIR___MAX_LEN:?} ]; then
        echo "The TERMUX__APPS_DIR '$TERMUX__APPS_DIR' with length ${#TERMUX__APPS_DIR} is invalid." 1>&2
        echo "The TERMUX__APPS_DIR must have max length \`<= TERMUX__APPS_DIR___MAX_LEN ($TERMUX__APPS_DIR___MAX_LEN)\` \
including the null \`\0\` terminator." 1>&2
        return 1
    fi


    if [[ ! "$TERMUX_APP__APP_IDENTIFIER" =~ ${TERMUX__APPS_APP_IDENTIFIER_REGEX:?} ]]; then
        echo "The TERMUX_APP__APP_IDENTIFIER '$TERMUX_APP__APP_IDENTIFIER' with length ${#TERMUX_APP__APP_IDENTIFIER} is invalid." 1>&2
        echo "Check 'TERMUX__APPS_APP_IDENTIFIER_REGEX' variable docs for info on what is a valid app identifier." 1>&2
        return 1
    fi

    if [[ "$__TERMUX_BUILD_PROPS__VALIDATE_PATHS_MAX_LEN" == "true" ]] && \
            [ "${#TERMUX_APP__APP_IDENTIFIER}" -gt ${TERMUX__APPS_APP_IDENTIFIER___MAX_LEN:?} ]; then
        echo "The TERMUX_APP__APP_IDENTIFIER '$TERMUX_APP__APP_IDENTIFIER' with length ${#TERMUX_APP__APP_IDENTIFIER} is invalid." 1>&2
        echo "The TERMUX_APP__APP_IDENTIFIER must have max length \
\`<= TERMUX__APPS_APP_IDENTIFIER___MAX_LEN ($TERMUX__APPS_APP_IDENTIFIER___MAX_LEN)\`." 1>&2
        return 1
    fi


    if [[ "$__TERMUX_BUILD_PROPS__VALIDATE_PATHS_MAX_LEN" == "true" ]] && \
            [ "${#TERMUX__ROOTFS}" -ge ${TERMUX__ROOTFS_DIR___MAX_LEN:?} ]; then
        echo "The TERMUX__ROOTFS '$TERMUX__ROOTFS' with length ${#TERMUX__ROOTFS} is invalid." 1>&2
        echo "The TERMUX__ROOTFS must have max length \`<= TERMUX__ROOTFS_DIR___MAX_LEN ($TERMUX__ROOTFS_DIR___MAX_LEN)\` \
including the null \`\0\` terminator." 1>&2
        return 1
    fi

    if [[ "$__TERMUX_BUILD_PROPS__VALIDATE_PATHS_MAX_LEN" == "true" ]] && \
            [ "${#TERMUX__PREFIX}" -ge ${TERMUX__PREFIX_DIR___MAX_LEN:?} ]; then
        echo "The TERMUX__PREFIX '$TERMUX__PREFIX' with length ${#TERMUX__PREFIX} is invalid." 1>&2
        echo "The TERMUX__PREFIX must have max length \`<= TERMUX__PREFIX_DIR___MAX_LEN ($TERMUX__PREFIX_DIR___MAX_LEN)\` \
including the null \`\0\` terminator." 1>&2
        return 1
    fi

    if [[ "$__TERMUX_BUILD_PROPS__VALIDATE_PATHS_MAX_LEN" == "true" ]] && \
            [ "${#TERMUX__PREFIX__TMP_DIR}" -ge ${TERMUX__PREFIX__TMP_DIR___MAX_LEN:?} ]; then
        echo "The TERMUX__PREFIX__TMP_DIR '$TERMUX__PREFIX__TMP_DIR' with length ${#TERMUX__PREFIX__TMP_DIR} is invalid." 1>&2
        echo "The TERMUX__PREFIX__TMP_DIR must have max length \`<= TERMUX__PREFIX__TMP_DIR___MAX_LEN ($TERMUX__PREFIX__TMP_DIR___MAX_LEN)\` \
including the null \`\0\` terminator." 1>&2
        return 1
    fi


    if [[ "$TERMUX__ROOTFS" != "/" ]] && \
            [[ "$__TERMUX_BUILD_PROPS__VALIDATE_TERMUX_PREFIX_USR_MERGE_FORMAT" == "true" ]]; then
        if [[ "$TERMUX__PREFIX" != "$TERMUX__ROOTFS/usr" ]]; then
            echo "The TERMUX__PREFIX '$TERMUX__PREFIX' is invalid." 1>&2
            echo "The TERMUX__PREFIX must be equal to '\$TERMUX__ROOTFS/usr' ($TERMUX__ROOTFS/usr) as per 'usr' merge format." 1>&2
            return 1
        fi

        if [[ "${TERMUX__PREFIX:?}" == "${TERMUX__HOME:?}" ]] || \
                [[ "$TERMUX__PREFIX" == "$TERMUX__HOME/"* ]] || \
                [[ "$TERMUX__HOME" == "$TERMUX__PREFIX/"* ]]; then
            echo "The TERMUX__PREFIX '$TERMUX__PREFIX' or TERMUX__HOME '$TERMUX__HOME' is invalid." 1>&2
            echo "The TERMUX__PREFIX must not be equal to TERMUX__HOME and they must not be under each other as per 'usr' merge format." 1>&2
            return 1
        fi
    else
        if [[ "${TERMUX__PREFIX:?}" == "${TERMUX__HOME:?}" ]] || \
                [[ "$TERMUX__PREFIX" == "$TERMUX__HOME/"* ]]; then
            echo "The TERMUX__PREFIX '$TERMUX__PREFIX' or TERMUX__HOME '$TERMUX__HOME' is invalid." 1>&2
            echo "The TERMUX__PREFIX must not be equal to or be under TERMUX__HOME." 1>&2
            return 1
        fi
    fi

    if [[ "${TERMUX__PREFIX:?}" == "${CGCT_DIR:?}" ]] || \
            [[ "$TERMUX__PREFIX" == "$CGCT_DIR/"* ]] || \
            [[ "$CGCT_DIR" == "$TERMUX__PREFIX/"* ]]; then
        echo "The TERMUX__PREFIX '$TERMUX__PREFIX' or CGCT_DIR '$CGCT_DIR' is invalid." 1>&2
        echo "The TERMUX__PREFIX must not be equal to CGCT_DIR and they must not be under each other." 1>&2
        return 1
    fi

    if [[ "$TERMUX__PREFIX" != "$TERMUX_PREFIX_CLASSICAL" ]]; then
        echo "The TERMUX__PREFIX '$TERMUX__PREFIX' or TERMUX_PREFIX_CLASSICAL '$TERMUX_PREFIX_CLASSICAL' is invalid." 1>&2
        echo "The TERMUX__PREFIX must be equal to TERMUX_PREFIX_CLASSICAL." 1>&2
        return 1
    fi

    if [[ "$TERMUX__PREFIX" == "$TERMUX__PREFIX_GLIBC" ]]; then
        echo "The TERMUX__PREFIX '$TERMUX__PREFIX' or TERMUX__PREFIX_GLIBC '$TERMUX__PREFIX_GLIBC' is invalid." 1>&2
        echo "The TERMUX__PREFIX must not be equal to TERMUX__PREFIX_GLIBC." 1>&2
        return 1
    fi

    if [[ "$TERMUX__PREFIX__BASE_LIB_DIR" == "$TERMUX__PREFIX__MULTI_LIB_DIR" ]]; then
        echo "The TERMUX__PREFIX__BASE_LIB_DIR '$TERMUX__PREFIX__BASE_LIB_DIR' or TERMUX__PREFIX__MULTI_LIB_DIR '$TERMUX__PREFIX__MULTI_LIB_DIR' is invalid." 1>&2
        echo "The TERMUX__PREFIX__BASE_LIB_DIR must not be equal to TERMUX__PREFIX__MULTI_LIB_DIR." 1>&2
        return 1
    fi

    if [[ "$TERMUX__PREFIX__BASE_INCLUDE_DIR" == "$TERMUX__PREFIX__MULTI_INCLUDE_DIR" ]]; then
        echo "The TERMUX__PREFIX__BASE_INCLUDE_DIR '$TERMUX__PREFIX__BASE_INCLUDE_DIR' or TERMUX__PREFIX__MULTI_INCLUDE_DIR '$TERMUX__PREFIX__MULTI_INCLUDE_DIR' is invalid." 1>&2
        echo "The TERMUX__PREFIX__BASE_INCLUDE_DIR must not be equal to TERMUX__PREFIX__MULTI_INCLUDE_DIR." 1>&2
        return 1
    fi

}

__termux_build_props__validate_variables || exit $?

unset __TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_MAP
unset __TERMUX_BUILD_PROPS__VARIABLES_VALIDATOR_ACTIONS_VARIABLE_NAMES
unset __TERMUX_BUILD_PROPS__VALIDATE_PATHS_MAX_LEN
unset __TERMUX_BUILD_PROPS__VALIDATE_TERMUX_PREFIX_USR_MERGE_FORMAT
unset __termux_build_props__add_variables_validator_actions
unset __termux_build_props__validate_variables
