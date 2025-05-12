TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-query
TERMUX_PKG_DESCRIPTION="TS query grammar for tree-sitter"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-query/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0fda401a86ed800be15b7209b9942b7fc2e6907a0a9d1a49580306d82ce744f1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-query.so "${TERMUX_PREFIX}"/lib/tree_sitter/query.so
}
