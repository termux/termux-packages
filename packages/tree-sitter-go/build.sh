TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-go
TERMUX_PKG_DESCRIPTION="Golang grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.25.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2dc241b97872c53195e01b86542b411a3c1a6201d9c946c78d5c60c063bba1ef
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
