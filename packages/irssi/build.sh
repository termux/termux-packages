TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_DEPENDS="ncurses, openssl, glib, libandroid-glob"
TERMUX_PKG_VERSION=1.0.4
TERMUX_PKG_SHA256=b85c07dbafe178213eccdc69f5f8f0ac024dea01c67244668f91ec1c06b986ca
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_FOLDERNAME=irssi-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
