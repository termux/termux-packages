TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl, libnghttp2"
TERMUX_PKG_VERSION=7.55.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=af1d69ec6f15fe70a2cabaa98309732bf035ef2a735e4e1a3e08754d2780e5b1
TERMUX_PKG_SRCURL=http://curl.askapache.com/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-nghttp2
--without-libidn
--without-librtmp
--with-ssl
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/curl-config share/man/man1/curl-config.1"
