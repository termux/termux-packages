TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl, libnghttp2"
TERMUX_PKG_VERSION=7.51.0
TERMUX_PKG_SRCURL=http://curl.askapache.com/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7f8240048907e5030f67be0a6129bc4b333783b9cca1391026d700835a788dde
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl --without-libidn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-nghttp2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --without-librtmp"
TERMUX_PKG_RM_AFTER_INSTALL="bin/curl-config share/man/man1/curl-config.1"
