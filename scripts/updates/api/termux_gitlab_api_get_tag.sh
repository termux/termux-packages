# shellcheck shell=bash

termux_gitlab_api_get_tag() {
	local api_host project tag_type
	tag_type="$TERMUX_PKG_UPDATE_TAG_TYPE"

	# Example:
	# https://gitlab.freedesktop.org/xorg/app/xeyes/-/archive/xeyes-${TERMUX_PKG_VERSION}/xeyes-xeyes-${TERMUX_PKG_VERSION}.tar.gz
	#        _="https:"
	#        _=""
	# api_host="gitlab.freedesktop.org"
	#  project="xorg/app/xeyes/-/archive/xeyes-${TERMUX_PKG_VERSION}/xeyes-xeyes-${TERMUX_PKG_VERSION}.tar.gz"
	IFS='/' read -r _ _ api_host project <<< "${TERMUX_PKG_SRCURL}"
	# Some projects like `xeyes` have are in a sub-namespace, e.g. 'xorg/app/xeyes' instead of 'xorg/xeyes'
	# cutting the project portion at the '/-/' is more reliable to get the project portion of the URL.
	project="${project%/-/*}"

	if [[ -z "${tag_type}" ]]; then # If not set, then decide on the basis of url.
		if [[ "${TERMUX_PKG_SRCURL:0:4}" == "git+" ]]; then
			tag_type="newest-tag" # Get newest tag.
		elif [[ -n "$TERMUX_PKG_UPDATE_VERSION_REGEXP" ]]; then
			tag_type="latest-regex" # Get the latest release tag.
		else
			tag_type="latest-release-tag" # Get the latest release tag.
		fi
	fi

	# The Gitlab API can be accessed without authentication if the repository is publicly accessible.
	# Default rate limit for Gitlab instances is 300 requests per repo, per minute,
	# for unauthenticated users and non-protected paths which should be more than enough for our needs.
	# see: https://docs.gitlab.com/administration/settings/rate_limits_on_raw_endpoints/
	local -a curl_opts=(
		-A "Termux update checker 1.1 (github.com/termux/termux-packages)"
		--silent
		--location
		--retry 10
		--retry-delay 1
		--write-out '|%{http_code}'
	)

	local jq_filter api_path
	case "${tag_type}" in
		newest-tag)
			api_path="repository/tags"
			jq_filter=".[0].name"
		;;
		latest-release-tag)
			api_path="releases/permalink/latest"
			jq_filter=".tag_name"
		;;
		latest-regex)
			api_path="repository/tags"
			jq_filter=".[].name"
		;;
		*)
			termux_error_exit <<-EndOfError
				ERROR: Invalid TERMUX_PKG_UPDATE_TAG_TYPE: '${tag_type}'.
				Allowed values: 'newest-tag', 'latest-release-tag', 'latest-regex'.
			EndOfError
		;;
	esac

	# Replace slash '/' with '%2F' in project name, as required by Gitlab's API.
	local api_url="https://${api_host}/api/v4/projects/${project//\//%2F}/${api_path}"
	local http_code response
	response="$(curl "${curl_opts[@]}" "${api_url}")"

	http_code="${response##*|}"
	# echo interpolates control characters, which jq does not like.
	response="$(printf "%s\n" "${response%|*}")"

	local tag_name=""
	case "${http_code}" in
		200)
			tag_name="$(jq --exit-status --raw-output "${jq_filter}" <<< "${response}")"
		;;
		404)
			termux_error_exit <<-EndOfError
				No '${tag_type}' found. (${api_url})
				HTTP code: ${http_code}
				Try using '$(
					if [[ "${tag_type}" == "newest-tag" ]]; then
						echo "latest-release-tag"
					else
						echo "newest-tag"
					fi
				)'.
			EndOfError
		;;
		*)
			if jq --exit-status "has(\"message\") and .message == \"Not Found\"" <<< "${response}"; then
				termux_error_exit <<-EndOfError
					No '${tag_type}' found. (${api_url})
					HTTP code: ${http_code}
					Try using '$(
						if [[ "${tag_type}" == "newest-tag" ]]; then
							echo "latest-release-tag"
						else
							echo "newest-tag"
						fi
					)'.
				EndOfError
			fi
		;;
	esac
	echo "${tag_name}"
}
