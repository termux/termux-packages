TERMUX_PKG_HOMEPAGE=http://libvterm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
TERMUX_PKG_LICENSE="MIT"
# libvterm does not do releases, take a specific commit for now:
TERMUX_PKG_VERSION=18.11.26
_COMMIT=7a3913a4f465fbf4f59a049f43da8d97fc573a97
TERMUX_PKG_SHA256=1da101b5b5885acc83e9f84e2ac2d93d97ac85e09122af3d5dd2606d8fe93b10
TERMUX_PKG_SRCURL=https://github.com/neovim/libvterm/archive/$_COMMIT.zip
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
	make src/encoding/DECdrawing.inc src/encoding/uk.inc
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/src
	$CC -std=c99 -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libvterm.so *.c -I../include -I.
	cp ../include/*.h $TERMUX_PREFIX/include/
}
