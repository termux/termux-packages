TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer and sniffer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_VERSION=2.6.7
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e3f4172cef86928d09cefb5eade249bc340a93a2565e4f622dc2514c7b36c1bb
TERMUX_PKG_DEPENDS="glib, libgpg-error, libgcrypt, libnl, libpcap, libgnutls, openssl"
# Needed by pkg-config (since they are dependenies for libgnutls and glib)
TERMUX_PKG_BUILD_DEPENDS="pcre-dev, libnettle-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-qt=no
--disable-wireshark
--with-lua=no
"

termux_step_pre_configure () {
	./autogen.sh
	LDFLAGS+=" -L$TERMUX_PKG_BUILDDIR/wsutil/.libs -L$TERMUX_PKG_BUILDDIR/epan/.libs" #A bit hacky...
}
