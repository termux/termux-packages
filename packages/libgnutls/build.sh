TERMUX_PKG_HOMEPAGE=https://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_DEPENDS="libgmp, libnettle, ca-certificates, libidn, libunistring"
_TERMUX_PKG_MAJOR_VERSION=3.5
TERMUX_PKG_VERSION=${_TERMUX_PKG_MAJOR_VERSION}.11
TERMUX_PKG_SRCURL=ftp://ftp.gnutls.org/gcrypt/gnutls/v${_TERMUX_PKG_MAJOR_VERSION}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=51765cc5579e250da77fbd7871507c517d01b15353cc40af7b67e9ec7b6fe28f
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-hardware-acceleration --disable-cxx --disable-openssl-compatibility --with-included-libtasn1 --without-p11-kit --with-default-trust-store-file=$TERMUX_PREFIX/etc/tls/cert.pem"

termux_step_pre_configure() {
	CFLAGS+=" -std=c99"
}
