TERMUX_PKG_HOMEPAGE=https://github.com/OpenZWave/open-zwave
TERMUX_PKG_DESCRIPTION="A C++ library to control Z-Wave Networks via a USB Z-Wave Controller"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6-git
TERMUX_PKG_REVISION=5
_COMMIT=a8aa6341f4da161d0747c9cad205d821105ed09d
TERMUX_PKG_SRCURL=https://github.com/OpenZWave/open-zwave/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=2af7f0e58d6c28be9d2229a0ede2e0799bddba617e7fd4f1ab7edcdbad6cf487
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export pkgconfigdir=$TERMUX_PREFIX/lib/pkgconfig
}
