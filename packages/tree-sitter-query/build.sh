TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-query
TERMUX_PKG_DESCRIPTION="TS query grammar for tree-sitter"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-query/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=79285847e8350ee9fe1f6f6c9eb64bc14320f70f7b9b65037193fc58f2638613
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
"

termux_step_pre_configure() {
	termux_setup_treesitter
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-query.so "${TERMUX_PREFIX}"/lib/tree_sitter/query.so
}
