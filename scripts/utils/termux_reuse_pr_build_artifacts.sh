#!/bin/bash
set -euo pipefail

cd "$(realpath "$(dirname "$0")")/../.."

GITHUB_EVENT_NAME="${1:-}"
TARGET_ARCH="${2:-}"

infoexit() {
	echo "$@"
	exit 1
} >&2

# Check required variables via nameref.
for var in OLD_COMMIT HEAD_COMMIT GITHUB_TOKEN GITHUB_EVENT_NAME TARGET_ARCH; do
	[[ -n "${!var:-}" ]] || infoexit "$var is unset, not performing CI fast path"
done

graphql_request() {
	local QUERY="${1}"
	# Send GraphQL to GitHub and obtain response
	# No hard tabs or newlines allowed inside a GraphQL request,
	# since it is encoded as a JSON string this means we should also escape quotes.
	curl --silent \
		-H "Authorization: token ${GITHUB_TOKEN}" \
		-H "Accept: application/vnd.github.v3+json" \
		-H 'Content-Type: application/json' \
		-X POST \
		--data "{ \"query\": \"$(tr '\t\n' '  ' <<< "${QUERY//\"/\\\"}\"}")" \
		"https://api.github.com/graphql" \
	|| return $?
}

ci_artifact_url() {
	curl --silent \
		-H "Authorization: token ${GITHUB_TOKEN}" \
		-H "Accept: application/vnd.github.v3+json" \
		"https://api.github.com/repos/termux/termux-packages/actions/runs/${1}/artifacts" \
		| jq -r '[.artifacts[] | select(.name | startswith("debs-'"${TARGET_ARCH}"'")) | .archive_download_url][0] // empty' \
	|| return $?
}

mask_output() {
	# Print output only in the case of error
	local output status
	if ! output=$("$@" 2>&1); then
		echo "$output"
		return 1
	fi
}


mask_output git fetch origin "$OLD_COMMIT:ref/tmp/$OLD_COMMIT" || infoexit "failed to fetch $OLD_COMMIT from origin, not performing CI fast path"
readarray -t COMMITS < <(git rev-list --no-merges "$OLD_COMMIT..$HEAD_COMMIT" || :) || :

(( ${#COMMITS[*]} == 0 )) && infoexit "Unable to obtain full commit history. Not performing CI fast path."

[[ "${GITHUB_EVENT_NAME:-}" == "push" ]] && {
	# Check if we can perform CI fast path.
	# We need to make sure all commits come from a single PR,
	# and make sure buildsystem nor dependencies were changed.
	# If so we can reuse PR check artifacts and upload them to apt repo to save some CI time

	readarray -t TERMUX_PACKAGE_DIRECTORIES < <(jq --raw-output 'del(.pkg_format) | keys | .[]' repo.json) || :

	# We should obtain data about all commits in this push to check that they are from the same PR if any
	RELATED_PRS_QUERY="
	query {
		repository(owner: \"termux\", name: \"termux-packages\") {
		$(
			for commit in "${COMMITS[@]}"; do
				# Add a query for this commit with the shorthash as the label
				echo "_${commit::7}: object(oid: \"${commit}\") { ...commitWithPR }"
			done
		)
		}
	}

	fragment commitWithPR on Commit {
		associatedPullRequests(first: 1) { nodes { baseRefOid headRefOid } edges { node { title body number } } }
	}"

	RESPONSE="$(graphql_request "$RELATED_PRS_QUERY" || infoexit "Couldn't query associated PRs for commit(s), not performing CI fast path")"

	# Ensure response is valid and obtain all associated PR numbers
	readarray -t PRS < <(jq '.data.repository | to_entries[] | .value.associatedPullRequests.edges.[]?.node?.number?' <<< "$RESPONSE") \
		|| infoexit "GraphQL response is invalid, not performing CI fast path"

	# Check that all commits come from the one and only one PR, bail if not
	(( ${#PRS[*]} == 0 )) && infoexit "push does not have a linked PR, not performing CI fast path"
	(( ${#PRS[*]}	> 1 )) && infoexit "push contains commits from more than one PR, not performing CI fast path"

	read -rd' ' PR_BASE_COMMIT PR_HEAD_COMMIT PR_COMMIT_TITLE PR_COMMIT_BODY < <(jq -r '
		.data.repository[].associatedPullRequests |
			(.nodes[0].baseRefOid,
			 .nodes[0].headRefOid,
			 .edges[0].node.title,
			 .edges[0].node.body)' <<< "$RESPONSE" || :)
	[[ -n "${PR_BASE_COMMIT:-}" ]] || infoexit "failed to read associated PR base commit, not performing CI fast path"
	[[ -n "${PR_HEAD_COMMIT:-}" ]] || infoexit "failed to read associated PR head commit, not performing CI fast path"

	echo "::group::Detected PR #${#PRS[*]}: ${PR_COMMIT_TITLE}"
	echo "${PR_COMMIT_BODY}"
	echo "::endgroup::"

	PR_CI_REUSE=0
	# Check for single-commit and squashed PRs if `[ci reuse]` is in the commit message
	if [[ "${#COMMITS[*]}" -eq 1 && "$(git log -1 --pretty=format:"%s%n%b" "${COMMITS[@]}")" == *"[ci reuse]"* ]]; then
		PR_CI_REUSE=1
		echo "Commit subject or description contain [ci reuse]"
	else
		# Otherwise check linked PR title and body
		[[ "${PR_COMMIT_TITLE}${PR_COMMIT_BODY}" == *"[ci reuse]"* ]] && PR_CI_REUSE=1
		(( PR_CI_REUSE )) && echo "PR description contains [ci reuse]"
	fi

	DIRS_REGEX="$(paste -sd'|' <<< "${TERMUX_PACKAGE_DIRECTORIES[@]}")" || exit 0

	# fetch PR commit tree
	mask_output git fetch origin "$PR_BASE_COMMIT:ref/tmp/$PR_BASE_COMMIT" || infoexit "failed to fetch PR base tree, not performing CI fast path"
	mask_output git fetch origin "$PR_HEAD_COMMIT:ref/tmp/$PR_HEAD_COMMIT" || infoexit "failed to fetch PR head tree, not performing CI fast path"

	# Here we compare changes from PR with changes from push
	# this is to make sure nobody injected additional changes to PR branch after CI was invoked
	# but before we fetched data in this check with GraphQL and `git fetch`.
	# We cannot apply `git diff --no-index` to commit ranges so we are going to strip indexes manually with sed.
	diff -q \
			<(git diff "$PR_BASE_COMMIT" "$PR_HEAD_COMMIT" | sed -n -E '/^diff --git a\// { p; n; /^index /!p; b } ; p') \
			<(git diff "$OLD_COMMIT" "$HEAD_COMMIT" | sed -n -E '/^diff --git a\// { p; n; /^index /!p; b } ; p') &> /dev/null \
	|| infoexit "PR head does not match pushed commit changes, probably PR ref was force pushed right after PR was merged. Not performing CI fast path."

	# obtain the common ancestor commit where the PR diverged
	PR_MERGE_BASE="$(git merge-base "ref/tmp/$PR_BASE_COMMIT" "$HEAD_COMMIT")" || infoexit "failed to obtain PR merge base, not performing CI fast path"

	# obtain list of all files changed since this PR diverged
	readarray -t PR_BASE_TO_HEAD_CHANGED_FILES < <(
		git diff-tree --name-only -r "$PR_MERGE_BASE..$OLD_COMMIT"
	) || :

	# obtain list of all packages changed by this PR
	readarray -t PR_CHANGED_PACKAGES < <(
		git diff-tree --name-only -r "$OLD_COMMIT..$HEAD_COMMIT" \
			| grep -E "^($DIRS_REGEX)/[^/]+/" \
			| sed -E "s#^(($DIRS_REGEX)/[^/]+)/.*#\1#" \
			| sort -u
	) || :
	echo "Packages changed by this PR: ${PR_CHANGED_PACKAGES[*]:-none}"

	# obtain list of all buildsystem files changed since this PR diverged
	readarray -t PR_BASE_TO_HEAD_CHANGED_BUILDSYSTEM_FILES < <(
		grep -e "^scripts/" -e "^ndk-patches/" -e "^build-package.sh$" <<< "${PR_BASE_TO_HEAD_CHANGED_FILES[@]}"
	) || :
	echo "Buildsystem files changed since PR divergence: ${PR_BASE_TO_HEAD_CHANGED_BUILDSYSTEM_FILES[*]:-none}"

	# obtain list of all packages changes since this PR diverged
	readarray -t PR_BASE_TO_HEAD_CHANGED_PACKAGES < <(
		echo "${PR_BASE_TO_HEAD_CHANGED_FILES[@]}" \
			| grep -E "^($DIRS_REGEX)/[^/]+/" \
			| sed -E "s#^(($DIRS_REGEX)/[^/]+)/.*#\1#" \
			| sort -u
	) || :
	echo "Packages updated since PR divergence: ${PR_BASE_TO_HEAD_CHANGED_PACKAGES[*]:-none}"

	# obtain the set of all dependencies of packages changed by this PR
	readarray -t PR_CHANGED_PACKAGES_DEPS < <(
		for dep in "${PR_CHANGED_PACKAGES[@]:-}"; do
			./scripts/buildorder.py "$dep" "${TERMUX_PACKAGE_DIRECTORIES[@]}" 2>/dev/null | awk '{print $NF}'
		done | sort -u
	) || :
	echo "Dependencies changed by this PR: ${PR_CHANGED_PACKAGES_DEPS[*]:-none}"

	# obtain the set of all build dependencies changed since this PR diverged
	readarray -t PR_BASE_TO_HEAD_CHANGED_DEPS < <(
		grep -Fx \
			-f <(echo "${PR_BASE_TO_HEAD_CHANGED_PACKAGES[@]}") \
			- <<< "${PR_CHANGED_PACKAGES_DEPS[@]}"
	) || :
	echo "Dependencies of these packages changed since PR divergence: ${PR_BASE_TO_HEAD_CHANGED_DEPS[*]:-none}"

	if (( ${#PR_BASE_TO_HEAD_CHANGED_BUILDSYSTEM_FILES[*]} + ${#PR_BASE_TO_HEAD_CHANGED_DEPS[*]} + PR_CI_REUSE )); then

		# The same commit can be used in more than one PR or even push
		WORKFLOW_PR_QUERY="
		query {
			repository(owner: \"termux\", name: \"termux-packages\") {
				object(oid: \"$PR_HEAD_COMMIT\") { ...workflowRun }
			}
		}

		fragment workflowRun on Commit {
			checkSuites(first: 32) { nodes { workflowRun { event file { path } databaseId } conclusion status } }
		}"

		RESPONSE="$(graphql_request "$WORKFLOW_PR_QUERY" || infoexit "Failed to perform GraphQL request, not performing CI fast path")"

		# Obtain the most recent, related, successful `packages.yml` workflow run.
		WORKFLOW_ID="$(
			jq -r '[.data.repository.object?.checkSuites?.nodes[]?
				| select(
				.workflowRun.event == "pull_request"
				and .workflowRun.file.path == ".github/workflows/packages.yml"
				and .conclusion == "SUCCESS"
				and .status == "COMPLETED")
				| .workflowRun.databaseId][0]' <<< "$RESPONSE" || :
		)"
		if [[ -n "${WORKFLOW_ID}" ]]; then
			echo "We can safely reuse CI artifacts from https://github.com/termux/termux-packages/actions/runs/${WORKFLOW_ID}"
			echo "CI artifact URL is $(ci_artifact_url "${WORKFLOW_ID}" || infoexit "Failed to get CI artifact URL")"
		else
			echo "We can safely reuse CI artifacts, but did not find any matching CI run."
		fi
	else
		echo "It is NOT safe to reuse PR build artifact"
	fi
}

[[ "${GITHUB_EVENT_NAME:-}" == "pull_request" ]] && {
	# In the case of pull_requests we can reuse build artifacts of recent workflow runs
	# if user added more commits to existing PR after workflow finished running.
	(( ${#COMMITS[*]} > 128 )) && infoexit "Pull request has more than 128 commits, not attempting to reuse CI artifacts."

	# We intentionally do not check if workflow run is related to this specific PR
	# to allow CI reuse artifacts of other PRs in the case if current PR diverged from another PR branch.
	WORKFLOW_COMMITS_QUERY="
	query {
		repository(owner: \"termux\", name: \"termux-packages\") {
		$(
			for commit in "${COMMITS[@]}"; do
				# Add a query for this commit with the shorthash as the label
				echo "_${commit::7}: object(oid: \"${commit}\") { ...workflowRun }"
			done
		)
		}
	}

	fragment workflowRun on Commit {
		checkSuites(first: 32) { nodes { workflowRun { event file { path } databaseId } conclusion status } }
	}"

	RESPONSE="$(graphql_request "$WORKFLOW_COMMITS_QUERY" || infoexit "Failed to perform GraphQL request, not performing CI fast path")"

	# git rev-list prints commits in chronologically descending order, so we can check them as is.
	for commit in "${COMMITS[@]}"; do
		# Get the most recent successful `packages.yml` workflow run for this commit if any
		WORKFLOW_ID="$(
			jq -r '[.data.repository["_'"${commit::7}"'"].checkSuites?.nodes[]?
				| select(
					.workflowRun.event == "pull_request" and
					.workflowRun.file.path == ".github/workflows/packages.yml" and
					.conclusion == "SUCCESS" and
					.status == "COMPLETED"
				) | .workflowRun.databaseId][0] // empty' <<< "$RESPONSE"
		)"
		# No need to go on if we found a match.
		[[ -z "${WORKFLOW_ID:-}" ]] || break
	done
	if [[ -n "${WORKFLOW_ID}" ]]; then
		echo "We can safely reuse CI artifacts from https://github.com/termux/termux-packages/actions/runs/${WORKFLOW_ID}"
		echo "CI artifact URL is $(ci_artifact_url "${WORKFLOW_ID}" || infoexit "Failed to get CI artifact URL")"
	else
		echo "We can not reuse CI artifacts since no relevant CI runs were found"
	fi
}
