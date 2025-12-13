# shellcheck shell=bash
termux_gitlab_api_get_tag() {
	local api_host project tag_type

	api_host="$(cut -d'/' -f3 <<<"${TERMUX_PKG_SRCURL}")"
	project="$(cut -d'/' -f4-5 <<<"${TERMUX_PKG_SRCURL}")"

	tag_type="$TERMUX_PKG_UPDATE_TAG_TYPE"

	if [[ -z "${tag_type}" ]]; then # If not set, then decide on the basis of url.
		if [[ "${TERMUX_PKG_SRCURL:0:4}" == "git+" ]]; then
			tag_type="newest-tag" # Get newest tag.
		else
			tag_type="latest-release-tag" # Get the latest release tag.
		fi
	fi

	local jq_filter api_path

	case "${tag_type}" in
	latest-release-tag)
		api_path="releases"
		jq_filter=".[0].tag_name"
		;;
	newest-tag)
		api_path="repository/tags"
		jq_filter=".[0].name"
		;;
	*)
		termux_error_exit <<-EndOfError
			ERROR: Invalid TERMUX_PKG_UPDATE_TAG_TYPE: '${tag_type}'.
			Allowed values: 'newest-tag', 'latest-release-tag'.
		EndOfError
		;;
	esac

	# Replace slash '/' with '%2F' in project name. It is required for Gitlab API.
	local api_url="https://${api_host}/api/v4/projects/${project//\//%2F}/${api_path}"
	# Api can be accessed without authentication if the repository is publicly accessible.
	# Default rate limit for gitlab.com is 300 requests per minute for unauthenticated users
	# and non-protected paths which should be enough for most use cases.
	# see: https://docs.gitlab.com/ee/user/gitlab_com/index.html#gitlabcom-specific-rate-limits
	local response
	response="$(
		curl --silent --location --retry 10 --retry-delay 1 \
			--write-out '|%{http_code}' \
			"${api_url}"
	)"

	local http_code
	http_code="${response##*|}"
	# Why printf "%s\n"? Because echo interpolates control characters, which jq does not like.
	response="$(printf "%s\n" "${response%|*}")"

	local tag_name

	case "${http_code}" in
	200)
		if jq --exit-status --raw-output "${jq_filter}" <<<"${response}" >/dev/null; then
			tag_name="$(jq --exit-status --raw-output "${jq_filter}" <<<"${response}")"
			tag_name="${tag_name#v}" # Strip leading 'v' which is common in version tags.
		else
			termux_error_exit "Failed to parse tag name from: '${response}'"
		fi
		;;
	404)
		if jq --exit-status "has(\"message\") and .message == \"Not Found\"" <<<"${response}"; then
			termux_error_exit "No '${tag_type}' found (${api_url}). Try using other options."
		else
			termux_error_exit <<-EndOfError
				ERROR: Failed to get '${tag_type}' (${api_url}).
				Response:
				${response}
			EndOfError
		fi
		;;
	*)
		termux_error_exit <<-EndOfError
			ERROR: Failed to get '${tag_type}' (${api_url}).
			HTTP code: ${http_code}
			Response:
			${response}
		EndOfError
		;;
	esac

	# If program control reached here and still no tag_name, then something is not right.
	if [[ -z "${tag_name:-}" ]] || [[ "${tag_name}" == "null" ]]; then
		termux_error_exit <<-EndOfError
			ERROR: JQ could not find '${tag_type}' (${api_url}).
			Response:
			${response}
			Please report this as bug.
		EndOfError
	fi

	echo "${tag_name}"
}
