# shellcheck shell=bash

# Title:          shell
# Description:    A library for shell.
# License-SPDX:   MIT
# Function-Depends: data, logger



##
# shell__is_valid_shell_variable_name `<variable_name>`
##
shell__is_valid_shell_variable_name() {

    # Case statements are slow for long strings
    # 1000 is arbitrarily selected and needs testing
    if [ "${#1}" -lt 1000 ]; then
        # Use `${parameter:offset:length}`
        local variable_name_rest="${1:1}" # 1:end
        local variable_name_first_char="${1:0:1}" # 0:1

        case "$variable_name_first_char" in
            [a-zA-Z_])
                case "$variable_name_rest" in
                    *[!a-zA-Z0-9_]*) return 1;;
                    *) return 0;;
                esac;;
            *) return 1;;
        esac
    else
        # Do not use `grep` since `grep -z` does not work with
        # start `^` and end `$` anchors
        # We manually add everything to pattern space and print only
        # if it matches the regex
        [ -n "$(data__printf_string "${1}x" | sed -r -n -e '$!{:a;N;$!ba;}; /^[a-zA-Z_][a-zA-Z0-9_]+$/p')" ]
    fi

    # If $1 is valid shell variable_name or array_element_name
    #[ -n "$(data__printf_string "${1}x" | sed -r -n -e '$!{:a;N;$!ba;}; /^[a-zA-Z_][a-zA-Z0-9_]*(\[[0-9]+\])?$/p')" ]

}

##
# shell__set_variable `<variable_name>` `<variable_value>`
##
shell__set_variable() {

    local variable_name="${1:-}"
    local variable_value="${2:-}"

    # If variable_name is not a valid shell variable_name
    if ! shell__is_valid_shell_variable_name "$variable_name"; then
        logger__log_errors "The variable_name \"$variable_name\" \
passed to \"shell__set_variable\" is not a valid shell variable name"
        return 1
    fi

    printf -v "$variable_name" "%s" "$variable_value"
    #eval "$variable_name"=\"\$variable_value\"

}

##
# shell__set_variable_if_name_set `<variable_name>` `<variable_value>`
##
shell__set_variable_if_name_set() {

    local variable_name="${1:-}"

    if [ -n "$variable_name" ] && [ "$variable_name" != "-" ]; then
        shell__set_variable "$@" || return $?
    fi

    return 0

}

##
# shell__copy_variable `<output_variable_name>` `<input_variable_name>`
##
shell__copy_variable() {

    local output_variable_name="${1:-}"
    local input_variable_name="${2:-}"

    # If variable_name is not a valid shell variable_name
    if ! shell__is_valid_shell_variable_name "$output_variable_name"; then
        logger__log_errors "The output_variable_name \"$output_variable_name\" \
passed to \"shell__copy_variable\" is not a valid shell variable name"
        return 1
    fi

    # If variable_name is not a valid shell variable_name
    if ! shell__is_valid_shell_variable_name "$input_variable_name"; then
        logger__log_errors "The input_variable_name \"$input_variable_name\" \
passed to \"shell__copy_variable\" is not a valid shell variable name"
        return 1
    fi

    eval "$output_variable_name"=\"\$\{"$input_variable_name":-\}\"

}



##
# shell__append_to_variable `<variable_name>` `<value_to_append>`
##
shell__append_to_variable() {

    local curr_value
    shell__copy_variable curr_value "${1:-}" || return $?
    shell__set_variable "${1:-}" "$curr_value${2:-}" || return $?

}



##
# Validate if a variable is set.
# .
# .
# **Parameters:**
# `variable_name` - The name of the variable to validate.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# shell__validate_variable_set `<variable_name>` [`<function_name>` `<additional_error>`]
##
shell__validate_variable_set() {

    local curr_value
    shell__copy_variable curr_value "${1:-}" || return $?

    if [ -z "$curr_value" ]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" variable is not set while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" variable is not set"
        fi
        return 1
    else
        return 0
    fi

}

##
# Validate if a variable is unset.
# .
# .
# **Parameters:**
# `variable_name` - The name of the variable to validate.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# shell__validate_variable_unset `<variable_name>` [`<function_name>` `<additional_error>`]
##
shell__validate_variable_unset() {

    local curr_value
    shell__copy_variable curr_value "${1:-}" || return $?

    if [ -n "$curr_value" ]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" variable is set while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" variable is set"
        fi
        return 1
    else
        return 0
    fi

}



