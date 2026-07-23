TERMUX_PKG_HOMEPAGE=https://github.com/haraldh/ssh-android-agent
TERMUX_PKG_DESCRIPTION="ssh-agent whose key lives in the Android hardware Keystore (via Termux:API)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@haraldh"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_SRCURL=https://github.com/haraldh/ssh-android-agent/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=26efe7053c95d9f6785a834d24da920f99ba062d5be97ae1b9b8be910718691b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="termux-api"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	local BUILD_TYPE=
	if [ $TERMUX_DEBUG_BUILD = false ]; then
		BUILD_TYPE=--release
	fi

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME ${BUILD_TYPE}
}

termux_step_make_install() {
	local BUILD_TYPE=release
	if [ $TERMUX_DEBUG_BUILD = true ]; then
		BUILD_TYPE=debug
	fi
	install -Dm700 -t $TERMUX_PREFIX/bin \
		target/${CARGO_TARGET_NAME}/${BUILD_TYPE}/ssh-android-agent
}
