# shellcheck shell=bash

# Title:          termux_packaging__debian
# Description:    A library for Termux debian packaging utils.



##
# Extract rootfs files in `data.tar.*` from `deb` package file.
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
# `termux_packaging__debian__extract_rootfs_files_from_package_file` `<package_name>` \
#     `<package_file_dir>` `<package_file_name>` `<package_tmp_dir>` \
#     `<package_rootfs_files_dir>`
##
termux_packaging__debian__extract_rootfs_files_from_package_file() {

    local return_value

    shell__arg__validate_argument_count eq $# 5 termux_packaging__debian__extract_rootfs_files_from_package_file "$@" || return $?

    local package_name="$1"
    local package_file_dir="$2"
    local package_file_name="$3"
    local package_tmp_dir="$4"
    local package_rootfs_files_dir="$5"

    local data_archive

    shell__validate_variable_set package_name termux_packaging__debian__extract_rootfs_files_from_package_file || return $?
    shell__validate_variable_set package_file_dir termux_packaging__debian__extract_rootfs_files_from_package_file || return $?
    shell__validate_variable_set package_file_name termux_packaging__debian__extract_rootfs_files_from_package_file || return $?
    shell__validate_variable_set package_tmp_dir termux_packaging__debian__extract_rootfs_files_from_package_file || return $?
    file__validate_directory_variable package_rootfs_files_dir termux_packaging__debian__extract_rootfs_files_from_package_file || return $?


    logger__log 1 "Extracting rootfs files from debian package \
file '$package_file_name' for package '$package_name' to '$package_rootfs_files_dir'"

    # Extract `data.tar.*` to `package_tmp_dir`.
    termux_packaging__debian__extract_member_from_package_file data_archive \
        "$package_name" "$package_file_dir" "$package_file_name" "$package_tmp_dir" \
        '^data\.tar\.[a-z0-9]+$' || return $?

    # Extract package rootfs files from `data.tar.*` to `package_rootfs_files_dir`.
    return_value=0
    if tar -tf "$package_tmp_dir/$data_archive" | grep "^./$" 1>/dev/null; then
        # Strip prefixed `./` to avoid possible permission errors from tar.
        tar -xf "$package_tmp_dir/$data_archive" --strip-components=1 \
            --no-overwrite-dir \
            -C "$package_rootfs_files_dir" || return_value=$?
    else
        tar -xf "$package_tmp_dir/$data_archive" \
            --no-overwrite-dir \
            -C "$package_rootfs_files_dir" || return_value=$?
    fi
    if [ $return_value -ne 0 ]; then
        logger__log_errors "Failed to extract the '$data_archive' file of the package \
file '$package_file_dir/$package_file_name' for package '$package_name' to package rootfs \
files directory '$package_rootfs_files_dir'."
        return $return_value
    fi

    return 0

}

##
# Extract control files in `control.tar.*` from `deb` package file.
#
#
# **Parameters:**
# `package_name` - The package name to extract.
# `package_file_dir` - The parent directory in which package file exits.
# `package_file_name` - The package file name.
# `package_tmp_dir` - The temp directory for the package used while extraction.
# `package_control_files_dir` - The destination directory to extract
#                               the package control files to.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_packaging__debian__extract_control_files_from_package_file` `<package_name>` \
#     `<package_file_dir>` `<package_file_name>` `<package_tmp_dir>` \
#     `<package_control_files_dir>`
##
termux_packaging__debian__extract_control_files_from_package_file() {

    local return_value

    shell__arg__validate_argument_count eq $# 5 termux_packaging__debian__extract_control_files_from_package_file "$@" || return $?

    local package_name="$1"
    local package_file_dir="$2"
    local package_file_name="$3"
    local package_tmp_dir="$4"
    local package_control_files_dir="$5"

    local control_archive

    shell__validate_variable_set package_name termux_packaging__debian__extract_control_files_from_package_file || return $?
    shell__validate_variable_set package_file_dir termux_packaging__debian__extract_control_files_from_package_file || return $?
    shell__validate_variable_set package_file_name termux_packaging__debian__extract_control_files_from_package_file || return $?
    shell__validate_variable_set package_tmp_dir termux_packaging__debian__extract_control_files_from_package_file || return $?
    file__validate_directory_variable package_control_files_dir termux_packaging__debian__extract_control_files_from_package_file || return $?


    logger__log 1 "Extracting control files from debian package \
file '$package_file_name' for package '$package_name' to '$package_control_files_dir'"

    # Extract `control.tar.*` to `package_tmp_dir`.
    termux_packaging__debian__extract_member_from_package_file control_archive \
        "$package_name" "$package_file_dir" "$package_file_name" "$package_tmp_dir" \
        '^control\.tar\.[a-z0-9]+$' || return $?

    # Extract package control files from `control.tar.*` to `package_control_files_dir`.
    return_value=0
    tar -xf "$package_tmp_dir/$control_archive" -C "$package_control_files_dir" || return_value=$?
    if [ $return_value -ne 0 ]; then
        logger__log_errors "Failed to extract the '$control_archive' file of the package \
file '$package_file_dir/$package_file_name' for package '$package_name' to package control \
files directory '$package_control_files_dir'."
        return $return_value
    fi

    return 0

}

