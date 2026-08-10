TERMUX_PKG_HOMEPAGE="https://herdr.dev/"
TERMUX_PKG_DESCRIPTION="Terminal workspace manager for AI coding agents"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL="https://github.com/herdrdev/herdr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=47bdb0753beb8a6b157cf2fec26fbe6b787f85ffea0dde579b0001d6cd663572
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_RUST_VERSION=1.96.1
TERMUX_ZIG_VERSION=0.15.2

termux_step_pre_configure() {
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
