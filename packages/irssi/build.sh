TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_DEPENDS="libiconv, ncurses, openssl, glib, libandroid-glob, utf8proc"
TERMUX_PKG_BREAKS="irssi-dev"
TERMUX_PKG_REPLACES="irssi-dev"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5466a1ed9612cfa707d9a37d60b29d027b4ac7d83c74ceb1a410e2b59edba92c
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
