TERMUX_PKG_HOMEPAGE=https://www.midnight-commander.org/
TERMUX_PKG_DESCRIPTION="Midnight Commander - a powerful file manager"
TERMUX_PKG_VERSION=4.8.19
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="http://ftp.midnight-commander.org/mc-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=eb9e56bbb5b2893601d100d0e0293983049b302c5ab61bfb544ad0ee2cc1f2df
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ncurses-libs=$TERMUX_PREFIX/lib --with-screen=ncurses"
