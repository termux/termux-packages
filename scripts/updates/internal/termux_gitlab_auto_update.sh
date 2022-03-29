# shellcheck shell=bash
# Default algorithm to use for packages hosted on hosts using gitlab-ci.
termux_gitlab_auto_update() {
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

	local latest_tag
	latest_tag="$(
		termux_gitlab_api_get_tag \
			"${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}" "${TERMUX_GITLAB_API_HOST}"
	)"
	# No need to check for return code `2`, since gitlab api does not implement cache control.

	if [[ -z "${latest_tag}" ]]; then
		termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	fi
	termux_pkg_upgrade_version "${pkg_epoch}${latest_tag}"
}
