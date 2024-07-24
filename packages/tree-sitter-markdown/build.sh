TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars
TERMUX_PKG_DESCRIPTION="Tree-sitter parser for Markdown"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.3"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4909d6023643f1afc3ab219585d4035b7403f3a17849782ab803c5f73c8a31d5
TERMUX_PKG_AUTO_UPDATE=true
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
