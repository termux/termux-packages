TERMUX_PKG_HOMEPAGE="https://github.com/bylaws/libadrenotools"
TERMUX_PKG_DESCRIPTION="Library for applying rootless system GPU driver modifications/replacements"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20240910+g8fae8ce2
TERMUX_PKG_SRCURL="git+https://github.com/bylaws/libadrenotools.git"
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

termux_pkg_auto_update() {
	local origin_url last_autoupdate

	# Get the git history
	if origin_url="$(git config --get remote.origin.url)"; then
		git fetch --quiet "${origin_url}" || {
			echo "WARN: Unable to fetch '${origin_url}'"
			echo "WARN: Skipping auto update for '${TERMUX_PKG_NAME}'"
			return
		}
	fi

	# Get the latest commit's date and SHA.
	local response latest_commit_date latest_commit_sha
	response="$(
		curl -sL \
			-H "X-GitHub-Api-Version: 2026-03-10" \
			-H "Accept: application/vnd.github+json" \
			"https://api.github.com/repos/wezterm/wezterm/commits/HEAD"
	)"

	read -rd' ' latest_commit_date latest_commit_sha < <(
		jq -r '.commit.author.date, .sha' <<<"${response}"
	)

	# Are they valid?
	if ! date -d "${latest_commit_date:=null}" >/dev/null || [[ ! "${latest_commit_sha:=null}" =~ [0-9a-f]* ]]; then
		{
			echo "Unable to get commit date and SHA from ${TERMUX_PKG_SRC}."
			echo "Date: ${latest_commit_date}"
			echo "SHA:  ${latest_commit_sha}"
			jq . <<<"${response}"
			return
		} | tee "${GITHUB_STEP_SUMMARY:-/dev/null}" >&2
	fi

	# Massage the date into shape.
	latest_commit_date="${latest_commit_date//-/}" # 2026-07-16T03:01:40Z -> 20260716T03:01:40Z
	latest_commit_date="${latest_commit_date%T*}"  # 20260716T03:01:40Z -> 20260716
	termux_pkg_upgrade_version "${latest_commit_date}+g${latest_commit_sha::8}"
}

termux_step_post_get_source() {
	local commit="${TERMUX_PKG_VERSION##*+g}" epoch_date
	epoch_date="$(date '+%s' -d "${TERMUX_PKG_VERSION%%+g*}")"

	# Remember to pull in the necessary amount of git history
	git fetch --shallow-since="${epoch_date}"
	git checkout "${commit}"
}

termux_step_make_install() {
	find -name '*.h'
	install -Dm644 -t "${TERMUX__PREFIX__LIB_DIR}" libadrenotools.so
}
