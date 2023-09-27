# shellcheck shell=bash
termux_gitlab_api_get_tag() {
	if [[ -z "$1" ]]; then
		termux_error_exit <<-EndOfUsage
			Usage: ${FUNCNAME[0]} PKG_SRCURL [TAG_TYPE] [API_HOST]
			Returns the latest tag of the given package.
		EndOfUsage

	fi
	local PKG_SRCURL="$1"
	local TAG_TYPE="${2:-}"
	local API_HOST="${3:-gitlab.com}"

	local project
	project="$(echo "${PKG_SRCURL}" | cut -d'/' -f4-5)"
	project="${project#git+}"

	if [[ -z "${TAG_TYPE}" ]]; then # If not set, then decide on the basis of url.
		if [[ "${PKG_SRCURL:0:4}" == "git+" ]]; then
			# Get newest tag.
			TAG_TYPE="newest-tag"
		else
			# Get the latest release tag.
			TAG_TYPE="latest-release-tag"
		fi
	fi

	local jq_filter
	local api_path

	case "${TAG_TYPE}" in
	latest-release-tag)
		api_path="/releases"
		jq_filter=".[0].tag_name"
		;;
	newest-tag)
		api_path="/repository/tags"
		jq_filter=".[0].name"
		;;
	*)
		termux_error_exit <<-EndOfError
			ERROR: Invalid TAG_TYPE: '${TAG_TYPE}'.
			Allowed values: 'newest-tag', 'latest-release-tag'.
		EndOfError
		;;
	esac

	# Replace slash '/' with '%2F' in project name. It is required for Gitlab API.
	local api_url="https://${API_HOST}/api/v4/projects/${project//\//%2F}${api_path}"
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
	if [[ "${http_code}" == "200" ]]; then
		if jq --exit-status --raw-output "${jq_filter}" <<<"${response}" >/dev/null; then
			tag_name="$(jq --exit-status --raw-output "${jq_filter}" <<<"${response}")"
		else
			termux_error_exit "ERROR: Failed to parse tag name from: '${response}'"
		fi
	elif [[ "${http_code}" == "404" ]]; then
		if jq --exit-status "has(\"message\") and .message == \"Not Found\"" <<<"${response}"; then
			termux_error_exit <<-EndOfError
				ERROR: No '${TAG_TYPE}' found. (${api_url})
				Try using '$(
					if [ ${TAG_TYPE} = "newest-tag" ]; then
						echo "latest-release-tag"
					else
						echo "newest-tag"
					fi
				)'.
			EndOfError
		else
			termux_error_exit <<-EndOfError
				ERROR: Failed to get '${TAG_TYPE}' (${api_url}).
				Response:
				${response}
			EndOfError
		fi
	else
		termux_error_exit <<-EndOfError
			ERROR: Failed to get '${TAG_TYPE}' (${api_url}).
			HTTP code: ${http_code}
			Response:
			${response}
		EndOfError
	fi

	# If program control reached here and still no tag_name, then something is not right.
	if [[ -z "${tag_name:-}" ]] || [[ "${tag_name}" == "null" ]]; then
		termux_error_exit <<-EndOfError
			ERROR: JQ could not find '${TAG_TYPE}' (${api_url}).
			Response:
			${response}
			Please report this as bug.
		EndOfError
	fi

	echo "${tag_name#v}" # Strip leading 'v'.
}
