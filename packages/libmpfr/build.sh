TERMUX_PKG_HOMEPAGE=https://www.mpfr.org/
TERMUX_PKG_DESCRIPTION="C library for multiple-precision floating-point computations with correct rounding"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mpfr/mpfr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ffd195bd567dbaffc3b98b23fd00aad0537680c9896171e44fe3ff79e28ac33d
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BREAKS="libmpfr-dev"
TERMUX_PKG_REPLACES="libmpfr-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_locale_h=no"
