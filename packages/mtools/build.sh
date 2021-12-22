TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/mtools/
TERMUX_PKG_DESCRIPTION="Tool for manipulating FAT images."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.35
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mtools/mtools-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_SHA256=0778c2a96cce205f1c5b702e2fe2eaacc9af7628ef28b943e1b600a3ddd85dbe
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-floppyd
ac_cv_lib_bsd_main=no
"

termux_step_pre_configure() {
	export LIBS="-liconv"
}
