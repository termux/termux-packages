# shellcheck shell=bash
termux_repology_auto_update() {
	local latest_version
	latest_version="$(termux_repology_api_get_latest_version "${TERMUX_PKG_NAME}")"
	# Repology api returns null if package is not tracked by repology or is already upto date.
	if [[ "${latest_version}" == "null" ]]; then
		echo "INFO: Already up to date." # Since we exclude unique to termux packages from auto-update,
		# this package should be tracked by repology and be already up to date.
		return 0
	fi
	termux_pkg_upgrade_version "${latest_version}"
}
