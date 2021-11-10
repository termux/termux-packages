TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/minicom-team/minicom
TERMUX_PKG_DESCRIPTION="Friendly menu driven serial communication program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://alioth-archive.debian.org/releases/minicom/Source/$TERMUX_PKG_VERSION/minicom-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=532f836b7a677eb0cb1dca8d70302b73729c3d30df26d58368d712e5cca041f1
TERMUX_PKG_DEPENDS="libiconv, ncurses"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-socket
--disable-music
--enable-lock-dir=$TERMUX_PREFIX/var/run
"

termux_step_pre_configure() {
	export CFLAGS+=" -fcommon"
}
