TERMUX_PKG_HOMEPAGE=https://github.com/neovim/tree-sitter-vimdoc
TERMUX_PKG_DESCRIPTION="Tree-sitter parser for Vim help files"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="4.1.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=020e8f117f648c8697fca967995c342e92dbd81dab137a115cc7555207fbc84f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
# This one is different from the tree-sitter-grammars/* parsers
# It does not have a CMakeLists.txt file, so we're using `make`
TERMUX_PKG_EXTRA_MAKE_ARGS="
PARSER_URL=https://github.com/neovim/tree-sitter-vimdoc
"

termux_step_configure() {
	termux_setup_treesitter
}

termux_step_make() {
	termux-tree-sitter build
}

termux_step_make_install() {
	termux-tree-sitter install
}
