TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/mtools/
TERMUX_PKG_DESCRIPTION="Tool for manipulating FAT images."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.0.23
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=f188db26751aeb5692a79b2380b440ecc05fd1848a52f869d7ca1193f2ef8ee3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mtools/mtools-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-floppyd
ac_cv_lib_bsd_main=no
"

termux_step_pre_configure() {
	export LIBS="-liconv"
}
