TERMUX_PKG_HOMEPAGE=http://libvterm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
# libvterm does not do releases, take a specific commit for now:
TERMUX_PKG_VERSION=17.10.05
_COMMIT=4ca7ebf7d25856e90bc9d9cc49412e80be7c4ea8
TERMUX_PKG_SHA256=287be22b5c11119959be63d938032b3a1c33e06b7a3a822ba075b3ec687a34f0
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
