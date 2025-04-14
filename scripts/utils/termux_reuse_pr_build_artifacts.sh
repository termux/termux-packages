#!/bin/bash
set -euo pipefail

GITHUB_EVENT_NAME="${1:-}"
TARGET_ARCH="${2:-}"

infoexit() {
  echo "$@" >&2
  exit 0
}

# Check required variables.
for var in OLD_COMMIT HEAD_COMMIT GITHUB_TOKEN GITHUB_EVENT_NAME TARGET_ARCH; do
  [[ -n "${!var:-}" ]] || infoexit "$var is unset, not performing CI fast path"
done

graphql_request() {
  local QUERY="${1}" INFOEXIT_TEXT="${2}" RESPONSE
  # Send graphql to github and obtain response
  # No hard tabs or newlines allowed inside a graphql request, also we should escape quotes
  curl -s \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    -H 'Content-Type: application/json' \
    -X POST \
    --data "{ \"query\": \"$(tr '\t\n' '  ' <<< "${QUERY//\"/\\\"}\"}")" \
    "https://api.github.com/graphql" || infoexit "${INFOEXIT_TEXT}"
}

ci_artifact_url() {
  curl -s \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/termux/termux-packages/actions/runs/${1}/artifacts" \
    | jq -r '[.artifacts[] | select(.name | startswith("debs-'"${TARGET_ARCH}"'")) | .archive_download_url][0] // empty' \
      || infoexit "$2"
}

COMMITS="$(git rev-list --no-merges "$OLD_COMMIT..$HEAD_COMMIT" ||:)"
[[ -z "$COMMITS" ]] && infoexit "Unable to obtain full commit history. Not performing CI fast path."

if [[ "${GITHUB_EVENT_NAME:-}" == "push" ]]; then
  # Check if we can perform CI fast path
  # Here we make sure all commits come from single PR, make sure nor buildsystem nor dependencies were not changed
  # and if so we are reusing PR check artifacts and uploading them to apt repo to make save some CI time

  TERMUX_PACKAGE_DIRECTORIES="$(jq --raw-output 'del(.pkg_format) | keys | .[]' repo.json)"

  # We should obtain data about all commits in this push and make sure they all came from the same PR if any.
  RESPONSE="$(graphql_request "
  query {
    repository(owner: \"termux\", name: \"termux-packages\") {
    $(
      for commit in ${COMMITS}; do
        # Add a query for this commit with the shorthash as the label
        echo "_${commit::7}: object(oid: \"${commit}\") { ...commitWithPR }"
      done
    )
    }
  }

  fragment commitWithPR on Commit {
    associatedPullRequests(first: 1) { nodes { baseRefOid headRefOid } edges { node { title body number } } }
  }" "Failed to perform GraphQL request, not performing CI fast path")"

  # Ensure response is valid and obtain all associated PR numbers if any and make sure response is valid
  PRS="$(jq '.data.repository | to_entries[] | .value.associatedPullRequests.edges
           | (.[] // []) | (.node? // []) | (.number? // 0)' <<< "$RESPONSE")" || \
           infoexit "GraphQL response is invalid, not performing CI fast path"

  # Check if all commits come from the same PR and return if not
  [[ "$(sort -u <<< "$PRS" | wc -l)" -eq 0 ]] && infoexit "push does not have linked PR, not performing CI fast path"
  [[ "$(sort -u <<< "$PRS" | wc -l)" -eq 1 ]] || infoexit "push contains commits from more than one pull request, not performing CI fast path"

  PR_BASE_COMMIT="$(jq -r '.data.repository | to_entries[0].value.associatedPullRequests.nodes[0].baseRefOid' <<< "$RESPONSE" ||:)"
  PR_HEAD_COMMIT="$(jq -r '.data.repository | to_entries[0].value.associatedPullRequests.nodes[0].headRefOid' <<< "$RESPONSE" ||:)"
  PR_TITLE="$(jq -r '.data.repository | to_entries[0].value.associatedPullRequests.edges[0].node.title' <<< "$RESPONSE" ||:)"
  PR_BODY="$(jq -r '.data.repository | to_entries[0].value.associatedPullRequests.edges[0].node.body' <<< "$RESPONSE" ||:)"
  [[ -n "${PR_BASE_COMMIT:-}" ]] || infoexit "failed to read associated PR base commit, not performing CI fast path"
  [[ -n "${PR_HEAD_COMMIT:-}" ]] || infoexit "failed to read associated PR head commit, not performing CI fast path"

  echo "::group::Detected PR #${PRS}: ${PR_TITLE}"
  echo "${PR_BODY}"
  echo "::endgroup::"

  PR_CI_REUSE=0
  # Check if single-commit and squashed PRs have `[ci reuse]` in commit description
  if [[ "$(wc -l <<< "${COMMITS}" 2>&1)" -eq 1 && "$(git log -1 --pretty=format:"%s%n%b" "${COMMITS}")" == *"[ci reuse]"* ]]; then
    PR_CI_REUSE=1
    echo "Commit subject or description contain [ci reuse]"
  else
    # Otherwise check linked PR title and body
    [[ "${PR_TITLE}${PR_BODY}" == *"[ci reuse]"* ]] && PR_CI_REUSE=1 || PR_CI_REUSE=0
    (( PR_CI_REUSE )) && echo "PR description contains [ci reuse]"
  fi

  DIRS_REGEX="$(echo "$TERMUX_PACKAGE_DIRECTORIES" | paste -sd'|' -)" || exit 0

  # fetch PR commit tree
  git fetch origin "$PR_BASE_COMMIT:ref/tmp/$PR_BASE_COMMIT" || infoexit "failed to fetch PR base tree, not performing CI fast path"
  git fetch origin "$PR_HEAD_COMMIT:ref/tmp/$PR_HEAD_COMMIT" || infoexit "failed to fetch PR head tree, not performing CI fast path"

  # Here we compare changes from PR with changes from push to make sure nobody injected additional changes to PR branch
  # after CI was invoked and before we fetched data with GraphQL and `git fetch`.
  # We can not do apply `git diff --no-index` to commit range so we are going to strip indexes manually with sed.
  diff -q \
      <(git diff "$PR_BASE_COMMIT" "$PR_HEAD_COMMIT" | sed -n -E '/^diff --git a\// { p; n; /^index /!p; b } ; p') \
      <(git diff "$OLD_COMMIT" "$HEAD_COMMIT" | sed -n -E '/^diff --git a\// { p; n; /^index /!p; b } ; p') >/dev/null 2>&1 \
  || infoexit "PR head does not match pushed commit changes, probably PR ref was force pushed right after PR was merged. Not performing CI fast path."

  # obtain the common ancestor commit where the PR diverged from master.
  PR_MERGE_BASE="$(git merge-base "ref/tmp/$PR_BASE_COMMIT" "$HEAD_COMMIT")" || infoexit "failed to obtain PR merge base, not performing CI fast path"

  # obtain list of all files changed in master branch since this PR diverged
  PR_BASE_TO_HEAD_CHANGED_FILES="$(git diff-tree --name-only -r "$PR_MERGE_BASE..$OLD_COMMIT")" ||:

  # obtain list of all packages changed by this PR
  PR_CHANGED_PACKAGES="$(
    git diff-tree --name-only -r "$OLD_COMMIT..$HEAD_COMMIT" \
      | grep -E "^($DIRS_REGEX)/[^/]+/" \
      | sed -E "s#^(($DIRS_REGEX)/[^/]+)/.*#\1#" \
      | sort -u
  )" ||:

  # obtain list of all buildsystem files changed since this PR diverged
  PR_BASE_TO_HEAD_CHANGED_BUILDSYSTEM_FILES="$(
    grep -e "^scripts/" -e "^ndk-patches/" -e "^build-package.sh$" <<< "$PR_BASE_TO_HEAD_CHANGED_FILES"
  )" ||:

  # obtain list of all packages changes since this PR diverged
  PR_BASE_TO_HEAD_CHANGED_PACKAGES="$(
    echo "$PR_BASE_TO_HEAD_CHANGED_FILES" \
      | grep -E "^($DIRS_REGEX)/[^/]+/" \
      | sed -E "s#^(($DIRS_REGEX)/[^/]+)/.*#\1#" \
      | sort -u
  )" ||:

  # obtain list of all build dependencies of packages changed by this PR
  PR_CHANGED_PACKAGES_DEPS="$(
    for i in ${PR_CHANGED_PACKAGES:-}; do
      ./scripts/buildorder.py $i $TERMUX_PACKAGE_DIRECTORIES | awk '{print $NF}'
    done | sort -u
  )" ||:

  # get list of all build dependencies changed since this PR diverged
  PR_BASE_TO_HEAD_CHANGED_DEPS="$(grep -Fxf <(echo "$PR_BASE_TO_HEAD_CHANGED_PACKAGES") - <<< "$PR_CHANGED_PACKAGES_DEPS")" ||:

  echo "Packages changed by this PR:" ${PR_CHANGED_PACKAGES:-none}
  echo "Dependencies of these packages changed since PR divergence: " ${PR_BASE_TO_HEAD_CHANGED_DEPS:-}
  echo "Buildsystem files changed since PR divergence:" ${PR_BASE_TO_HEAD_CHANGED_BUILDSYSTEM_FILES:-none}
  echo "Packages updated since PR divergence:" ${PR_BASE_TO_HEAD_CHANGED_PACKAGES:-none}

  if [[ -z "${PR_BASE_TO_HEAD_CHANGED_BUILDSYSTEM_FILES:-}${PR_BASE_TO_HEAD_CHANGED_DEPS:-}" ]] || (( PR_CI_REUSE )); then
    # Same commit can be used in more than one pull request or even push
    # No hard tabs or newlines allowed inside a graphql request.

    RESPONSE="$(graphql_request "
    query {
      repository(owner: \"termux\", name: \"termux-packages\") {
        object(oid: \"$PR_HEAD_COMMIT\") {
          ... on Commit { checkSuites(first: 16) { nodes { workflowRun { event file { path } databaseId } conclusion status } } }
        }
      }
    }" "Failed to perform GraphQL request, not performing CI fast path")"
    # Obtain the first completed and successfull `packages.yml` workflow run.
    WORKFLOW_ID="$(
      jq -r '[.data.repository.object?.checkSuites?.nodes[]?
               | select(
                 .workflowRun.event == "pull_request" and
                 .workflowRun.file.path == ".github/workflows/packages.yml" and
                 .conclusion == "SUCCESS" and
                 .status == "COMPLETED"
               ) | .workflowRun.databaseId][0]' <<< "$RESPONSE" ||:
    )"
    if [[ -n "${WORKFLOW_ID}" ]]; then
      echo "We can safely reuse CI artifacts from https://github.com/termux/termux-packages/actions/runs/${WORKFLOW_ID}"
      echo "CI artifact URL is $(ci_artifact_url "${WORKFLOW_ID}" "Failed to get CI artifact URL")"
    else
      echo "We can safely reuse CI artifacts, but did not find any matching CI run."
    fi
  else
    echo "It is NOT safe to reuse PR build artifact"
  fi
