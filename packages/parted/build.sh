TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parted/
TERMUX_PKG_DESCRIPTION="Versatile partition editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.8"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parted/parted-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a2b7811f47b0ddb1f7b1d0aa456f7c1270da70708ce231c2fe054c7199eafa63
TERMUX_PKG_DEPENDS="libblkid, libiconv, libuuid, ncurses, readline"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="parted-dev"
TERMUX_PKG_REPLACES="parted-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-device-mapper
"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-gnu-designator"
	export LIBS="-liconv"
}
