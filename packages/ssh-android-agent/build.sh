TERMUX_PKG_HOMEPAGE=https://github.com/haraldh/ssh-android-agent
TERMUX_PKG_DESCRIPTION="ssh-agent whose key lives in the Android hardware Keystore (via Termux:API)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Harald Hoyer <harald@hoyer.xyz>"
TERMUX_PKG_VERSION=0.1.2
TERMUX_PKG_SRCURL="https://github.com/haraldh/ssh-android-agent/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e0df13346210c95a91534948fe2f1a0c6efe26b38a40ba413a2ed6ca6f5a4f0d
TERMUX_PKG_DEPENDS="termux-api"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	local -a BUILD_ARGS=("--release")
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		BUILD_ARGS=()
	fi

	TERMUX_APP__PACKAGE_NAME="$TERMUX_APP__PACKAGE_NAME" \
		cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" "${BUILD_ARGS[@]}"
}

termux_step_make_install() {
	local BUILD_TYPE="release"
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		BUILD_TYPE="debug"
	fi
	install -Dm700 -t "$TERMUX_PREFIX/bin" \
		"target/${CARGO_TARGET_NAME}/${BUILD_TYPE}/ssh-android-agent"
}
