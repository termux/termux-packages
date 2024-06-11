TERMUX_PKG_HOMEPAGE=https://github.com/vi/websocat
TERMUX_PKG_DESCRIPTION="Command-line client for WebSockets, like netcat (or curl) for ws:// with advanced socat-like functions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.13.0"
TERMUX_PKG_SRCURL=https://github.com/vi/websocat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=43800f8df38ede8b5bffe825e633c0db6a3c36cfe26c23e882bcfc028d3119c7
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/websocat
}
