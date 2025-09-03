#!/bin/bash

termux_pkg_is_update_needed() {
	# USAGE: termux_pkg_is_update_needed <current-version> <latest-version>
	if [[ -z "$1" ]] || [[ -z "$2" ]]; then
		termux_error_exit "${BASH_SOURCE[0]}: at least 2 arguments expected"
	fi

	local CURRENT_VERSION="$1"
	local LATEST_VERSION="$2"

	# Compare versions.
	# shellcheck disable=SC2091
	dpkg --compare-versions "${CURRENT_VERSION}" lt "${LATEST_VERSION}" 2> >(sed -e "s/^/$([[ "${CI-false}" == "true" ]] && echo "::warning::${TERMUX_PKG_NAME:-}: ")/" >&2)
	DPKG_EXIT_CODE=$?
	case "$DPKG_EXIT_CODE" in
	0) ;;          # true.  Update needed but we need to do additional checking.
	1) return 1 ;; # false. Update not needed.
	*) termux_error_exit "Bad 'dpkg --compare-versions' exit code: $DPKG_EXIT_CODE - bad version numbers?" ;;
	esac

	# Additional checking dpkg warns but not errors
	if ! grep -E "^[0-9]" <<< "${LATEST_VERSION}"; then
		termux_error_exit "${TERMUX_PKG_NAME} latest version '${LATEST_VERSION}' does not start with digit"
	fi
}

# Make it also usable as command line tool. `scripts/bin/apt-compare-versions` is symlinked to this file.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	declare -f termux_error_exit >/dev/null ||
		. "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/termux_error_exit.sh" # realpath is used to resolve symlinks.

	if [[ "${1}" == "--help" ]]; then
		cat <<-EOF
			Usage: $(basename "${BASH_SOURCE[0]}") [--help] <first-version> <second-version>] [version-regex]
				--help - show this help message and exit
				<first-version> - first version to compare
				<second-version> - second version to compare
				[version-regex] - optional regular expression to filter version numbers from given versions
		EOF
	fi

	# Print in human readable format.
	first_version="$1"
	second_version="$2"
	version_regexp="${3:-}"
	if [[ -n "${version_regexp}" ]]; then
		first_version="$(grep -oP "${version_regexp}" <<<"${first_version}")"
		second_version="$(grep -oP "${version_regexp}" <<<"${second_version}")"
		if [[ -z "${first_version}" ]] || [[ -z "${second_version}" ]]; then
			termux_error_exit "ERROR: Unable to parse version numbers using regexp '${version_regexp}'"
		fi
	fi
	if [[ "${first_version}" == "${second_version}" ]]; then
		echo "${first_version} = ${second_version}"
	else
		if termux_pkg_is_update_needed "${first_version}" "${second_version}"; then
			echo "${first_version} < ${second_version}"
		elif termux_pkg_is_update_needed "${second_version}" "${first_version}"; then
			echo "${first_version} > ${second_version}"
		else
			echo "${first_version} = ${second_version}"
		fi
	fi
fi
