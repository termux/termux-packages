TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parted/
TERMUX_PKG_DESCRIPTION="Versatile partition editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parted/parted-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=57e2b4bd87018625c515421d4524f6e3b55175b472302056391c5f7eccb83d44
TERMUX_PKG_DEPENDS="libiconv, libuuid, readline"
TERMUX_PKG_BREAKS="parted-dev"
TERMUX_PKG_REPLACES="parted-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-device-mapper
"

termux_step_pre_configure() {
    CFLAGS+=" -Wno-gnu-designator"
    export LIBS="-liconv"
}
