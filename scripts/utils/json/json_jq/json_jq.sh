# shellcheck shell=bash

# Title:          json_jq
# Description:    A library for json `jq` utils.
# SPDX-License-Identifier: MIT
# Function-Depends: logger, shell, shell__arg



##
# Get the key value of the `<parent_key_name_filter>["<sub_key_name>"]`
# primitive key from the json file and ensure the key exists, is not
# `null`, is of the require type set in `key_type`, and optionally not
# empty.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set key value
#                          into.
# `json_label` - The label for the json file.
# `json_file` - The path to the json file.
# `json_content` - If set, then then this will be used as the `json`
#                  content to get the key value from instead of the
#                  `json_file`.
# `key_label` - The label for the key.
# `parent_key_name_filter` - The filter for the parent key.
# `sub_key_name` - The filter for the sub key.
# `valid_key_value_regex` - If set, then the key value found must
#                           match the regex set.
# `key_type` - The key type to get. Valid values are `boolean`,
#              `number` and `string`.
# `is_value_set` - If set to `true`, then it will be validated
#                  that the key is not null or empty.
# `default_value` - If `is_value_set` is not set to `true`, then the
#                   default value will be returned if the key is null
#                   or empty.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# json_jq__get_json_primitive_key_value `<output_variable_name>` \
#     `<json_label>` `<json_file>` `<json_content>` `<key_label>` \
#     `<parent_key_name_filter>` `<sub_key_name>` `<valid_key_value_regex>` \
#     `<key_type>` `<is_value_set>` `<default_value>` \
#     [`<jq_additional_command_options>`]
##
json_jq__get_json_primitive_key_value() {

    shell__arg__validate_argument_count ge $# 11 json_jq__get_json_primitive_key_value "$@" || return $?

    local output_variable_name="$1"
    local json_label="$2"
    local json_file="$3"
    local json_content="$4"
    local key_label="$5"
    local parent_key_name_filter="$6"
    local sub_key_name="$7"
    local valid_key_value_regex="$8"
    local key_type="$9"
    local is_value_set="${10}"
    local default_value="${11}"

    # Remove all arguments except `jq_additional_command_options`.
    [ $# -ge 11 ] && shift 11

    local __key_value
    local is_key_value_set_conditional=""
    local jq_filter

    shell__validate_variable_set json_file json_jq__get_json_primitive_key_value || return $?
    shell__validate_variable_set parent_key_name_filter json_jq__get_json_primitive_key_value || return $?
    shell__validate_variable_set sub_key_name json_jq__get_json_primitive_key_value || return $?

    if [[ ! "$key_type" =~ ^(boolean|number|string)$ ]]; then
        logger__log_errors "The key_type '$key_type' passed to \
'json_jq__get_json_primitive_key_value' does not equal 'boolean', 'number' or 'string'"
        return 1
    fi


    # Unset if already set.
    shell__set_variable_if_name_set "$output_variable_name" "" || return $?

    if [[ "$is_value_set" == "true" ]]; then
        is_key_value_set_conditional=' and . != null and . != ""'
    fi

    jq_filter="${parent_key_name_filter}[\"$sub_key_name\"] | select(type == \"$key_type\"$is_key_value_set_conditional"')'
    if [[ -z "$json_content" ]]; then
        __key_value="$(jq --join-output "$@" "$jq_filter" "$json_file" && printf "%s" x)" || return $?
    else
        __key_value="$(printf "%s" "$json_content" | jq --join-output "$@" "$jq_filter" && printf "%s" x)" || return $?
    fi
    __key_value="${__key_value%x}"

    if [[ -z "$__key_value" ]]; then
        if [[ "$is_value_set" == "true" ]]; then
            logger__log_errors "Failed to get $key_label key value from $json_label json file '$json_file'"
            logger__log_errors "key_value='$__key_value'"
            return 1
        else
            __key_value="$default_value"
        fi
    fi

    if [[ -n "$valid_key_value_regex" ]] && [[ ! "$__key_value" =~ $valid_key_value_regex ]]; then
        logger__log_errors "The $key_label key in $json_label json file '$json_file' is \
invalid and must match the regex \`$valid_key_value_regex\`"
        logger__log_errors "key_value='$__key_value'"
        return 1
    fi

    shell__set_variable_if_name_set "$output_variable_name" "$__key_value"

}

##
# Get the `<parent_key_name_filter>["<sub_key_name>"]` collection
# in the json file and ensure the collection key exists, is not `null`,
# is of the require type set in `collection_type`, and optionally not
# empty.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set collection
#                          value into.
# `json_label` - The label for the json file.
# `json_file` - The path to the json file.
# `json_content` - If set, then then this will be used as the `json`
#                  content to get the collection from instead of the
#                  `json_file`.
# `key_label` - The label for the collection.
# `parent_key_name_filter` - The filter for the parent key.
# `sub_key_name` - The filter for the sub key.
# `valid_sub_key_name_regex` - If set, then the `sub_key_name` must
#                              match the regex set.
# `collection_type` - The collection type to get. Valid values
#                     are `array` and `object`.
# `is_collection_set` - If set to `true`, then it will be validated
#                       that the collection is not empty.
# `jq_additional_command_options` - The optional additional command
#                                   options to pass to `jq`.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# json_jq__get_json_collection_key_value `<output_variable_name>` \
#     `<json_label>` `<json_file>` `<json_content>` `<key_label>` \
#     `<parent_key_name_filter>` `<sub_key_name>` `<valid_sub_key_name_regex>` \
#     `<collection_type>` `<is_collection_set>` `<filter_suffix>` \
#     [`<jq_additional_command_options>`]
##
json_jq__get_json_collection_key_value() {

    shell__arg__validate_argument_count ge $# 11 json_jq__get_json_collection_key_value "$@" || return $?

    local output_variable_name="$1"
    local json_label="$2"
    local json_file="$3"
    local json_content="$4"
    local key_label="$5"
    local parent_key_name_filter="$6"
    local sub_key_name="$7"
    local valid_sub_key_name_regex="$8"
    local collection_type="$9"
    local is_collection_set="${10}"
    local filter_suffix="${11}"

    # Remove all arguments except `jq_additional_command_options`.
    [ $# -ge 11 ] && shift 11

    local __collection_value
    local is_collection_set_conditional=""
    local jq_filter

    shell__validate_variable_set json_file json_jq__get_json_collection_key_value || return $?
    shell__validate_variable_set parent_key_name_filter json_jq__get_json_collection_key_value || return $?
    shell__validate_variable_set sub_key_name json_jq__get_json_collection_key_value || return $?

    if [[ "$collection_type" != "array" ]] && [[ "$collection_type" != "object" ]]; then
        logger__log_errors "The collection_type '$collection_type' passed to \
'json_jq__get_json_collection_key_value' does not equal 'array' or 'object'"
        return 1
    fi


    # Unset if already set.
    shell__set_variable_if_name_set "$output_variable_name" "" || return $?

    if [[ -n "$valid_sub_key_name_regex" ]] && [[ ! "$sub_key_name" =~ $valid_sub_key_name_regex ]]; then
        logger__log_errors "The $key_label key in $json_label json file '$json_file' is \
invalid and must match the regex \`$valid_sub_key_name_regex\`"
        return 1
    fi

    if [[ "$is_collection_set" == "true" ]]; then
        if [[ "$collection_type" == "array" ]]; then
            is_collection_set_conditional=' and . != []'
        elif [[ "$collection_type" == "object" ]]; then
            is_collection_set_conditional=' and . != {}'
        fi
    fi

    jq_filter="${parent_key_name_filter}[\"$sub_key_name\"] | select(type == \"$collection_type\"$is_collection_set_conditional"')'"$filter_suffix"
    if [[ -z "$json_content" ]]; then
        __collection_value="$(jq "$@" "$jq_filter" "$json_file")" || return $?
    else
        __collection_value="$(printf "%s" "$json_content" | jq "$@" "$jq_filter")" || return $?
    fi

    if [[ "$is_collection_set" == "true" ]] &&
        { [[ -z "$__collection_value" ]] || [[ "$__collection_value" == "null" ]]; }; then
        logger__log_errors "Failed to get $key_label $collection_type collection from $json_label json file '$json_file'"
        logger__log_errors "jq_output='$__collection_value'"
        return 1
    fi

    shell__set_variable_if_name_set "$output_variable_name" "$__collection_value"

}





##
# Get the key names of the `<parent_key_name_filter>["<sub_key_name>"]`
# object from the json file.
#
# The `keys_unsorted` filter will be used while getting the key names.
# > The `keys_unsorted` function is just like `keys`, but if the input
# is an object then the keys will not be sorted, instead the keys will
# roughly be in insertion order.
# - https://jqlang.github.io/jq/manual/#keys-keys_unsorted
#
# Duplicate key names are removed by `jq`. When attempting to get
# the value of a duplicate key, the last defined one will be returned.
# - https://github.com/jqlang/jq/issues/1636
#
# Callers must have run following for the variable name passed in
# `key_names_array_variable_name` to create a bash indexed array
# before calling this function.
# Replace `array` with the variable name passed.
# ```
# unset array
# declare -a array=()
# ```
#
#
# **Parameters:**
# `key_names_array_variable_name` - The bash indexed array name
#                                   (`declared -a`) in which to add
#                                    all the key names found.
#
# Check `json_jq__get_json_collection_key_value()` for
# parameters whose info is missing here.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# json_jq__get_json_object_key_names `<key_names_array_variable_name>` \
#     `<json_label>` `<json_file>` `<json_content>` `<key_label>` \
#     `<parent_key_name_filter>` `<sub_key_name>` `<valid_sub_key_name_regex>` \
#     `<is_collection_set>`
##
json_jq__get_json_object_key_names() {

    local return_value

    shell__arg__validate_argument_count eq $# 9 json_jq__get_json_object_key_names "$@" || return $?

    local key_names_array_variable_name="$1"
    local json_label="$2"
    local json_file="$3"
    local json_content="$4"
    local key_label="$5"
    local parent_key_name_filter="$6"
    local sub_key_name="$7"
    local valid_sub_key_name_regex="$8"
    local is_collection_set="$9"

    local collection_value
    local key_name
    #local __key_names

    shell__validate_is_indexed_bash_array "$key_names_array_variable_name" json_jq__get_json_object_key_names || return $?

    # Create `nameref` to `key_names_array_variable_name`
    # so that array syntax can be used locally.
    # - https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html
    local -n key_names_array="$key_names_array_variable_name" || return $?
    key_names_array=()


    json_jq__get_json_collection_key_value collection_value "$json_label" "$json_file" "$json_content" \
        "$key_label" \
        "$parent_key_name_filter" "$sub_key_name" "$valid_sub_key_name_regex" \
        "object" "$is_collection_set" "" || return $?

    # Get all key name values separated by a NUL `\0` character
    # with a single `jq` call and each key name to the `key_names_array`.
    return_value=0
    key_name="READ_ERROR"
    while IFS= read -d '' -r key_name; return_value=$?; [[ $return_value -eq 0 ]]; do
        key_names_array+=("$key_name")
    done < <(printf "%s" "$collection_value" | \
        jq --join-output '. | keys_unsorted | .[] | ( . + "\u0000")' || echo -n "CMD_ERROR")
    # If running `read` command failed (`READ_ERROR`), or process
    # substitution command failed (`CMD_ERROR`), or `read` command
    # had some other failure and returned with exit code `> 1`.
    # Under normal operation, `read` will unset `key_name` after
    # its last iteration when all input has been read and return
    # with exit code `1`.
    if [[ -n "${key_name:-}" ]] || [ $return_value -ne 1 ]; then
        logger__log_errors "Failed to get $key_label object key names from $json_label json file '$json_file'"
        [[ -n "${key_name:-}" ]] && logger__log_errors "Error type: '$key_name'"
        return 1
    fi

    if [[ "$is_collection_set" == "true" ]] && [[ "${#key_names_array}" -lt 1 ]]; then
        logger__log_errors "The $key_label object key names are not set in $json_label json file '$json_file'"
        return 1
    fi

    # Unset `nameref` to `key_names_array_variable_name`.
    unset -n key_names_array || return $?

    return 0

}
