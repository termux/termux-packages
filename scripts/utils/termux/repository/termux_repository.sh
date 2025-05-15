# shellcheck shell=bash

# Title:          termux_repository
# Description:    A library for Termux repository utils.



##
# Validate if `TERMUX_REPO__PACKAGE_MANAGER` variable is set to one of
# the supported Termux package managers in `TERMUX__SUPPORTED_PACKAGE_MANAGERS`.
#
#
# **Parameters:**
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__validate_termux_repo_package_manager` \
#     [`<function_name>` `<additional_error>`]
##
# FIXME:
termux_repository__validate_termux_repo_package_manager() {

    termux__validate_termux_package_manager_variable TERMUX_REPO__PACKAGE_MANAGER \
        "${1:-}" "${2:-}"

}

##
# Validate if `TERMUX_REPO__PACKAGE_FORMAT` variable is set to one of
# the supported Termux package formats in `TERMUX__SUPPORTED_PACKAGE_FORMATS`.
#
#
# **Parameters:**
# `function_name` - The function name in which validation was required.
# `additional_error` - The additional error message to append.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__validate_termux_repo_package_format` \
#     [`<function_name>` `<additional_error>`]
##
termux_repository__validate_termux_repo_package_format() {

    termux__validate_termux_package_format_variable TERMUX_REPO__PACKAGE_FORMAT \
        "${1:-}" "${2:-}"

}





