TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars
TERMUX_PKG_DESCRIPTION="Vimscript grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90019d12d2da0751c027124f27f5335babf069a050457adaed53693b5e9cf10a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
PARSER_URL=https://github.com/tree-sitter-grammars/tree-sitter-vim
"

termux_step_pre_configure() {
	rm setup.py pyproject.toml
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-vim.so "${TERMUX_PREFIX}"/lib/tree_sitter/vim.so
}
