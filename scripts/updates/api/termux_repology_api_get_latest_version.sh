# shellcheck shell=bash
termux_repology_api_get_latest_version() {
	if [[ -z "$1" ]]; then
		termux_error_exit "Usage: ${FUNCNAME[0]} PKG_NAME"
	fi

	if [[ ! -s "${TERMUX_REPOLOGY_DATA_FILE}" ]]; then
		pip3 install bs4 requests >/dev/null # Install python dependencies.
		python3 "${TERMUX_SCRIPTDIR}"/scripts/updates/api/dump-repology-data \
			"${TERMUX_REPOLOGY_DATA_FILE}" >/dev/null
	fi

	local PKG_NAME="$1"
	local version
	# Why `--arg`? See: https://stackoverflow.com/a/54674832/15086226
	version="$(jq -r --arg packageName "$PKG_NAME" '.[$packageName]' <"${TERMUX_REPOLOGY_DATA_FILE}")"
	echo "${version#v}"
}
