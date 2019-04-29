TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_DEPENDS="ncurses, openssl, glib, libandroid-glob, utf8proc"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=1643fca1d8b35e5a5d7b715c9c889e1e9cdb7e578e06487901ea959e6ab3ebe5
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
