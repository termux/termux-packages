TERMUX_PKG_HOMEPAGE=https://github.com/kakoune-lsp/kakoune-lsp
TERMUX_PKG_DESCRIPTION="Language Server Protocol Client for the Kakoune editor"
TERMUX_PKG_LICENSE="MIT, Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.0.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/kakoune-lsp/kakoune-lsp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ad33b20437cd7bc89d7992b9449a02c946528e7f91d15d76dba27c7ad2ae7d36
TERMUX_PKG_CONFLICTS="kak-lsp"
TERMUX_PKG_REPLACES="kak-lsp"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm Makefile
}

termux_step_post_make_install() {
	rm -rf $TERMUX_PREFIX/share/kak-lsp
	cp -r $TERMUX_PKG_SRCDIR/rc $TERMUX_PREFIX/share/kak-lsp
}
