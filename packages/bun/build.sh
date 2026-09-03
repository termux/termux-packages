TERMUX_PKG_HOMEPAGE=https://bun.com
TERMUX_PKG_DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.4.2"
TERMUX_PKG_REVISION=2
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

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_version}."
		return
	fi

	# Update the version and checksum in termux_setup_bun
	local TERMUX_BUN_ZIP
	TERMUX_BUN_ZIP="$(mktemp)"
	curl -Ls "https://github.com/oven-sh/bun/releases/download/bun-v${latest_version}/bun-linux-x64.zip" \
		-o "${TERMUX_BUN_ZIP}"
	local TERMUX_BUN_SHA256
	TERMUX_BUN_SHA256="$(sha256sum "${TERMUX_BUN_ZIP}" | cut -d" " -f1)"
	rm -f "${TERMUX_BUN_ZIP}"

	sed \
		-e "s|local TERMUX_BUN_VERSION=.*|local TERMUX_BUN_VERSION=\"\${TERMUX_BUN_VERSION:-${latest_version}}\"|" \
		-e "s|local TERMUX_BUN_SHA256=.*|local TERMUX_BUN_SHA256=\"${TERMUX_BUN_SHA256}\"|" \
		-i "${TERMUX_SETUP_BUN}"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_make() {
	# Bun needs to build without Termux's toolchain, although it is not recommended anyway...
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
