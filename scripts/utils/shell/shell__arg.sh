# shellcheck shell=bash

# Title:          shell__arg
# Description:    A library for shell arguments.
# License-SPDX:   MIT
# Function-Depends: data, logger, shell



##
# shell__arg__get_arguments_string `output_variable_name` `arguments...`
##
shell__arg__get_arguments_string() {

	local output_variable_name="${1-}"
	shift 1

	local argument=""
	local __arguments_string=""
	local i=1

	while [ $# -ne 0 ]; do
		argument="${1-}"
		__arguments_string="$__arguments_string$i: \`$argument\`"

		if [ $# -gt 1 ]; then
			__arguments_string="$__arguments_string$DATA__NL"
		fi

		i=$((i + 1))
		shift
	done

	shell__set_variable "$output_variable_name" "$__arguments_string" || return $?

}

##
# shell__arg__print_arguments_string `arguments...`
##
shell__arg__print_arguments_string() {

	local arguments_string=""
	shell__arg__get_arguments_string arguments_string "$@" || return $?
	data__printfln_string "$arguments_string"

}

##
# shell__arg__print_function_arguments_string `function_name` `arguments...`
##
shell__arg__print_function_arguments_string() {

	local function_name="${1-}"
	shift 1

	if [ $# -gt 0 ]; then
		local arguments_string=""
		shell__arg__get_arguments_string arguments_string "$@" || return $?
		data__printfln_string "$function_name arguments:"
		data__printfln_string "$arguments_string"
	else
		data__printfln_string "$function_name arguments: -"
	fi

}

##
# shell__arg__validate_argument_count `"eq"`|`"lt"`|`"le"`|`"gt"`|`"ge"` `arguments_received` `arguments_actual` `label`
# shell__arg__validate_argument_count `"or"` `arguments_received` `arguments_actual_1` `arguments_actual_2` `label`
# shell__arg__validate_argument_count `"between"` `arguments_received` `arguments_actual_min` `arguments_actual_max label`
##
shell__arg__validate_argument_count() {

	local return_value=0

	case "$1" in
		eq) if [ "$2" -eq "$3" ]; then :; else logger__log_errors "Invalid argument count \"$2\" to \"$4\". Expected \"$3\" argument(s)."; shift 4; return_value=1; fi;;
		lt) if [ "$2" -lt "$3" ]; then :; else logger__log_errors "Invalid argument count \"$2\" to \"$4\". Expected less than \"$3\" argument(s)."; shift 4; return_value=1; fi;;
		le) if [ "$2" -le "$3" ]; then :; else logger__log_errors "Invalid argument count \"$2\" to \"$4\". Expected less than or equal to \"$3\" argument(s)."; shift 4; return_value=1; fi;;
		gt) if [ "$2" -gt "$3" ]; then :; else logger__log_errors "Invalid argument count \"$2\" to \"$4\". Expected greater than \"$3\" argument(s)."; shift 4; return_value=1; fi;;
		ge) if [ "$2" -ge "$3" ]; then :; else logger__log_errors "Invalid argument count \"$2\" to \"$4\". Expected greater than or equal to \"$3\" argument(s)."; shift 4; return_value=1; fi;;
		or) if [ "$2" -eq "$3" ] || [ "$2" -eq "$4" ]; then :; else logger__log_errors "Invalid argument count \"$2\" to \"$5\". Expected \"$3\" or \"$4\" argument(s)."; shift 5; return_value=1; fi;;
		between) if [ "$2" -ge "$3" ] && [ "$2" -le "$4" ]; then :; else logger__log_errors "Invalid argument count \"$2\" to \"$5\". Expected between \"$3\" and \"$4\" (inclusive) argument(s)."; shift 5; return_value=1; fi;;
		*) logger__log_errors "The comparison \"$1\" while running \"shell__arg__validate_argument_count\" is invalid"; return 1;;
	esac

	[ $return_value -eq 0 ] && return 0

	if [ $# -gt 0 ]; then
		shell__arg__print_arguments_string "$@" || return $?
	fi

	return $return_value

}
