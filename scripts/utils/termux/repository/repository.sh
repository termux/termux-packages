# shellcheck shell=bash

# Title:          repository
# Description:    A library for Termux repository utils.



##
# Add repository signing keys to local keystore.
# .
# Each repo channel dict in `repo.json` file should have a
# `signing_keys` key for an array of dicts, where each dict contains
# information for each key that may be required by the parent repo
# channel. At least one signing key info must exist for each repo
# channel.
# .
# The `key_file` key should be set to the path of the key file. If it
# is a relative path that does not start a slash `/`, then
# `termux-packages` repo root directory will be prepended to it.
# .
#
# A dict is being used because other keys may be required
# in future in addition to current `key_file` key, like `key_format`, etc.
# .
# ```
# "<repo_channel_path>": {
#     "signing_keys": [
#       {
#         "key_file": "path/to/key1.gpg"
#       },
#       {
#         "key_file": "path/to/key1.gpg"
#       }
#     ]
# }
# ```
# .
# .
# **Parameters:**
# `repo_json_file` - The path to the `repo.json` file.
# `repo_root_dir` - The path to the `termux-packages` repo root
#                   directory.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# termux_repository__add_repo_signing_keys_to_keystore `<repo_json_file>`
#     `<repo_root_dir>`
##
termux_repository__add_repo_signing_keys_to_keystore() {

	local repo_json_file="$1"
	local repo_root_dir="$2"

	local gpg_keys_list
	local i
	local key_file
	local repo_channel_path
	local repo_channel_paths_list
	local signing_keys_json
	local signing_keys_json_array_string

	local -a signing_keys_json_array

	if [[ -z "$repo_json_file" ]]; then
		echo "The repo_json_file is not set that is passed to 'termux_repository__add_repo_signing_keys_to_keystore'" 1>&2
		return 1
	elif [[ ! -f "$repo_json_file" ]]; then
		echo "The repo_json_file '$repo_json_file' does not exist at path that is passed to 'termux_repository__add_repo_signing_keys_to_keystore'" 1>&2
		return 1
	fi

	# Get the paths list for each repo channel and loop on it.
	repo_channel_paths_list="$(jq --raw-output 'del(.pkg_format) | keys | .[]' "$repo_json_file")" || return $?
	for repo_channel_path in $repo_channel_paths_list; do
		# Check if `signing_keys` array exists for repo channel
		if [[ "$(jq ".[\"$repo_channel_path\"].signing_keys"' | if type=="array" then "found" else "not_found" end' "$repo_json_file")" != '"found"' ]]; then
			echo "The 'signing_keys' array in '$repo_channel_path' repo channel dict in repo json file '$repo_json_file' does not exist" 1>&2
			echo "Check 'termux_repository__add_repo_signing_keys_to_keystore()' function for more info." 1>&2
			return 1
		fi

		# Get the json for each `dict` in the the `signing_keys` array
		# of the repo channel, separated by newlines.
		signing_keys_json_array_string="$(jq --compact-output ".[\"$repo_channel_path\"].signing_keys[]" "$repo_json_file")" || return $?
		if [[ -z "$signing_keys_json_array_string" ]]; then
			echo "The 'signing_keys' array in '$repo_channel_path' repo channel dict in repo json file '$repo_json_file' is empty." 1>&2
			echo "At least one singing key info must exist for a repo channel." 1>&2
			return 1
		fi

		# Create an array of jsons and loop on it.
		readarray -t signing_keys_json_array < <(echo "$signing_keys_json_array_string")
		i=1
		for signing_keys_json in "${signing_keys_json_array[@]}"; do
			key_file=$(echo "$signing_keys_json" | jq --raw-output '.key_file')

			if [[ -z "$key_file" ]] || [[ "$key_file" == "null" ]]; then
				echo "The 'key_file' key for signing key $i of '$repo_channel_path' repo channel in repo json file '$repo_json_file' does not exist or is not set" 1>&2
				echo "signing_keys_json: $signing_keys_json" 1>&2
				return 1
			fi

			if [[ "$key_file" != "/"* ]]; then
				key_file="$repo_root_dir/$key_file"
			fi

			if [[ ! -f "$key_file" ]]; then
				echo "The key file '$key_file' for signing key $i of '$repo_channel_path' repo channel in repo json file '$repo_json_file' does not exist at path" 1>&2
				echo "signing_keys_json: $signing_keys_json" 1>&2
				return 1
			fi

			gpg_keys_list=$(gpg --show-keys "$key_file" | sed -n 2p | sed -E -e 's/^[ ]+//') || return $?
			gpg --list-keys "$gpg_keys_list" > /dev/null 2>&1 || {
				echo "Adding key file '$key_file' for signing key $i of '$repo_channel_path' repo channel in repo json file '$repo_json_file' to gpg keystore"
				gpg --import "$key_file" || return $?
				gpg --no-tty --command-file <(echo -e "trust\n5\ny")  --edit-key "$gpg_keys_list" || return $?
			}

			i=$((i + 1))
		done
	done

}
