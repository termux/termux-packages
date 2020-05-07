TERMUX_PKG_HOMEPAGE=https://github.com/rakshasa/rtorrent/wiki
TERMUX_PKG_DESCRIPTION="Libtorrent BitTorrent library"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.13.8
TERMUX_PKG_SRCURL=https://github.com/rakshasa/libtorrent/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0f6c2e7ffd3a1723ab47fdac785ec40f85c0a5b5a42c1d002272205b988be722
TERMUX_PKG_DEPENDS="openssl, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-aligned=true
--without-fastcgi
--with-zlib=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	./autogen.sh
}
