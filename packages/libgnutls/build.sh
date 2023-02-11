TERMUX_PKG_HOMEPAGE=https://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.7.9
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnutls/v${TERMUX_PKG_VERSION:0:3}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=aaa03416cdbd54eb155187b359e3ec3ed52ec73df4df35a0edd49429ff64d844
TERMUX_PKG_DEPENDS="libc++, libgmp, libnettle, ca-certificates, libidn2, libunistring, unbound"
TERMUX_PKG_BREAKS="libgnutls-dev"
TERMUX_PKG_REPLACES="libgnutls-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-cxx
--disable-hardware-acceleration
--disable-openssl-compatibility
--with-default-trust-store-file=$TERMUX_PREFIX/etc/tls/cert.pem
--with-system-priority-file=${TERMUX_PREFIX}/etc/gnutls/default-priorities
--with-unbound-root-key-file=$TERMUX_PREFIX/etc/unbound/root.key
--with-included-libtasn1
--enable-local-libopts
--without-p11-kit
--disable-guile
--disable-doc
"

termux_step_pre_configure() {
	CFLAGS+=" -DNO_INLINE_GETPASS=1"
}
