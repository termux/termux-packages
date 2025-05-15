# shellcheck shell=sh
# shellcheck disable=SC2039,SC2059

# Title:          termux_package
# Description:    A library for Termux package utils.



##
# Get the label for a package containing is package name and version.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set the
#                          the label into.
# `package_name` - The package name.
# `package_version` - The package version.
# `package_version_pacman` - The package version to use if
#                            `$TERMUX_REPO__PACKAGE_FORMAT` is `pacman`.
# `package_version_ignore` - Set to `true` if package version should
#                            not be added to label.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_package__get_package_name_and_version_label` `<output_variable_name>`
#     `<package_name>` `<package_version>` `<package_version_pacman>` \
#     `<package_version_ignore>`
##
termux_package__get_package_name_and_version_label() {

    local output_variable_name="$1"
    local package_name="$2"
    local package_version="$3"
    local package_version_pacman="${4:-}"
    local package_version_ignore="${5:-}"

    local __package_label="$package_name"

    if [[ "$package_version_ignore" != "true" ]]; then
        if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "debian" ]] && [[ -n "$package_version" ]]; then
            __package_label+="@$package_version"
        elif [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]] && [[ -n "$package_version_pacman" ]]; then
            __package_label+="@$package_version_pacman"
        fi
    fi

    shell__set_variable "$output_variable_name" "$__package_label"

}



##
# Check if package on device builds are supported by checking
# `$TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED` value in its `build.sh`
# file.
# .
# .
# **Parameters:**
# `package_dir` - The directory path for the package `build.sh` file.
# .
# **Returns:**
# Returns `0` if supported, otherwise `1`.
# .
# .
# termux_package__is_package_on_device_build_supported `<package_dir>`
##
termux_package__is_package_on_device_build_supported() {

	# shellcheck disable=SC1091
	[[ "$(. "$1/build.sh"; echo "$TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED")" != "true" ]]
	return $?

}



##
# Check if a specific version of a package has been built by checking
# the `$TERMUX_BUILT_PACKAGES_DIRECTORY/<package_name>` file.
# .
# .
# **Parameters:**
# `package_name` - The package name for the package.
# `package_version` - The package version for the package to check.
# .
# **Returns:**
# Returns `0` if built, otherwise `1`.
# .
# .
# termux_package__is_package_version_built `<package_name>` `<package_version>`
##
termux_package__is_package_version_built() {

	[ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$1" ] && [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$1")" = "$2" ]
	return $?

}



