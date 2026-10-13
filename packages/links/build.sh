TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Links is a text and graphics mode WWW browser"
# License: GPL-2.0-with-OpenSSL-exception
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.30"
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=c4631c6b5a11527cdc3cb7872fc23b7f2b25c2b021d596be410dadb40315f166
TERMUX_PKG_DEPENDS="brotli, fontconfig, freetype, glib, libbz2, libcairo, libevent, libjpeg-turbo, liblzma, libpng, librsvg, libtiff, libwebp, libx11, openssl, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="libxt"
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
--enable-graphics
--without-openmp
"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-error=implicit-function-declaration"
}
