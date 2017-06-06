TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_DEPENDS="ncurses, openssl, glib, libandroid-glob"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=838220297dcbe7c8c42d01005059779a82f5b7b7e7043db37ad13f5966aff581
TERMUX_PKG_FOLDERNAME=irssi-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
