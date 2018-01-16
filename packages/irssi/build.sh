TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_DEPENDS="ncurses, openssl, glib, libandroid-glob"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SHA256=109bab173d046391212b330de1f86611ed72af247e6886c18bee73265c2d5f02
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