##
# Set `TERMUX_REPO_*` variables from the `repo.json` file.
#.
# Check `scripts/repo.sh` file for info on the required format for
# `repo.json` file and the repo variables set.
#
#
# This function will add values for each channel to the `2` groups of
# sibling bash indexed arrays  (`declared -a`), under the names
# `TERMUX_REPO__CHANNEL_*` and `TERMUX_REPO__DISABLED_CHANNEL_*`.
# Callers must have run following for each array to create a bash
# indexed array before calling this function.
# Replace `array` with the actual variable name of the sibling array.
# ```
# unset array
# declare -a array=()
# ```
#
#
# **Parameters:**
# `repo_root_dir` - The path to the `termux-packages` repo root
#                   directory.
# `repo_json_file` - The path to the `repo.json` file.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__import_repo_signing_keys_to_keystore` \
#     `<repo_root_dir>` `<repo_json_file>`
##
termux_repository__set_repo_variables_from_repo_json_file() {

    local return_value

    shell__arg__validate_argument_count eq $# 2 termux_repository__set_repo_variables_from_repo_json_file "$@" || return $?

    local repo_root_dir="$1"
    local repo_json_file="$2"

    local i
    local key_index
    local key_name
    local key_pair
    local key_value
    local key_value_is_valid
    local key_value_regex
    local package_build_variables_object
    local properties_package_build_variable_name
    local repo_channel_component
    local repo_channel_dir
    local repo_channel_distribution
    local repo_channel_is_disabled
    local repo_channel_name
    local repo_channel_object
    local repo_channel_url
    local repo_channel_url_set=""
    local repo_json_object
    local repo_package_build_variable_name
    local repo_pkg_format
    local termux_regex__absolute_path='^(/[^/]+)+$'
    local termux_regex__rootfs_or_absolute_path='^((/)|((/[^/]+)+))$'
    local termux_regex__app_package_name="^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$"

    local -a key_names_array=()
    local -a repo_channel_dirs=()
    local -a signing_key_names=()

    # Unset if already set.
    TERMUX_REPO__PACKAGE_MANAGER=""
    TERMUX_REPO__PACKAGE_FORMAT=""
    TERMUX_REPO_APP__PACKAGE_NAME=""
    TERMUX_REPO_APP__DATA_DIR=""
    TERMUX_REPO__PROJECT_DIR=""
    TERMUX_REPO__CORE_DIR=""
    TERMUX_REPO__APPS_DIR=""
    TERMUX_REPO__ROOTFS=""
    TERMUX_REPO__HOME=""
    TERMUX_REPO__PREFIX=""
    TERMUX_REPO__CHANNELS_URL_SET=""
    TERMUX_REPO__CHANNEL_DIRS=()
    TERMUX_REPO__CHANNEL_NAMES=()
    TERMUX_REPO__CHANNEL_DISTRIBUTIONS=()
    TERMUX_REPO__CHANNEL_COMPONENTS=()
    TERMUX_REPO__CHANNEL_URLS=()
    TERMUX_REPO__DISABLED_CHANNEL_DIRS=()
    TERMUX_REPO__DISABLED_CHANNEL_NAMES=()

    shell__validate_variable_set repo_root_dir termux_repository__set_repo_variables_from_repo_json_file || return $?
    file__validate_regular_file_variable repo_json_file termux_repository__set_repo_variables_from_repo_json_file || return $?
    shell__validate_bash_array_set TERMUX__SUPPORTED_PACKAGE_MANAGERS_TO_PACKAGE_FORMAT_MAP termux_repository__set_repo_variables_from_repo_json_file || return $?
    shell__validate_bash_array_set TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP termux_repository__set_repo_variables_from_repo_json_file || return $?


    logger__log 1 "Setting repo variables from 'repo.json' file"

    # Read the root object of the 'repo.json' file into `repo_json_object`.
    # The `repo_json_object` variable is used for further `jq` commands
    # so that time is not wasted to read the 'repo.json' file from disk.
    termux_repository__get_repo_json_object repo_json_object "$repo_json_file" || return $?



    # Read `repo__package_manager` key.
    json_jq__get_json_primitive_key_value TERMUX_REPO__PACKAGE_MANAGER \
        repo "$repo_json_file" "$repo_json_object" \
        "repo package manager" \
        "." "repo__package_manager" "" \
        "string" "false" "apt" || return $?
    termux_repository__validate_termux_repo_package_manager termux_repository__set_repo_variables_from_repo_json_file || return $?

    TERMUX_REPO__PACKAGE_FORMAT="${TERMUX__SUPPORTED_PACKAGE_MANAGERS_TO_PACKAGE_FORMAT_MAP["$TERMUX_REPO__PACKAGE_MANAGER"]}"
    termux_repository__validate_termux_repo_package_format termux_repository__set_repo_variables_from_repo_json_file || return $?

    logger__log 3 "TERMUX_REPO__PACKAGE_MANAGER='$TERMUX_REPO__PACKAGE_MANAGER'"
    logger__log 3 "TERMUX_REPO__PACKAGE_FORMAT='$TERMUX_REPO__PACKAGE_FORMAT'"



    # Read `channels` object.
    # Get the directory for each repo channel and loop on it.
    termux_repository__get_repo_channels_dirs repo_channel_dirs "$repo_json_file" "$repo_json_object" || return $?
    i=0
    for repo_channel_dir in "${repo_channel_dirs[@]}"; do
        termux_repository__validate_repo_channel_dir "$repo_root_dir" \
            "$repo_json_file" "$repo_channel_dir" || return $?
        termux_repository__get_repo_channel_object repo_channel_object \
            "$repo_json_file" "$repo_json_object" "$repo_channel_dir" || return $?

        # Read all `string` key values separated by a NUL `\0` character
        # with a single `jq` call to save time and then set each
        # respective variable.
        # The `signing_key_names` array key value is read in its own
        # `case` statement.
        key_index=1
        key_value="READ_ERROR"
        return_value=0
        while IFS= read -d '' -r key_value; return_value=$?; [[ $return_value -eq 0 ]]; do
            case "$key_index" in
                1) repo_channel_is_disabled="$key_value";;
                2) repo_channel_name="$key_value";;
                3) repo_channel_url="$key_value";;
                4) repo_channel_distribution="$key_value";;
                5) repo_channel_component="$key_value";;
                *) break;;
            esac
            key_index=$((key_index + 1))
        done < <(printf "%s" "$repo_channel_object" | \
            jq --join-output '. | [.is_disabled, .name, .url, .distribution, .component][] | ( . + "\u0000")' || echo -n "CMD_ERROR")
        # If running `read` command failed (`READ_ERROR`), or process
        # substitution command failed (`CMD_ERROR`), or `read` command
        # had some other failure and returned with exit code `> 1`.
        # Under normal operation, `read` will unset `key_value` after
        # its last iteration when all input has been read and return
        # with exit code `1`.
        if [[ -n "${key_value:-}" ]] || [ $return_value -ne 1 ]; then
            logger__log_errors "Failed to get 'channels[\"$repo_channel_dir\"]' object key values from repo json file '$repo_json_file'"
            [[ -n "${key_value:-}" ]] && logger__log_errors "Error type: '$key_value'"
            return 1
        fi

        if [[ "$repo_channel_is_disabled" == "true" ]]; then
            TERMUX_REPO__DISABLED_CHANNEL_DIRS+=("$repo_channel_dir")
            key_names_array=("name")
        else
            TERMUX_REPO__CHANNEL_DIRS+=("$repo_channel_dir")
            key_names_array=("name" "url" "distribution" "component" "signing_key_names")
        fi

        # The arrays should store empty string instead of
        # `null` for `test -z` checks.
        [[ "$repo_channel_url" == "null" ]] && repo_channel_url=""


        # The order of keys is necessary so that 'url` key is updated/
        # validated before other keys as later keys check if repo url is set.
        for key_name in "${key_names_array[@]}"; do
            # The distribution, component and url keys may not be set if repo is not published by a fork.
            key_value_is_valid="true"
            key_value_regex=""
            case "$key_name" in
                name)
                    key_value="$repo_channel_name"
                    key_value_regex='^[a-zA-Z0-9._-]+$'

                    if [[ ! "$key_value" =~ $key_value_regex ]] || [[ "$key_value" == "null" ]]; then
                        key_value_is_valid="false"
                    fi
                    ;;
                url)
                    key_value="$repo_channel_url"
                    key_value_regex='^https?://.+$'

                    if [[ -n "$key_value" ]]; then
                        repo_channel_url_set="true"
                        if [[ ! "$key_value" =~ $key_value_regex ]]; then
                            key_value_is_valid="false"
                        fi
                    fi
                    ;;
                distribution|component)
                    if [[ "$key_name" == "distribution" ]]; then
                        key_value="$repo_channel_distribution"
                    elif [[ "$key_name" == "component" ]]; then
                        key_value="$repo_channel_component"
                    fi
                    key_value_regex='^[a-zA-Z0-9._-]+$'

                    # The arrays should store empty string instead of
                    # `null` for `test -z` checks.
                    [[ "$key_value" == "null" ]] && key_value=""

                    if [[ -n "$repo_channel_url" ]]; then
                        if [[ -n "$key_value" ]]; then
                            if [[ ! "$key_value" =~ $key_value_regex ]]; then
                                key_value_is_valid="false"
                            fi
                        else
                            logger__log_errors "The '$key_name' key for '$repo_channel_dir' \
repo channel object in repo json file '$repo_json_file' is not set while 'url' key is set to '$repo_channel_url'"
                            logger__log_errors "The value must match the regex \`$key_value_regex\`"
                            return 1
                        fi
                    else
                        # Only add value if repo channel url is set.
                        key_value=""
                    fi
                    ;;
                signing_key_names)
                    if [[ -n "$repo_channel_url" ]]; then
                        # At least one singing key config must exist for
                        # a repo channel if repo url is set, so `true`
                        # is passed for `is_collection_set`.
                        json_jq__get_json_collection_key_value - repo \
                            "$repo_json_file" "$repo_channel_object" \
                            "'$repo_channel_dir' repo channel object 'signing_key_names'" \
                            "." "signing_key_names" "" \
                            "array" "true" " | .[]" --raw-output || return $?
                    fi
                    ;;
                *)
                    logger__log_errors "Unhandled repo channel object key_name '$key_name'"
                    return 1
                    ;;
            esac

            if [[ "$key_value_is_valid" == "false" ]]; then
                logger__log_errors "The '$key_name' key for '$repo_channel_dir' \
repo channel object in repo json file '$repo_json_file' does not exist or is not valid"
                logger__log_errors "The value must match the regex \`$key_value_regex\`"
                logger__log_errors "value='$key_value'"
                return 1
            fi

            if [[ "$repo_channel_is_disabled" == "true" ]]; then
                [[ "$key_name" == "name" ]] && TERMUX_REPO__DISABLED_CHANNEL_NAMES+=("$key_value")
            else
                [[ "$key_name" == "name" ]] && TERMUX_REPO__CHANNEL_NAMES+=("$key_value")
                [[ "$key_name" == "distribution" ]] && TERMUX_REPO__CHANNEL_DISTRIBUTIONS+=("$key_value")
                [[ "$key_name" == "component" ]] && TERMUX_REPO__CHANNEL_COMPONENTS+=("$key_value")
                [[ "$key_name" == "url" ]] && TERMUX_REPO__CHANNEL_URLS+=("$key_value")
            fi
        done

        i=$((i + 1))
    done

    if [[ "$repo_channel_url_set" == "true" ]]; then
        TERMUX_REPO__CHANNELS_URL_SET="true"
    else
         TERMUX_REPO__CHANNELS_URL_SET="false"
    fi


    logger__log 3 "TERMUX_REPO__CHANNEL_DIRS='${TERMUX_REPO__CHANNEL_DIRS[*]}'"
    logger__log 3 "TERMUX_REPO__CHANNEL_NAMES='${TERMUX_REPO__CHANNEL_NAMES[*]}'"
    logger__log 3 "TERMUX_REPO__CHANNEL_DISTRIBUTIONS='${TERMUX_REPO__CHANNEL_DISTRIBUTIONS[*]}'"
    logger__log 3 "TERMUX_REPO__CHANNEL_COMPONENTS='${TERMUX_REPO__CHANNEL_COMPONENTS[*]}'"
    logger__log 3 "TERMUX_REPO__CHANNEL_URLS='${TERMUX_REPO__CHANNEL_URLS[*]}'"
    logger__log 3 "TERMUX_REPO__DISABLED_CHANNEL_DIRS='${TERMUX_REPO__DISABLED_CHANNEL_DIRS[*]}'"
    logger__log 3 "TERMUX_REPO__DISABLED_CHANNEL_NAMES='${TERMUX_REPO__DISABLED_CHANNEL_NAMES[*]}'"
    logger__log 3 "TERMUX_REPO__CHANNELS_URL_SET='$TERMUX_REPO__CHANNELS_URL_SET'"



    # Read `signing_keys` object.
    # If repo channel url is set, then `signing_keys` object must be
    # set, so `true` is passed for `is_collection_set`.
    # We do not validate the sub keys, that is done by
    # `termux_repository__import_repo_signing_keys_to_keystore` if its
    # required to download repo metadata to reduce execution time of
    # this function.
    if [[ "$repo_channel_url_set" == "true" ]]; then
        return_value=0
        termux_repository__get_repo_signing_keys signing_key_names \
            "$repo_json_file" "$repo_json_object" "true" || return_value=$?
        if [ $return_value -ne 0 ]; then
            logger__log_errors "Failed to get 'signing_keys' object key names from repo json file."
            logger__log_errors "The 'signing_keys' key in repo json file must be set to a \
json object containing config for each repo channel signing keys set in 'signing_key_names' key."
            return $return_value
        fi
    fi



    # Read `package_build_variables` object.
    if [[ "$repo_channel_url_set" == "true" ]]; then
        termux_repository__get_package_build_variables_object package_build_variables_object \
            "$repo_json_file" "$repo_json_object" || return $?

        # Read all `string` properties package build variable key
        # names and values defined in `key_names_filter` in the format
        # `<key_name>=<key_value>` separated by a NUL `\0` character
        # with a single `jq` call to save time and then set and
        # validate each respective repo package build variable defined
        # by the mapping in `TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP`.
        key_names_filter=""
        for properties_package_build_variable_name in "${!TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP[@]}"; do
            [[ -n "$key_names_filter" ]] && key_names_filter+=", "
            key_names_filter+="\"${properties_package_build_variable_name}=\" + .${properties_package_build_variable_name}"
        done
        #logger__log 1 "key_names_filter='$key_names_filter'"

        key_index=1
        key_pair="READ_ERROR"
        return_value=0
        while IFS= read -d '' -r key_pair; return_value=$?; [[ $return_value -eq 0 ]]; do
            properties_package_build_variable_name="${key_pair%%=*}"
            key_value="${key_pair#*=}"

            repo_package_build_variable_name="${TERMUX_REPO__PACKAGE_BUILD_VARIABLES_MAP["$properties_package_build_variable_name"]:-}"
            shell__validate_variable_set repo_package_build_variable_name termux_repository__set_repo_variables_from_repo_json_file \
                " for properties package build variable '$properties_package_build_variable_name'" || return $?
            shell__set_variable "$repo_package_build_variable_name" "$key_value" || return $?

            # Re-read value to ensure it was set.
            key_value="${!repo_package_build_variable_name:-}"
            key_value_regex=""
            logger__log 3 "$repo_package_build_variable_name='$key_value'"
            case "$repo_package_build_variable_name" in
                TERMUX_REPO_APP__PACKAGE_NAME) key_value_regex="$termux_regex__app_package_name" ;;
                TERMUX_REPO_APP__DATA_DIR) key_value_regex="$termux_regex__absolute_path" ;;
                TERMUX_REPO__PROJECT_DIR) key_value_regex="$termux_regex__rootfs_or_absolute_path" ;;
                TERMUX_REPO__CORE_DIR) key_value_regex="$termux_regex__absolute_path" ;;
                TERMUX_REPO__APPS_DIR) key_value_regex="$termux_regex__absolute_path" ;;
                TERMUX_REPO__ROOTFS) key_value_regex="$termux_regex__absolute_path" ;;
                TERMUX_REPO__HOME) key_value_regex="$termux_regex__absolute_path" ;;
                TERMUX_REPO__PREFIX) key_value_regex="$termux_regex__absolute_path" ;;
                *)
                    logger__log_errors "Unhandled repo package build variable '$repo_package_build_variable_name'"
                    return 1
                    ;;
            esac

            if [[ -n "$key_value_regex" ]] && [[ ! "$key_value" =~ $key_value_regex ]]; then
                logger__log_errors "The '$properties_package_build_variable_name' \
key for 'package_build_variables' object in repo json file '$repo_json_file' \
does not exist or is not valid"
                logger__log_errors "The value must match the regex \`$key_value_regex\`"
                logger__log_errors "value='$key_value'"
                return 1
            fi
        done < <(printf "%s" "$package_build_variables_object" | \
            jq --join-output '. | ['"$key_names_filter"'][] | ( . + "\u0000")' || echo -n "CMD_ERROR")
        if [[ -n "${key_pair:-}" ]] || [ $return_value -ne 1 ]; then
            logger__log_errors "Failed to get 'package_build_variables' \
object key values from repo json file '$repo_json_file'"
            [[ -n "${key_pair:-}" ]] && logger__log_errors "Error type: '$key_pair'"
            return 1
        fi
    fi

}





