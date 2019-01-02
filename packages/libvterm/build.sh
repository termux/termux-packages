TERMUX_PKG_HOMEPAGE=http://libvterm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
# libvterm does not do releases, take a specific commit for now:
TERMUX_PKG_VERSION=18.12.22
_COMMIT=26c3468c51d1c8f1a26aa1252783b04845ccc9f9
TERMUX_PKG_SHA256=ea0abe90cdeac7c4141933540dc5868bc4ef4004d135e798716f8c9021e1951f
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
