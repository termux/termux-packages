TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-c
TERMUX_PKG_DESCRIPTION="C grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.23.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f7e50412230150ce514efcccb962ff9b452d9f358e0a2c89f2a0a0256c2ec886
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-c.so "${TERMUX_PREFIX}"/lib/tree_sitter/c.so
}
