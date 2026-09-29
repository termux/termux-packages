# shellcheck shell=bash
# Default algorithm to use for packages hosted on gitlab instances.
termux_gitlab_auto_update() {
	local latest_tag
	latest_tag="$(termux_gitlab_api_get_tag)"

	if [[ -z "${latest_tag}" ]]; then
		termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	fi
	termux_pkg_upgrade_version "${latest_tag}"
}
