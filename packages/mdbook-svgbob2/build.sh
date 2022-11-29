TERMUX_PKG_HOMEPAGE=https://github.com/matthiasbeyer/mdbook-svgbob2
TERMUX_PKG_DESCRIPTION="Alternative mdbook preprocessor for svgbob"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.0
TERMUX_PKG_SRCURL=https://github.com/matthiasbeyer/mdbook-svgbob2/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9e36746b4975dfa3db996a3e890fea57810493c48aa18f7bd09dc4b5a76f5a96
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-svgbob2
}
