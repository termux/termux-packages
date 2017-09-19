TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/broguegame/
TERMUX_PKG_DESCRIPTION="Roguelike dungeon crawling game"
TERMUX_PKG_VERSION=1.7.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sites.google.com/site/broguegame/brogue-${TERMUX_PKG_VERSION}-linux-i386.tbz2
TERMUX_PKG_SHA256=9e313521c4004566ab1518402393f5bd1cc14df097a283c2cc614998b9097e26
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_MAKE_ARGS="curses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS"
}

termux_step_make_install () {
	cp bin/brogue $TERMUX_PREFIX/bin
}
