TERMUX_PKG_HOMEPAGE=http://www.vanheusden.com/multitail/
TERMUX_PKG_DESCRIPTION="Tool to monitor logfiles and command output in multiple windows in a terminal, colorize, filter and merge"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.0.0
TERMUX_PKG_SRCURL=https://github.com/folkertvanheusden/multitail/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=23f85f417a003544be38d0367c1eab09ef90c13d007b36482cf3f8a71f9c8fc5
TERMUX_PKG_DEPENDS="libandroid-glob, ncurses, ncurses-ui-libs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/multitail.conf"

termux_step_pre_configure() {
	echo "Applying version.diff"
	sed "s|@VERSION@|${TERMUX_PKG_VERSION#*:}|g" \
		$TERMUX_PKG_BUILDER_DIR/version.diff \
		| patch --silent -p1

	CFLAGS+=" -DNCURSES_WIDECHAR"
	LDFLAGS+=" -landroid-glob"
}
