TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-html
TERMUX_PKG_DESCRIPTION="HTML grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.23.2"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-html/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=21fa4f2d4dcb890ef12d09f4979a0007814f67f1c7294a9b17b0108a09e45ef7
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
