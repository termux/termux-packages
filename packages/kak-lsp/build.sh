TERMUX_PKG_HOMEPAGE=https://github.com/kak-lsp/kak-lsp
TERMUX_PKG_DESCRIPTION="Language Server Protocol Client for the Kakoune editor"
TERMUX_PKG_LICENSE="MIT, Unlicense"
TERMUX_PKG_MAINTAINER="@buttaface"
TERMUX_PKG_VERSION=12.0.1
TERMUX_PKG_SRCURL=https://github.com/kak-lsp/kak-lsp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=37b54186f7f18d879c605cb235452a92308361676fc3966c2e65bbaae30b7a3e
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
