TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-lua
TERMUX_PKG_DESCRIPTION="Lua grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.4.0"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0977aced4a63bb75f26725787e047b8f5f4a092712c840ea7070765d4049559
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
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-lua.so "${TERMUX_PREFIX}"/lib/tree_sitter/lua.so
}
