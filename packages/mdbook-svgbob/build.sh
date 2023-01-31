TERMUX_PKG_HOMEPAGE=https://github.com/boozook/mdbook-svgbob
TERMUX_PKG_DESCRIPTION="SvgBob mdbook preprocessor which swaps code-blocks with neat SVG"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.1
TERMUX_PKG_SRCURL=https://github.com/boozook/mdbook-svgbob/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cd5c6a58db33e87db04a1f9a5773de860b81cf75bafbe7a9fdb3f4b9f85cbbdc
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-svgbob
}