##
# Check if the package name has a prefix called `glibc`.
# .
# .
# **Parameters:**
# `package_name` - The package name for the package.
# .
# **Returns:**
# Returns `0` if have, otherwise `1`.
# .
# .
# termux_package__is_package_name_have_glibc_prefix `<package_name>`
##
termux_package__is_package_name_have_glibc_prefix() {

	for __pkgname_part in ${1//-/ }; do
		if [ "$__pkgname_part" = "glibc" ]; then
			return 0
		fi
	done

	return 1

}



##
# Adds the prefix `-glibc` to the package name
# .
# .
# **Parameters:**
# `package_name` - Package name.
# .
# **Returns:**
# Returns a modified package name.
# .
# .
# termux_package__add_prefix_glibc_to_package_name `<package_name>`
##
termux_package__add_prefix_glibc_to_package_name() {

	if [[ "${1}" = *"-static" ]]; then
		echo "${1/-static/-glibc-static}"
	else
		echo "${1}-glibc"
	fi

}



##
# Adds the prefix `-glibc` to the list of package names if necessary.
# .
# .
# **Parameters:**
# `package_list` - List of package names (eg `TERMUX_PKG_DEPENDS`).
# .
# **Returns:**
# Returns a modified list of package names.
# .
# .
# termux_package__add_prefix_glibc_to_package_list `<package_list>`
##
termux_package__add_prefix_glibc_to_package_list() {

	local packages=""

	for __pkg in ${1//,/}; do
		if ! "$(echo "$__pkg" | grep -q -e '(' -e ')' -e '|')"; then
			if [ "${packages: -1}" != "|" ]; then
				packages+=","
			fi
			packages+=" "
			if ! termux_package__is_package_name_have_glibc_prefix "$__pkg"; then
				packages+="$(termux_package__add_prefix_glibc_to_package_name "$__pkg")"
			else
				packages+="$__pkg"
			fi
		else
			packages+=" $__pkg"
		fi
	done

	echo "${packages:2}"





# FIXME: Fix docs
##
# Check if packages in packages repo can be used for building, like
# as dependencies.
#
# Packages hosted by packages repo can only be used if they were built
# for the same core variable values that current built is using.
# Check `TERMUX_REPO_*` variables in `scripts/properties.sh` file.
#
#
# **Returns:**
# Returns `0` always as exit code. If packages repo cannot be used,
# then a log string for repo vs build variables that do not match
# are printed on `stdout`, otherwise if usable, then nothing is printed.
#
#
# `termux_package__set_package_build_file_variables` \
#     `<orig_package_name_output_variable_name>` \
#     `<package_name_output_variable_name>` \
#     `<package_dir_output_variable_name>` \
#     `<package_repo_channel_dir_output_variable_name>` \
#     `<subpackage_name_output_variable_name>` \
#     `<is_subpackage_output_variable_name>` \
#     `<is_virtual_output_variable_name>` \
#     `<package_name_or_dir>` \
#     `<repo_root_dir>` `<allow_disabled_packages>`
##
termux_package__set_package_build_file_variables() {

    shell__arg__validate_argument_count eq $# 10 termux_package__set_package_build_file_variables "$@" || return $?

    local orig_package_name_output_variable_name="$1"
    local package_name_output_variable_name="$2"
    local package_dir_output_variable_name="$3"
    local package_repo_channel_dir_output_variable_name="$4"
    local subpackage_name_output_variable_name="$5"
    local is_subpackage_output_variable_name="$6"
    local is_virtual_output_variable_name="$7"
    local package_name_or_dir="$8"
    local repo_root_dir="$9"
    local allow_disabled_packages="${10}"

    local found_package=
    local package_parent_dir=
    local repo_channel_dir
    local subpackage_file=

    local __orig_package_name=
    local __package_name=
    local __package_dir=
    local __package_repo_channel_dir=
    local __subpackage_name=
    local __is_subpackage="false"
    local __is_virtual="false"

    shell__validate_variable_set package_name_or_dir termux_package__set_package_build_file_variables || return $?
    shell__validate_variable_set repo_root_dir termux_package__set_package_build_file_variables || return $?


    if [[ "$package_name_or_dir" == *"/"* ]]; then
        # Search for package in provided directory path
        __package_dir="$(realpath "$package_name_or_dir")" || return $?
        __package_name="$(basename "$__package_dir")" || return $?
        __orig_package_name="$__package_name"
        if [ ! -f "$__package_dir/build.sh" ]; then
            logger__log_errors "Failed to find 'build.sh' file in custom package directory '$__package_dir'"
            ls "$__package_dir"
            return 1
        fi
        # FIXME: Ensure under
        # Find the package repo channel directory by checking which
        # repo channel directory in `repo.json` file does the path
        # end in.
        # Even if the package directory is outside the
        # `TERMUX_SCRIPTDIR`/`repo_root_dir`, it should be in the
        # format `/path/to/custom/dir/<repo_channel_dir>/<package_name>`.
        # The  package repo channel directory is used by
        # `termux_repository__download_package_file` to find which
        # repo channel should the package file be downloaded from.
        package_parent_dir="$(dirname "$__package_dir")" || return $?
        for repo_channel_dir in "${TERMUX_REPO__CHANNEL_DIRS[@]}" "${TERMUX_REPO__DISABLED_CHANNEL_DIRS[@]}"; do
            if [[ "$package_parent_dir" == *"/$repo_channel_dir" ]]; then
                __package_repo_channel_dir="$repo_channel_dir"
                break
            fi
        done
        if [ -z "$__package_repo_channel_dir" ]; then
            logger__log_errors "Failed to find repo channel directory \
from custom package directory '$__package_dir'"
            logger__log_errors "The package parent directory must end \
with one of the repo channel directories in the 'repo.json' file"
            logger__log_errors "package_parent_dir='$package_parent_dir'"
            return 1
        fi
    else
        __orig_package_name="$(basename "$package_name_or_dir")" || return $?
        __package_name="$__orig_package_name"

        for repo_channel_dir in \
                "${TERMUX_REPO__CHANNEL_DIRS[@]}" "${TERMUX_REPO__DISABLED_CHANNEL_DIRS[@]}"; do
            # Search for parent package
            if [ -f "$repo_root_dir/$repo_channel_dir/$__package_name/build.sh" ]; then
                found_package="true"
                __package_dir="$repo_root_dir/$repo_channel_dir/$__package_name"
                __package_repo_channel_dir="$repo_channel_dir"

            # Search for virtual static subpackage
            elif [[ "$__package_name" == *"-static" ]] && \
                [ -f "$repo_root_dir/$repo_channel_dir/${__package_name%-static}/build.sh" ]; then
                found_package="true"
                __is_subpackage="true"
                __is_virtual="true"
                __subpackage_name="$__package_name"
                __package_name="${__package_name%-static}"
                __package_dir="$repo_root_dir/$repo_channel_dir/$__package_name"
                __package_repo_channel_dir="$repo_channel_dir"

            else
                # Search for subpackage
                subpackage_file="$(find "$repo_channel_dir" \
                    -mindepth 2 -maxdepth 2 -type f -name "$__package_name.subpackage.sh")" || return $?
                if [ -n "$subpackage_file" ]; then
                    if [ "$(echo "$subpackage_file" | wc -l)" -gt 1 ]; then
                        logger__log_errors "More than one build file found for subpackage '$__package_name'"
                        return 1
                    fi

                    found_package="true"
                    __is_subpackage="true"
                    __package_dir="$(dirname "$subpackage_file")" || return $?
                    __package_dir="$(realpath "$__package_dir")" || return $?
                    __subpackage_name="$__package_name"
                    __package_name="$(basename "$__package_dir")" || return $?
                    __package_repo_channel_dir="$repo_channel_dir"
                fi
            fi
        done

        if [[ "$found_package" != "true" ]]; then
            logger__log_errors "Failed to find 'build.sh' file for the \
package '$__orig_package_name' in any of the packages repo channel directories"
            return 1
        fi
    fi

    if [[ "$allow_disabled_packages" != "true" ]]; then
        for repo_channel_dir in "${TERMUX_REPO__DISABLED_CHANNEL_DIRS[@]}"; do
            if [[ "$__package_repo_channel_dir" == "$repo_channel_dir" ]]; then
                logger__log_errors "The package directory '$__package_dir' found is for a disabled repo channel."
                logger__log_errors "To build packages from disabled repo channels, passed the -D option."
                return 1
            fi
        done
    fi

    shell__set_variable_if_name_set "$orig_package_name_output_variable_name" "$__orig_package_name" || return $?
    shell__set_variable_if_name_set "$package_name_output_variable_name" "$__package_name" || return $?
    shell__set_variable_if_name_set "$package_dir_output_variable_name" "$__package_dir" || return $?
    shell__set_variable_if_name_set "$package_repo_channel_dir_output_variable_name" "$__package_repo_channel_dir" || return $?
    shell__set_variable_if_name_set "$subpackage_name_output_variable_name" "$__subpackage_name" || return $?
    shell__set_variable_if_name_set "$is_subpackage_output_variable_name" "$__is_subpackage" || return $?
    shell__set_variable_if_name_set "$is_virtual_output_variable_name" "$__is_virtual" || return $?

    return 0

}
