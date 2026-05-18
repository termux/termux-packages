# shellcheck shell=bash

termux_pkg_get_update_method() {
	local source_url="$1"

	# shellcheck source=/dev/null
	# If the package has an explicit $TERMUX_PKG_UPDATE_METHOD make sure we know about it.
	TERMUX_PKG_UPDATE_METHOD="$(set +e +u; . "${TERMUX_PKG_BUILDER_DIR}/build.sh" &> /dev/null ; echo "${TERMUX_PKG_UPDATE_METHOD:-}")"

	# Example:
	# https://github.com/vim/vim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
	#            _="https:"
	#            _=""
	# project_host="github.com"
	#            _="vim/vim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
	local project_host
	IFS='/' read -r _ _ project_host _ <<< "${source_url}"

	# gitlab.gnome.org started responding to API requests originating from
	# GitHub Actions with HTTP 403 errors in January 2026.
	# Example command failing in GitHub Actions:
	# curl https://gitlab.gnome.org/api/v4/projects/GNOME%2Fvte/releases/permalink/latest
	# See: https://github.com/termux/termux-packages/issues/28242
	if [[ -z "${TERMUX_PKG_UPDATE_METHOD:-}" ]]; then
		if [[ "${project_host}" == "github.com" ]]; then
			TERMUX_PKG_UPDATE_METHOD="github"
		elif [[ "$source_url" == *"/-/archive/"* && "$source_url" != *"gitlab.gnome.org"* ]]; then
			TERMUX_PKG_UPDATE_METHOD="gitlab"
		else
			TERMUX_PKG_UPDATE_METHOD="repology"
		fi
	fi
	printf '%s' "${TERMUX_PKG_UPDATE_METHOD}"
}

termux_pkg_auto_update() {
	if [[ -n "${__CACHED_TAG:-}" ]]; then
		termux_pkg_upgrade_version "${__CACHED_TAG}"
		return $?
	fi

	local TERMUX_PKG_UPDATE_METHOD
	TERMUX_PKG_UPDATE_METHOD="$(termux_pkg_get_update_method "${TERMUX_PKG_SRCURL}")"
	case "$TERMUX_PKG_UPDATE_METHOD" in
		github)
			if [[ "${TERMUX_PKG_SRCURL}" != *"${TERMUX_PKG_UPDATE_METHOD}.com"* ]]; then
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
				wrong value '${TERMUX_PKG_UPDATE_METHOD}' for TERMUX_PKG_UPDATE_METHOD.
				Can be 'github', 'gitlab' or 'repology'
			EndOfError
		;;
	esac
}
