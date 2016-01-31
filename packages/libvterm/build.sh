TERMUX_PKG_HOMEPAGE=http://libvterm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
# libvterm does not do releases, take a specific commit for now:
TERMUX_PKG_VERSION=0.0.201601301200
TERMUX_PKG_SRCURL=https://github.com/neovim/libvterm/archive/a9c7c6fd20fa35e0ad3e0e98901ca12dfca9c25c.zip
TERMUX_PKG_FOLDERNAME=libvterm-a9c7c6fd20fa35e0ad3e0e98901ca12dfca9c25c
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	make src/encoding/DECdrawing.inc src/encoding/uk.inc
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR/src
	$CC -std=c99 -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libvterm.so *.c -I../include -I.
	cp ../include/*.h $TERMUX_PREFIX/include/
}
