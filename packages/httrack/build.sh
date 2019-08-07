TERMUX_PKG_HOMEPAGE=http://www.httrack.com
TERMUX_PKG_DESCRIPTION="It allows you to download a World Wide Web site from the Internet"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.49.2
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=http://mirror.httrack.com/historical/httrack-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3477a0e5568e241c63c9899accbfcdb6aadef2812fcce0173688567b4c7d4025
TERMUX_PKG_DEPENDS="libiconv, openssl, zlib"
TERMUX_PKG_BREAKS="httrack-dev"
TERMUX_PKG_REPLACES="httrack-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-zlib=$TERMUX_PREFIX LIBS=-liconv"
TERMUX_PKG_BUILD_IN_SRC="yes"
