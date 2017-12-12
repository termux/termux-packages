TERMUX_PKG_HOMEPAGE=https://www.midnight-commander.org/
TERMUX_PKG_DESCRIPTION="Midnight Commander - a powerful file manager"
TERMUX_PKG_VERSION=4.8.20
TERMUX_PKG_SHA256=017ee7f4f8ae420a04f4d6fcebaabe5b494661075c75442c76e9c8b1923d501c
TERMUX_PKG_SRCURL=http://ftp.midnight-commander.org/mc-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ncurses-libs=$TERMUX_PREFIX/lib --with-screen=ncurses"
