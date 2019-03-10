TERMUX_PKG_HOMEPAGE=https://www.mpfr.org/
TERMUX_PKG_DESCRIPTION="C library for multiple-precision floating-point computations with correct rounding"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_VERSION=4.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=1d3be708604eae0e42d578ba93b390c2a145f17743a744d8f3f8c2ad5855a38a
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mpfr/mpfr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_locale_h=no"
