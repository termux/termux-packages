TERMUX_PKG_HOMEPAGE=https://www.fefe.de/fortune/
TERMUX_PKG_DESCRIPTION="Revealer of fortunes"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=http://dl.fefe.de/fortune-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=cbb246a500366db39ce035632eb4954e09f1e03b28f2c4688864bfa8661b236a

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR
	$CC $CFLAGS fortune.c -o $TERMUX_PREFIX/bin/fortune
	mkdir -p $TERMUX_PREFIX/share/man/man6
	cp debian/fortune.6 $TERMUX_PREFIX/share/man/man6/

	local TARFILE=$TERMUX_PKG_CACHEDIR/f.tar.gz
	if [ ! -f $TARFILE ]; then
		curl --retry 3 -L -o $TARFILE http://http.debian.net/debian/pool/main/f/fortune-mod/fortune-mod_1.99.1.orig.tar.gz
	fi
	cd $TERMUX_PKG_TMPDIR
	mkdir datfiles
	cd datfiles
	tar xf $TARFILE
	cd fortune-mod-1.99.1/datfiles
	rm -Rf html off Makefile
	mkdir -p $TERMUX_PREFIX/share/games/fortunes
	cp * $TERMUX_PREFIX/share/games/fortunes
}
