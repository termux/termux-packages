TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/
TERMUX_PKG_DESCRIPTION="Easy-to-use client-side URL transfer library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=7.69.1
TERMUX_PKG_SRCURL=https://curl.haxx.se/download/curl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2ff5e5bd507adf6aa88ff4bbafd4c7af464867ffb688be93b9930717a56c4de8
TERMUX_PKG_DEPENDS="libnghttp2, openssl (>= 1.1.1), zlib"
TERMUX_PKG_BREAKS="libcurl-dev"
TERMUX_PKG_REPLACES="libcurl-dev"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-ntlm-wb=$TERMUX_PREFIX/bin/ntlm_auth
--with-ca-bundle=$TERMUX_PREFIX/etc/tls/cert.pem
--with-ca-path=$TERMUX_PREFIX/etc/tls/certs
--with-nghttp2
--without-libidn
--without-libidn2
--without-librtmp
--without-brotli
--with-ssl
"


# Starting with version 7.62 curl started enabling http/2 by default.
# Support for http/2 as added in version 1.4.8-8 of the apt package, so we
# conflict with previous versions to avoid broken installations.
TERMUX_PKG_CONFLICTS="apt (<< 1.4.8-8)"
