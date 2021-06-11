TERMUX_PKG_HOMEPAGE=https://github.com/OpenZWave/open-zwave
TERMUX_PKG_DESCRIPTION="A C++ library to control Z-Wave Networks via a USB Z-Wave Controller"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6-git
TERMUX_PKG_REVISION=4
_COMMIT=38f8f6caf7f14a99d37946fa81eece436ad16643
TERMUX_PKG_SRCURL=https://github.com/OpenZWave/open-zwave/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=d69d0fb772a233e290e9c6d226c858f5b7d49437419263c2c277b331bcf8d13f
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export pkgconfigdir=$TERMUX_PREFIX/lib/pkgconfig
}
