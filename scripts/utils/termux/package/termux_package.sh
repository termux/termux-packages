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

    [ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$1" ] && [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$1")" = "$2" ]
    return $?

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
