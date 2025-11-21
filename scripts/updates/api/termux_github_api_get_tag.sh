# shellcheck shell=bash
termux_github_api_get_tag() {
	if [[ -z "${GITHUB_TOKEN:-}" ]]; then
		# Needed to use graphql API.
		termux_error_exit "GITHUB_TOKEN environment variable not set."
	fi

	local project tag_type filter_regex=""

	project="$(cut -d'/' -f4-5 <<<"${TERMUX_PKG_SRCURL}")"
	tag_type="$TERMUX_PKG_UPDATE_TAG_TYPE"

	if [[ -z "${tag_type}" ]]; then # If not set, then decide on the basis of url.
		if [[ "${TERMUX_PKG_SRCURL:0:4}" == "git+" ]]; then
			tag_type="newest-tag" # Get newest tag.
		else
			tag_type="latest-release-tag" # Get the latest release tag.
		fi
	fi

	if [[ "${tag_type}" == "latest-regex" ]]; then
		filter_regex="$TERMUX_PKG_UPDATE_VERSION_REGEXP"
	fi

	local jq_filter api_url="https://api.github.com"
	local -a curl_opts=(
		--silent
		--location
		--retry 10
		--retry-delay 1
		-H "Authorization: token ${GITHUB_TOKEN}"
		-H "Accept: application/vnd.github.v3+json"
		--write-out '|%{http_code}'
	)

	case "${tag_type}" in
	newest-tag)
		# We use graphql intensively so we should slowdown our requests to avoid hitting github ratelimits.
		sleep 1

		api_url="${api_url}/graphql"
		jq_filter='.data.repository.refs.edges[0].node.name'
		curl_opts+=(-X POST)
		curl_opts+=(
			-d "$(
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
		;;
	latest-release-tag)
		api_url="${api_url}/repos/${project}/releases/latest"
		jq_filter=".tag_name"
		;;

	latest-regex)
		api_url="${api_url}/repos/${project}/releases"
		jq_filter=".[].tag_name"
		;;
	*)
		termux_error_exit <<-EndOfError
			ERROR: Invalid TERMUX_PKG_UPDATE_TAG_TYPE: '${tag_type}'.
			Allowed values: 'newest-tag', 'latest-release-tag', 'latest-regex'.
		EndOfError
		;;
	esac

	local response
	response="$(curl "${curl_opts[@]}" "${api_url}")"

	local http_code
	http_code="${response##*|}"
	# Why printf "%s\n"? Because echo interpolates control characters, which jq does not like.
	response="$(printf "%s\n" "${response%|*}")"

	local tag_name=""

	case "${http_code}" in
	200)
		if tag_name="$(jq --exit-status --raw-output "${jq_filter}" <<<"${response}")"; then
			tag_name="$(sed 's/^v//' <<<"${tag_name}")"
			if [[ -n "${filter_regex}" ]]; then
				tag_name="$(grep -P "${filter_regex}" <<<"${tag_name}" | head -n 1)"
				[[ -z "${tag_name}" ]] && termux_error_exit "No tags matched regex '${filter_regex}' in '${response}'"
			fi
		else
			termux_error_exit "Failed to parse tag name from: '${response}'"
		fi
		;;
	404)
		if jq --exit-status "has(\"message\") and .message == \"Not Found\"" <<<"${response}"; then
			termux_error_exit "No '${tag_type}' found (${api_url}). Try using other options."
		else
			termux_error_exit <<-EndOfError
				ERROR: Failed to get '${tag_type}'(${api_url})'.
				Response:
				${response}
			EndOfError
		fi
		;;
	*)
		termux_error_exit <<-EndOfError
			ERROR: Failed to get '${tag_type}'(${api_url})'.
			HTTP code: ${http_code}
			Response:
			${response}
		EndOfError
		;;
	esac

	# If program control reached here and still no tag_name, then something went wrong.
	if [[ -z "${tag_name}" ]] || [[ "${tag_name}" == "null" ]]; then
		termux_error_exit <<-EndOfError
			ERROR: JQ could not find '${tag_type}'(${api_url})'.
			Response:
			${response}
			Please report this as bug.
		EndOfError
	fi

	echo "${tag_name}"
}
