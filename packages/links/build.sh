TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Links is a text and graphics mode WWW browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.25
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5c0b3b0b8fe1f3c8694f5fb7fbdb19c63278ac68ae4646da69b49640b20283b1
TERMUX_PKG_DEPENDS="brotli, fontconfig, freetype, glib, libbz2, libcairo, libevent, liblzma, libpng, librsvg, libtiff, libx11, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libxt"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
--enable-graphics
--without-openmp
"
