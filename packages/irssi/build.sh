TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_DEPENDS="ncurses, openssl, glib, libandroid-glob"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SHA256=784807e7a1ba25212347f03e4287cff9d0659f076edfb2c6b20928021d75a1bf
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
