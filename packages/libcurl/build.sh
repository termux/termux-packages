TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_DEPENDS="openssl (>= 1.1.1), libnghttp2"
TERMUX_PKG_VERSION=7.62.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=55ccd5b5209f8cc53d4250e2a9fd87e6f67dd323ae8bd7d06b072cfcbb7836cb
TERMUX_PKG_SRCURL=https://curl.haxx.se/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
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
