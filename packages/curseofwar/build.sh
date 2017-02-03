TERMUX_PKG_HOMEPAGE=http://a-nikolaev.github.io/curseofwar/
TERMUX_PKG_DESCRIPTION="Fast-paced action strategy game focusing on high-level strategic planning"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_SRCURL=https://github.com/a-nikolaev/curseofwar/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME="curseofwar-$TERMUX_PKG_VERSION"

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/share/man/man6
	cp curseofwar $TERMUX_PREFIX/bin
	cp $TERMUX_PKG_SRCDIR/curseofwar.6 $TERMUX_PREFIX/share/man/man6
}
