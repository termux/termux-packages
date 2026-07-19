TERMUX_PKG_HOMEPAGE=https://github.com/ayntgl/discordo
TERMUX_PKG_DESCRIPTION="A lightweight, secure, and feature-rich Discord terminal client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=cdd97ff900a099ca520e5a720c547780dd6de162
TERMUX_PKG_VERSION=2025.08.06
TERMUX_PKG_SRCURL=git+https://github.com/ayntgl/discordo
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_SHA256=030bfd86b518586ca520891c0af5b1b32c0285260d825a0ddccdd7eec5d920ae
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_DEPENDS="libx11"
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

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod download

	# golang's "mobile" package contains both code related to SurfaceFlinger(ANativeWindow[For Building an APK]),
	# and also X11-related code that upstream connects to "linux && !android".
	# apply the pattern "treat Android as linux" here,
	# to force the disabling of the SurfaceFlinger-dependent
	# code and the enabling of the X11-related code,
	# fixing the error when building discordo using NDK r28c:
	# android.c:171:52: error: incompatible pointer to integer conversion
	# passing 'ANativeWindow *' (aka 'struct ANativeWindow *') to parameter
	# of type 'EGLNativeWindowType' (aka 'unsigned long') [-Wint-conversion]
	for go_module in golang.org/x/mobile golang.design/x/clipboard; do
		cp --no-preserve=mode,ownership -rf "${GOPATH}"/pkg/mod/"${go_module}"\@* ./"${go_module##*/}"
		find ./"${go_module##*/}" -type f | \
			xargs -n 1 sed -i \
			-e 's|build android|build disabling_this_because_it_is_for_building_an_apk|g' \
			-e 's|linux && !android|linux|g' \
			-e 's|linux,!android|linux|g'
		local go_module_version=$(grep "${go_module}" go.mod | awk '{print $2}')
		go mod edit -replace "${go_module}@${go_module_version}=./${go_module##*/}"
	done
}

termux_step_make() {
	go build -trimpath -buildmode=pie -ldflags "-s -w" .
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/discordo
}
