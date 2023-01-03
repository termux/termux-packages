# shellcheck shell=sh
# shellcheck disable=SC2039,SC2059

# Title:          package
# Description:    A library for package utils.



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
# pacakge__is_package_on_device_build_supported `package_dir`
##
pacakge__is_package_on_device_build_supported() {
	[ $(. "${1}/build.sh"; echo "$TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED") != "true" ]
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
# pacakge__is_package_version_built `package_name` `package_version`
##
pacakge__is_package_version_built() {
	[ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$1" ] && [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$1")" = "$2" ]
	return $?
}
