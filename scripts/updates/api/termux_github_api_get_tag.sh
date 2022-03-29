# shellcheck shell=bash
termux_github_api_get_tag() {
	if [[ -z "$1" ]]; then
		termux_error_exit <<-EndOfUsage
			Usage: ${FUNCNAME[0]} PKG_SRCURL [TAG_TYPE]
			Returns the latest tag of the given package.
		EndOfUsage
	fi

	if [[ -z "${GITHUB_TOKEN:-}" ]]; then
		# Needed to use graphql API.
		termux_error_exit "ERROR: GITHUB_TOKEN environment variable not set."
	fi

	local PKG_SRCURL="$1"
	local TAG_TYPE="${2:-}"

	local project
	project="$(echo "${PKG_SRCURL}" | cut -d'/' -f4-5)"
	project="${project%.git}"

	if [[ -z "${TAG_TYPE}" ]]; then # If not set, then decide on the basis of url.
		if [[ "${PKG_SRCURL: -4}" == ".git" ]]; then
			# Get newest tag.
			TAG_TYPE="newest-tag"
		else
			# Get the latest release tag.
			TAG_TYPE="latest-release-tag"
		fi
	fi

	local jq_filter
	local api_url="https://api.github.com"
	local -a extra_curl_opts

	if [[ "${TAG_TYPE}" == "newest-tag" ]]; then
		api_url="${api_url}/graphql"
		jq_filter='.data.repository.refs.edges[0].node.name'
		extra_curl_opts=(
			"-X POST"
			"-d $(
				cat <<-EOF | tr '\n' ' '
					{
						"query": "query {
							repository(owner: \"${project%/*}\", name: \"${project##*/}\") {
								refs(refPrefix: \"refs/tags/\", first: 1, orderBy: {
									field: TAG_COMMIT_DATE, direction: DESC
								})
								{
									edges {
										node {
											name
										}
									}
								}
							}
						}"
					}
				EOF
			)"
		)

	elif [[ "${TAG_TYPE}" == "latest-release-tag" ]]; then
		api_url="${api_url}/repos/${project}/releases/latest"
		jq_filter=".tag_name"
	else
		termux_error_exit <<-EndOfError
			ERROR: Invalid TAG_TYPE: '${TAG_TYPE}'.
			Allowed values: 'newest-tag', 'latest-release-tag'.
		EndOfError
	fi

	local response
	# shellcheck disable=SC2086 # we need expansion of ${extra_curl_opts[0]}
	response="$(
		curl --silent --location --retry 10 --retry-delay 1 \
			-H "Authorization: token ${GITHUB_TOKEN}" \
			-H "Accept: application/vnd.github.v3+json" \
			--write-out '|%{http_code}' \
			${extra_curl_opts[0]:-} \
			"${extra_curl_opts[1]:-}" \
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
				ERROR: No '${TAG_TYPE}' found (${api_url}).
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
				ERROR: Failed to get '${TAG_TYPE}'(${api_url})'.
				Response:
				${response}
			EndOfError
		fi
	else
		termux_error_exit <<-EndOfError
			ERROR: Failed to get '${TAG_TYPE}'(${api_url})'.
			HTTP code: ${http_code}
			Response:
			${response}
		EndOfError
	fi

	# If program control reached here and still no tag_name, then something went wrong.
	if [[ -z "${tag_name:-}" ]] || [[ "${tag_name}" == "null" ]]; then
		termux_error_exit <<-EndOfError
			ERROR: JQ could not find '${TAG_TYPE}'(${api_url})'.
			Response:
			${response}
			Please report this as bug.
		EndOfError
	fi

	echo "${tag_name#v}" # Remove leading 'v' which is common in version tag.
}
