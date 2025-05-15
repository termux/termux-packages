# shellcheck shell=bash

# Title:          repo.sh
# Description:    The file to set variables for Termux packages repositories.

# XXX: This file is sourced by repology-updater script.
# So avoid doing things like executing commands except of those available in
# coreutils and are clearly not a default part of most Linux installations,
# or sourcing any other script in our build directories.

if [ -z "${BASH_VERSION:-}" ]; then
    echo "repo.sh file must be sourced from a bash shell." 1>&2
    exit 1
fi

__TERMUX_REPO__REPO_ROOT_DIR="$(readlink -f -- "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")/..")" || exit $?

###
# The `repo.json` file must be in the following format.
#
# ```
# {
#     "repo__package_manager": "<value>",
#     "channels": {
#         "<repo_channel_dir_1>": {
#             "name": "<value>"
#             "distribution": "<value>"
#             "component": "<value>"
#             "url": "<value>"
#             "signing_key_names": [ "<signing_key_1>" ]
#         },
#         "<repo_channel_dir_2>": {
#             ...
#         },
#         ...
#     },
#     "signing_keys": {
#         "<signing_key_1>": {
#             "key_file": "<path/to/key_file>"
#         },
#         "<signing_key_2>": {
#             ...
#         },
#         ...
#    },
#    "package_build_variables": {
#        "<variable_name_1>": "<value>"
#        "<variable_name_2>": "<value>"
#        ...
#    }
# }
# ```
#
#
# The `repo__package_manager` string key in the top level object
# of the `repo.json` file is for the package manager for the repo.
# Valid values are defined by `TERMUX__SUPPORTED_PACKAGE_MANAGERS`.
# If not set, then it defaults to `apt`.
#
#
# The following rules apply for `channels` object in the top level
# object of the `repo.json` file.
# - The `channels` object must be set and must at least contain one
#   channel.
# - Each sub key of the `channels` object must be an object where the
#   key name is for the relative path to the repo channel directory
#   under the `termux-packages` repo root directory where package
#   directories exist for the channel.
#   Since the path is required to be relative, the `termux-packages`
#   repo root directory will be prepended to it at runtime when required.
#   The repo channel directory value must match the regex
#   `^[a-zA-Z0-9._-]+(/[a-zA-Z0-9._-]+)*$` and the directory must exist.
# - The `name` string sub key of the repo channel object is
#   for the repo channel name. The value must be set and must equal
#   the regex `^[a-zA-Z0-9._-]+$`.
# - The `url` string sub key of the repo channel object is
#   for the repo channel url. If it is set, then it must equal the
#   regex `^https?://.+$`. It can optionally not be set if no
#   repositories are currently hosted and all packages and
#   dependencies must be compiled locally.
# - The `distribution` string sub key of the repo channel
#   object is for the repo channel distribution. The value must be set
#   if `url` key is set and must equal the regex `^[a-zA-Z0-9._-]+$`.
# - The `component` string sub key of the repo channel
#   object is for the repo channel component. The value must be set
#   if `url` key is set and must equal the regex `^[a-zA-Z0-9._-]+$`.
# - The `signing_key_names` array sub key of the repo channel
#   object is for the list of repo channel signing key, where the
#   values are key names set for the keys in the `signing_keys` object
#   in the top level object of the `repo.json` file. At least one key
#   name must be defined in the list if `url` key is set.
#
#
# The following rules apply for `signing_keys` object in the top level
# object of the `repo.json` file.
# - The `signing_keys` object must be set if any channel in `channels`
#   object has the `url` key set, in which case it must contain
#   signing keys config for each repo channel whose `url` key is set.
#   If no channel has the `url` key set, then it can be removed or
#   set to an empty object like `"signing_keys": {}` as it will not be
#   read.
#   The signing keys are used to verify the signature of repo channels
#   metadata files.
#   - For `apt` repos, the keys are used to verify the `Release` and
#   `Release.gpg`. files.
#     - https://wiki.debian.org/DebianRepository/Format
#     - https://wiki.debian.org/SecureApt#How_apt_uses_Release.gpg
#   - For `pacman` repos, the keys are used to verify the `json` and
#     `*.json.sig` files.
# - Each sub key of the `signing_keys` object must be an object where
#   the key name is a unique name for the signing key config.
#   The signing key name value must match the regex `^[a-zA-Z0-9._-]+$`.
# - The `key_file` sub key of the signing key object is for the
#   relative path to signing key file under the `termux-packages` repo
#   root directory.
#   Since the path is required to be relative, the `termux-packages`
#   repo root directory will be prepended to it at runtime when
#   required.
# - An object is being used for signing key object because other keys
#   may be required in future in addition to current `key_file` key,
#   like `key_format`, etc.
###




