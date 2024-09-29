TERMUX_PKG_HOMEPAGE=https://github.com/rakshasa/rtorrent/wiki
TERMUX_PKG_DESCRIPTION="Libtorrent BitTorrent library"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.14.0
TERMUX_PKG_SRCURL=https://github.com/rakshasa/libtorrent/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0ec8ef7544a551ccbf6fce5c6c535f69cb3ad10e4d5e70e620ecd47fef90a13e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, openssl, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-aligned=true
--without-fastcgi
--with-zlib=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
