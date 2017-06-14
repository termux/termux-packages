TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl, libnghttp2"
TERMUX_PKG_VERSION=7.54.1
TERMUX_PKG_SRCURL=http://curl.askapache.com/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=fdfc4df2d001ee0c44ec071186e770046249263c491fcae48df0e1a3ca8f25a0
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-nghttp2
--without-libidn
--without-librtmp
--with-ssl
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/curl-config share/man/man1/curl-config.1"
