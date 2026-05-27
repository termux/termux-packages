TERMUX_PKG_HOMEPAGE=https://www.seehuhn.de/programs/moon-buggy
TERMUX_PKG_DESCRIPTION="Simple game where you drive a car across the moon's surface"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL="https://www.seehuhn.de/programs/moon-buggy/moon-buggy-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=259ae6e7b1838c40532af5c0f20cd7c6173cd5c552ede408114064475bcfc5b6
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--sharedstatedir=$TERMUX_PREFIX/var"
TERMUX_PKG_GROUPS="games"

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/share/man/man6
	cp moon-buggy $TERMUX_PREFIX/bin
	cp moon-buggy.6 $TERMUX_PREFIX/share/man/man6
}
