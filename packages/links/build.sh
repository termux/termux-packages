TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Links is a text and graphics mode WWW browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.27
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b3e7f302e748f6394806aaac28ea878dbfa2af38745d96507adf68a0a541ba8b
TERMUX_PKG_DEPENDS="brotli, fontconfig, freetype, glib, libbz2, libcairo, libevent, liblzma, libpng, librsvg, libtiff, libx11, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libxt"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
--enable-graphics
--without-openmp
"
