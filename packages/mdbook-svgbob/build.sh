TERMUX_PKG_HOMEPAGE=https://github.com/boozook/mdbook-svgbob
TERMUX_PKG_DESCRIPTION="SvgBob mdbook preprocessor which swaps code-blocks with neat SVG"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.0"
TERMUX_PKG_SRCURL=https://github.com/boozook/mdbook-svgbob/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=246b8eb6b085984e7c91939b94b64e135667d385dead48bd08985b96e52b065f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/mdbook-svgbob
}
