# shellcheck shell=bash

# Title:          termux_packaging
# Description:    A library for Termux packaging utils.
# SPDX-License-Identifier: MIT
# Function-Depends: logger, shell, shell__arg



##
# Extract package rootfs files in package file.
#
#
# **Parameters:**
# `package_name` - The package name to extract.
# `package_file_dir` - The parent directory in which package file exits.
# `package_file_name` - The package file name.
# `package_tmp_dir` - The temp directory for the package used while extraction.
# `package_rootfs_files_dir` - The destination directory to extract
#                              the package rootfs files to.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_packaging__extract_rootfs_files_from_package_file` `<package_name>` \
#     `<package_file_dir>` `<package_file_name>` `<package_tmp_dir>` \
#     `<package_rootfs_files_dir>`
##
termux_packaging__extract_rootfs_files_from_package_file() {

    shell__arg__validate_argument_count eq $# 5 termux_packaging__extract_rootfs_files_from_package_file "$@" || return $?

    local package_name="$1"
    local package_file_dir="$2"
    local package_file_name="$3"
    local package_tmp_dir="$4"
    local package_rootfs_files_dir="$5"

    termux_repository__validate_termux_repo_package_format termux_packaging__extract_rootfs_files_from_package_file || return $?

    if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "debian" ]]; then
        termux_packaging__debian__extract_rootfs_files_from_package_file \
            "$package_name" "$package_file_dir" "$package_file_name" "$package_tmp_dir" \
            "$package_rootfs_files_dir" || return $?

    elif [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]]; then
        termux_packaging__pacman__extract_rootfs_files_from_package_file \
            "$package_name" "$package_file_dir" "$package_file_name" \
            "$package_rootfs_files_dir" || return $?
    fi

    return 0

}
