TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Links is a text and graphics mode WWW browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.20.1
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=17619208e75bb45890982b37b834c70cf9c56b6f9f98aadb787efd6a88db7e86
TERMUX_PKG_DEPENDS="libbz2, libevent, liblzma, openssl, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --mandir=$TERMUX_PREFIX/share/man"
