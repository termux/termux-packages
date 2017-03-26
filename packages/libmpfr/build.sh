TERMUX_PKG_HOMEPAGE=http://www.mpfr.org/
TERMUX_PKG_DESCRIPTION="C library for multiple-precision floating-point computations with correct rounding"
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_VERSION=3.1.5
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mpfr/mpfr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=015fde82b3979fbe5f83501986d328331ba8ddf008c1ff3da3c238f49ca062bc
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_locale_h=no"
