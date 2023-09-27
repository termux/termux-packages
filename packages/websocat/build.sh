TERMUX_PKG_HOMEPAGE=https://github.com/vi/websocat
TERMUX_PKG_DESCRIPTION="Command-line client for WebSockets, like netcat (or curl) for ws:// with advanced socat-like functions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.0"
TERMUX_PKG_SRCURL=https://github.com/vi/websocat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ca6ab2bc71a9c641fbda7f15d4956f2e19ca32daba9b284d26587410944a3adb
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/websocat
}
