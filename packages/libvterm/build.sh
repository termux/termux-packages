TERMUX_PKG_HOMEPAGE=http://libvterm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
# libvterm does not do releases, take a specific commit for now:
TERMUX_PKG_VERSION=18.02.20
_COMMIT=005845cd58ca409a970d822b74e1a02a503d32e7
TERMUX_PKG_SHA256=2424ee587bc13910894ade21ba75649d558b8c161fa1eb5ed69802ecca47b516
TERMUX_PKG_SRCURL=https://github.com/neovim/libvterm/archive/$_COMMIT.zip
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	make src/encoding/DECdrawing.inc src/encoding/uk.inc
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR/src
	$CC -std=c99 -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libvterm.so *.c -I../include -I.
	cp ../include/*.h $TERMUX_PREFIX/include/
}
