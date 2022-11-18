TERMUX_PKG_HOMEPAGE=https://github.com/virtualsquare/vde-2
TERMUX_PKG_DESCRIPTION="Virtual Distributed Ethernet for emulators like qemu"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_SRCURL=https://github.com/virtualsquare/vde-2/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a7d2cc4c3d0c0ffe6aff7eb0029212f2b098313029126dcd12dc542723972379
TERMUX_PKG_DEPENDS="libpcap, libwolfssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf --install
	CFLAGS+=" -Dindex=strchr -Drindex=strrchr"
}
