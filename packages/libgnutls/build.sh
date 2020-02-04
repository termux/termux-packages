TERMUX_PKG_HOMEPAGE=https://www.gnutls.org/
TERMUX_PKG_DESCRIPTION="Secure communications library implementing the SSL, TLS and DTLS protocols and technologies around them"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=3.6.12
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnutls/v${TERMUX_PKG_VERSION:0:3}/gnutls-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bfacf16e342949ffd977a9232556092c47164bd26e166736cf3459a870506c4b
TERMUX_PKG_DEPENDS="libgmp, libnettle, ca-certificates, libidn2, libunistring"
TERMUX_PKG_BREAKS="libgnutls-dev"
TERMUX_PKG_REPLACES="libgnutls-dev"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-cxx
--disable-hardware-acceleration
--disable-openssl-compatibility
--with-default-trust-store-file=$TERMUX_PREFIX/etc/tls/cert.pem
--with-system-priority-file=${TERMUX_PREFIX}/etc/gnutls/default-priorities
--with-included-libtasn1
--without-p11-kit
"

termux_step_pre_configure() {
	CFLAGS+=" -DNO_INLINE_GETPASS=1"
	if $TERMUX_DEBUG; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.termux-build/_cache/android-r20-api-24-v2/bin/../sysroot/usr/include/bits/fortify/string.h:157:22: error: use of undeclared identifier '__USE_FORTIFY_LEVEL'
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
