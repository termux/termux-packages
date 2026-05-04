TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/xorriso
TERMUX_PKG_DESCRIPTION="Tool for creating ISO files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:1.5.8.pl01"
TERMUX_PKG_SRCURL=https://www.gnu.org/software/xorriso/xorriso-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=0381798b7bb4f162578b4f31fe30bfe53608b5077075967f8df2facfab4c90f9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libiconv, libandroid-support, readline, libbz2, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-jtethreads"

termux_step_pre_configure() {
	./bootstrap
}
