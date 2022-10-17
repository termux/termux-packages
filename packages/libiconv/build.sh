TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libiconv/
TERMUX_PKG_DESCRIPTION="An implementation of iconv()"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17
TERMUX_PKG_SRCURL=https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8f74213b56238c85a50a5329f77e06198771e70dd9a739779f4c02f65d971313
TERMUX_PKG_BREAKS="libandroid-support (<= 24), libiconv-dev, libandroid-support-dev"
TERMUX_PKG_REPLACES="libandroid-support (<= 24), libiconv-dev, libandroid-support-dev"

# Enable extra encodings (such as CP437) needed by some programs:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-extra-encodings"
