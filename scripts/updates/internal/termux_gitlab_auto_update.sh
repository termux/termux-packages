# shellcheck shell=bash
# Default algorithm to use for packages hosted on hosts using gitlab-ci.
termux_gitlab_auto_update() {
	local latest_tag
	latest_tag="$(
		termux_gitlab_api_get_tag \
			"${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}" "${TERMUX_GITLAB_API_HOST}"
	)"
	if [[ -z "${latest_tag}" ]]; then
		termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	fi
	termux_pkg_upgrade_version "${latest_tag}"
}
