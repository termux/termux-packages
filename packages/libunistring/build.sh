TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libunistring/
TERMUX_PKG_DESCRIPTION="Library providing functions for manipulating Unicode strings"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libunistring/libunistring-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=827c1eb9cb6e7c738b171745dac0888aa58c5924df2e59239318383de0729b98
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"
TERMUX_PKG_BREAKS="libunistring-dev"
TERMUX_PKG_REPLACES="libunistring-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_uselocale=no am_cv_langinfo_codeset=yes"
