TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-lua
TERMUX_PKG_DESCRIPTION="Lua grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.5.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf01b93f4b61b96a6d27942cf28eeda4cbce7d503c3bef773a8930b3d778a2d9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
"

termux_step_configure() {
	termux_setup_treesitter
}

termux_step_make() {
	termux-tree-sitter build
}

termux_step_make_install() {
	termux-tree-sitter install
}
