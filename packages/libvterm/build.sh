TERMUX_PKG_HOMEPAGE=http://libvterm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
# libvterm does not do releases, take a specific commit for now:
TERMUX_PKG_VERSION=17.08.04
_COMMIT=6fe2c783d15942f26abdba53eb4144c04e105c96
TERMUX_PKG_SHA256=ed945b667d41641cc71f575a0a51786da3f3f5e8f2bdc5ce20ee0e5b6e26f6f6
TERMUX_PKG_SRCURL=https://github.com/neovim/libvterm/archive/$_COMMIT.zip
TERMUX_PKG_FOLDERNAME=libvterm-$_COMMIT
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	make src/encoding/DECdrawing.inc src/encoding/uk.inc
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR/src
	$CC -std=c99 -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libvterm.so *.c -I../include -I.
	cp ../include/*.h $TERMUX_PREFIX/include/
}
