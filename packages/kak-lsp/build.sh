TERMUX_PKG_HOMEPAGE=https://github.com/kak-lsp/kak-lsp
TERMUX_PKG_DESCRIPTION="Language Server Protocol Client for the Kakoune editor"
TERMUX_PKG_LICENSE="MIT, Unlicense"
TERMUX_PKG_MAINTAINER="@finagolfin"
TERMUX_PKG_VERSION="14.2.0"
TERMUX_PKG_SRCURL=https://github.com/kak-lsp/kak-lsp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b81ba87bc8d6896041b96aa67b58011c23490fc9fdb47d1c89f176884b504fee
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm Makefile
}

termux_step_post_make_install() {
	mkdir -p ${TERMUX_PKG_MASSAGEDIR}/$TERMUX_PREFIX/share/kak-lsp/examples
	cp kak-lsp.toml ${TERMUX_PKG_MASSAGEDIR}/$TERMUX_PREFIX/share/kak-lsp/examples
	cp -r rc ${TERMUX_PKG_MASSAGEDIR}/$TERMUX_PREFIX/share/kak-lsp
}
