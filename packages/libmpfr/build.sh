TERMUX_PKG_HOMEPAGE=http://www.mpfr.org/
TERMUX_PKG_DESCRIPTION="C library for multiple-precision floating-point computations with correct rounding"
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_VERSION=4.0.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mpfr/mpfr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=67874a60826303ee2fb6affc6dc0ddd3e749e9bfcb4c8655e3953d0458a6e16e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_header_locale_h=no"
if [ $TERMUX_ARCH = i686 ]; then
	# Avoid clang bug with NDK r16:
	TERMUX_PKG_CLANG=no
fi
