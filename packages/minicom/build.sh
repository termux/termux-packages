TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/minicom-team/minicom
TERMUX_PKG_DESCRIPTION="Friendly menu driven serial communication program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.1"
TERMUX_PKG_SRCURL="https://salsa.debian.org/minicom-team/minicom/-/archive/${TERMUX_PKG_VERSION}/minicom-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b296b0e5795ca143fb1ffa78f46fd294daddfccd720faf9909a842d2f70c564e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^[\d.]+$'
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