##
# Import repository signing keys to local keystore for each repo
# channel whose repo `url` key is set by reading the array defined in
# the `signing_key_names` key of the channel config and then finding
# the singing key config for each key name in the array from the
# `signing_keys` object in the top level object of the `repo.json`
# file, and then importing the key if not already imported.
#
# For all keys imported for a channel, a newline separated signing key
# names and fingerprints list in the format
# `${signing_key_name}:${signing_key_fingerprint}` is generated and
# is set to the `repo_channel_dir` key of the
# `TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS` bash
# associative array.
# The `repo_channel_dir` key value can then be used during repo files
# verifying to validate that the keys defined in the `repo.json`
# were the ones that were used to verify the file signature and not
# some other key in the local keystore.
#
# Currently, only `gpg` keys are supported, and they are imported by
# `termux_repository__import_repo_gpg_signing_key_to_keystore()`
# function and files are verified with the
# `termux_repository__verify_repo_gpg_signing_key` function, which
# accepts the `signing_key_names_and_fingerprints` argument for
# newline separated signing key names and fingerprints list.
#
# Check the `termux_repository__set_repo_variables_from_repo_json_file()`
# function for more info on the requirements for the `signing_key_names`
# key of the channel config and the `signing_keys` object.
#
#
# **Parameters:**
# `repo_root_dir` - The path to the `termux-packages` repo root
#                   directory.
# `repo_json_file` - The path to the `repo.json` file.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__import_repo_signing_keys_to_keystore` `<repo_root_dir>` \
#     `<repo_json_file>`
##
termux_repository__import_repo_signing_keys_to_keystore() {

    local return_value

    shell__arg__validate_argument_count eq $# 2 termux_repository__import_repo_signing_keys_to_keystore "$@" || return $?

    local repo_root_dir="$1"
    local repo_json_file="$2"

    local key_file
    local key_file_original
    local key_index
    local key_value
    local repo_channel_dir
    local repo_channel_object
    local repo_channel_name
    local repo_channel_url
    local repo_json_object
    local signing_key_error_label
    local signing_key_fingerprint
    local signing_key_name
    local signing_key_name_regex
    local signing_key_names
    local signing_key_names_and_fingerprints
    local signing_key_object
    local signing_key_names_array_string

    local -a repo_channel_dirs=()
    local -a signing_key_names=()
    local -A signing_keys_already_processed_all=()
    local -A signing_keys_already_processed_cur=()
    local -A signing_key_objects_array=()
    local -a signing_key_names_array=()

    TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS=()

    shell__validate_variable_set repo_root_dir termux_repository__import_repo_signing_keys_to_keystore || return $?
    file__validate_regular_file_variable repo_json_file termux_repository__set_repo_variables_from_repo_json_file || return $?


    logger__log 1 "Importing packages repo signing keys to keystore"

    if [[ "$TERMUX_REPO__CHANNELS_URL_SET" != "true" ]]; then
        logger__log_errors "Cannot import packages repo signing keys \
to keystore as none of the repo channels in 'repo.json' file have a \
repo url set."
            return 1
    fi

    # Read the root object of the repo json file into `repo_json_object`.
    # The `repo_json_object` variable is used for further `jq` commands
    # so that time is not wasted to read the repo json file from disk.
    termux_repository__get_repo_json_object repo_json_object "$repo_json_file" || return $?


    # Get the json for each signing key object and add it to the signing_key_objects_array
    termux_repository__get_repo_signing_keys signing_key_names \
        "$repo_json_file" "$repo_json_object" "true" || return $?
    for signing_key_name in "${signing_key_names[@]}"; do
        termux_repository__get_repo_signing_key_object signing_key_object \
            "$repo_json_file" "$repo_json_object" "$signing_key_name" || return $?

        signing_key_objects_array["$signing_key_name"]="$signing_key_object"
    done

    # Get the directory for each repo channel and loop on it.
    termux_repository__get_repo_channels_dirs repo_channel_dirs \
        "$repo_json_file" "$repo_json_object" || return $?
    for repo_channel_dir in "${repo_channel_dirs[@]}"; do
        termux_repository__validate_repo_channel_dir "$repo_root_dir" \
            "$repo_json_file" "$repo_channel_dir" || return $?
        termux_repository__get_repo_channel_object repo_channel_object \
            "$repo_json_file" "$repo_json_object" "$repo_channel_dir" || return $?


        # Read all `string` key values separated by a NUL `\0` character
        # with a single `jq` call to save time and then set each
        # respective variable.
        # The `signing_key_names` array key value is read in its own
        # `case` statement.
        key_index=1
        key_value="READ_ERROR"
        return_value=0
        while IFS= read -d '' -r key_value; return_value=$?; [[ $return_value -eq 0 ]]; do
            case "$key_index" in
                1) repo_channel_is_disabled="$key_value";;
                2) repo_channel_name="$key_value";;
                3) repo_channel_url="$key_value";;
                *) break;;
            esac
            key_index=$((key_index + 1))
        done < <(printf "%s" "$repo_channel_object" | \
            jq --join-output '. | [.is_disabled, .name, .url][] | ( . + "\u0000")' || echo -n "CMD_ERROR")
        # If running `read` command failed (`READ_ERROR`), or process
        # substitution command failed (`CMD_ERROR`), or `read` command
        # had some other failure and returned with exit code `> 1`.
        # Under normal operation, `read` will unset `key_value` after
        # its last iteration when all input has been read and return
        # with exit code `1`.
        if [[ -n "${key_value:-}" ]] || [ $return_value -ne 1 ]; then
            logger__log_errors "Failed to get '$repo_channel_dir' repo channel object key values from repo json file '$repo_json_file'"
            [[ -n "${key_value:-}" ]] && logger__log_errors "Error type: '$key_value'"
            return 1
        fi


        # If repo is disabled, then ignore importing signing key.
        if [[ "$repo_channel_is_disabled" == "true" ]]; then
            continue
        fi

        if [[ ! "$repo_channel_name" =~ ^[a-zA-Z0-9._-]+$ ]] || [[ "$repo_channel_name" == "null" ]]; then
            logger__log_errors "The repo channel name for repo channel directory \
'$repo_channel_dir' in repo json file '$repo_json_file' is not set or is not valid"
            logger__log_errors "repo_channel_name='$repo_channel_name'"
            return 1
        fi

        # If repo url is not set, then ignore importing signing key.
        if [[ -z "$repo_channel_url" ]] || [[ "$repo_channel_url" == "null" ]]; then
            logger__log 1 "Ignoring to import '$repo_channel_name' \
repo channel signing keys as its url is not set"
            continue
        fi


        # At least one singing key config must exist for a repo channel
        # if repo url is set, so `true` is passed for `is_collection_set`.
        json_jq__get_json_collection_key_value signing_key_names_array_string repo \
            "$repo_json_file" "$repo_channel_object" \
            "'$repo_channel_name' repo 'signing_key_names'" \
            "." "signing_key_names" "" \
            "array" "true" " | .[]" --raw-output || return $?

        # Create an array of jsons and loop on it.
        readarray -t signing_key_names_array < <(printf "%s" "$signing_key_names_array_string")
        signing_keys_already_processed_cur=()
        signing_key_names_and_fingerprints=""
        for signing_key_name in "${signing_key_names_array[@]}"; do
            signing_key_name_regex='^[a-zA-Z0-9._-]+$'
            if [[ ! "$signing_key_name" =~ $signing_key_name_regex ]] || [[ "$signing_key_name" == "null" ]]; then
                logger__log_errors "The signing key name '$signing_key_name' of \
'$repo_channel_name' repo channel in repo json file '$repo_json_file' is not valid"
                logger__log_errors "The signing key name must match the regex \`$signing_key_name_regex\`"
                logger__log_errors "signing_key_names_array_string=\`$signing_key_names_array_string\`"
                return 1
            fi

            # If signing key of current channel was already processed
            # before.
            if [[ -n "${signing_keys_already_processed_cur["$signing_key_name"]:-}" ]]; then
                logger__log_errors "The signing key name '$signing_key_name' of \
'$repo_channel_name' repo channel in repo json file '$repo_json_file' defined more than once"
                logger__log_errors "signing_key_names: '${signing_key_names_array[*]}'"
                return 1
            fi

            # If signing key of current channel was shared with another
            # channel already processed, then just add its fingerprint
            # to `signing_key_names_and_fingerprints` and continue.
            if [[ -n "${signing_keys_already_processed_all["$signing_key_name"]:-}" ]]; then
                #logger__log 1 "Ignoring already added signing key '$signing_key_name' of '$repo_channel_name' repo channel"
                [[ -n "$signing_key_names_and_fingerprints" ]] && signing_key_names_and_fingerprints+=$'\n'
                signing_key_names_and_fingerprints+="${signing_key_name}:${signing_keys_already_processed_all["$signing_key_name"]}"
                continue
            fi

            logger__log 1 "Processing signing key '$signing_key_name' of '$repo_channel_name' repo channel"

            signing_key_error_label="signing key '$signing_key_name' of \
'$repo_channel_name' repo channel in repo json file '$repo_json_file'"

            signing_key_object="${signing_key_objects_array["$signing_key_name"]:-}"
            if [[ -z "$signing_key_object" ]]; then
                logger__log_errors "No config exists for $signing_key_error_label"
                return 1
            fi

            key_file="$(printf "%s" "$signing_key_object" | jq --join-output ".key_file" && printf "%s" x)" || return $?
            key_file="${key_file%x}"

            if [[ -z "$key_file" ]] || [[ "$key_file" == "null" ]]; then
                logger__log_errors "The 'key_file' key for \
$signing_key_error_label does not exist or is not set"
                logger__log_errors "signing_key_object: $signing_key_object"
                return 1
            fi

            if [[ "$key_file" == "/"* ]]; then
                logger__log_errors "The key file '$key_file' for \
$signing_key_error_label is not set to a relative path and starts with a slash '/' instead."
                logger__log_errors "signing_key_object: $signing_key_object"
                return 1
            fi

            key_file_original="$key_file"
            key_file="$repo_root_dir/$key_file"

            if [[ ! -f "$key_file" ]]; then
                logger__log_errors "The key file '$key_file_original' for \
$signing_key_error_label does not exist at path '$key_file'"
                logger__log_errors "signing_key_object: $signing_key_object"
                return 1
            fi

            termux_repository__import_repo_gpg_signing_key_to_keystore signing_key_fingerprint \
                "$key_file" "$signing_key_error_label" || return $?
            if [[ -z "$signing_key_fingerprint" ]]; then
                logger__log_errors "The 'termux_repository__import_repo_gpg_signing_key_to_keystore' \
function did not return fingerprint of key file '$key_file' for $signing_key_error_label" 1>&2
                return 1
            fi

            [[ -n "$signing_key_names_and_fingerprints" ]] && signing_key_names_and_fingerprints+=$'\n'
            signing_key_names_and_fingerprints+="${signing_key_name}:${signing_key_fingerprint}"

            signing_keys_already_processed_all["$signing_key_name"]="$signing_key_fingerprint"
            signing_keys_already_processed_cur["$signing_key_name"]="$signing_key_fingerprint"
        done

        # shellcheck disable=SC2034
        TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS["$repo_channel_dir"]="$signing_key_names_and_fingerprints"

        #logger__log 1 "$repo_channel_name signing_key_names_and_fingerprints:"$'\n'"$signing_key_names_and_fingerprints"
    done

}



