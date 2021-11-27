TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/broguegame/
TERMUX_PKG_DESCRIPTION="Roguelike dungeon crawling game"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.5
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/termux/distfiles/releases/download/2021.01.04/brogue-${TERMUX_PKG_VERSION}-linux-amd64.tbz2
TERMUX_PKG_SHA256=a74ff18139564c597d047cfb167f74ab1963dd8608b6fb2e034e7635d6170444
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_MAKE_ARGS="curses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
        CFLAGS+=" -fcommon"
	CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS"
}

termux_step_make_install () {
	install -m700 bin/brogue $TERMUX_PREFIX/bin
}
