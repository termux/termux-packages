TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=7.65.3
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://curl.haxx.se/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0a855e83be482d7bc9ea00e05bdb1551a44966076762f9650959179c89fce509
TERMUX_PKG_DEPENDS="libnghttp2, openssl (>= 1.1.1), zlib"
TERMUX_PKG_CONFLICTS="apt (<< 1.4.8-8), curl, libcurl-dev"
TERMUX_PKG_REPLACES="curl, libcurl-dev"
TERMUX_PKG_PROVIDES="curl"
TERMUX_PKG_ESSENTIAL=yes

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
