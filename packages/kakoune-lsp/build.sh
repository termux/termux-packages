TERMUX_PKG_HOMEPAGE=https://github.com/kakoune-lsp/kakoune-lsp
TERMUX_PKG_DESCRIPTION="Language Server Protocol Client for the Kakoune editor"
TERMUX_PKG_LICENSE="MIT, Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="19.0.0"
TERMUX_PKG_SRCURL=https://github.com/kakoune-lsp/kakoune-lsp/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=48e4866522559905e44d4e1adeb5d3d525b9385e9222474b056c52d12b0b2e88
TERMUX_PKG_CONFLICTS="kak-lsp"
TERMUX_PKG_REPLACES="kak-lsp"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	rm Makefile
}

termux_step_post_make_install() {
	rm -rf $TERMUX_PREFIX/share/kak-lsp
	cp -r $TERMUX_PKG_SRCDIR/rc $TERMUX_PREFIX/share/kak-lsp
}
