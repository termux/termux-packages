TERMUX_PKG_HOMEPAGE=https://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_DEPENDS="libgmp, libnettle, ca-certificates, libidn, libunistring"
TERMUX_PKG_VERSION=3.5.15
TERMUX_PKG_SHA256=046081108b8b1fe455a13a4c5a4eaa0368e185b678f1670fe09a11a2d7ecfad5
TERMUX_PKG_SRCURL=ftp://ftp.gnutls.org/gcrypt/gnutls/v${TERMUX_PKG_VERSION:0:3}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-cxx
--disable-hardware-acceleration
--disable-openssl-compatibility
--with-default-trust-store-file=$TERMUX_PREFIX/etc/tls/cert.pem
--with-included-libtasn1
--without-p11-kit
"
