# shellcheck shell=bash
termux_repology_auto_update() {
	# Our local version of package.
	local pkg_version
	pkg_version="$(echo "${TERMUX_PKG_VERSION}" | cut -d: -f2-)"
	local pkg_epoch
	pkg_epoch="$(echo "${TERMUX_PKG_VERSION}" | cut -d: -f1)"

	if [[ "${pkg_version}" == "${pkg_epoch}" ]]; then
		# No epoch set.
		pkg_epoch=""
	else
		pkg_epoch+=":"
	fi

	local latest_version
	latest_version="$(termux_repology_api_get_latest_version "${TERMUX_PKG_NAME}")"

	# Repology api returns null if package is not tracked by repology or is already upto date.
	if [[ "${latest_version}" == "null" ]]; then
		echo "INFO: Already up to date." # Since we exclude unique to termux packages, this package
		# should be tracked by repology and be already up to date.
		return 0
	fi
	termux_pkg_upgrade_version "${pkg_epoch}${latest_version}"
}
