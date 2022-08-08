TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parted/
TERMUX_PKG_DESCRIPTION="Versatile partition editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parted/parted-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4938dd5c1c125f6c78b1f4b3e297526f18ee74aa43d45c248578b1d2470c05a2
TERMUX_PKG_DEPENDS="libiconv, libuuid (>> 2.38.1), readline"
TERMUX_PKG_BREAKS="parted-dev"
TERMUX_PKG_REPLACES="parted-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-device-mapper
"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-gnu-designator"
	export LIBS="-liconv"
}
