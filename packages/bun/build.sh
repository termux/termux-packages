TERMUX_PKG_HOMEPAGE=https://bun.com
TERMUX_PKG_DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.4.4"
TERMUX_PKG_SRCURL=git+https://github.com/oven-sh/bun
TERMUX_PKG_GIT_BRANCH="bun-v$TERMUX_PKG_VERSION"
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

	# WebKit prebuilt archives were built with NDK r27c (has_val at offset 0xE8).
	# NDK r30 packs has_val into tail padding at offset 0xE2.
	# Create an unprivileged libc++ overlay to restore 0xE8 layout without touching root-owned $NDK.
	local libcxx_overlay="$TERMUX_PKG_BUILDDIR/libcxx-overlay"
	mkdir -p "$libcxx_overlay/__expected"
	local orig_expected
	orig_expected="$(find "$NDK" -type f -path "*/c++/v1/__expected/expected.h" 2> /dev/null | head -n 1)"
	if [[ -z "$orig_expected" || ! -f "$orig_expected" ]]; then
		termux_error_exit "Failed to locate __expected/expected.h in NDK at $NDK"
	fi

	if ! grep -q '__fits_in_tail_padding<__union_t, bool>' "$orig_expected"; then
		termux_error_exit "Unexpected __expected/expected.h format in NDK at $orig_expected"
	fi
	cp "$orig_expected" "$libcxx_overlay/__expected/expected.h"
	sed -i 's|__fits_in_tail_padding<__union_t, bool>|false|g' "$libcxx_overlay/__expected/expected.h"

	# Inject overlay path into Android C++ flags before NDK sysroot's c++/v1
	if ! grep -q "$libcxx_overlay" "$TERMUX_PKG_SRCDIR/scripts/build/flags.ts"; then
		sed -i \
			's|join(c.sysroot!, "usr", "include", "c++", "v1"),|"'"$libcxx_overlay"'",\n      "-isystem",\n      &|' \
			"$TERMUX_PKG_SRCDIR/scripts/build/flags.ts"
	fi

	if ! grep -q "$libcxx_overlay" "$TERMUX_PKG_SRCDIR/scripts/build/flags.ts"; then
		termux_error_exit "Failed to inject libcxx-overlay into scripts/build/flags.ts"
	fi

	rustup toolchain install
	bun run build:release \
		--abi=android \
		--arch="$_bun_arch" \
		--android-ndk="$NDK" \
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
