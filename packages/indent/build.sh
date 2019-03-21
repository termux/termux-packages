TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/indent/
TERMUX_PKG_DESCRIPTION="C language source code formatting program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.2.12
TERMUX_PKG_SHA256=b745a5dfc68f86a483d7f96dc1cda7aafd1e78ecba3c7d8ad304709e91e1defb
TERMUX_PKG_SRCURL=http://mirrors.kernel.org/gnu/indent/indent-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setlocale=no"
TERMUX_PKG_RM_AFTER_INSTALL="bin/texinfo2man"
