TERMUX_PKG_HOMEPAGE=https://github.com/neovim/tree-sitter-vimdoc
TERMUX_PKG_DESCRIPTION="Tree-sitter parser for Vim help files"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="4.0.2"
TERMUX_PKG_SRCURL=https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=13f2dd182436e0b75db33cc1d097ab0442e0c3135375998f15331dbe9c6b74ab
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
# This one is different from the tree-sitter-grammars/* parsers
# It does not have a CMakeLists.txt file, so we're using `make`
TERMUX_PKG_EXTRA_MAKE_ARGS="
PARSER_URL=https://github.com/neovim/tree-sitter-vimdoc
"

termux_step_pre_configure() {
	# these need to be removed for this one, hell if I know why
	rm setup.py pyproject.toml
	termux_setup_treesitter
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-vimdoc.so "${TERMUX_PREFIX}"/lib/tree_sitter/vimdoc.so
}