##
# Validate if a bash indexed (`declare -a`) or associative (`declare -A`) array is set.
# .
# .
# **Parameters:**
# `variable_name` - The name of the bash array to validate.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# shell__validate_bash_array_set `<variable_name>` [`<function_name>` `<additional_error>`]
##
shell__validate_bash_array_set() {

    local variable_name="${1:-}"

    local array_size

    # If variable_name is not a valid shell variable_name
    if ! shell__is_valid_shell_variable_name "$variable_name"; then
        logger__log_errors "The variable_name \"$variable_name\" \
passed to \"shell__validate_bash_array_set\" is not a valid shell variable name"
        return 1
    fi

    # shellcheck disable=SC2140
    eval "array_size"=\"\$\{\#"$variable_name"\[\@\]\}\" || return $?

    if [ "$array_size" -lt 1 ]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" array variable is not set while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" array variable is not set"
        fi
        return 1
    else
        return 0
    fi

}

##
# Validate if the variable has been declared as a bash indexed array (declare -a).
# .
# .
# **Parameters:**
# `variable_name` - The name of the bash array to validate.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# shell__validate_is_indexed_bash_array `<variable_name>` [`<function_name>` `<additional_error>`]
##
shell__validate_is_indexed_bash_array() {

    local variable_name="${1:-}"

    local declare_output

    # If variable_name is not a valid shell variable_name
    if ! shell__is_valid_shell_variable_name "$variable_name"; then
        logger__log_errors "The variable_name \"$variable_name\" \
passed to \"shell__validate_is_indexed_bash_array\" is not a valid shell variable name"
        return 1
    fi

    declare_output="$(declare -p "$variable_name" 2>&1 || true)"
    if [[ "$declare_output" != "declare -a "* ]]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" variable has not been \
declared as a bash indexed array (declare -a) while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" variable has not been \
declared as a bash indexed array (declare -a)"
        fi
        return 1
    else
        return 0
    fi

}

##
# Validate if the variable has been declared as a bash associative array (declare -A).
# .
# .
# **Parameters:**
# `variable_name` - The name of the bash array to validate.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# shell__validate_is_associative_bash_array `<variable_name>` [`<function_name>` `<additional_error>`]
##
shell__validate_is_associative_bash_array() {

    local variable_name="${1:-}"

    local declare_output

    # If variable_name is not a valid shell variable_name
    if ! shell__is_valid_shell_variable_name "$variable_name"; then
        logger__log_errors "The variable_name \"$variable_name\" \
passed to \"shell__validate_is_associative_bash_array\" is not a valid shell variable name"
        return 1
    fi

    declare_output="$(declare -p "$variable_name" 2>&1 || true)"
    if [[ "$declare_output" != "declare -A "* ]]; then
        if [ -n "${2:-}" ]; then
            logger__log_errors "The \"${1:-}\" variable has not been \
declared as a bash associative array (declare -A) while running \"${2:-}\"${3:-}"
        else
            logger__log_errors "The \"${1:-}\" variable has not been \
declared as a bash associative array (declare -A)"
        fi
        return 1
    else
        return 0
    fi

}

##
# Validate if a variable is set to one of the values in a bash indexed
# (`declare -a`) or associative (`declare -A`) array. For associative
# arrays, the values are compared, not the key names.
# .
# .
# **Parameters:**
# `variable_name` - The name of the variable that contains the value.
# `array_label` - The label of the array variable that the value
#                 should be checked in.
# `array_name` - The name of the array variable that the value should
#                be checked in.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# shell__validate_value_exists_in_bash_array `<variable_name>` \
#     `<array_label>` `<array_name>` \
#     [`<function_name>` `<additional_error>`]
##
shell__validate_value_exists_in_bash_array() {

    shell__arg__validate_argument_count between $# 3 5 shell__validate_value_exists_in_bash_array "$@" || return $?

    local variable_name="$1"
    local array_label="$2"
    local array_name="$3"

    local array_item
    local array_items=""
    local i
    local variable_value
    local value_exists="false"

    # Validate array variable name and ensure it is set.
    shell__validate_bash_array_set "$array_name" "${4:-}" "${5:-}" || return $?

    # Create `nameref` to `array_name`.
    # so that array syntax can be used locally.
    # - https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html
    local -n array="$array_name" || return $?

    shell__copy_variable variable_value "$variable_name" || return $?

    if [[ -n "$variable_value" ]]; then
        for array_item in "${array[@]}"; do
            if [[ "$variable_value" == "$array_item" ]]; then
                value_exists="true"
                break
            fi
        done
    fi

    if [[ "$value_exists" == "false" ]]; then
        if [[ -n "${4:-}" ]]; then
            logger__log_errors "The '$variable_name' variable is set to an \
invalid value '$variable_value' while running \"${4:-}\"${5:-}"
        else
            logger__log_errors "The '$variable_name' variable is set to an \
invalid value '$variable_value'"
        fi

        for i in "${!array[@]}"; do
            [ "$i" -ge 1 ] && array_items+=", "
            array_items+="'${array["$i"]}'"
        done
        logger__log_errors "It must only be set to one of the $array_label: $array_items"
    fi

     # Unset `nameref` to `array_name`.
    unset -n array || return $?

    if [[ "$value_exists" == "false" ]]; then
        return 1
    else
        return 0
    fi

}
