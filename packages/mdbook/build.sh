TERMUX_PKG_HOMEPAGE=https://rust-lang.github.io/mdBook/
TERMUX_PKG_DESCRIPTION="Creates book from markdown files"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.37"
TERMUX_PKG_SRCURL=https://github.com/rust-lang/mdBook/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a360cb8702d8a35d9db9d0639a6a4650d3a9492970cf772f49c5a99d981272c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook
}
