TERMUX_PKG_HOMEPAGE=https://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_DEPENDS="libgmp, libnettle, ca-certificates, libidn, libunistring"
TERMUX_PKG_VERSION=3.5.16
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=0924dec90c37c05f49fec966eba3672dab4d336d879e5c06e06e13325cbfec25
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnutls/v${TERMUX_PKG_VERSION:0:3}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEVPACKAGE_DEPENDS="libidn-dev, libnettle-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-cxx
--disable-hardware-acceleration
--disable-openssl-compatibility
--with-default-trust-store-file=$TERMUX_PREFIX/etc/tls/cert.pem
--with-included-libtasn1
--without-p11-kit
"
