TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libunistring/
TERMUX_PKG_DESCRIPTION="Library providing functions for manipulating Unicode strings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.9.10
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=a82e5b333339a88ea4608e4635479a1cfb2e01aafb925e1290b65710d43f610b
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libunistring/libunistring-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_uselocale=no am_cv_langinfo_codeset=yes"
