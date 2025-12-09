# shellcheck shell=bash
termux_pkg_auto_update() {
	if [[ -n "${__CACHED_TAG:-}" ]]; then
		termux_pkg_upgrade_version ${__CACHED_TAG}
		return $?
	fi

	local project_host
	project_host="$(echo "${TERMUX_PKG_SRCURL}" | cut -d"/" -f3)"

	if [[ -z "${TERMUX_PKG_UPDATE_METHOD}" ]]; then
		if [[ "${project_host}" == "github.com" ]]; then
			TERMUX_PKG_UPDATE_METHOD="github"
		elif [[ "$TERMUX_PKG_SRCURL" == *"/-/archive/"* ]]; then
			TERMUX_PKG_UPDATE_METHOD="gitlab"
		else
			TERMUX_PKG_UPDATE_METHOD="repology"
		fi
	fi

	case "${TERMUX_PKG_UPDATE_METHOD}" in
		github)
			if [[ "${project_host}" != "${TERMUX_PKG_UPDATE_METHOD}.com" ]]; then
				termux_error_exit <<-EndOfError
					source url's hostname is not ${TERMUX_PKG_UPDATE_METHOD}.com, but has been
					configured to use ${TERMUX_PKG_UPDATE_METHOD}'s method.
				EndOfError
			fi
			termux_github_auto_update
		;;
		gitlab)
			termux_gitlab_auto_update
		;;
	repology)
		termux_repology_auto_update
		;;
	*)
		termux_error_exit <<-EndOfError
			ERROR: wrong value '${TERMUX_PKG_UPDATE_METHOD}' for TERMUX_PKG_UPDATE_METHOD.
			Can be 'github', 'gitlab' or 'repology'
		EndOfError
		;;
	esac
}