TERMUX_REPO__PACKAGE_MANAGER=
TERMUX_REPO__PACKAGE_FORMAT=

###
# Variables for Termux packages repository channels.
#
# There are two groups of sibling arrays
#
# DO NOT USE `${array[*]}` expansion like in for loops as some array
# items for distribution, components and urls array may be set to
# empty values and so will give wrong index in loop if referencing a
# sibling array with the same index. Always use `"${array[@]}"` expansion.
###

unset TERMUX_REPO__CHANNEL_DIRS; declare -a TERMUX_REPO__CHANNEL_DIRS=()
unset TERMUX_REPO__CHANNEL_NAMES; declare -a TERMUX_REPO__CHANNEL_NAMES=()
unset TERMUX_REPO__CHANNEL_DISTRIBUTIONS; declare -a TERMUX_REPO__CHANNEL_DISTRIBUTIONS=()
unset TERMUX_REPO__CHANNEL_COMPONENTS; declare -a TERMUX_REPO__CHANNEL_COMPONENTS=()
unset TERMUX_REPO__CHANNEL_URLS; declare -a TERMUX_REPO__CHANNEL_URLS=()

unset TERMUX_REPO__DISABLED_CHANNEL_DIRS; declare -a TERMUX_REPO__DISABLED_CHANNEL_DIRS=()
unset TERMUX_REPO__DISABLED_CHANNEL_NAMES; declare -a TERMUX_REPO__DISABLED_CHANNEL_NAMES=()

##
# The bool variable for whether if at least one repo channel in
# `repo.json` file has its repo url set. If this is `false`, like in
# case packages repository is not hosted with packages built for
# current package build variables defined in `package_build_variables` as
# per `TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP`, then
# all packages and its dependencies are always built locally.
#
# See also `termux_repository__are_packages_in_packages_repos_usable_for_building()`.
##
TERMUX_REPO__CHANNELS_URL_SET=



###
# Variables read from the `package_build_variables` json object of
# the `repo.json` file which define the values for which the packages
# hosted in the Termux package repositories are built for.
#
# - If a custom packages repos are being hosted for ALL repo channels
#   in the `repo.json` file, then all packages hosted there must be
#   built with the same values defined in `properties.sh` file for
#   the package build variables defined in
#   `TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP`.
#   The json keys for the package build variables under the
#   `package_build_variables` json object in the `repo.json` file
#   should be updated with the same values as in the `properties.sh`
#   file that would normally be generated at runtime. The json keys
#   are read into the below variables under the `TERMUX_REPO_`
#   variable scope at runtime. Additionally, the `channels` and
#   `signing_keys` json objects in the `repo.json` file
#   should be updated with the values for the hosted repo channels.
#   The build variables specified in
#   `TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP` are used for the
#   `-i/-I` flags passed to `build-package.sh`, and if respective
#   values in the `properties.sh` and `repo.json` files do not match,
#   then those flags are ignored and dependency packages are not
#   downloaded from the package repos and are built locally instead.
# - If custom packages repos are not being hosted for ALL repo
#   `channels` in the `repo.json` file, then DO NOT CHANGE ANY VALUE
#   defined in the `repo.json` for the default Termux repos as it
#   will be checked during build time if package build variables in
#   `repo.json` and `properties.sh` do not match and downloading of
#   dependencies will automatically be skipped. However, you can
#   remove the `url` keys of ALL default repo channels under the
#   `channels` object and remove the `signing_keys` object, so that if
#   `-i/-I` flags are passed to `build-package.sh`, then the message
#   that `package build variables for which packages hosted in the
#   packages repos were built for do not match the current package
#   build variables in the 'properties.sh' file` is not logged, as
#   checking will not be if no repo channel in `repo.json` file has
#   its repo url set as per `TERMUX_REPO__CHANNELS_URL_SET` and in
#   that case a different message that `none of the repo channels in
#   'repo.json' file have a repo url set` will be logged.
#
# See also `termux_repository__are_packages_in_packages_repos_usable_for_building()`.
###

