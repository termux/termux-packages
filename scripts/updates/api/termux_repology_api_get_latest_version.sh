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
	if [[ -z "$1" ]]; then
		termux_error_exit "Usage: ${FUNCNAME[0]} PKG_NAME"
	fi

	if [[ ! -s "${TERMUX_REPOLOGY_DATA_FILE}" ]]; then
		# We should not install them in the case if python packages are externally managed.
		find /usr/lib/python3.* -name EXTERNALLY-MANAGED -print -quit | grep -q . || 
			pip3 install bs4 requests >/dev/null # Install python dependencies.
		python3 "${TERMUX_SCRIPTDIR}"/scripts/updates/api/dump-repology-data \
			"${TERMUX_REPOLOGY_DATA_FILE}" >/dev/null || \
   				echo "{}" > ${TERMUX_REPOLOGY_DATA_FILE}
	fi

	# Why `--arg`? See: https://stackoverflow.com/a/54674832/15086226; `sub` strips the leading 'v'
	jq -r --arg pkg "$1" '.[$pkg] // "null" | sub("^v";"")' "$TERMUX_REPOLOGY_DATA_FILE"
}
