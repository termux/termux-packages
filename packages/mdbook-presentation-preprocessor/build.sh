TERMUX_PKG_HOMEPAGE=https://github.com/FreeMasen/mdbook-presentation-preprocessor
TERMUX_PKG_DESCRIPTION="A preprocessor for utilizing an MDBook as slides for a presentation"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/FreeMasen/mdbook-presentation-preprocessor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=477eb3104bfe216ebd2067bad97cc3e5a2116ae37bd3819cf523771d315733c6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-presentation-preprocessor
}
