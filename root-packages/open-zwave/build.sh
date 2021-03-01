TERMUX_PKG_HOMEPAGE=https://github.com/OpenZWave/open-zwave
TERMUX_PKG_DESCRIPTION="A C++ library to control Z-Wave Networks via a USB Z-Wave Controller"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6-git
TERMUX_PKG_REVISION=2
_COMMIT=590e999c2d091500845a64b5113374357ae543d1
TERMUX_PKG_SRCURL=https://github.com/OpenZWave/open-zwave/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=2e0d2210a2ff21380c9e77d5a037c1d82657fc99496dffb0a30b32c3310d05b5
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export pkgconfigdir=$TERMUX_PREFIX/lib/pkgconfig
}
