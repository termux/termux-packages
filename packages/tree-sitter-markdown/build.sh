TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-markdown
TERMUX_PKG_DESCRIPTION="Markdown grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.4.1"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e0fdb2dca1eb3063940122e1475c9c2b069062a638c95939e374c5427eddee9f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DALL_EXTENSIONS=ON
"

termux_step_pre_configure() {
	termux_setup_nodejs
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-markdown.so "${TERMUX_PREFIX}"/lib/tree_sitter/markdown.so
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-markdown-inline.so "${TERMUX_PREFIX}"/lib/tree_sitter/markdown-inline.so
}
