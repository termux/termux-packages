TERMUX_PKG_HOMEPAGE=https://github.com/ayn2op/discordo
TERMUX_PKG_DESCRIPTION="A lightweight, secure, and feature-rich Discord terminal client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.07.16+g2e051919"
TERMUX_PKG_SRCURL="https://github.com/ayn2op/discordo/archive/${TERMUX_PKG_VERSION##*+g}.tar.gz"
TERMUX_PKG_SHA256=853e69f8d0463b525c436b1f0fadf8b45cd3e131a762d3836a86eb73e150a92e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# This auto update function is based on x11/wezterm-nightly
termux_pkg_auto_update() {
	local origin_url last_autoupdate
	# Throttle auto updates to once every two weeks
	local update_interval="$((2 * 7 * 86400))"

	# Get the git history
	if origin_url="$(git config --get remote.origin.url)"; then
		git fetch --quiet "${origin_url}" || {
			echo "WARN: Unable to fetch '${origin_url}'"
			echo "WARN: Skipping auto update for '$TERMUX_PKG_NAME'"
			return
		}
	fi

	# When was the last autoupdate to this package? (Unix epoch timestamp)
	last_autoupdate="$(
		git log \
		--author="Termux Github Actions <contact@termux.dev>" \
		-n1 \
		--pretty=format:%at \
		-- "$TERMUX_PKG_BUILDER_DIR/build.sh"
	)"

	# If we're still in the $update_interval skip the actual checking.
	if (( last_autoupdate + update_interval > EPOCHSECONDS )); then
		local t days hrs mins secs
		(( t = EPOCHSECONDS - last_autoupdate, days = t/86400, t %= 86400, secs = t%60, t /= 60, mins = t%60, hrs = t/60 ))

		printf 'INFO: Last updated %dd%dh%02dm%02ds ago.\n' "$days" "$hrs" "$mins" "$secs"
		printf 'INFO: Which is less than the desired %sd minimum update interval.\n' "$(( update_interval / 86400 ))"
		return
	fi

	# Get the latest commit's date and SHA.
	local response latest_commit_date latest_commit_sha
	response="$(curl -sL \
		-H "X-GitHub-Api-Version: 2026-03-10" \
		-H "Accept: application/vnd.github+json" \
		"https://api.github.com/repos/ayn2op/discordo/commits/HEAD"
	)"


	read -rd' ' latest_commit_date latest_commit_sha < <(
		jq -r '.commit.author.date, .sha' <<< "$response"
	)

	# Are they valid?
	if ! date -d "${latest_commit_date:=null}" > /dev/null || [[ ! "${latest_commit_sha:=null}" =~ [0-9a-f]* ]]; then
		{
			echo "Unable to get commit date and SHA from ${TERMUX_PKG_SRCURL}."
			echo "Date: $latest_commit_date"
			echo "SHA:  $latest_commit_sha"
			jq . <<< "$response"
			return
		} | tee "${GITHUB_STEP_SUMMARY:-/dev/null}" >&2
	fi

	# Massage the date into shape.
	latest_commit_date="${latest_commit_date//-/.}" # 2026-07-16T03:01:40Z -> 2026.07.16T03:01:40Z
	latest_commit_date="${latest_commit_date%T*}"   # 2026.07.16T03:01:40Z -> 2026.07.16

	termux_pkg_upgrade_version "${latest_commit_date}+g${latest_commit_sha::8}"
}

termux_step_post_get_source() {
	# Vendor and sanitize go modules ahead of patching step.
	termux_setup_golang
	go mod tidy
	go mod vendor

	# golang's "mobile" module contains both code
	# related to SurfaceFlinger(ANativeWindow[For Building an APK]),
	# and also X11-related code that upstream connects to "linux && !android".
	# apply the pattern "treat Android as linux" here,
	# to force the disabling of the SurfaceFlinger-dependent
	# code and the enabling of the X11-related code,
	# fixing the error when building discordo using NDK r28c:
	# android.c:171:52: error: incompatible pointer to integer conversion
	# passing 'ANativeWindow *' (aka 'struct ANativeWindow *') to parameter
	# of type 'EGLNativeWindowType' (aka 'unsigned long') [-Wint-conversion]
	find \
		vendor/golang.org/x/mobile \
		-type f -print0 | \
		xargs -0 -n 1 sed -i \
		-e 's|build android|build disabling_this_because_it_is_for_building_an_apk|g' \
		-e 's|linux && !android|linux|g' \
		-e 's|linux,!android|linux|g'

}

termux_step_make() {
	go build -trimpath -buildmode=pie -ldflags "-s -w" .
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/discordo
}
