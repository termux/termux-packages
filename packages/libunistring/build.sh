TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libunistring/
TERMUX_PKG_DESCRIPTION="Library providing functions for manipulating Unicode strings"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libunistring/libunistring-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f245786c831d25150f3dfb4317cda1acc5e3f79a5da4ad073ddca58886569527
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"
TERMUX_PKG_BREAKS="libunistring-dev"
TERMUX_PKG_REPLACES="libunistring-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_uselocale=no am_cv_langinfo_codeset=yes"
