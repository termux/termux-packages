TERMUX_PKG_HOMEPAGE=https://www.dechifro.org/dcraw/
TERMUX_PKG_DESCRIPTION="Raw digital camera images decoding utility"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.28.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mirrors.dotsrc.org/pub/mirrors/exherbo/dcraw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2890c3da2642cd44c5f3bfed2c9b2c1db83da5cec09cc17e0fa72e17541fb4b9
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="littlecms, libjasper, libjpeg-turbo"

termux_step_make_install() {
	# See the "install" script for flags:
	$CC $CFLAGS $CPPFLAGS $LDFLAGS dcraw.c -lm -ljasper -ljpeg -llcms2 -o $TERMUX_PREFIX/bin/dcraw
	chmod +w dcraw.1 # Add missing write permission
	cp dcraw.1 $TERMUX_PREFIX/share/man/man1/
}
