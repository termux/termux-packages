# Takes in a list of GraphQL query snippets
termux_github_graphql() {
	local -a GITHUB_GRAPHQL_QUERIES=( "$@" )
	local pkg_json; pkg_json="$(jq -c -n '$ARGS.positional' --args "${__GITHUB_PACKAGES[@]}")"

	# if there are no github graphql queries to make, do nothing because otherwise this error would happen:
	# termux_github_graphql.sh: line 12: GITHUB_GRAPHQL_QUERIES[$BATCH * $BATCH_SIZE]: unbound variable
	if (( ${#GITHUB_GRAPHQL_QUERIES[@]} == 0 )); then
		return
	fi

	# Batch size for fetching tags, 100 seems to work consistently.
	local BATCH BATCH_SIZE=100
	# echo "# vim: ft=graphql" > /tmp/query-12345 # Uncomment for debugging GraphQL queries
	# echo "# $(date -Iseconds)" >> /tmp/query-12345
	for (( BATCH = 0; ${#GITHUB_GRAPHQL_QUERIES[@]} >= BATCH_SIZE * BATCH ; BATCH++ )); do

		echo "Starting batch $BATCH at: ${GITHUB_GRAPHQL_QUERIES[$BATCH * $BATCH_SIZE]//\\/}" >&2

		# JSON strings cannot contain tabs or newlines
		# so shutup shellcheck complaining about escapes in single quotes
		local QUERY

		# Start the GraphQL query with our two fragments for getting the latest tag from a release, and from refs/tags
		# These are defined only if needed.

		# _latest_release_tag returns latestRelease.tagName from the repo its querying
		grep -q '_latest_release_tag' <<< "${GITHUB_GRAPHQL_QUERIES[@]:$BATCH * $BATCH_SIZE:$BATCH_SIZE}" && {
			QUERY+="$(printf '%s\n' \
			'fragment _latest_release_tag on Repository {' \
			'  latestRelease { tagName }' \
			'}')"
		}

		# _latest_regex returns the (20) latest tags by commit date
		grep -q '_latest_regex' <<< "${GITHUB_GRAPHQL_QUERIES[@]:$BATCH * $BATCH_SIZE:$BATCH_SIZE}" && {
			QUERY+="$(printf '%s\n' \
			'fragment _latest_regex on Repository {' \
			'  refs( refPrefix: \"refs/tags/\" first: 20 orderBy: {field: TAG_COMMIT_DATE, direction: DESC}) {' \
			'    nodes { name }' \
			'  }' \
			'}')"
		}

		# _newest_tag returns the (1) newest tag by commit date
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

		# echo "# Batch: $BATCH" >> /tmp/query-12345 # Uncomment for debugging GraphQL queries
		# printf '%s' "${QUERY}"  >> /tmp/query-12345 # Uncomment for debugging GraphQL queries

		# We use graphql intensively so we should slowdown our requests to avoid hitting github ratelimits.
		sleep 5

		local response
		# Try up to 3 times to fetch the batch, GitHub's GraphQL API can be a bit unreliable at times.
		if ! response="$(printf '{ "query": "%s" }' "${QUERY//$'\n'/ }" | curl -fL \
			--retry 3 --retry-delay 5 \
			--no-progress-meter \
			-H "Authorization: token ${GITHUB_TOKEN}" \
			-H 'Accept: application/vnd.github.v3+json' \
			-H 'Content-Type: application/json' \
			-X POST \
			--data @- \
			https://api.github.com/graphql)"; then
			{
				printf '\t%s\n' \
					"Did not receive a clean API response." \
					"Need to run a manual sanity check on the response."
				if ! jq <<< "$response"; then
					printf '\t%s\n' "Doesn't seem to be valid JSON, skipping batch."
					continue
				fi
				printf '\t%s\n' "Seems to be valid JSON, let's try parsing it."
			} >&2
		fi

		unset QUERY
		ret="$(jq -r --argjson pkgs "$pkg_json" '
			.data                                          # From the data: table
			| del(.ratelimit)                              # Remove the ratelimit: table
			| to_entries[]                                 # Convert the remaining entries to an array
			| .key as $alias                               # Save key to variable
			| ($alias | ltrimstr("_") | tonumber) as $idx  # Extract iterator from bash array
			| .value | (                                   # For each .value
				.latestRelease?.tagName                    # Print out the tag name of the latest release
				// (.refs.nodes | map(.name) | join("\n")) # or of the tags
				// empty                                   # If neither exists print nothing
			) as $tag                                      # Save to variable
			| select($tag != "")                           # Filter out empty strings
			| ($pkgs[$idx] | split("/")[-1]) as $pkgName   # Get package name from bash array
			| "GIT|\($pkgName)|\($tag)"                    # Print results
			' <<< "$response" 2>/dev/null)" || {
				echo "something ain't right with this response"
			}
		# # Uncomment for debugging GraphQL queries
		# jq '.' <<< "$response" >> /tmp/query-12345
		# echo "$ret" >> /tmp/query-12345
		echo "$ret"
	done
}
