#!/bin/bash
set -euo pipefail

# Opens a "file conflict" issue per package pair termux_audit_published_conflicts.sh
# finds, skipping pairs that already have one open. Requires GITHUB_TOKEN/gh.

cd "$(realpath "$(dirname "$0")")/../.."

declare -A cached_issues=()
while read -r number title; do
	cached_issues["$number"]="'${title}'" # extra quotes avoid false positive substring matches
done < <(
	gh issue list \
		--limit 10000 \
		--label "file conflict" --label "bot" \
		--state open \
		--search "File conflict: in:title type:issue" \
		--json number,title | jq -r '.[] | "\(.number) \(.title)"' | sort -u
)

issue_exists() {
	local title="$1" number
	for number in "${!cached_issues[@]}"; do
		# shellcheck disable=SC2076 # literal match, not regex
		[[ "${cached_issues[$number]}" =~ "'${title}'" ]] && return 0
	done
	return 1
}

pkg_dir() {
	# Prints the package's (or its parent's, if a subpackage) directory path,
	# or nothing if it can't be found.
	local pkg="$1" dir
	for dir in packages root-packages x11-packages; do
		[[ -f "$dir/$pkg/build.sh" ]] && { echo "$dir/$pkg"; return; }
		compgen -G "$dir/*/$pkg.subpackage.sh" > /dev/null && {
			dirname "$(compgen -G "$dir/*/$pkg.subpackage.sh" | head -n1)"
			return
		}
	done
}

declare -A pair_paths=()
while read -r pkg_a pkg_b path; do
	# Normalize pair ordering so the same pair always maps to the same key,
	# regardless of which order Contents happened to list the owners in.
	if [[ "$pkg_a" > "$pkg_b" ]]; then
		tmp="$pkg_a"; pkg_a="$pkg_b"; pkg_b="$tmp"
	fi
	key="${pkg_a} ${pkg_b}"
	pair_paths["$key"]+="${pair_paths[$key]:+$'\n'}${path}"
done < <(./scripts/utils/termux_audit_published_conflicts.sh)

for key in "${!pair_paths[@]}"; do
	read -r pkg_a pkg_b <<< "$key"
	title="File conflict: ${pkg_a} and ${pkg_b}"

	if issue_exists "$title"; then
		echo "INFO: An open issue already exists for '${pkg_a}'/'${pkg_b}'."
		continue
	fi

	body="$(
		cat <<-EOF
			Hi, I'm Termux 🤖.

			[${pkg_a}](../../tree/master/$(pkg_dir "$pkg_a")) and [${pkg_b}](../../tree/master/$(pkg_dir "$pkg_b")) both ship the following file(s), with no Conflicts/Replaces/Breaks declared between them:

			\`\`\`
			${pair_paths[$key]}
			\`\`\`

			<hr>
			<i>
			Detected at $(date -u +"%Y-%m-%d %H:%M:%S UTC").<br>
			Run ID: <a href="${GITHUB_SERVER_URL:-}/${GITHUB_REPOSITORY:-}/actions/runs/${GITHUB_RUN_ID:-}">${GITHUB_RUN_ID:-}</a>
			</i>
		EOF
	)"

	issue_number=$(
		gh issue create \
			--title "$title" \
			--body "$body" \
			--label "file conflict" --label "bot" |
			grep -oE "[0-9]+"
	)
	if [[ -z "$issue_number" ]]; then
		echo "ERROR: Failed to create issue for '${pkg_a}'/'${pkg_b}'."
		continue
	fi
	echo "INFO: Created issue ${issue_number} for '${pkg_a}'/'${pkg_b}'."
done
