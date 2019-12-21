TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/xorriso
TERMUX_PKG_DESCRIPTION="Tool for creating ISO files."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.5.3
TERMUX_PKG_SRCURL=https://www.gnu.org/software/xorriso/xorriso-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bb8db9274caecd44993e8242e6acff4298b3508b83ac3c51c9fd970b9e765adc
TERMUX_PKG_DEPENDS="libiconv, libandroid-support, readline, libbz2, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-jtethreads"

termux_step_pre_configure() {
	./bootstrap
}
