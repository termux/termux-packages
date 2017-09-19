TERMUX_PKG_HOMEPAGE=http://www.cybercom.net/~dcoffin/dcraw/
TERMUX_PKG_DESCRIPTION="Raw digital camera images decoding utility"
TERMUX_PKG_VERSION=9.27.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.cybercom.net/~dcoffin/dcraw/archive/dcraw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c1d8cc4f19752a3d3aaab1fceb712ea85b912aa25f1f33f68c69cd42ef987099
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="littlecms, libjasper, libjpeg-turbo"

termux_step_make_install () {
	# See the "install" script for flags:
	$CC $CFLAGS $CPPFLAGS $LDFLAGS dcraw.c $TERMUX_PKG_BUILDER_DIR/swab.c -lm -ljasper -ljpeg -llcms2 -o $TERMUX_PREFIX/bin/dcraw
        chmod +w dcraw.1 # Add missing write permission
	cp dcraw.1 $TERMUX_PREFIX/share/man/man1/
}
