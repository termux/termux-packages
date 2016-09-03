TERMUX_PKG_VERSION=6.1.1
TERMUX_PKG_HOMEPAGE=https://gmplib.org/
TERMUX_PKG_DESCRIPTION="Library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers"
TERMUX_PKG_SRCURL=https://gmplib.org/download/gmp/gmp-${TERMUX_PKG_VERSION}.tar.lz

termux_step_pre_configure() {
	# https://gmplib.org/list-archives/gmp-bugs/2012-April/002620.html
	CFLAGS+=" $LDFLAGS"
}
