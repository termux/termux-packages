TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libunistring/
TERMUX_PKG_DESCRIPTION="Library providing functions for manipulating Unicode strings"
TERMUX_PKG_VERSION=0.9.7
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libunistring/libunistring-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9ce081cbee1951b55597b30e7030bda9d7b2f034ef901a135ff3a020be5a41e5
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_uselocale=no"
