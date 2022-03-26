#!/bin/bash
#
# NOTE: This function returns true even when CURRENT_VERSION = "1.0" and LATEST_VERSION = "1.0-1".
# This is logically correct, but repology sometimes returns "1.0-1" as the latest version even
# if "1.0" is latest. This happens when any of the repositories tracked by repology has specified
# "1.0-1" as the latest.
#
# For example:
# latest lua:lpeg version (as of 2021-11-20T12:21:31) is "1.0.2" but MacPorts specifies as "1.0.2-1".
# Hence repology returns "1.0.2-1" as the latest.
#
# But hopefully, all this can be avoided if TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP is set.
#
termux_pkg_is_update_needed() {
	if [[ "$#" -lt 2 ]] || [[ "$#" -gt 3 ]]; then
		termux_error_exit <<-EndOfUsage
			Usage: ${FUNCNAME[0]} <current-version> <latest-version> [version-regexp]
			Returns: 0 if update is needed, 1 if not.
		EndOfUsage
	fi

	local CURRENT_VERSION="$1"
	local LATEST_VERSION="$2"
	local VERSION_REGEX="${3:-}"

	# If needed, filter version numbers from tag by using regexp.
	if [[ -n "${VERSION_REGEX}" ]]; then
		LATEST_VERSION="$(grep -oP "${VERSION_REGEX}" <<<"${LATEST_VERSION}" || true)"
	fi

	if [[ -z "${LATEST_VERSION}" ]]; then
		termux_error_exit <<-EndOfError
			ERROR: failed to check latest version. Ensure whether the version regex '${VERSION_REGEX}'
			works correctly with latest release tag.
		EndOfError
	fi

	# Translate "_" into ".": some packages use underscores to seperate
	# version numbers, but we require them to be separated by dots.
	LATEST_VERSION="${LATEST_VERSION//_/.}"

	# Compare versions.
	# shellcheck disable=SC2091
	if $(
		cat <<-EOF | python3 -
			import sys

			from pkg_resources import parse_version

			if parse_version("${CURRENT_VERSION}") < parse_version("${LATEST_VERSION}"):
			    sys.exit(0)
			else:
			    sys.exit(1)
		EOF
	); then
		return 0 # true. Update needed.
	fi
	return 1 # false. Update not needed.
}

# Make script sourceable as well as executable.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	declare -f termux_error_exit >/dev/null || . "$(dirname "${BASH_SOURCE[0]}")/termux_error_exit.sh"
	termux_pkg_is_update_needed "$@"
fi
