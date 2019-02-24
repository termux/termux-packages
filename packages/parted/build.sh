TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parted/
TERMUX_PKG_DESCRIPTION="Versatile partition editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parted/parted-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=858b589c22297cacdf437f3baff6f04b333087521ab274f7ab677cb8c6bb78e4
TERMUX_PKG_DEPENDS="libuuid, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-device-mapper
"

termux_step_pre_configure() {
    CFLAGS+=" -Wno-gnu-designator"
}
