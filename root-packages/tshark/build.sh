TERMUX_PKG_HOMEPAGE=https://www.aircrack-ng.org
TERMUX_PKG_DESCRIPTION="network protocol analyzer and sniffer"
TERMUX_PKG_VERSION=2.4.4
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=049a758e39422dcd536d7f75cebbfaa44e4f305d602bf22964d6459821126f58
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_DEPENDS="libnl, openssl, libpcap, libpcap-dev, libcrypt, libgcrypt-dev, glib"
# As GUI is not supported by termux we need to disable wireshark
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-qt=no --disable-wireshark"

termux_step_pre_configure () {
	./autogen.sh
	LDFLAGS+=" -L$TERMUX_PKG_BUILDDIR/wsutil/.libs -L$TERMUX_PKG_BUILDDIR/epan/.libs" #A bit hacky.. 
}
