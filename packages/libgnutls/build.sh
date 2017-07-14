TERMUX_PKG_HOMEPAGE=https://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_DEPENDS="libgmp, libnettle, ca-certificates, libidn, libunistring"
_TERMUX_PKG_MAJOR_VERSION=3.5
TERMUX_PKG_VERSION=${_TERMUX_PKG_MAJOR_VERSION}.14
TERMUX_PKG_SRCURL=ftp://ftp.gnutls.org/gcrypt/gnutls/v${_TERMUX_PKG_MAJOR_VERSION}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4aa12dec92f42a0434df794aca3d02f6f2a35b47b48c01252de65f355c051bda
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-cxx
--disable-hardware-acceleration
--disable-openssl-compatibility
--with-default-trust-store-file=$TERMUX_PREFIX/etc/tls/cert.pem
--with-included-libtasn1
--without-p11-kit
"

termux_step_pre_configure() {
	CFLAGS+=" -std=c99"
}
