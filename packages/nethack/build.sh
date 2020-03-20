TERMUX_PKG_HOMEPAGE=http://www.nethack.org/
TERMUX_PKG_DESCRIPTION="Dungeon crawl game"
TERMUX_PKG_LICENSE="Nethack"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=3.6.6
TERMUX_PKG_SRCURL=http://www.nethack.org/download/${TERMUX_PKG_VERSION}/nethack-${TERMUX_PKG_VERSION//./}-src.tgz
TERMUX_PKG_SHA256=cfde0c3ab6dd7c22ae82e1e5a59ab80152304eb23fb06e3129439271e5643ed2
TERMUX_PKG_DEPENDS="gzip, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/sys/unix
	sh setup.sh hints/linux
	CFLAGS="$CPPFLAGS $CFLAGS $LDFLAGS"
	cd $TERMUX_PKG_SRCDIR
	cd util
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		HOST_CC="gcc -m32"
        else
		HOST_CC="gcc"
	fi
	CFLAGS="" CC="$HOST_CC" LD="ld" make makedefs
	cp makedefs makedefs.host
	CFLAGS="" CC="$HOST_CC" LD="ld" make lev_comp
	cp lev_comp lev_comp.host
	CFLAGS="" CC="$HOST_CC" LD="ld" make dgn_comp dlb recover
	cp dgn_comp dgn_comp.host
	cp dlb dlb.host
	cd ../
	make clean
	make WINTTYLIB="$LDFLAGS -lcurses"  -j $TERMUX_MAKE_PROCESSES
	make install
	cd doc
	mkdir -p $TERMUX_PREFIX/share/man/man6
	cp nethack.6 $TERMUX_PREFIX/share/man/man6/
	ln -sf $TERMUX_PREFIX/games/nethack $TERMUX_PREFIX/bin/
}
