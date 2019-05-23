TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer and sniffer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=86864c3d0f6c2311992a98d8ea7dfd429097fe62dae2e5516e1a2f6bef2ac08c
TERMUX_PKG_DEPENDS="glib, libgpg-error, libgcrypt, libnl, libpcap, libgnutls, openssl, libiconv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_wireshark=OFF
-DENABLE_LUA=OFF
-DHAVE_LINUX_IF_BONDING_H=1
"
TERMUX_PKG_HOSTBUILD=yes

termux_step_host_build() {
	gcc $TERMUX_PKG_SRCDIR/tools/lemon/lemon.c -o lemon
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
}
