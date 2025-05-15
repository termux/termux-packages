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
DATA__TAB="$(printf '\t')"

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

	printf "%s" "${1-}"

}

##
# Print a string to stdout with `printf` and append a newline.
# .
# .
# data__printfln_string `string`
##
data__printfln_string() {

	printf "%s\n" "${1-}"

}

##
# Print a literal string to stdout with `printf`.
# .
# .
# data__printf_literal_string `string`
##
data__printf_literal_string() {

	printf "${1-}"

}

##
# Print a literal string to stdout with `printf` and append a newline.
# .
# .
# data__printf_literal_string `string`
##
data__printfln_literal_string() {

	printf "${1-}\n"

}



##
# data__is_boolean `value`
##
data__is_boolean() {

	case "${1-}" in
		''|*[!0-1]*) return 1;;
		*) return 0;;
	esac

}

##
# data__validate_is_boolean `label` `value` [`error_output_variable_name`]
##
data__validate_is_boolean() {

	local label="${1-}"
	local value="${2-}"
	local error

	if ! data__is_boolean "$value"; then
		error="$label is not a valid boolean: \"$value\""
		if [ -n "${3-}" ]; then
			shell__set_variable "${3-}" "$error" || return $?
		else
			logger__log_errors "$error"
		fi
		return 1
	else
		return 0
	fi

}

##
# data__sh_convert_string_to_boolean_int `output_variable_name` `value`
##
data__sh_convert_string_to_boolean_int() {

	local __boolean_int_value="${2-}"

	# If value is a signed float
	if data__is_signed_float "$__boolean_int_value"; then
		[ "$__boolean_int_value" != "0" ] && __boolean_int_value="1"
	else
		case "$__boolean_int_value" in
			[tT][rR][uU][eE]|[yY][eE][sS]|[oO][nN]|[yY]) __boolean_int_value="1" || return $?;;
			[fF][aA][lL][sS][eE]|[nN][oO]|[oO][fF][fF]|[nN]) __boolean_int_value="0" || return $?;;
			*) return 0;; # Do not set output variable
		esac
	fi

	shell__set_variable "${1-}" "$__boolean_int_value" || return $?

}



##
# data__is_unsigned_int `value`
##
data__is_unsigned_int() {

	case "${1-}" in
		''|*[!0-9]*) return 1;;
		*) return 0;;
	esac

}

##
# data__validate_is_unsigned_int `label` `value` [`error_output_variable_name`]
##
data__validate_is_unsigned_int() {

	local label="${1-}"
	local value="${2-}"
	local error

	if ! data__is_unsigned_int "$value"; then
		error="$label is not a valid unsigned int: \"$value\""
		if [ -n "${3-}" ]; then
			shell__set_variable "${3-}" "$error" || return $?
		else
			logger__log_errors "$error"
		fi
		return 1
	else
		return 0
	fi

}



##
# data__is_signed_int `value`
##
data__is_signed_int() {

	data__is_unsigned_int "${1#-}"

}

##
# data__validate_is_signed_int `label` `value` [`error_output_variable_name`]
##
data__validate_is_signed_int() {

	local label="${1-}"
	local value="${2-}"
	local error

	if ! data__is_signed_int "$value"; then
		error="$label is not a valid signed int: \"$value\""
		if [ -n "${3-}" ]; then
			shell__set_variable "${3-}" "$error" || return $?
		else
			logger__log_errors "$error"
		fi
		return 1
	else
		return 0
	fi

}



##
# Checks if a string contains a substring.
# .
# .
# data__contains_substring `string` `substring` `"prefix"`|`"suffix"`|`""`
##
data__contains_substring() {

	local substring="${2-}"
	local position="${3-}"

	if [ "$position" = "prefix" ]; then
		case "${1-}" in
			"$substring"*) return 0;;
			*) return 1;;
		esac
	elif [ "$position" = "suffix" ]; then
		case "${1-}" in
			*"$substring") return 0;;
			*) return 1;;
		esac
	else
		case "${1-}" in
			*"$substring"*) return 0;;
			*) return 1;;
		esac
	fi

}

