TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl, libnghttp2"
TERMUX_PKG_VERSION=7.59.0
TERMUX_PKG_SHA256=b5920ffd6a8c95585fb95070e0ced38322790cb335c39d0dab852d12e157b5a0
TERMUX_PKG_SRCURL=http://curl.askapache.com/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-nghttp2
--without-libidn
--without-librtmp
--with-ssl
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/curl-config share/man/man1/curl-config.1"