fi # end of [[ "${GITHUB_EVENT_NAME:-}" == "push" ]]

if [[ "${GITHUB_EVENT_NAME:-}" == "pull_request" ]]; then
  # In the case of pull_requests we can reuse build artifacts of recent workflow runs
  # if user added more commits to existing PR after workflow finished running.
  if [[ "$(wc -l <<< "${COMMITS}" 2>&1)" -ge 128 ]]; then
    echo "::error title=CI-ARTIFACT-REUSING::Pull request has more than 128 commits, can not reuse CI artifacts."
    exit 0
  fi

  # We intentionally do not check if workflow run is related to this specific PR
  # to allow CI reuse artifacts of other PRs in the case if current PR diverged from other PR branch.
  RESPONSE="$(graphql_request "
  query {
    repository(owner: \"termux\", name: \"termux-packages\") {
    $(
      for commit in ${COMMITS}; do
        # Add a query for this commit with the shorthash as the label
        echo "_${commit::7}: object(oid: \"${commit}\") { ...workflowRun }"
      done
    )
    }
  }

  fragment workflowRun on Commit {
    checkSuites(first: 32) { nodes { workflowRun { event file { path } databaseId } conclusion status } }
  }" "Failed to perform GraphQL request, not performing CI fast path")"

  WORKFLOW_ID=
  # git rev-list prints commits in chronologically descending order, so we can check them as is.
  for commit in ${COMMITS}; do
    # Print the first completed and successfull `packages.yml` workflow run for this commit if any
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
    [[ -z "$WORKFLOW_ID" ]] || break
  done
  if [[ -n "${WORKFLOW_ID}" ]]; then
    echo "We can safely reuse CI artifacts from https://github.com/termux/termux-packages/actions/runs/${WORKFLOW_ID}"
    echo "CI artifact URL is $(ci_artifact_url "${WORKFLOW_ID}" "Failed to get CI artifact URL")"
  else
    echo "We can not reuse CI artifacts since no relevant CI runs were found"
  fi
fi # end of [[ "${GITHUB_EVENT_NAME:-}" == "pull_request" ]]
