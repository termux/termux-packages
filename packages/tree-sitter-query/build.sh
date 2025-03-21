TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-query
TERMUX_PKG_DESCRIPTION="TS query grammar for tree-sitter"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.5.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-query/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fe8c712880a529d454347cd4c58336ac2db22243bae5055bdb5844fb3ea56192
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-query.so "${TERMUX_PREFIX}"/lib/tree_sitter/query.so
}
