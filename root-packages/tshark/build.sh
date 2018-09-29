TERMUX_PKG_HOMEPAGE=https://www.aircrack-ng.org
TERMUX_PKG_DESCRIPTION="network protocol analyzer and sniffer"
TERMUX_PKG_VERSION=2.6.3
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d158a8a626dc0997a826cf12b5316a3d393fb9f93d84cc86e75b212f0044a3ec
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_DEPENDS="glib, libgpg-error, libgcrypt, libnl, libpcap, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-qt=no
--disable-wireshark
--with-lua=no
"

termux_step_pre_configure () {
	./autogen.sh
	LDFLAGS+=" -L$TERMUX_PKG_BUILDDIR/wsutil/.libs -L$TERMUX_PKG_BUILDDIR/epan/.libs" #A bit hacky..
}
