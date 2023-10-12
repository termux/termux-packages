TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/minicom-team/minicom
TERMUX_PKG_DESCRIPTION="Friendly menu driven serial communication program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9"
TERMUX_PKG_SRCURL=https://salsa.debian.org/minicom-team/minicom/-/archive/${TERMUX_PKG_VERSION}/minicom-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=21e609d1b58c5de06400f6e36ed3a5060711847a63bc984b6e994d9ad1641d37
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, ncurses"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-socket
--disable-music
--enable-lock-dir=$TERMUX_PREFIX/var/run
"

termux_step_pre_configure() {
	export CFLAGS+=" -fcommon"
	CPPFLAGS+=" -Dushort=u_short"
}
