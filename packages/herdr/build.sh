TERMUX_PKG_HOMEPAGE="https://herdr.dev/"
TERMUX_PKG_DESCRIPTION="Terminal workspace manager for AI coding agents"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL="https://github.com/herdrdev/herdr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=47bdb0753beb8a6b157cf2fec26fbe6b787f85ffea0dde579b0001d6cd663572
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
# libghostty-vt has not been ported to Zig 0.16 yet.
TERMUX_ZIG_VERSION=0.15.2

termux_step_post_get_source() {
	local p="$TERMUX_PKG_BUILDER_DIR/termux.diff"
	echo "Applying $(basename "$p")"
	sed \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@TERMUX_PKG_API_LEVEL@|${TERMUX_PKG_API_LEVEL}|g" \
		"$p" | patch --silent -p1
}

termux_step_pre_configure() {
	# Use Termux's current Rust toolchain instead of the upstream pin.
	rm -f rust-toolchain.toml
	termux_setup_rust
	termux_setup_zig

	export ANDROID_NDK_HOME="$NDK"
}

termux_step_post_make_install() {
	chmod 700 "$TERMUX_PREFIX/bin/herdr"
}

termux_step_post_massage() {
	[[ "$TERMUX_ARCH" != "aarch64" ]] && return
	local headers
	headers=$("$READELF" -lW bin/herdr) || termux_error_exit "failed to inspect AArch64 binary"
	if grep -E '^[[:space:]]*TLS[[:space:]]' <<< "$headers" >/dev/null; then
		termux_error_exit "unexpected PT_TLS segment in AArch64 binary"
	fi
}
