TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-vim
TERMUX_PKG_DESCRIPTION="Vimscript grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.8.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=93cafb9a0269420362454ace725a118ff1c3e08dcdfdc228aa86334b54d53c2a
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
