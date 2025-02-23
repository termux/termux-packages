# Takes in a list of GraphQL query snippets
termux_github_graphql() {
	local -a GITHUB_GRAPHQL_QUERIES=( "$@" )

	# Batch size for fetching tags, 100 seems to work consistently.
	local BATCH BATCH_SIZE=100
	for (( BATCH = 0; ${#GITHUB_GRAPHQL_QUERIES[@]} >= BATCH_SIZE * BATCH ; BATCH++ )); do

		echo "Starting batch $BATCH at: ${GITHUB_GRAPHQL_QUERIES[$BATCH * $BATCH_SIZE]//\\/}" >&2

		# JSON strings cannot contain tabs or newlines
		# so shutup shellcheck complaining about escapes in single quotes
		local QUERY

		# Start the GraphQL query with our two fragments for getting the latest tag from a release, and from refs/tags
		# These are defined only if needed, so this one is for '_latest_release_tag'
		grep -q '_latest_release_tag' <<< "${GITHUB_GRAPHQL_QUERIES[@]:$BATCH * $BATCH_SIZE:$BATCH_SIZE}" && {
			QUERY+="$(printf '%s\n' \
			'fragment _latest_release_tag on Repository {' \
			'  latestRelease { tagName }' \
			'}')"
		}

		grep -q '_newest_tag' <<< "${GITHUB_GRAPHQL_QUERIES[@]:$BATCH * $BATCH_SIZE:$BATCH_SIZE}" && {
			QUERY+="$(printf '%s\n' \
			'fragment _newest_tag on Repository {' \
			'  refs( refPrefix: \"refs/tags/\" first: 1 orderBy: {field: TAG_COMMIT_DATE, direction: DESC}) {' \
			'    nodes { name }' \
			'  }' \
			'}')"
		}

		QUERY+='query {'

		# Fill out the query body with the package repos we need to query for updates
		# Lastly fetch the rate limit utilization
		printf -v QUERY '%s\n' \
				"${QUERY}" \
				"${GITHUB_GRAPHQL_QUERIES[@]:$BATCH * $BATCH_SIZE:$BATCH_SIZE}" \
				'ratelimit: rateLimit { cost limit remaining used resetAt }' \
				'}' \

		# echo "// Batch: $BATCH" >> /tmp/query-12345 # Uncomment for debugging GraphQL queries
		# printf '%s' "${QUERY}"  >> /tmp/query-12345 # Uncomment for debugging GraphQL queries

		local response
		response="$(printf '{ "query": "%s" }' "${QUERY//$'\n'/ }" | curl -fL \
			--no-progress-meter \
			-H "Authorization: token ${GITHUB_TOKEN}" \
			-H 'Accept: application/vnd.github.v3+json' \
			-H 'Content-Type: application/json' \
			-X POST \
			--data @- \
			https://api.github.com/graphql 2>&1
		)" || termux_error_exit "ERR - termux_github_graphql: $response"


		unset QUERY
		local TAGS idx i=0
		TAGS="$(jq -r '.data            # From the data: table
			| del(.ratelimit)           # Remove the ratelimit: table
			| to_entries[]              # convert the remaining entries to an array
			| .value                    # For each .value
			| (.latestRelease?.tagName  # Print out the tag name of the latest release
			// .refs.nodes[]?.name      # or of the latest tag
			// null)' <<< "$response")" # If neither exists return null

		while IFS=$'\n' read -r idx; do
			printf 'PKG|%s|%s\n' \
				"${__GITHUB_PACKAGES[$BATCH * $BATCH_SIZE + $(( i++ ))]##*/}" \
				"${idx}"
		done <<< "$TAGS"
	done
}
