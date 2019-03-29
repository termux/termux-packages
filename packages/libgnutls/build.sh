TERMUX_PKG_HOMEPAGE=https://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_DEPENDS="libgmp, libnettle, ca-certificates, libidn2, libunistring"
TERMUX_PKG_VERSION=3.6.7
TERMUX_PKG_SHA256=5b3409ad5aaf239808730d1ee12fdcd148c0be00262c7edf157af655a8a188e2
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnutls/v${TERMUX_PKG_VERSION:0:3}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEVPACKAGE_DEPENDS="libidn2-dev, libnettle-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-cxx
--disable-hardware-acceleration
--disable-openssl-compatibility
--with-default-trust-store-file=$TERMUX_PREFIX/etc/tls/cert.pem
--with-system-priority-file=${TERMUX_PREFIX}/etc/gnutls/default-priorities
--with-included-libtasn1
--without-p11-kit
"

termux_step_pre_configure() {
	CFLAGS+=" -DNO_INLINE_GETPASS=1"
}
