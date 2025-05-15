# shellcheck shell=bash

# Title:          termux_package
# Description:    A library for Termux package utils.



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

    # bash builtins only, a bit faster than [ -e $file ] && [ "$(cat $file)" == "smth" ]
    [[ -f "$TERMUX_BUILT_PACKAGES_DIRECTORY/$1" ]] && [[ "$(< "$TERMUX_BUILT_PACKAGES_DIRECTORY/$1")" == "$2" ]]
    return $?

}




# FIXME: Fix docs
##
# Check if packages in packages repo can be used for building, like
# as dependencies.
# .
# Packages hosted by packages repo can only be used if they were built
# for the same core variable values that current built is using.
# Check `TERMUX_REPO_*` variables in `scripts/properties.sh` file.
# .
# .
# **Returns:**
# Returns `0` always as exit code. If packages repo cannot be used,
# then a log string for repo vs build variables that do not match
# are printed on `stdout`, otherwise if usable, then nothing is printed.
# .
# .
# termux_package__set_package_build_file_variables `<package_name_or_path>`
#   `<repo_root_dir>` `Mpackages_repo_channel_dirs>` `<allow_disabled_packages>`
##
termux_package__set_package_build_file_variables() {

    local package_name_or_path="$1"
    local repo_root_dir="$2"
    local packages_repo_channel_dirs="$3"$'\n'"disabled-packages"
    local allow_disabled_packages="$4"

    local found_package=
    local subpackage_file=

    orig_package_name=
    package_name=
    package_dir=
    subpackage_name=
    is_subpackage="false"
    is_virtual="false"

    if [ -z "$package_name_or_path" ]; then
        echo "The package name or path not set" 1>&2
        return 1
    fi

    if [[ "$package_name_or_path" == *"/"* ]]; then
        # Search for package in provided directory path
        package_dir="$(realpath "$package_name_or_path")"
        package_name="$(basename "$package_dir")"
        orig_package_name="$package_name"
        if [ ! -f "$package_dir/build.sh" ]; then
            echo "Failed to find 'build.sh' file in custom package directory '$package_dir'" 1>&2;
            return 1
        fi
    else
        orig_package_name="$(basename "$package_name_or_path")"
        package_name="$orig_package_name"

        for packages_dir in $packages_repo_channel_dirs; do
            # Search for parent package
            if [ -f "$TERMUX_SCRIPTDIR/$packages_dir/$package_name/build.sh" ]; then
                found_package="true"
                package_dir="$TERMUX_SCRIPTDIR/$packages_dir/$package_name"

            # Search for virtual static subpackage
            elif [[ "$package_name" == *"-static" ]] && [ -f "$TERMUX_SCRIPTDIR/$packages_dir/${package_name%-static}/build.sh" ]; then
                found_package="true"
                is_subpackage="true"
                is_virtual="true"
                subpackage_name="$package_name"
                package_name="${package_name%-static}"
                package_dir="$TERMUX_SCRIPTDIR/$packages_dir/$package_name"

            else
                # Search for subpackage
                subpackage_file="$(find "$packages_dir" -mindepth 2 -maxdepth 2 -type f -name "$package_name.subpackage.sh")"
                if [ -n "$subpackage_file" ]; then
                    if [ "$(echo "$subpackage_file" | wc -l)" -gt 1 ]; then
                        echo "More than one build file found for subpackage '$package_name'" 1>&2
                        return 1
                    fi

                    found_package="true"
                    is_subpackage="true"
                    package_dir="$(dirname "$subpackage_file")"
                    package_dir="$(realpath "$package_dir")"
                    subpackage_name="$package_name"
                    package_name="$(basename "$package_dir")"
                fi
            fi
        done

        if [[ "$found_package" != "true" ]]; then
            echo "Failed to find 'build.sh' file for the package '$orig_package_name' in any of the packages repo channel directories" 1>&2
            return 1
        fi
    fi

    if [[ "$allow_disabled_packages" != "true" ]] && [[ "$package_dir" == "$repo_root_dir/disabled-packages/$package_name" ]]; then
        echo "The package directory '$package_dir' found is for a disabled package which are not enabled to be built" 1>&2;
        return 1
    fi

}




##
# Convert comma separated dependency list like control file `Depends`
# field or `TERMUX_PKG_DEPENDS` to space separated list without
# versions.
# .
# Alternates dependencies separated by `|`, like `nodejs | nodejs-lts`
# will have their `|` character removed.
# .
# .
# **Parameters:**
# `output_variable_name` - The name of the variable to set
#                          space separated dependency list into.
# `dependencies_list` - Comma separated dependency list.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# termux_package__get_space_separated_dependencies_list `output_variable_name` \
#   `dependencies_list`
##
termux_package__get_space_separated_dependencies_list() {

    shell__arg__validate_argument_count eq $# 2 termux_package__get_space_separated_dependencies_list "$@" || return $?

    local __dependencies_list="${2-}"

    if [ -z "$__dependencies_list" ]; then
        shell__set_variable "${1-}" ""

    else
        # If more than 1 line, then abort
        if data__contains_substring "$__dependencies_list" "$DATA__NL"; then
            logger__log_errors "${DATA__NL}dependencies_list=${DATA__NL}\`\`\`${DATA__NL}$__dependencies_list${DATA__NL}\`\`\`"
            logger__log_errors "Dependencies list passed to \"termux_package__get_space_separated_dependencies_list\" is invalid"
            return 1
        fi

        __dependencies_list="$(data__printfln_string "$__dependencies_list" | sed -r 's/\([^)]*\)//g' | sed -r 's/[,|]+//g' | sed -r 's/[ \t]+/ /g' | sed -r 's/^[ \t]+//g' | sed -r 's/[ \t]+$//g')"
        shell__set_variable "${1-}" "$__dependencies_list"
    fi

}

##
# Check if dependency exists in dependencies list.
# .
# .
# **Parameters:**
# `output_variable_name` - The name of the variable to set
#                          `true` or `false` into.
# `dependency` - The dependency name to check.
# `dependencies_list` - Comma separated dependency list.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# termux_package__does_dependency_exists_in_dependencies_list `output_variable_name` \
#   `dependency` `dependencies_list`
##
termux_package__does_dependency_exists_in_dependencies_list() {

    shell__arg__validate_argument_count eq $# 3 termux_package__does_dependency_exists_in_dependencies_list "$@" || return $?

    local dependency="${2-}"
    local dependencies_list="${3-}"

    local result

    shell__validate_variable_set dependency termux_package__does_dependency_exists_in_dependencies_list || return $?

    if [ -z "$dependencies_list" ]; then
        result="false"
    else
        termux_package__get_space_separated_dependencies_list dependencies_list "$dependencies_list"
        [[ " $dependencies_list " == *" $dependency "* ]] && result="true" || result="false"
    fi

    shell__set_variable "${1-}" "$result"

}



##
# Check if the package name has a prefix called `glibc` or `glibc32`.
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
        if [ "$__pkgname_part" = "glibc" ] || [ "$__pkgname_part" = "glibc32" ]; then
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

}
