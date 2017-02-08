TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_DEPENDS="ncurses, openssl, glib, libandroid-glob"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=9428c51a3f3598ffaef438c351a8d609cf10db34f2435bdcb84456226c383ccf
TERMUX_PKG_FOLDERNAME=irssi-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob"
}
