TERMUX_PKG_HOMEPAGE=http://www.bzip.org/
TERMUX_PKG_DESCRIPTION="BZ2 format compression library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.0.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=4bbea71ae30a0e5a8ddcee8da750bc978a479ba11e04498d082fa65c2f8c1ad5
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/bzip2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	# bzip2 does not use configure. But place man pages at correct path:
	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" $TERMUX_PKG_SRCDIR/Makefile
}

termux_step_make() {
	# bzip2 uses a separate makefile for the shared library
	make -f Makefile-libbz2_so
}

termux_step_make_install() {
	# The shared library makefile contains no install makefile, so issue a normal install to get scripts
	make $TERMUX_PKG_EXTRA_MAKE_ARGS install

	# Clean out statically linked binaries and libs and replace them with shared ones:
	rm -Rf $TERMUX_PREFIX/lib/libbz2*
	rm -Rf $TERMUX_PREFIX/bin/{bzcat,bunzip2}
	cp bzip2-shared $TERMUX_PREFIX/bin/bzip2
	cp libbz2.so.${TERMUX_PKG_VERSION} $TERMUX_PREFIX/lib
	(cd $TERMUX_PREFIX/lib && ln -s libbz2.so.${TERMUX_PKG_VERSION} libbz2.so.1.0)
	(cd $TERMUX_PREFIX/lib && ln -s libbz2.so.${TERMUX_PKG_VERSION} libbz2.so)
	(cd $TERMUX_PREFIX/bin && ln -s bzip2 bzcat)
	(cd $TERMUX_PREFIX/bin && ln -s bzip2 bunzip2)
	# bzgrep should be enough so remove bz{e,f}grep
	rm $TERMUX_PREFIX/bin/bz{e,f}grep $TERMUX_PREFIX/share/man/man1/bz{e,f}grep.1
}
