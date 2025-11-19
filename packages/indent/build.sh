TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/indent/
TERMUX_PKG_DESCRIPTION="C language source code formatting program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.13
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/indent/indent-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=1b81ba4e9a006ca8e6eb5cbbe4cf4f75dfc1fc9301b459aa0d40393e85590a0b
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setlocale=no"
TERMUX_PKG_RM_AFTER_INSTALL="bin/texinfo2man"
