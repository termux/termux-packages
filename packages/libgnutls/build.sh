TERMUX_PKG_HOMEPAGE=https://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_DEPENDS="libgmp, libnettle, ca-certificates, libidn, libunistring"
_TERMUX_PKG_MAJOR_VERSION=3.5
TERMUX_PKG_VERSION=${_TERMUX_PKG_MAJOR_VERSION}.13
TERMUX_PKG_SRCURL=ftp://ftp.gnutls.org/gcrypt/gnutls/v${_TERMUX_PKG_MAJOR_VERSION}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=79f5480ad198dad5bc78e075f4a40c4a315a1b2072666919d2d05a08aec13096
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-hardware-acceleration --disable-cxx --disable-openssl-compatibility --with-included-libtasn1 --without-p11-kit --with-default-trust-store-file=$TERMUX_PREFIX/etc/tls/cert.pem"

termux_step_pre_configure() {
	CFLAGS+=" -std=c99"
}
