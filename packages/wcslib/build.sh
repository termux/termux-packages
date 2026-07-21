TERMUX_PKG_HOMEPAGE=https://www.atnf.csiro.au/people/Mark.Calabretta/WCS/
TERMUX_PKG_DESCRIPTION="a C library that implements the 'World Coordinate System' (WCS) standard in FITS"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.9"
TERMUX_PKG_SRCURL="https://www.atnf.csiro.au/computing/software/wcs/wcslib-releases/wcslib-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=82ac09ce5091b0bf06cec8f5cdeec1dabe1d06ba5dfb7ff2bdb0c1680488807b
TERMUX_PKG_DEPENDS="cfitsio"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-cfitsioinc=${TERMUX_PREFIX}/include
--with-cfitsiolib=${TERMUX_PREFIX}/lib
"

termux_step_pre_configure() {
	autoreconf -vfi
}
