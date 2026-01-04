TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-xml
TERMUX_PKG_DESCRIPTION="XML grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-xml/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4330a6b3685c2f66d108e1df0448eb40c468518c3a66f2c1607a924c262a3eb9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_treesitter
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-xml.so "${TERMUX_PREFIX}"/lib/tree_sitter/xml.so
}
