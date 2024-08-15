TERMUX_PKG_HOMEPAGE=https://github.com/kak-lsp/kak-lsp
TERMUX_PKG_DESCRIPTION="Language Server Protocol Client for the Kakoune editor"
TERMUX_PKG_LICENSE="MIT, Unlicense"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION="17.1.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/kak-lsp/kak-lsp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5a5a888b5d5574b3468979234d925cd0e056425610b425c6b2ef3d97dcb97b86
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm Makefile
}

termux_step_post_make_install() {
	rm -rf $TERMUX_PREFIX/share/kak-lsp
	mkdir -p $TERMUX_PREFIX/share/kak-lsp/examples
	cp $TERMUX_PKG_SRCDIR/kak-lsp.toml $TERMUX_PREFIX/share/kak-lsp/examples
	cp -r $TERMUX_PKG_SRCDIR/rc $TERMUX_PREFIX/share/kak-lsp
}
