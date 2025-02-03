TERMUX_PKG_HOMEPAGE=https://github.com/kakoune-lsp/kakoune-lsp
TERMUX_PKG_DESCRIPTION="Language Server Protocol Client for the Kakoune editor"
TERMUX_PKG_LICENSE="MIT, Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.1.2"
TERMUX_PKG_SRCURL=https://github.com/kakoune-lsp/kakoune-lsp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d3087c0f78f42d3ad30ccaa64f192a88f646e40615b7e4986c53165019f34934
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
