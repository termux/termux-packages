TERMUX_PKG_HOMEPAGE=http://libvterm.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Terminal emulator library"
TERMUX_PKG_VERSION=0.0.`date "+%Y%m%d%H%M"`
TERMUX_PKG_SRCURL=https://github.com/neovim/libvterm/archive/master.zip
TERMUX_PKG_FOLDERNAME="libvterm-master"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	make src/encoding/DECdrawing.inc src/encoding/uk.inc
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR/src
	$CC -std=c99 -shared -fPIC $LDFLAGS -o $TERMUX_PREFIX/lib/libvterm.so *.c -I../include -I.
	cp ../include/*.h $TERMUX_PREFIX/include/
}
