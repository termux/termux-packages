TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libunistring/
TERMUX_PKG_DESCRIPTION="Library providing functions for manipulating Unicode strings"
TERMUX_PKG_VERSION=0.9.8
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libunistring/libunistring-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b792f2bd05d0fa7b339e39e353da7232b2e514e0db2cf5ed95beeff3feb53cf5
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_uselocale=no"
