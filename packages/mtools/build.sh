TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/mtools/
TERMUX_PKG_DESCRIPTION="Tool for manipulating FAT images"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.44"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/mtools/mtools-${TERMUX_PKG_VERSION}.tar.lz
TERMUX_PKG_SHA256=e9cd7fff9e107b69a57bcbd59e9ccd76448cd5db0194a2383757e421994b21d7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libiconv"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-floppyd
ac_cv_lib_bsd_main=no
"

termux_step_pre_configure() {
	export LIBS="-liconv"
}
