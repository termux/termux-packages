TERMUX_PKG_HOMEPAGE=http://links.twibright.com
TERMUX_PKG_DESCRIPTION="Links is a text and graphics mode WWW browser"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.19
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://links.twibright.com/download/links-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=37299f804f22c945bf63e22a7bc4418bbb8144b410c0ced70b82ebe6f9e3c82b
TERMUX_PKG_DEPENDS="libbz2, libevent, liblzma, openssl, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --mandir=$TERMUX_PREFIX/share/man"
