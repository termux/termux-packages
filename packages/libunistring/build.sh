TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/libunistring/
TERMUX_PKG_DESCRIPTION="Library providing functions for manipulating Unicode strings"
TERMUX_PKG_VERSION=0.9.5
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/libunistring/libunistring-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_uselocale=no"
