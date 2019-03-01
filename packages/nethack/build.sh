# TODO: move to game-packages repo
TERMUX_PKG_HOMEPAGE=http://www.nethack.org/
TERMUX_PKG_DESCRIPTION="Dungeon crawl game"
TERMUX_PKG_LICENSE="Nethack"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=3.6.1
TERMUX_PKG_SRCURL=http://www.nethack.org/download/3.6.1/nethack-361-src.tgz
TERMUX_PKG_SHA256=4b8cbf1cc3ad9f6b9bae892d44a9c63106d44782a210906162a7c3be65040ab6
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/sys/unix
	sh setup.sh hints/linux
	CFLAGS="$CPPFLAGS $CFLAGS $LDFLAGS"
	cd $TERMUX_PKG_SRCDIR
	cd util
	CFLAGS="" CC="gcc" LD="ld" make  makedefs
	cp makedefs makedefs.host
	CFLAGS="" CC="gcc" LD="ld" make lev_comp
	cp lev_comp lev_comp.host
	CFLAGS="" CC="gcc" LD="ld" make dgn_comp dlb recover
	cp dgn_comp dgn_comp.host
	cp dlb dlb.host
	cd ../
	make clean
	make WINTTYLIB="$LDFLAGS -lcurses"  -j $TERMUX_MAKE_PROCESSES
	make install
	#mkdir -p $TERMUX_PREFIX/share/man/man6
	cd doc #	zsh
	mkdir -p $TERMUX_PREFIX/share/man/man6
	cp nethack.6 $TERMUX_PREFIX/share/man/man6/
	ln -sf $TERMUX_PREFIX/games/nethack $TERMUX_PREFIX/bin/
}