##
# Import the `gpg` `key_file` into the local keystore if not already
# imported. The trust level of the key will be set to `ultimate`
# **only if** the key was not already imported.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set the
#                          the fingerprint of the `gpg` signing key
#                          file into.
# `key_file` - The `gpg` signing key file to import.
# `signing_key_error_label` - The path to the `repo.json` file.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__import_repo_gpg_signing_key_to_keystore` `<output_variable_name>` \
#     `<key_file>` `<signing_key_error_label>`
##
termux_repository__import_repo_gpg_signing_key_to_keystore() {

    shell__arg__validate_argument_count eq $# 3 termux_repository__import_repo_gpg_signing_key_to_keystore "$@" || return $?

    local output_variable_name="$1"
    local key_file="$2"
    local signing_key_error_label="$3"

    local __signing_key_fingerprint

    shell__validate_variable_set key_file termux_repository__import_repo_gpg_signing_key_to_keystore || return $?
    shell__validate_variable_set signing_key_error_label termux_repository__import_repo_gpg_signing_key_to_keystore || return $?


    # Unset if already set.
    shell__set_variable "$output_variable_name" "" || return $?

    # Extract fingerprint for primary singing key from field 10 of
    # `fpr` row. The `fbr` entries for secondary keys may also be
    # logged after primary key, so we get first matched row.
    # - https://github.com/gpg/gnupg/blob/gnupg-2.5.0/doc/DETAILS#description-of-the-fields
    # The `--quiet` flag is passed to suppress the unrelated
    # `checking the trustdb` and `next trustdb check due at yy-mm-dd`
    # related messages that are occasionally logged.
    __signing_key_fingerprint="$(gpg --show-keys --with-colons --quiet "$key_file" | \
        awk -F':' '$1=="fpr"{print $10}' | head -n 1)" || return $?
    if [[ ! "$__signing_key_fingerprint" =~ ^[0-9A-Z]{40}$ ]]; then
        logger__log_errors "Failed to get fingerprint of key file '$key_file' for $signing_key_error_label"
        logger__log_errors "signing_key_fingerprint='$__signing_key_fingerprint'"
        return 1
    fi

    gpg --list-keys "$__signing_key_fingerprint" > /dev/null 2>&1 || {
        logger__log 1 "Importing key file '$key_file' with fingerprint '$__signing_key_fingerprint'"
        gpg --import "$key_file" || return $?
        gpg --no-tty --command-file <(echo -e "trust\n5\ny")  --edit-key "$__signing_key_fingerprint" || return $?
    }

    shell__set_variable "$output_variable_name" "$__signing_key_fingerprint"

}

