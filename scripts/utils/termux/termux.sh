# shellcheck shell=bash

# Title:          termux
# Description:    A library for Termux utils.



##
# Validate if a variable is set to one of the supported Termux
# architectures in `TERMUX__SUPPORTED_ARCHITECTURES`, or optionally
# `all`.
#
#
# **Parameters:**
# `variable_name` - The name of the variable that contains the arch.
# `allow_all_architecture` - Set to `true` if to allow the `all` architecture.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux__validate_termux_arch_variable` `<variable_name>` \
#     `<allow_all_architecture>` [`<function_name>` `<additional_error>`]
##
termux__validate_termux_arch_variable() {

    local allow_all_architecture="$2"

    if [[ "$allow_all_architecture" == "true" ]]; then
        shell__validate_bash_array_set TERMUX__SUPPORTED_ARCHITECTURES "${3:-}" "${4:-}" || return $?

        local -a termux__supported_architectures=("${TERMUX__SUPPORTED_ARCHITECTURES[@]}" "all")

        shell__validate_value_exists_in_bash_array "${1:-}" \
            "supported Termux architectures" termux__supported_architectures \
            "${3:-}" "${4:-}"
    else
        shell__validate_value_exists_in_bash_array "${1:-}" \
            "supported Termux architectures" TERMUX__SUPPORTED_ARCHITECTURES \
            "${3:-}" "${4:-}"
    fi

}

##
# Validate if a variable is set to one of the supported Termux
# package library in `TERMUX__SUPPORTED_PACKAGE_LIBRARIES`.
#
#
# **Parameters:**
# `variable_name` - The name of the variable that contains the package
#                   library.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux__validate_termux_package_library_variable` `<variable_name>` \
#     [`<function_name>` `<additional_error>`]
##
termux__validate_termux_package_library_variable() {

    shell__validate_value_exists_in_bash_array "${1:-}" \
        "supported Termux package libraries" TERMUX__SUPPORTED_PACKAGE_LIBRARIES \
        "${2:-}" "${3:-}"

}

##
# Validate if a variable is set to one of the supported Termux package
# managers in `TERMUX__SUPPORTED_PACKAGE_MANAGERS`.
#
#
# **Parameters:**
# `variable_name` - The name of the variable that contains the repo
#                   package manager.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux__validate_termux_package_manager_variable` `<variable_name>` \
#     [`<function_name>` `<additional_error>`]
##
# FIXME:
termux__validate_termux_package_manager_variable() {

    shell__validate_value_exists_in_bash_array "${1:-}" \
        "supported Termux package managers" TERMUX__SUPPORTED_PACKAGE_MANAGERS \
        "${2:-}" "${3:-}"

}

##
# Validate if a variable is set to one of the supported Termux package
# formats in `TERMUX__SUPPORTED_PACKAGE_FORMATS`.
#
#
# **Parameters:**
# `variable_name` - The name of the variable that contains the package
#                   format.
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux__validate_termux_package_format_variable` `<variable_name>` \
#     [`<function_name>` `<additional_error>`]
##
termux__validate_termux_package_format_variable() {

    shell__validate_value_exists_in_bash_array "${1:-}" \
        "supported Termux package formats" TERMUX__SUPPORTED_PACKAGE_FORMATS \
        "${2:-}" "${3:-}"

}
