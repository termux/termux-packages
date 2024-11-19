TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter
TERMUX_PKG_DESCRIPTION="C grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.23.2"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d8b9c1b2ffb6a42caf9bc76e07c52507d4e60b17175ed9beb0e779be8db1200c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
PARSER_URL=https://github.com/tree-sitter/tree-sitter-c
"

termux_step_pre_configure() {
	rm setup.py pyproject.toml
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-c.so "${TERMUX_PREFIX}"/lib/tree_sitter/c.so
}