##
# Verify a signed file against the signing keys currently imported
# into the local keystore.
#
# - https://manpages.debian.org/testing/gpg/gpg.1.en.html#verify
#
#
# **Parameters:**
# `label` - The label for the signed file.
# `signing_key_names_and_fingerprints` - The optional newline
#                     separated signing key names and fingerprints
#                     list in the format
#                     `${signing_key_name}:${signing_key_fingerprint}`
#                     that should be used to validate that the
#                     that files are verified against a key whose
#                     fingerprint exists in the list and not some
#                     other key in the keystore.
#                     Set to an empty string if validation should
#                     not be done.
# `detached_signature_file` - The optional detached signature file.
# `signed_data_file` - The signed data file to verify. If
#                      `detached_signature_file` is not passed, then
#                      the specified file is expected to include a
#                      complete signature.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__verify_repo_gpg_signing_key` `<label>` \
#     `<signing_key_names_and_fingerprints>` \
#     [`<detached_signature_file>`] `<signed_data_file>`
##
termux_repository__verify_repo_gpg_signing_key() {

    shell__arg__validate_argument_count or $# 3 4 termux_repository__verify_repo_gpg_signing_key "$@" || return $?

    local label="$1"
    local signing_key_names_and_fingerprints="$2"
    shift 2

    local gpg_output
    local signing_key_fingerprints
    local signing_key_fingerprints_regex

    # `gpg` logs verification output to `stderr`.
    gpg_output="$(gpg --verify "$@" 2>&1)" || return $?
    logger__log 1 "$gpg_output"

    if [[ -z "$signing_key_names_and_fingerprints" ]]; then
        return 0
    fi

    if [[ -n "$(printf "%s" "$signing_key_names_and_fingerprints" | \
            grep -vE "^[a-zA-Z0-9._-]+:[0-9A-Z]{40}$" || true)" ]]; then
        logger__log_errors "The $label expected signing key fingerprints are \
invalid while running 'termux_repository__verify_repo_gpg_signing_key'"
        return 1
    fi

    signing_key_fingerprints="$(printf "%s" "$signing_key_names_and_fingerprints" | \
        sed -E "s/^[a-zA-Z0-9._-]+://g")" || return $?

    signing_key_fingerprints_regex="^gpg: .*using .*key .*((${signing_key_fingerprints//$'\n'/")|("}))$"
    if ! printf "%s" "$gpg_output" | grep -qE "$signing_key_fingerprints_regex"; then
        logger__log_errors "The $label file was not verified against its expected \
signing key fingerprints:"$'\n'"$signing_key_names_and_fingerprints"
        return 1
    fi

    return 0

}





##
# Get the root object from the `repo.json` file.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set the root
#                          object into.
# `repo_json_file` - The path to the `repo.json` file.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__get_repo_json_object` `<output_variable_name>` \
#     `<repo_json_file>`
##
termux_repository__get_repo_json_object() {

    local return_value

    shell__arg__validate_argument_count eq $# 2 termux_repository__get_repo_json_object "$@" || return $?

    local output_variable_name="$1"
    local repo_json_file="$2"

    local __repo_json_object


    # Unset if already set.
    shell__set_variable_if_name_set "$output_variable_name" "" || return $?

    return_value=0
    __repo_json_object="$(jq '. | select(type == "object" and . != {})' "$repo_json_file")" || return_value=$?
    if [ $return_value -ne 0 ]; then
        logger__log_errors "Failed to parse repo json file '$repo_json_file'."
        return $return_value
    fi

    if [[ -z "$__repo_json_object" ]] || [[ "$__repo_json_object" == "null" ]]; then
        logger__log_errors "Failed to get the root object of repo json file '$repo_json_file'"
        logger__log_errors "repo_json_object='$__repo_json_object'"
        return 1
    fi

    shell__set_variable_if_name_set "$output_variable_name" "$__repo_json_object"

}



##
# Get the repo channels directories from the `repo.json` file set as
# the key names of the `channels` object.
#
#
# **Parameters:**
# `key_names_array_variable_name` - The bash indexed array name
#                                   (`declared -a`) in which to add
#                                    all the key names found.
# `repo_json_file` - The path to the `repo.json` file.
# `repo_json_object` - The optional content of the `repo.json` file.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__get_repo_channels_dirs` `<output_variable_name>` \
#     `<repo_json_file>` `<repo_json_object>`
##
termux_repository__get_repo_channels_dirs() {

    shell__arg__validate_argument_count eq $# 3 termux_repository__get_repo_channels_dirs "$@" || return $?

    local key_names_array_variable_name="$1"
    local repo_json_file="$2"
    local repo_json_object="$3"

    json_jq__get_json_object_key_names "$key_names_array_variable_name" \
        repo "$repo_json_file" "$repo_json_object" \
        "repo 'channels'" \
        "." "channels" "" \
        "true"

}

##
# Get the repo channel object in the `repo.json` file set as the sub
# key of a `channels` object.
#
# At least one repo channel config must exist.
# The repo channel directory value must match the regex
# `^[a-zA-Z0-9._-]+(/[a-zA-Z0-9._-]+)*$`.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set the
#                          repo channel object into.
# `repo_json_file` - The path to the `repo.json` file.
# `repo_json_object` - The optional content of the `repo.json` file.
# `repo_channel_dir` - The repo channel directory key whose object to
#                      get.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__get_repo_channel_object` `<output_variable_name>` \
#     `<repo_json_file>` `<repo_json_object>` `<repo_channel_dir>`
##
termux_repository__get_repo_channel_object() {

    shell__arg__validate_argument_count eq $# 4 termux_repository__get_repo_channel_object "$@" || return $?

    local output_variable_name="$1"
    local repo_json_file="$2"
    local repo_json_object="$3"
    local repo_channel_dir="$4"

    # The repo channel dirs may be expanded without quotes in the
    # codebase, so must not contain shell special characters,
    # especially whitespaces.
    local valid_repo_channel_dir_regex='^[a-zA-Z0-9._-]+(/[a-zA-Z0-9._-]+)*$'

    # At least one repo channel config must exist, so `true` is passed
    # for `is_collection_set`.
    json_jq__get_json_collection_key_value "$output_variable_name" \
        repo "$repo_json_file" "$repo_json_object" \
        "repo channel directory '$repo_channel_dir'" \
        ".channels" "$repo_channel_dir" "$valid_repo_channel_dir_regex" \
        "object" "true" "" --compact-output

}

##
# Validate the repo channel directory.
#
# The repo channel directory value must match the regex
# `^[a-zA-Z0-9._-]+(/[a-zA-Z0-9._-]+)*$` and a directory must exist
# at its path value.
#
#
# **Parameters:**
# `repo_root_dir` - The path to the `termux-packages` repo root
#                   directory.
# `repo_json_file` - The path to the `repo.json` file.
# `repo_channel_dir` - The repo channel directory to validate.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__validate_repo_channel_dir` `<repo_root_dir>` \
#     `<repo_json_file>` `<repo_channel_dir>`
##
termux_repository__validate_repo_channel_dir() {

    shell__arg__validate_argument_count eq $# 3 termux_repository__validate_repo_channel_dir "$@" || return $?

    local repo_root_dir="$1"
    local repo_json_file="$2"
    local repo_channel_dir="$3"

    local repo_channel_dir_original
    local valid_repo_channel_dir_regex='^[a-zA-Z0-9._-]+(/[a-zA-Z0-9._-]+)*$'

    shell__validate_variable_set repo_root_dir termux_repository__validate_repo_channel_dir || return $?


    if [[ ! "$repo_channel_dir" =~ $valid_repo_channel_dir_regex ]]; then
        logger__log_errors "The repo channel directory '$repo_channel_dir' key \
in repo json file '$repo_json_file' is invalid and must match the regex \
\`$valid_repo_channel_dir_regex\`"
        return 1
    fi

    repo_channel_dir_original="$repo_channel_dir"
    repo_channel_dir="$repo_root_dir/$repo_channel_dir"

    if [[ ! -d "$repo_channel_dir" ]]; then
        logger__log_errors "The repo channel directory '$repo_channel_dir_original' in \
repo json file '$repo_json_file' does not exist at path '$repo_channel_dir'"
        return 1
    fi

    return 0

}



##
# Get the repo signing keys from the `repo.json` file set as the key
# names of the `signing_keys` object.
#
#
# **Parameters:**
# `key_names_array_variable_name` - The bash indexed array name
#                                   (`declared -a`) in which to add
#                                    all the key names found.
# `repo_json_file` - The path to the `repo.json` file.
# `repo_json_object` - The optional content of the `repo.json` file.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__get_repo_signing_keys` `<output_variable_name>` \
#     `<repo_json_file>` `<repo_json_object>` `<is_collection_set>`
##
termux_repository__get_repo_signing_keys() {

    shell__arg__validate_argument_count eq $# 4 termux_repository__get_repo_signing_keys "$@" || return $?

    local key_names_array_variable_name="$1"
    local repo_json_file="$2"
    local repo_json_object="$3"
    local is_collection_set="$4"

    json_jq__get_json_object_key_names "$key_names_array_variable_name" \
        repo "$repo_json_file" "$repo_json_object" \
        "repo 'signing_keys'" \
        "." "signing_keys" "" \
        "$is_collection_set"

}

