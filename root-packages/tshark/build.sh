TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer and sniffer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f467cc77f0fc73fce0b854cdbc292f132d4879fca69d417eccad5f967fbf262b
TERMUX_PKG_DEPENDS="glib, libgpg-error, libgcrypt, libnl, libpcap, libgnutls, openssl, libiconv, libcap, c-ares"
TERMUX_PKG_BREAKS="tshark-dev"
TERMUX_PKG_REPLACES="tshark-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_wireshark=OFF
-DENABLE_LUA=OFF
-DHAVE_LINUX_IF_BONDING_H=1
"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	gcc $TERMUX_PKG_SRCDIR/tools/lemon/lemon.c -o lemon
}

termux_step_pre_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
}
