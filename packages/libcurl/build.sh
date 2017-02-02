TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl, libnghttp2"
TERMUX_PKG_VERSION=7.52.1
TERMUX_PKG_SRCURL=http://curl.askapache.com/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_CHECKTYPE=SHA256
TERMUX_PKG_CHECKSUM=d16185a767cb2c1ba3d5b9096ec54e5ec198b213f45864a38b3bda4bbf87389b
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl --without-libidn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-nghttp2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --without-librtmp"
TERMUX_PKG_RM_AFTER_INSTALL="bin/curl-config share/man/man1/curl-config.1"
