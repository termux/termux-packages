TERMUX_PKG_HOMEPAGE=https://gleam.run
TERMUX_PKG_DESCRIPTION="A friendly language for building type-safe, scalable systems!"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.19.0"
TERMUX_PKG_SRCURL=https://github.com/gleam-lang/gleam/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ee53459e1939cbd8dd4571d8268d7f74123fc16f36cc5241e4594b808ee9cab
TERMUX_PKG_DEPENDS="erlang"
TERMUX_PKG_ANTI_BUILD_DEPENDS="nodejs, nodejs-lts"
TERMUX_PKG_SUGGESTS="nodejs | nodejs-lts"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/gleam"
}
