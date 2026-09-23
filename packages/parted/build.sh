TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parted/
TERMUX_PKG_DESCRIPTION="Versatile partition editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.7
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parted/parted-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=008de57561a4f3c25a0648e66ed11e7b30be493889b64334a6d70f2c1951ef7b
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
