# shellcheck shell=bash

# Title:          shell__optargs
# Description:    A library for shell optargs.
# License-SPDX:   MIT
# Function-Depends: data, shell, shell__arg



shell__optarg__log_arg() { if [ "$SHELL__OPTARG__ARGS_LOG_LEVEL" -ge "1" ]; then data__printfln_string "$@"; fi }
shell__optarg__log_arg_errors() { data__printfln_string "$@" 1>&2; }


##
# shell__optarg__init_parse_optargs `<exit_on_error_function_name>` `<args_log_level>`
##
shell__optarg__init_parse_optargs() {

    shell__arg__validate_argument_count eq $# 2 shell__optarg__init_parse_optargs "$@" || return $?

    local exit_on_error_function_name="$1"
    local args_log_level="$2"

    shell__validate_variable_set exit_on_error_function_name shell__optarg__init_parse_optargs || return $?
    data__validate_is_unsigned_int "The \"args_log_level\" value while running \"args_log_level\"" "$args_log_level" || return $?

    SHELL__OPTARG__EXIT_ON_ERROR_FUNCTION_NAME="$exit_on_error_function_name"
    SHELL__OPTARG__ARGS_LOG_LEVEL="$args_log_level"

}

##
# shell__optarg__parse_opt
##
shell__optarg__parse_opt() {

    shell__optarg__log_arg "Parsing option: '-${opt}'"

}

##
# shell__optarg__parse_long_opt
##
shell__optarg__parse_long_opt() {

    shell__optarg__log_arg "Parsing option: '--${OPTARG%=*}'"

}

##
# shell__optarg__parse_long_opt_error [`<exit_on_error_function_arguments...>`]
##
shell__optarg__parse_long_opt_error() {

    shell__optarg__log_arg_errors "Invalid option or arguments not allowed for option: '--${OPTARG%=*}'"

    if ! shell__is_function "$SHELL__OPTARG__EXIT_ON_ERROR_FUNCTION_NAME"; then
        shell__optarg__log_arg_errors "The exit_on_error_function \
\"$SHELL__OPTARG__EXIT_ON_ERROR_FUNCTION_NAME\" is not defined while running \"shell__optarg__parse_long_opt_error\""
        return 1
    fi

    SHELL__OPTARG__EXIT_ON_ERROR_FUNCTION_NAME "$@"

}

##
# shell__optarg__parse_long_opt_with_arg `<arg>`
# shell__optarg__parse_long_opt_with_arg `<output_variable_name>` `<arg>`
# shell__optarg__parse_long_opt_with_arg `<output_variable_name>` `<arg>` `<alternate_arg_to_set>`
##
shell__optarg__parse_long_opt_with_arg() {

    if [ $# -eq 1 ]; then
        shell__optarg__log_arg "Parsing option: '--${OPTARG%=*}', arg: '${1}'"
    elif [ $# -eq 2 ]; then
        shell__optarg__log_arg "Parsing option: '--${OPTARG%=*}', arg: '${2}'"
        shell__set_variable "$1" "$2" || return $?
    elif [ $# -eq 3 ]; then
        shell__optarg__log_arg "Parsing option: '--${OPTARG%=*}', arg: '${2}'"
        shell__set_variable "$1" "$3" || return $?
    else
        shell__arg__validate_argument_count between $# 1 3 shell__optarg__parse_long_opt_with_arg "$@" || return $?
    fi

}

##
# shell__optarg__parse_long_opt_with_arg_error [`<exit_on_error_function_arguments...>`]
##
shell__optarg__parse_long_opt_with_arg_error() {

    shell__optarg__log_arg_errors "No arguments set for option: '--${OPTARG%=*}'"

    if ! shell__is_function "$SHELL__OPTARG__EXIT_ON_ERROR_FUNCTION_NAME"; then
        shell__optarg__log_arg_errors "The exit_on_error_function \
\"$SHELL__OPTARG__EXIT_ON_ERROR_FUNCTION_NAME\" is not defined while running \"shell__optarg__parse_long_opt_error\""
        return 1
    fi

    SHELL__OPTARG__EXIT_ON_ERROR_FUNCTION_NAME "$@"

}
