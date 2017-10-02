TERMUX_PKG_HOMEPAGE=http://www.mpfr.org/
TERMUX_PKG_DESCRIPTION="C library for multiple-precision floating-point computations with correct rounding"
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_VERSION=3.1.6
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mpfr/mpfr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7a62ac1a04408614fccdc506e4844b10cf0ad2c2b1677097f8f35d3a1344a950
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_locale_h=no"
