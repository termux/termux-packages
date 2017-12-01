TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl, libnghttp2"
TERMUX_PKG_VERSION=7.56.1
TERMUX_PKG_SHA256=2594670367875e7d87b0f129b5e4690150780884d90244ba0fe3e74a778b5f90
TERMUX_PKG_SRCURL=http://curl.askapache.com/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-nghttp2
--without-libidn
--without-librtmp
--with-ssl
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/curl-config share/man/man1/curl-config.1"
