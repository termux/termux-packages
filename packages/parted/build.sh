TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parted/
TERMUX_PKG_DESCRIPTION="Versatile partition editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parted/parted-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e1298022472da5589b7f2be1d5ee3c1b66ec3d96dfbad03dc642afd009da5342
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
