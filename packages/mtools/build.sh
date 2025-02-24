TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/mtools/
TERMUX_PKG_DESCRIPTION="Tool for manipulating FAT images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.48"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mtools/mtools-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_SHA256=7d57f14a2482dc4658e4b386180793ef50f0de89ee3a9a28f0a371630baac7c4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-floppyd
ac_cv_lib_bsd_main=no
"

termux_step_pre_configure() {
	export LIBS="-liconv"
}