##
# Get the repo signing key object in the `repo.json` file set as
# the sub key of a `signing_keys` object.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set the
#                          signing key object into.
# `repo_json_file` - The path to the `repo.json` file.
# `repo_json_object` - The optional content of the `repo.json` file.
# `signing_key` - The repo signing key whose object to get.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__get_repo_signing_key_object` `<output_variable_name>` \
#     `<repo_json_file>` `<repo_json_object>` `<signing_key>`
##
termux_repository__get_repo_signing_key_object() {

    shell__arg__validate_argument_count eq $# 4 termux_repository__get_repo_signing_key_object "$@" || return $?

    local output_variable_name="$1"
    local repo_json_file="$2"
    local repo_json_object="$3"
    local signing_key="$4"

    # The repo signing keys may be expanded without quotes in the
    # codebase, so must not contain shell special characters,
    # especially whitespaces.
    local valid_signing_key_name_regex='^[a-zA-Z0-9._-]+$'

    json_jq__get_json_collection_key_value "$output_variable_name" \
        repo "$repo_json_file" "$repo_json_object" \
        "repo signing key '$signing_key'" \
        ".signing_keys" "$signing_key" "$valid_signing_key_name_regex" \
        "object" "true" "" --compact-output

}



##
# Get the repo package build variables from the `repo.json` file set
# as the `package_build_variables` object.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set the
#                          repo channel object into.
# `repo_json_file` - The path to the `repo.json` file.
# `repo_json_object` - The optional content of the `repo.json` file.
#
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
#
#
# `termux_repository__get_package_build_variables_object` \
#     `<output_variable_name>` `<repo_json_file>` `<repo_json_object>`
##
termux_repository__get_package_build_variables_object() {

    shell__arg__validate_argument_count eq $# 3 termux_repository__get_package_build_variables_object "$@" || return $?

    local output_variable_name="$1"
    local repo_json_file="$2"
    local repo_json_object="$3"

    # The `package_build_variables` object must be set, so `true` is
    # passed for `is_collection_set`.
    json_jq__get_json_collection_key_value "$output_variable_name" \
        repo "$repo_json_file" "$repo_json_object" \
        "package build variables" \
        "." "package_build_variables" "" \
        "object" "true" "" --compact-output

}





termux_repository__download_repo_metadata_files() {

    local return_value

    shell__arg__validate_argument_count eq $# 3 termux_repository__download_repo_metadata_files "$@" || return $?

    local repo_root_dir="$1"
    local cache_dir="$2"
    local repo_arch="$3"

    local arch
    local download_attempts
    local i
    local debian_repo_release_file
    local repo_channel_dir
    local repo_channel_component
    local repo_channel_distribution
    local repo_channel_name
    local repo_channel_url
    local repo_channel_url_base
    local repo_channel_url_id
    local repo_packages_metadata_file
    local repo_packages_metadata_file_hash
    local repo_packages_metadata_filename_prefix
    local repo_signing_key_names_and_fingerprints

    shell__validate_variable_set repo_root_dir termux_repository__download_repo_metadata_files || return $?
    shell__validate_variable_set cache_dir termux_repository__download_repo_metadata_files || return $?
    termux__validate_termux_arch_variable repo_arch "false" termux_repository__download_repo_metadata_files || return $?
    termux_repository__validate_termux_repo_package_format termux_repository__download_repo_metadata_files || return $?


    logger__log 1 "Downloading repo channels metadata files"


    for i in "${!TERMUX_REPO__CHANNEL_DIRS[@]}"; do
        repo_channel_dir="${TERMUX_REPO__CHANNEL_DIRS["$i"]}"
        repo_channel_name="${TERMUX_REPO__CHANNEL_NAMES["$i"]}"
        repo_channel_distribution="${TERMUX_REPO__CHANNEL_DISTRIBUTIONS["$i"]}"
        repo_channel_component="${TERMUX_REPO__CHANNEL_COMPONENTS["$i"]}"
        repo_channel_url="${TERMUX_REPO__CHANNEL_URLS["$i"]}"
        repo_signing_key_names_and_fingerprints="${TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS["$repo_channel_dir"]:-}"

        if [[ -z "$repo_channel_url" ]]; then
            logger__log 1 "Ignoring to download '$repo_channel_name' \
repo channel metadata files as its url is not set"
            continue
        fi

        if [[ -z "$repo_signing_key_names_and_fingerprints" ]]; then
            logger__log_errors "The signing key names and fingerprints \
not set for the '$repo_channel_dir' repo channel directory"
            return 1
        fi

        repo_channel_url_id="$(printf "%s" "$repo_channel_url" | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')"
        if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "debian" ]]; then
            repo_channel_url_base="$repo_channel_url/dists/$repo_channel_distribution"
            debian_repo_release_file="$cache_dir/$repo_arch/repo-files/${repo_channel_url_id}-${repo_channel_distribution}-Release"
            repo_packages_metadata_filename_prefix="${repo_channel_url_id}-${repo_channel_distribution}-${repo_channel_component}"
        elif [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]]; then
            repo_channel_url_base="$repo_channel_url/$repo_arch"
            repo_packages_metadata_file="$cache_dir/$repo_arch/repo-files/${repo_channel_url_id}-json"
        fi

        logger__log 1 "Downloading '$repo_channel_name' repo channel metadata files"

        mkdir -p "$cache_dir/$repo_arch/repo-files" || return $?

        download_attempts=6
        while true; do
            if [[ "$download_attempts" -lt 6 ]]; then
                if [[ "$download_attempts" -lt 1 ]]; then
                    logger__log_errors "Failed to download '$repo_channel_name' repo channel metadata files."
                    return 74 # EX__IOERR (download failure)
                fi

                logger__log 1 "Retrying download in 30 seconds ($download_attempts attempts left)..." >&2
                sleep 30
            fi

            download_attempts=$((download_attempts - 1))

            if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "debian" ]]; then
                # FIXME: add custom exit code for download failures and tmp_dir arg
                return_value=0
                termux_download "$repo_channel_url_base/Release" "$debian_repo_release_file" SKIP_CHECKSUM || return_value=$?
                if [ $return_value -ne 0 ]; then
                    [ $return_value -eq 74 ] && continue # EX__IOERR (download failure)
                    logger__log_errors "Internal failure while \
downloading '$repo_channel_name' repo channel metadata 'Release' file"
                    return $return_value
                fi

                return_value=0
                termux_download "$repo_channel_url_base/Release.gpg" "${debian_repo_release_file}.gpg" SKIP_CHECKSUM || return_value=$?
                if [ $return_value -ne 0 ]; then
                    [ $return_value -eq 74 ] && continue # EX__IOERR (download failure)
                    logger__log_errors "Internal failure while \
downloading '$repo_channel_name' repo channel repo metadata 'Release.gpg' file"
                    return $return_value
                fi

                termux_repository__verify_repo_gpg_signing_key "'$repo_channel_name' repo" \
                    "$repo_signing_key_names_and_fingerprints" \
                    "${debian_repo_release_file}.gpg" "$debian_repo_release_file" || return $?

                for arch in all "$repo_arch"; do
                    repo_packages_metadata_file_hash="$("$repo_root_dir/scripts/get_hash_from_file.py" \
                        "$debian_repo_release_file" "$arch" "$repo_channel_component")" || return $?

                    # If `<hash> <size> <repo_channel_component>/binary-<arch>/Release`
                    # entry does not exist in `Release` file, then
                    # repo probably does not contain debs for arch.
                    if [[ -n "$repo_packages_metadata_file_hash" ]]; then
                        repo_packages_metadata_file="$cache_dir/$arch/repo-files/${repo_packages_metadata_filename_prefix}-Packages"
                        mkdir -p "$cache_dir/$arch/repo-files" || return $?

                        return_value=0
                        termux_download "$repo_channel_url_base/$repo_channel_component/binary-${arch}/Packages" \
                            "$repo_packages_metadata_file" \
                            "$repo_packages_metadata_file_hash" || return_value=$?
                        if [ $return_value -ne 0 ]; then
                            [ $return_value -eq 74 ] && continue 2 # EX__IOERR (download failure)
                            logger__log_errors "Internal failure while \
downloading '$repo_channel_name' repo channel metadata 'Packages' file"
                            return $return_value
                        fi
                    fi
                done

                break

            elif [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]]; then
                return_value=0
                termux_download "$repo_channel_url_base/${repo_channel_distribution}.json" "$repo_packages_metadata_file" SKIP_CHECKSUM || return_value=$?
                if [ $return_value -ne 0 ]; then
                    [ $return_value -eq 74 ] && continue # EX__IOERR (download failure)
                    logger__log_errors "Internal failure while \
downloading '$repo_channel_name' repo channel metadata 'json' file"
                    return $return_value
                fi

                return_value=0
                termux_download "$repo_channel_url_base/${repo_channel_distribution}.json.sig" "${repo_packages_metadata_file}.sig" SKIP_CHECKSUM || return_value=$?
                if [ $return_value -ne 0 ]; then
                    [ $return_value -eq 74 ] && continue # EX__IOERR (download failure)
                    logger__log_errors "Internal failure while \
downloading '$repo_channel_name' repo channel metadata 'json.gpg' file"
                    return $return_value
                fi


                termux_repository__verify_repo_gpg_signing_key "'$repo_channel_name' repo" \
                    "$repo_signing_key_names_and_fingerprints" \
                    "${repo_packages_metadata_file}.sig" "$repo_packages_metadata_file" || return $?

                break
            fi
        done
    done

}

