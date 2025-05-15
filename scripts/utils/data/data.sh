# shellcheck shell=bash

# Title:          data
# Description:    A library for data types and their utils.
# License-SPDX:   MIT
# Function-Depends: logger, shell, shell__arg
# Function-Depends-Optional: android



##
# Set `data` library default variables.
# .
# .
# data__set_default_variables
##
data__set_default_variables() {

DATA__VARIABLES_SET=0

### Set Default Variables Start
# The following variables must not be modified unless you know what you are doing

DATA__NL='
'
DATA__TAB="$(printf '\t')" || return $?

### Set Default Variables End

DATA__VARIABLES_SET=1

}



##
# Print a string to stdout with `printf`.
# .
# .
# data__printf_string `string`
##
data__printf_string() {

    printf "%s" "${1:-}"

}

##
# Print a string to stdout with `printf` and append a newline.
# .
# .
# data__printfln_string `string`
##
data__printfln_string() {

    printf "%s\n" "${1:-}"

}

##
# Print a literal string to stdout with `printf`.
# .
# .
# data__printf_literal_string `string`
##
data__printf_literal_string() {

    printf "${1:-}"

}

##
# Print a literal string to stdout with `printf` and append a newline.
# .
# .
# data__printf_literal_string `string`
##
data__printfln_literal_string() {

    printf "${1:-}\n"

}

##
# Print formatted string arguments to stdout with `printf`.
# .
# .
# **Parameters:**
# `format` - The `printf` format.
# `string_args...` - The `printf` arguments to print as per `format`.
# .
# data__printf_formatted_string `<format>` `<string_args...>`
##
data__printf_formatted_string() {

    printf "$@"

}





##
# data__is_unsigned_int `value`
##
data__is_unsigned_int() {

    case "${1:-}" in
        ''|*[!0-9]*) return 1;;
        *) return 0;;
    esac

}

##
# data__validate_is_unsigned_int `label` `value` [`error_output_variable_name`]
##
data__validate_is_unsigned_int() {

    local label="${1:-}"
    local value="${2:-}"
    local error

    if ! data__is_unsigned_int "$value"; then
        error="$label is not a valid unsigned int: \"$value\""
        if [ -n "${3:-}" ]; then
            shell__set_variable "$3" "$error" || return $?
        else
            logger__log_errors "$error"
        fi
        return 1
    else
        return 0
    fi

}
