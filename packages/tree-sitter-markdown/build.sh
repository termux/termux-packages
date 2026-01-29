TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-markdown
TERMUX_PKG_DESCRIPTION="Markdown grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.5.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=122be47d4a50ac75a4f6861a17c3c88144197e0949f5d83ca917f2382b37761b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DALL_EXTENSIONS=ON
"

termux_step_configure() {
	termux_setup_treesitter
}

termux_step_make() {
	local parser
	for parser in "markdown" "markdown-inline"; do
		termux-tree-sitter build -s "tree-sitter-$parser/src"
	done
}

termux_step_make_install() {
	local parser
	for parser in "markdown" "markdown-inline"; do
		termux-tree-sitter install -s "tree-sitter-$parser/src"
	done
}