termux_repository__download_package_file() {

    local return_value

    shell__arg__validate_argument_count eq $# 11 termux_repository__download_package_file "$@" || return $?

    local output_variable_name="$1"
    local repo_root_dir="$2"
    local cache_dir="$3"
    local package_name_or_dir="$4"
    local package_arch="$5"
    local package_version="$6"
    local package_version_pacman="$7"
    local package_version_ignore="$8"
    local package_local_file_dir="$9"
    local allow_disabled_packages="${10}"
    local quiet_mode="${11}"

    local arch
    local i
    local package_file_hash=""
    local __package_local_file_name=""
    local package_metadata
    local package_name
    local package_label
    local package_local_file_name_regex
    local package_remote_file_path
    local package_remote_version
    local package_repo_channel_dir
    local repo_channel_dir
    local repo_channel_component
    local repo_channel_distribution
    local repo_channel_name
    local repo_channel_url
    local repo_channel_url_id
    local repo_packages_metadata_file
    local repo_packages_metadata_filename_prefix

    local -a architectures=()

    shell__validate_variable_set repo_root_dir termux_repository__download_package_file || return $?
    shell__validate_variable_set cache_dir termux_repository__download_package_file || return $?
    shell__validate_variable_set package_name_or_dir termux_repository__download_package_file || return $?
    termux__validate_termux_arch_variable package_arch "true" termux_repository__download_package_file || return $?
    shell__validate_variable_set package_version termux_repository__download_package_file || return $?
    shell__validate_variable_set package_local_file_dir termux_repository__download_package_file || return $?
    termux_repository__validate_termux_repo_package_format termux_repository__download_package_file || return $?

    if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]] && [[ "$package_version_ignore" != "true" ]]; then
        shell__validate_variable_set package_version_pacman termux_repository__download_package_file || return $?
    fi


    # Unset if already set.
    shell__set_variable "$output_variable_name" "" || return $?


    return_value=0
    termux_package__set_package_build_file_variables \
        - package_name - package_repo_channel_dir - - - \
        "$package_name_or_dir" "$repo_root_dir" "$allow_disabled_packages" || return_value=$?
    if [ $return_value -ne 0 ]; then
        logger__log_errors "Failed to download package file for package '$package_name_or_dir'"
        return $return_value
    fi


    termux_package__get_package_name_and_version_label package_label \
        "$package_name" "$package_version" "$package_version_pacman" "$package_version_ignore" || return $?

    logger__log 1 "Attempting to download package file for package '$package_label'"


    if [[ "$package_arch" == "all" ]]; then
        shell__validate_bash_array_set TERMUX__SUPPORTED_ARCHITECTURES termux_repository__download_package_file || return $?
        architectures=("${TERMUX__SUPPORTED_ARCHITECTURES[@]}")
    else
        architectures=("$package_arch")
    fi


    if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "debian" ]]; then
        package_local_file_name_regex='^[^ \t]+\.deb$'
    elif [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]]; then
        package_local_file_name_regex='^[^ \t]+\.tar\.[a-z0-9]+$'
    fi


    for i in "${!TERMUX_REPO__CHANNEL_DIRS[@]}"; do
        repo_channel_dir="${TERMUX_REPO__CHANNEL_DIRS["$i"]}"
        repo_channel_name="${TERMUX_REPO__CHANNEL_NAMES["$i"]}"
        repo_channel_distribution="${TERMUX_REPO__CHANNEL_DISTRIBUTIONS["$i"]}"
        repo_channel_component="${TERMUX_REPO__CHANNEL_COMPONENTS["$i"]}"
        repo_channel_url="${TERMUX_REPO__CHANNEL_URLS["$i"]}"

        # If not the repo channel directory for the package, then ignore.
        if [[ "$package_repo_channel_dir" != "$repo_channel_dir" ]]; then
            continue
        fi

        if [[ -z "$repo_channel_url" ]]; then
            logger__log 1 "Ignoring to download package file for package \
'$package_label' from the '$repo_channel_name' repo as its url is not set"
            return 1
        fi

        repo_channel_url_id="$(printf "%s" "$repo_channel_url" | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')"
        if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "debian" ]]; then
            repo_packages_metadata_filename_prefix="${repo_channel_url_id}-${repo_channel_distribution}-${repo_channel_component}"
        elif [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]]; then
            repo_packages_metadata_file="$cache_dir/$package_arch/repo-files/${repo_channel_url_id}-json"
        fi

        for arch in "${architectures[@]}"; do
            if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "debian" ]]; then
                repo_packages_metadata_file="$cache_dir/$arch/repo-files/${repo_packages_metadata_filename_prefix}-Packages"
                if [[ -f "$repo_packages_metadata_file" ]]; then
                    package_metadata="$("$repo_root_dir/scripts/get_hash_from_file.py" \
                        "$repo_packages_metadata_file" \
                        "$package_name" "$package_version")" || return $?

                    IFS=$'\n' read -d '' -r package_remote_file_path package_file_hash < <(printf "%s\0" "$package_metadata") || return $?

                    __package_local_file_name="$(basename "$package_remote_file_path")" || return $?
                fi

            elif [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]]; then
                if [[ -f "$repo_packages_metadata_file" ]]; then
                    if [[ "$package_version_ignore" == "true" ]]; then
                        :
                    else
                        package_remote_version="$(jq -r ".[\"$package_name\"].VERSION" "$repo_packages_metadata_file")" || return $?
                        if [[ "$package_remote_version" != "$package_version_pacman" ]]; then
                            continue
                        fi
                    fi
                    package_file_hash="$(jq -r ".[\"$package_name\"].SHA256SUM" "$repo_packages_metadata_file")" || return $?
                    package_remote_file_path="$(jq -r ".[\"$package_name\"].FILENAME" "$repo_packages_metadata_file")" || return $?
                    __package_local_file_name="$(basename "$package_remote_file_path")" || return $?
                    package_remote_file_path="$arch/$package_remote_file_path"
                fi
            fi
            if [[ -n "$package_file_hash" ]] && [[ "$package_file_hash" != "null" ]]; then
                if [[ "$quiet_mode" != "true" ]]; then
                    if [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "debian" ]]; then
                        logger__log 1 "Found '$package_label' in '$repo_channel_url/dists/$repo_channel_distribution'"
                    elif [[ "$TERMUX_REPO__PACKAGE_FORMAT" == "pacman" ]]; then
                        logger__log 1 "Found '$package_label' in '$repo_channel_url'"
                    fi
                fi
                break 2
            fi
        done

    done

    if [[ -z "$__package_local_file_name" ]]; then
        logger__log_errors "Failed to find package file name for package '$package_label' from repo metadata."
        return 69 # EX__UNAVAILABLE
    fi

    if [[ "$__package_local_file_name" == "null" ]] || \
            [[ ! "$__package_local_file_name" =~ $package_local_file_name_regex ]]; then
        logger__log_errors "The package file name '$__package_local_file_name' for \
package '$package_label' extracted from '$repo_channel_name' repo metadata is not valid."
        logger__log_errors "It must match the regex '$package_local_file_name_regex' \
if package format is '$TERMUX_REPO__PACKAGE_FORMAT'"
        return 1
    fi


    if [[ -z "$package_file_hash" ]]; then
        logger__log_errors "Failed to find package file hash for package '$package_label' from repo metadata."
        return 1
    fi

    if [[ "$package_file_hash" == "null" ]] || \
            [[ ! "$package_file_hash" =~ ^[a-zA-Z0-9]{64}$ ]]; then
        logger__log_errors "The package file hash '$package_file_hash' for \
package '$package_label' extracted from '$repo_channel_name' repo metadata is not valid."
        logger__log_errors "It must match the regex '^[a-zA-Z0-9]{64}' for a SHA256 hash."
        return 1
    fi


    # Download the package file.
    # FIXME: network__download_file
    termux_download "$repo_channel_url/$package_remote_file_path" \
        "$package_local_file_dir/$__package_local_file_name" \
        "$package_file_hash" || return $?

    shell__set_variable "$output_variable_name" "$__package_local_file_name"

}





