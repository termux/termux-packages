TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer and sniffer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=58a7fa8dfe2010a8c8b7dcf66438c653e6493d47eb936ba48ef49d4aa4dbd725
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
