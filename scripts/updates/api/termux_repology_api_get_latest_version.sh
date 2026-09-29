# shellcheck shell=bash

# NOTE: Repology sometimes returns "1.0-1" as the latest version even if "1.0" is latest.
# This happens when any of the repositories tracked by repology has specified
# "1.0-1" as the latest.
#
# For example:
# latest lua:lpeg version (as of 2021-11-20T12:21:31) is "1.0.2" but MacPorts specifies as "1.0.2-1".
# Hence repology returns "1.0.2-1" as the latest.
#
# But hopefully, all this can be avoided if TERMUX_PKG_UPDATE_VERSION_REGEXP is set.
#
termux_repology_api_get_latest_version() {
	# shellcheck source=scripts/build/termux_error_exit.sh
	declare -f termux_error_exit >/dev/null ||
		. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../../build/termux_error_exit.sh" # realpath is used to resolve symlinks.

	if [[ -z "$1" ]]; then
		termux_error_exit "Usage: ${FUNCNAME[0]} PKG_NAME"
	fi

	local tag_name
	# We are performing a key match for `$pkg` (function `$1`) in the repology data file and return its value.
	if ! tag_name="$(jq --exit-status --raw-output --arg pkg "$1" '.[$pkg] // "null"' "$TERMUX_REPOLOGY_DATA_FILE")"; then
		# If the input failed to parse log it for the issue.
		termux_error_exit <<-EndOfError
			${CI:+::group::}ERROR: Response seems to be invalid JSON.
			Codepath: ${FUNCNAME[0]}
			\`\`\`json
			$(<"$TERMUX_REPOLOGY_DATA_FILE")
			\`\`\`
			${CI:+::endgroup::}
		EndOfError

	fi

	echo "${tag_name}"
}
