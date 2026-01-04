TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-json
TERMUX_PKG_DESCRIPTION="JSON grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.24.8"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-json/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=acf6e8362457e819ed8b613f2ad9a0e1b621a77556c296f3abea58f7880a9213
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_treesitter
}

termux_step_make() {
	termux-tree-sitter build
}

termux_step_make_install() {
	termux-tree-sitter install
}