##
# Check if packages in packages repos can be used for building, like
# as dependencies.
#
# Packages hosted by packages repos are only usable if all following
# conditions are met:
# 1. Current build package format equals repo package format.
# 2. At least one repo channel in `repo.json` file has its repo url set.
# 3. The repo package build variables in `package_build_variables`
#    object of the `repo.json` file for which packages hosted in the
#    packages repos were built for match the current package build
#    variables in the 'properties.sh' file.
#
# If packages with mismatched package build variables are downloaded,
# then the package file extraction  by
# `termux_packaging__extract_rootfs_files_from_package_file()`
# would extract files to a different prefix than the `TERMUX__PREFIX`
# defined in `properties.sh` of current build and builds would fail,
# like when looking for `-I$TERMUX__PREFIX/include` files.
#
# If a mismatch is found, then packages shouldn't be downloaded with
# package managers from packages repos either for on-device builds as
# it should be assumed that repo channels defined in `repo.json` and
# in the package managers config (like `sources.list`) on the device
# are the same or are mirrors, and have packages built with the same
# package build variables.
#
# See also `scripts/repo.sh` file.
#
#
# **Parameters:**
# `output_variable_name` - The name of the variable to set the
#                          reason why packages repos are unusable.
# `add_mismatched_variables` - Set to `true` if the list of variables
#                              that do not match are also appended to
#                              `output_variable_name`.
#
# **Returns:**
# Returns `0` if packages repos can be used.
# Returns `1` if packages repos cannot be used and the reason will be
# set in the variable set in `output_variable_name`, if any.
#
#
# `termux_repository__are_packages_in_packages_repos_usable_for_building` \
#     `<output_variable_name>` `<add_mismatched_variables>`
##
termux_repository__are_packages_in_packages_repos_usable_for_building() {

    shell__arg__validate_argument_count or $# 1 2 termux_repository__are_packages_in_packages_repos_usable_for_building "$@" || return $?

    local output_variable_name="$1"
    local add_mismatched_variables="${2:-}"

     local not_usable_due_to_different_package_format="\
current build package format '$TERMUX_PACKAGE_FORMAT' does not equal \
repo package format '$TERMUX_REPO__PACKAGE_FORMAT'."
    local not_usable_due_to_repo_urls_not_set="\
none of the repo channels in 'repo.json' file have a repo url set."
    local not_usable_due_to_mismatched_package_build_variables="\
package build variables for which packages hosted in the packages repos \
were built for do not match the current package build variables in \
the 'properties.sh' file."
    local mismatched_variables_error_prefix=" The following variables \
do not match at least:"
    local mismatched_variables_list=""
    local _not_usable_reason


    # Unset if already set.
    shell__set_variable_if_name_set "$output_variable_name" "" || return $?


    # If current build package format does not equal repo package format.
    if [[ "$TERMUX_PACKAGE_FORMAT" != "$TERMUX_REPO__PACKAGE_FORMAT" ]]; then
        shell__set_variable_if_name_set "$output_variable_name" "$not_usable_due_to_different_package_format" || return $?
        return 1
    fi


    # If no repo channel has its repo url set.
    if [[ "$TERMUX_REPO__CHANNELS_URL_SET" != "true" ]]; then
        shell__set_variable_if_name_set "$output_variable_name" "$not_usable_due_to_repo_urls_not_set" || return $?
        return 1
    fi


    # Check if package build variables in `repo.json` and `properties.sh` file mismatch.
    _not_usable_reason="$not_usable_due_to_mismatched_package_build_variables"

    shell__validate_variable_set TERMUX_REPO_APP__PACKAGE_NAME termux_repository__are_packages_in_packages_repos_usable_for_building || return $?
    shell__validate_variable_set TERMUX_REPO_APP__DATA_DIR termux_repository__are_packages_in_packages_repos_usable_for_building || return $?
    shell__validate_variable_set TERMUX_REPO__PROJECT_DIR termux_repository__are_packages_in_packages_repos_usable_for_building || return $?
    shell__validate_variable_set TERMUX_REPO__CORE_DIR termux_repository__are_packages_in_packages_repos_usable_for_building || return $?
    shell__validate_variable_set TERMUX_REPO__APPS_DIR termux_repository__are_packages_in_packages_repos_usable_for_building || return $?
    shell__validate_variable_set TERMUX_REPO__ROOTFS termux_repository__are_packages_in_packages_repos_usable_for_building || return $?
    shell__validate_variable_set TERMUX_REPO__HOME termux_repository__are_packages_in_packages_repos_usable_for_building || return $?
    shell__validate_variable_set TERMUX_REPO__PREFIX termux_repository__are_packages_in_packages_repos_usable_for_building || return $?

    if [[ "$TERMUX_REPO_APP__PACKAGE_NAME" != "${TERMUX_APP__PACKAGE_NAME:-}" ]]; then
        mismatched_variables_list+=$'\n'"TERMUX_REPO_APP__PACKAGE_NAME '$TERMUX_REPO_APP__PACKAGE_NAME' != TERMUX_APP__PACKAGE_NAME '${TERMUX_APP__PACKAGE_NAME:-}'"
    fi
    if [[ "$TERMUX_REPO_APP__DATA_DIR" != "${TERMUX_APP__DATA_DIR:-}" ]]; then
        mismatched_variables_list+=$'\n'"TERMUX_REPO_APP__DATA_DIR '$TERMUX_REPO_APP__DATA_DIR' != TERMUX_APP__DATA_DIR '${TERMUX_APP__DATA_DIR:-}'"
    fi

    # If package name or data directory was changed, then its enough
    # to log them only, instead of all their sub directories.
    if [[ -n "$mismatched_variables_list" ]]; then
        if [[ "$add_mismatched_variables" == "true" ]]; then
            _not_usable_reason+="$mismatched_variables_error_prefix$mismatched_variables_list"
        fi
        shell__set_variable_if_name_set "$output_variable_name" "$_not_usable_reason" || return $?
        return 1
    fi

    if [[ "$TERMUX_REPO__PROJECT_DIR" != "${TERMUX__PROJECT_DIR:-}" ]]; then
        mismatched_variables_list+=$'\n'"TERMUX_REPO__PROJECT_DIR '$TERMUX_REPO__PROJECT_DIR' != TERMUX__PROJECT_DIR '${TERMUX__PROJECT_DIR:-}'"
    fi
    if [[ "$TERMUX_REPO__CORE_DIR" != "${TERMUX__CORE_DIR:-}" ]]; then
        mismatched_variables_list+=$'\n'"TERMUX_REPO__CORE_DIR '$TERMUX_REPO__CORE_DIR' != TERMUX__CORE_DIR '${TERMUX__CORE_DIR:-}'"
    fi
    if [[ "$TERMUX_REPO__APPS_DIR" != "${TERMUX__APPS_DIR:-}" ]]; then
        mismatched_variables_list+=$'\n'"TERMUX_REPO__APPS_DIR '$TERMUX_REPO__APPS_DIR' != TERMUX__APPS_DIR '${TERMUX__APPS_DIR:-}'"
    fi
    if [[ "$TERMUX_REPO__ROOTFS" != "${TERMUX__ROOTFS:-}" ]]; then
        mismatched_variables_list+=$'\n'"TERMUX_REPO__ROOTFS '$TERMUX_REPO__ROOTFS' != TERMUX__ROOTFS '${TERMUX__ROOTFS:-}'"
    fi

    # If rootfs was changed, then its enough to log it only, instead
    # of all its sub directories.
    if [[ -n "$mismatched_variables_list" ]]; then
        if [[ "$add_mismatched_variables" == "true" ]]; then
            _not_usable_reason+="$mismatched_variables_error_prefix$mismatched_variables_list"
        fi
        shell__set_variable_if_name_set "$output_variable_name" "$_not_usable_reason" || return $?
        return 1
    fi

    if [[ "$TERMUX_REPO__HOME" != "${TERMUX__HOME:-}" ]]; then
        mismatched_variables_list+=$'\n'"TERMUX_REPO__HOME '$TERMUX_REPO__HOME' != TERMUX__HOME '${TERMUX__HOME:-}'"
    fi
    if [[ "$TERMUX_REPO__PREFIX" != "${TERMUX__PREFIX:-}" ]]; then
        mismatched_variables_list+=$'\n'"TERMUX_REPO__PREFIX '$TERMUX_REPO__PREFIX' != TERMUX__PREFIX '${TERMUX__PREFIX:-}'"
    fi

     if [[ -n "$mismatched_variables_list" ]]; then
        if [[ "$add_mismatched_variables" == "true" ]]; then
            _not_usable_reason+="$mismatched_variables_error_prefix$mismatched_variables_list"
        fi
        shell__set_variable_if_name_set "$output_variable_name" "$_not_usable_reason" || return $?
        return 1
    fi

    return 0

}