# FIXME: Sync with TermuxRootfsFilesystem and add TERMUX__CACHE_DIR and rename to TERMUX__ROOTFS_DIR
unset TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP; declare -A TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP
##
# The package build variables mapping for `properties.sh` -> `repo.sh`
# variables.
##
TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP=(
    ["TERMUX_APP__PACKAGE_NAME"]="TERMUX_REPO_APP__PACKAGE_NAME"
    ["TERMUX_APP__DATA_DIR"]="TERMUX_REPO_APP__DATA_DIR"
    ["TERMUX__PROJECT_DIR"]="TERMUX_REPO__PROJECT_DIR"
    ["TERMUX__CORE_DIR"]="TERMUX_REPO__CORE_DIR"
    ["TERMUX__APPS_DIR"]="TERMUX_REPO__APPS_DIR"
    ["TERMUX__ROOTFS"]="TERMUX_REPO__ROOTFS"
    ["TERMUX__HOME"]="TERMUX_REPO__HOME"
    ["TERMUX__PREFIX"]="TERMUX_REPO__PREFIX"
)

##
# Termux app package name for which packages in the packages repo are
# built for.
##
TERMUX_REPO_APP__PACKAGE_NAME=

##
# Termux app data directory path for which packages in the packages
# repo are built for.
##
TERMUX_REPO_APP__DATA_DIR=

##
# Termux project directory path under `TERMUX_APP__DATA_DIR` for which
# packages in the packages repo are built for.
##
TERMUX_REPO__PROJECT_DIR=

##
# Termux core directory path under `TERMUX__PROJECT_DIR` for which
# packages in the packages repo are built for.
##
TERMUX_REPO__CORE_DIR=

##
# Termux apps directory path under `TERMUX__PROJECT_DIR` for which
# packages in the packages repo are built for.
##
TERMUX_REPO__APPS_DIR=

##
# Termux rootfs directory path under `TERMUX_APP__DATA_DIR` for which
# packages in the packages repo are built for.
##
TERMUX_REPO__ROOTFS=

##
# Termux home directory path under `TERMUX__ROOTFS` for which
# packages in the packages repo are built for.
##
TERMUX_REPO__HOME=

##
# Termux prefix directory path under `TERMUX__ROOTFS` for which
# packages in the packages repo are built for.
##
TERMUX_REPO__PREFIX=




# If `termux_repository` library has not be sourced, like if not being
# FIXME: utils library won't be loaded if only properties.sh is sourced
# FIXME: Move `repo.json` file to under `scripts/` directory and COPY it to `/tmp/termux-packages` in `Dockerfile`.
if ! declare -F "termux_repository__set_repo_variables_from_repo_json_file" > /dev/null; then
    # Source the utils library.
    # shellcheck source=scripts/utils/utils.sh
    source "$__TERMUX_REPO__REPO_ROOT_DIR/scripts/utils/utils.sh" || exit $?

    # Set all utils library default variables
    utils__set_all_default_variables || exit $?
fi

start_time="$(date +%s%3N)" || return $?

# Set `TERMUX_REPO_*` variables from the `repo.json` file.
termux_repository__set_repo_variables_from_repo_json_file "$__TERMUX_REPO__REPO_ROOT_DIR" \
    "$__TERMUX_REPO__REPO_ROOT_DIR/repo.json" || exit $?
# FIXME: Remove
echo "time=$(($(date +%s%3N) - start_time))"


unset __TERMUX_REPO__REPO_ROOT_DIR
