TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl, libnghttp2"
TERMUX_PKG_VERSION=7.60.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=897dfb2204bd99be328279f88f55b7c61592216b0542fcbe995c60aa92871e9b
TERMUX_PKG_SRCURL=http://curl.askapache.com/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-ntlm-wb=$TERMUX_PREFIX/bin/ntlm_auth
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-nghttp2
--without-libidn
--without-libidn2
--without-librtmp
--without-brotli
--with-ssl
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/curl-config share/man/man1/curl-config.1"
