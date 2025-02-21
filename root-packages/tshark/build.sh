TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer and sniffer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4.4"
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5154d2b741ec928b1bdb5eba60e29536f78907b21681a7fe18c652f4db44b1f1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="brotli, c-ares, glib, libandroid-support, libcap, libgcrypt, libgmp, libgnutls, libgpg-error, libiconv, libidn2, liblz4, liblzma, libminizip, libnettle, libnghttp2, libnl, libopus, libpcap, libsnappy, libssh, libunistring, libxml2, openssl, pcre2, speexdsp, zlib, zstd"
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
	LDFLAGS+=" -lm -landroid-support"
	sed -i "s#-T/usr/share/lemon/lempar.c#-T$TERMUX_PKG_SRCDIR/tools/lemon/lempar.c#" $TERMUX_PKG_SRCDIR/cmake/modules/UseLemon.cmake
}
