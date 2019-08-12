TERMUX_PKG_HOMEPAGE=http://www.nethack.org/
TERMUX_PKG_DESCRIPTION="Dungeon crawl game"
TERMUX_PKG_VERSION=3.6.0
TERMUX_PKG_SRCURL=https://s3.amazonaws.com/altorg/nethack/nethack-360-src.tgz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="ncurses"

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/sys/unix
	sh setup.sh hints/linux

	cd $TERMUX_PKG_SRCDIR
	make install
}
