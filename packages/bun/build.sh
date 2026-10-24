TERMUX_PKG_HOMEPAGE=https://bun.com
TERMUX_PKG_DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.4.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/oven-sh/bun
TERMUX_PKG_GIT_BRANCH="bun-v$TERMUX_PKG_VERSION"
TERMUX_PKG_DEPENDS="libicu"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local TERMUX_SETUP_BUN="${TERMUX_SCRIPTDIR}/scripts/build/setup/termux_setup_bun.sh"
	local latest_tag latest_version
	latest_tag="$(termux_github_api_get_tag)"
	latest_version="${latest_tag#bun-v}"

	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	# Get the SHA256 checksum from the release artifacts
	local TERMUX_BUN_SHA256
	TERMUX_BUN_SHA256="$(
		curl -sL \
			-H "X-GitHub-Api-Version: 2026-03-10" \
			-H "Accept: application/vnd.github+json" \
			-A "Termux update checker 1.1 (github.com/termux/termux-packages)" \
			"https://api.github.com/repos/oven-sh/bun/releases/tags/${latest_tag}" |
			jq -r '.[].[]? | select(.name? == "bun-linux-x64.zip") | .digest | ltrimstr("sha256:")'
	)"

	if [[ ! "${TERMUX_BUN_SHA256:-}" =~ [0-9a-f]{64} ]]; then
		printf '%s\n' \
			"Could not fetch valid SHA256 sum from upstream release artifacts." \
			"Got: '${TERMUX_BUN_SHA256:-}'" >&2
		return
	fi

	printf '%s\n' \
		"" \
		"Toolchain:" \
		"bun-linux-x64.zip  $TERMUX_BUN_SHA256" \
		""

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_version}."
		return
	fi

	# Update the version and checksum in termux_setup_bun
	sed \
		-e "s|local TERMUX_BUN_VERSION=.*|local TERMUX_BUN_VERSION=\"\${TERMUX_BUN_VERSION:-${latest_version}}\"|" \
		-e "s|local TERMUX_BUN_SHA256=.*|local TERMUX_BUN_SHA256=\"${TERMUX_BUN_SHA256}\"|" \
		-i "${TERMUX_SETUP_BUN}"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	local _wk_ver
	_wk_ver="$(sed -nE 's/.*WEBKIT_VERSION = "([^"]+)".*/\1/p' "$TERMUX_PKG_SRCDIR/scripts/build/deps/webkit.ts")"
	if [[ -z "${_wk_ver}" ]]; then
		termux_error_exit "Failed to determine WEBKIT_VERSION from Bun source"
	fi
	local _wk_tag="${_wk_ver}"
	if [[ "${_wk_tag}" != autobuild-* ]]; then
		_wk_tag="autobuild-${_wk_tag}"
	fi

	if [[ ! -d "$TERMUX_PKG_SRCDIR/vendor/WebKit" ]]; then
		echo "Fetching WebKit source for Bun from tag ${_wk_tag}..."
		mkdir -p "$TERMUX_PKG_SRCDIR/vendor"
		git clone \
			--depth 1 \
			--branch "${_wk_tag}" \
			--single-branch \
			https://github.com/oven-sh/WebKit.git \
			"$TERMUX_PKG_SRCDIR/vendor/WebKit"
	fi
}

termux_step_make() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust
	termux_setup_bun

	export BUN_TOOLCHAIN_LLVM="$NDK/toolchains/llvm/prebuilt/linux-x86_64"
	export PATH="$BUN_TOOLCHAIN_LLVM/bin:$PATH"

	local _bun_arch="$TERMUX_ARCH"
	if [[ "$TERMUX_ARCH" == "x86_64" ]]; then
		_bun_arch="x64"
	fi

	export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
	export CARGO_BUILD_JOBS=$(nproc)
	export BUN_ANDROID_ICU_ROOT="$TERMUX_PREFIX"

	rustup toolchain install
	bun run build:release \
		--abi=android \
		--arch="$_bun_arch" \
		--android-ndk="$NDK" \
		--webkit=local \
		--canary=false \
		--lto=on
}

termux_step_make_install() {
	install -Dm755 "$TERMUX_PKG_SRCDIR/build/release/bun" "$TERMUX_PREFIX/bin/bun"
	ln -sf bun "$TERMUX_PREFIX/bin/bunx"

	install -Dm644 "$TERMUX_PKG_SRCDIR/completions/bun.bash" \
		"$TERMUX_PREFIX/share/bash-completion/completions/bun"
	install -Dm644 "$TERMUX_PKG_SRCDIR/completions/bun.zsh" \
		"$TERMUX_PREFIX/share/zsh/site-functions/_bun"
	install -Dm644 "$TERMUX_PKG_SRCDIR/completions/bun.fish" \
		"$TERMUX_PREFIX/share/fish/vendor_completions.d/bun.fish"
}
