TERMUX_PKG_HOMEPAGE=http://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_DEPENDS="libgmp, libnettle"
_TERMUX_PKG_MAJOR_VERSION=3.4
TERMUX_PKG_VERSION=${_TERMUX_PKG_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=ftp://ftp.gnutls.org/gcrypt/gnutls/v${_TERMUX_PKG_MAJOR_VERSION}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-hardware-acceleration --disable-cxx --disable-openssl-compatibility --with-included-libtasn1 --without-p11-kit"

CFLAGS+=" -std=c99"
