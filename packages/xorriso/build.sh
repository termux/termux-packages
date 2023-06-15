TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/xorriso
TERMUX_PKG_DESCRIPTION="Tool for creating ISO files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.5.6.pl01
TERMUX_PKG_SRCURL=https://www.gnu.org/software/xorriso/xorriso-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=1b3ebfe1f75c3a561d79290a8d0a0ba947b16c0ff04dcd71cc43c5792ebe5be2
TERMUX_PKG_DEPENDS="libiconv, libandroid-support, readline, libbz2, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-jtethreads"

termux_step_pre_configure() {
	./bootstrap
}
