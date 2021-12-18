TERMUX_PKG_HOMEPAGE=http://a-nikolaev.github.io/curseofwar/
TERMUX_PKG_DESCRIPTION="Fast-paced action strategy game focusing on high-level strategic planning"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/a-nikolaev/curseofwar/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2a90204d95a9f29a0e5923f43e65188209dc8be9d9eb93576404e3f79b8a652b
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_GROUPS="games"

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/share/man/man6
	cp curseofwar $TERMUX_PREFIX/bin
	cp $TERMUX_PKG_SRCDIR/curseofwar.6 $TERMUX_PREFIX/share/man/man6
}
