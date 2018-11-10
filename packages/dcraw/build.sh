TERMUX_PKG_HOMEPAGE=http://www.cybercom.net/~dcoffin/dcraw/
TERMUX_PKG_DESCRIPTION="Raw digital camera images decoding utility"
TERMUX_PKG_VERSION=9.28.0
TERMUX_PKG_SHA256=2890c3da2642cd44c5f3bfed2c9b2c1db83da5cec09cc17e0fa72e17541fb4b9
TERMUX_PKG_SRCURL=http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="littlecms, libjasper, libjpeg-turbo"

termux_step_make_install () {
	# See the "install" script for flags:
	$CC $CFLAGS $CPPFLAGS $LDFLAGS dcraw.c $TERMUX_PKG_BUILDER_DIR/swab.c -lm -ljasper -ljpeg -llcms2 -o $TERMUX_PREFIX/bin/dcraw
        chmod +w dcraw.1 # Add missing write permission
	cp dcraw.1 $TERMUX_PREFIX/share/man/man1/
}
