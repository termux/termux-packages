TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Links is a text and graphics mode WWW browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.24
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=225c808ec6fa238ba5956f24750cea5f374075f8aa2e95385883d4f51a0fc37e
TERMUX_PKG_DEPENDS="brotli, libbz2, libevent, liblzma, libpng, librsvg, libtiff, libx11, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libxt"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
--enable-graphics
--without-openmp
"
