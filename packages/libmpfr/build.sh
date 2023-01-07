TERMUX_PKG_HOMEPAGE=https://www.mpfr.org/
TERMUX_PKG_DESCRIPTION="C library for multiple-precision floating-point computations with correct rounding"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.0
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mpfr/mpfr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=06a378df13501248c1b2db5aa977a2c8126ae849a9d9b7be2546fb4a9c26d993
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BREAKS="libmpfr-dev"
TERMUX_PKG_REPLACES="libmpfr-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_locale_h=no"
