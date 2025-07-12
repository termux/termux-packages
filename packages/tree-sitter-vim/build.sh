TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-vim
TERMUX_PKG_DESCRIPTION="Vimscript grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=44eabc31127c4feacda19f2a05a5788272128ff561ce01093a8b7a53aadcc7b2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# these need to be removed for this one, hell if I know why
	rm setup.py pyproject.toml
	termux_setup_treesitter
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-vim.so "${TERMUX_PREFIX}"/lib/tree_sitter/vim.so
}
