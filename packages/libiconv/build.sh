TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libiconv/
TERMUX_PKG_DESCRIPTION="An implementation of iconv()"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.19"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libiconv/libiconv-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=88dd96a8c0464eca144fc791ae60cd31cd8ee78321e67397e25fc095c4a19aa6
TERMUX_PKG_BREAKS="libandroid-support (<= 24), libiconv-dev, libandroid-support-dev"
TERMUX_PKG_REPLACES="libandroid-support (<= 24), libiconv-dev, libandroid-support-dev"

# Enable extra encodings (such as CP437) needed by some programs:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-extra-encodings"
