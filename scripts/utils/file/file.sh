# shellcheck shell=bash

# Title:          file
# Description:    A library for file utils.
# SPDX-License-Identifier: MIT
# Function-Depends: logger, shell, shell__arg



##
# Validate if a variable containing a path to a regular file is set
# and the file exists.
#
#
# **Parameters:**
# `variable_name` - The name of the variable that contains the path
#                   to the regular file.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `file__validate_regular_file_variable` `<variable_name>` [`<function_name>` `<additional_error>`]
##
file__validate_regular_file_variable() {

    local path
    shell__copy_variable path "${1:-}" || return $?

    if [ -z "$path" ]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" variable is not set while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" variable is not set"
        fi
        return 1
    fi

    if [ ! -f "$path" ]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" file does not exist at \"$path\" while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" file does not exist at \"$path\""
        fi
        return 1
    fi

    return 0

}

##
# Validate if a variable containing a path to a directory is set
# and the directory exists.
#
#
# **Parameters:**
# `variable_name` - The name of the variable that contains the path
#                   to the directory.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `file__validate_directory_variable` `<variable_name>` [`<function_name>` `<additional_error>`]
##
file__validate_directory_variable() {

    local path
    shell__copy_variable path "${1:-}" || return $?

    if [ -z "$path" ]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" variable is not set while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" variable is not set"
        fi
        return 1
    fi

    if [ ! -d "$path" ]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" directory does not exist at \"$path\" while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" directory does not exist at \"$path\""
        fi
        return 1
    fi

    return 0

}
