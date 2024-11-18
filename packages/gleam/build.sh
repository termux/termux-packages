TERMUX_PKG_HOMEPAGE=https://gleam.run
TERMUX_PKG_DESCRIPTION="A friendly language for building type-safe, scalable systems!"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL=https://github.com/gleam-lang/gleam/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e4362bca4e82cfdbbb5a09f2bfa9a67fe6d766f893c6bed8852694aca9c30bc9
TERMUX_PKG_DEPENDS="erlang"
TERMUX_PKG_SUGGESTS="nodejs"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/gleam"
}
