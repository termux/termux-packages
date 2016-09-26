TERMUX_PKG_HOMEPAGE=http://www.mpfr.org/
TERMUX_PKG_DESCRIPTION="C library for multiple-precision floating-point computations with correct rounding"
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_VERSION=3.1.4
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mpfr/mpfr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_locale_h=no"
