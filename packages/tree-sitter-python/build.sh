TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-python
TERMUX_PKG_DESCRIPTION="Python grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.25.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-python/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4609a3665a620e117acf795ff01b9e965880f81745f287a16336f4ca86cf270c
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
