TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libunistring/
TERMUX_PKG_DESCRIPTION="Library providing functions for manipulating Unicode strings"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libunistring/libunistring-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fe89007a8a414ae4790b816b86859e877d3ab135db3c37f06541ff7e85ac344b
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"
TERMUX_PKG_BREAKS="libunistring-dev"
TERMUX_PKG_REPLACES="libunistring-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_uselocale=no am_cv_langinfo_codeset=yes"
