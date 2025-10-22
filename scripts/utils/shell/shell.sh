# shellcheck shell=bash

# Title:          shell
# Description:    A library for shell.
# License-SPDX:   MIT
# Function-Depends: logger



##
# shell__is_valid_shell_variable_name `variable_name`
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
# shell__set_variable `variable_name` `variable_value` `export_variable`
##
shell__set_variable() {

	local variable_name="${1-}"

	# If variable_name is not a valid shell variable_name
	if ! shell__is_valid_shell_variable_name "$variable_name"; then
		logger__log_errors "The variable_name \"$variable_name\" passed to \"shell__set_variable\" is not a valid shell variable name"
		return 1
	fi

	printf -v "$variable_name" "%s" "${2-}"
	#eval "$variable_name"=\"\$2\"

}

##
# shell__copy_variable `output_variable_name` `input_variable_name`
##
shell__copy_variable() {

	local output_variable_name="${1-}"
	local input_variable_name="${2-}"

	# If variable_name is not a valid shell variable_name
	if ! shell__is_valid_shell_variable_name "$output_variable_name"; then
		logger__log_errors "The output_variable_name \"$output_variable_name\" passed to \"shell__copy_variable\" is not a valid shell variable name"
		return 1
	fi

	# If variable_name is not a valid shell variable_name
	if ! shell__is_valid_shell_variable_name "$input_variable_name"; then
		logger__log_errors "The input_variable_name \"$input_variable_name\" passed to \"shell__copy_variable\" is not a valid shell variable name"
		return 1
	fi

	eval "$output_variable_name"=\"\$$input_variable_name\"

}



##
# shell__append_to_variable `variable_name` `value_to_append`
##
shell__append_to_variable() {

	local curr_value
	shell__copy_variable curr_value "${1-}" || return $?
	shell__set_variable "${1-}" "$curr_value$2" || return $?

}



##
# shell__validate_variable_set `variable_name` [`function_name` `additional_error`]
##
shell__validate_variable_set() {

	local curr_value
	shell__copy_variable curr_value "${1-}" || return $?

	if [ -z "$curr_value" ]; then
		if [ -n "${2-}" ]; then
			logger__log_errors "The $1 is not set while running \"${2-}\"${3-}"
		else
			logger__log_errors "The $1 is not set"
		fi
		return 1
	else
		return 0
	fi

}

##
# shell__validate_variable_unset `variable_name` [`function_name` `additional_error`]
##
shell__validate_variable_unset() {

	local curr_value
	shell__copy_variable curr_value "${1-}" || return $?

	if [ -n "$curr_value" ]; then
		if [ -n "${2-}" ]; then
			logger__log_errors "The $1 is set while running \"${2-}\"${3-}"
		else
			logger__log_errors "The $1 is set"
		fi
		return 1
	else
		return 0
	fi

}
