TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/mtools/
TERMUX_PKG_DESCRIPTION="Tool for manipulating FAT images."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.0.25
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mtools/mtools-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=fd161eec3bb7a93d13936db67725ad3e17f2d5f4e6fa8f7667fbc7ac728e2c15
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-floppyd
ac_cv_lib_bsd_main=no
"

termux_step_pre_configure() {
	export LIBS="-liconv"
}
