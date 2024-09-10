TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars
TERMUX_PKG_DESCRIPTION="Tree-sitter parser for Markdown"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.1"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c5065bb7d3a9944c156818956947a7ec02759cf7df1d543ef5fc566e441c8a44
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
PARSER_URL=https://github.com/tree-sitter-grammars/tree-sitter-markdown
"

termux_step_pre_configure() {
	rm setup.py pyproject.toml
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-markdown.so "${TERMUX_PREFIX}"/lib/tree_sitter/markdown.so
}
