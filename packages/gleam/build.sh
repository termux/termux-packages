TERMUX_PKG_HOMEPAGE=https://gleam.run
TERMUX_PKG_DESCRIPTION="A friendly language for building type-safe, scalable systems!"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.19.1"
TERMUX_PKG_SRCURL=https://github.com/gleam-lang/gleam/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5a717b4013d5599d73a99b3a1a4bb9168e62bfc18afff2f5bbab43244f860df0
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
