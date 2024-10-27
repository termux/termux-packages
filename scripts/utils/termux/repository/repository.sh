# shellcheck shell=bash

# Title:          repository
# Description:    A library for Termux repository utils.



##
# Check that each repos specifies existing signing key names.
# .
# Each repo channel must contain a `key` key, which must store
# a list of signing key names in the `repo.json` file. The names
# of the signing keys are the keys of the `signing_keys` key,
# which are configured separately.
# .
# ```
# "<repo_channel_path>": {
#     "keys": ["signing_key1", "signing_key2"]
# }
# ```
# .
# .
# **Parameters:**
# `TERMUX_PACKAGES_DIRECTORIES` - list of package directories (repos).
# `TERMUX_REPO_KEYS` - list of signing key names for each repos.
# .
# **Returns:**
# Returns 0 if everything is ok. Otherwise, an error.
# .
# .
# TERMUX_PACKAGES_DIRECTORIES= TERMUX_REPO_KEYS= termux_repository__check_repo_keys_name
##
termux_repository__check_repo_keys_name() {
	local index=0
	local repo
	local key
	for repo in ${TERMUX_PACKAGES_DIRECTORIES}; do
		for key in ${TERMUX_REPO_KEYS[$index]}; do
			if [[ -z "$key" ]] || [[ "$key" == "null" ]]; then
				echo "The repo channel '${repo}' does not specify a list of signing keys in repo json file" 1>&2
				return 1
			fi
			if ! [[ " ${TERMUX_SIGNING_KEYS} " =~ " ${key} " ]]; then
				echo "The repo channel '${repo}' specifies non-existent signing key '${key}' in repo json file" 1>&2
				return 1
			fi
		done
		index=$((index + 1))
	done
	return 0
}



##
# Add repository signing keys to local keystore.
# .
# To store signing keys, the `signing_keys` key of the `repo.json`
# file is used. To configure (add) a signing key, you first need to
# give a name to the signing key, which will be the key of `signing_keys`,
# and then configure the following keys inside your signing key: `key_file`.
# .
# `key_file` - path to signing key file (full path or not full
# but accessible via path `TERMUX_SCRIPTDIR`).
# .
# A dict is being used because other keys may be required
# in future in addition to current `key_file` key, like `key_format`, etc.
# .
# ```
# "signing_keys": {
#     "signing_key1": {
#         "key_file": "path/to/key1.gpg"
#     },
#     "signing_key2": {
#         "key_file": "path/to/key2.gpg"
#     }
# }
# ```
# .
# .
# **Parameters:**
# `TERMUX_SIGNING_KEYS` - list of signing key names.
# `TERMUX_SIGNING_KEYS_FILE` - list of paths to the signing key file.
# `TERMUX_SCRIPTDIR` - full path to the repository directory.
# .
# **Returns:**
# Returns `0` if successful, otherwise returns with a non-zero exit code.
# .
# .
# TERMUX_SIGNING_KEYS= TERMUX_SIGNING_KEYS_FILE= TERMUX_SCRIPTDIR= termux_repository__add_repo_signing_keys_to_keystore
##
termux_repository__add_repo_signing_keys_to_keystore() {
	# The first step is to check the specified key names in repos.
	termux_repository__check_repo_keys_name

	# The second stage is adding signing keys.
	local sig_keys_array=(${TERMUX_SIGNING_KEYS})
	local gpg_keys_list
	local index
	for index in ${!sig_keys_array[@]}; do
		local sig_key="${sig_keys_array[$index]}"
		local key_file="${TERMUX_SIGNING_KEYS_FILE[$index]}"

		if [[ -z "$key_file" ]] || [[ "$key_file" == "null" ]]; then
			echo "The 'key_file' key for signing key $sig_key in repo json file does not exist or is not set" 1>&2
			return 1
		fi

		if [[ "$key_file" != "/"* ]]; then
			key_file="$TERMUX_SCRIPTDIR/$key_file"
		fi

		if [[ ! -f "$key_file" ]]; then
			echo "The key file '$key_file' for signing key $sig_key in repo json file does not exist at path" 1>&2
			return 1
		fi

		gpg_keys_list=$(gpg --show-keys "$key_file" | sed -n 2p | sed -E -e 's/^[ ]+//') || return $?
		gpg --list-keys "$gpg_keys_list" > /dev/null 2>&1 || {
			echo "Adding key file '$key_file' for signing key $sig_key in repo json file to gpg keystore"
			gpg --import "$key_file" || return $?
			gpg --no-tty --command-file <(echo -e "trust\n5\ny")  --edit-key "$gpg_keys_list" || return $?
		}
	done
}
