TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Links is a text and graphics mode WWW browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.28
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=2fd5499b13dee59457c132c167b8495c40deda75389489c6cccb683193f454b4
TERMUX_PKG_DEPENDS="brotli, fontconfig, freetype, glib, libbz2, libcairo, libevent, libjpeg-turbo, liblzma, libpng, librsvg, libtiff, libwebp, libx11, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libxt"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
--enable-graphics
--without-openmp
"
