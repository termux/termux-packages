TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=6727060c918568ba2ff4295ad736128dba0b995d7b20491bca11f593bd857578
TERMUX_PKG_DEPENDS="libiconv, ncurses, openssl, glib, libandroid-glob, utf8proc"
TERMUX_PKG_BREAKS="irssi-dev"
TERMUX_PKG_REPLACES="irssi-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