##
# Extract a single member from `deb` package file.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set
#                          to the member filename that is extracted.
# `package_name` - The package name to extract.
# `package_file_dir` - The parent directory in which package file exits.
# `package_file_name` - The package file name.
# `member_extraction_dir` - The destination directory to extract the
#                           member file to.
# `member_regex` - The extended regex to match the member the member
#                  to extract in the `ar t` output.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_packaging__debian__extract_member_from_package_file` `<output_variable_name>` \
#     `<package_name>`  `<package_file_dir>` `<package_file_name>` \
#     `<member_extraction_dir>` `<member_regex>`
##
termux_packaging__debian__extract_member_from_package_file() {

    local return_value

    shell__arg__validate_argument_count eq $# 6 termux_packaging__debian__extract_member_from_package_file "$@" || return $?

    local package_name="$2"
    local package_file_dir="$3"
    local package_file_name="$4"
    local member_extraction_dir="$5"
    local member_regex="$6"

    local deb_file_contents
    local __member_file

    shell__validate_variable_set package_name termux_packaging__debian__extract_member_from_package_file || return $?
    shell__validate_variable_set package_file_dir termux_packaging__debian__extract_member_from_package_file || return $?
    shell__validate_variable_set package_file_name termux_packaging__debian__extract_member_from_package_file || return $?
    file__validate_directory_variable member_extraction_dir termux_packaging__debian__extract_member_from_package_file || return $?
    shell__validate_variable_set member_regex termux_packaging__debian__extract_member_from_package_file || return $?


    # Find `data.tar.*` file in `deb` file.
    deb_file_contents="$(ar t "$package_file_dir/$package_file_name")" || return $?
    __member_file="$(printf "%s" "$deb_file_contents" | grep -E "$member_regex")" || return $?
    if [[ -n "$__member_file" ]]; then
        if [[ "$(printf "%s" "$__member_file" | wc -l)" -gt 1 ]]; then
            logger__log_errors "More than one member matching '$member_regex' found in package \
file '$package_file_dir/$package_file_name' for package '$package_name':"
            logger__log_errors "matching_member_files:"$'\n'"$__member_file"
            return 1
        fi
    else
        logger__log_errors "No member matching '$member_regex' found in package \
file '$package_file_dir/$package_file_name' for package '$package_name'"
        logger__log_errors "deb_file_contents:"$'\n'"$deb_file_contents"
        return 1
    fi

    (
        # cd to extraction directory.
        cd "$member_extraction_dir" || exit $?

        # Extract member to `member_extraction_dir`.
        return_value=0
        ar x "$package_file_dir/$package_file_name" "$__member_file" || return_value=$?
        if [ $return_value -ne 0 ]; then
            logger__log_errors "Failed to extract the member '$__member_file' from the package \
file '$package_file_dir/$package_file_name' for package '$package_name'."
            exit $return_value
        fi
    ) || return $?

    shell__set_variable "$1" "$__member_file"

}
