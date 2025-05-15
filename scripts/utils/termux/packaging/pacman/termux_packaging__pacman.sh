# shellcheck shell=bash

# Title:          termux_packaging__pacman
# Description:    A library for Termux pacman packaging utils.



##
# Extract rootfs files from `pacman` package file.
#
#
# **Parameters:**
# `package_name` - The package name to extract.
# `package_file_dir` - The parent directory in which package file exits.
# `package_file_name` - The package file name.
# `package_rootfs_files_dir` - The destination directory to extract
#                              the package rootfs files to.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_packaging__pacman__extract_rootfs_files_from_package_file` `<package_name>` \
#     `<package_file_dir>` `<package_file_name>` `<package_rootfs_files_dir>`
##
termux_packaging__pacman__extract_rootfs_files_from_package_file() {

    local return_value

    shell__arg__validate_argument_count eq $# 4 termux_packaging__pacman__extract_rootfs_files_from_package_file "$@" || return $?

    local package_name="$1"
    local package_file_dir="$2"
    local package_file_name="$3"
    local package_rootfs_files_dir="$4"

    shell__validate_variable_set package_name termux_packaging__pacman__extract_rootfs_files_from_package_file || return $?
    shell__validate_variable_set package_file_dir termux_packaging__pacman__extract_rootfs_files_from_package_file || return $?
    shell__validate_variable_set package_file_name termux_packaging__pacman__extract_rootfs_files_from_package_file || return $?
    file__validate_directory_variable package_rootfs_files_dir termux_packaging__pacman__extract_rootfs_files_from_package_file || return $?
    shell__validate_variable_set TERMUX_BASE_DIR termux_packaging__pacman__extract_rootfs_files_from_package_file || return $?

    local rootfs_top_level_dir


    logger__log 1 "Extracting rootfs files from pacman package \
file '$package_file_name' for package '$package_name' to '$package_rootfs_files_dir'"


    if [[ ! "$TERMUX_BASE_DIR" =~ ^(/[^/]+)+$ ]]; then
        logger__log_errors "TERMUX_BASE_DIR '$TERMUX_BASE_DIR' is not an absolute path \
under rootfs '/' while running 'termux_packaging__pacman__extract_rootfs_files_from_package_file'."
        return 1
    fi

    # The `package.tar.*` file contains package info files in the
    # root directory (`.BUILDINFO`, `.INSTALL`, `.MTREE`, `.PKGINFO`),
    # and so we just extract the rootfs top level directory.
    # Using `tar --exclude='.*'` will match files starting with dot `.`
    # in subdirectories as well instead of just root directory of tar
    # file.
    if [[ "$TERMUX_BASE_DIR" =~ ^/[^/]+$ ]]; then
        # Use `/rootfs` as is.
        rootfs_top_level_dir="$TERMUX_BASE_DIR"
    else
        # Get `/path/` from `/path/to/rootfs`.
        rootfs_top_level_dir="${TERMUX_BASE_DIR%"${TERMUX_BASE_DIR#/*/}"}"
    fi

    # Remove leading slash `/` from `/rootfs`
    rootfs_top_level_dir="${rootfs_top_level_dir#/}"


    # Extract package rootfs files from `package.tar.*` to `package_rootfs_files_dir`.
    return_value=0
    tar -xf "$package_file_dir/$package_file_name" \
        --force-local --no-overwrite-dir \
        -C "$package_rootfs_files_dir" "$rootfs_top_level_dir" || return_value=$?
    if [ $return_value -ne 0 ]; then
        logger__log_errors "Failed to extract the package rootfs files of the package \
file '$package_file_dir/$package_file_name' for package '$package_name' to package rootfs \
files directory '$package_rootfs_files_dir'."
        return $return_value
    fi

    return 0

}
