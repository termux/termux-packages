TERMUX_PKG_HOMEPAGE=https://github.com/OpenZWave/open-zwave
TERMUX_PKG_DESCRIPTION="A C++ library to control Z-Wave Networks via a USB Z-Wave Controller"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_VERSION=1.6-git
_COMMIT=5db357e3169945f990c4b2be01b38e506745097a
TERMUX_PKG_SRCURL=https://github.com/OpenZWave/open-zwave/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=c7493ef20e59d10733b0c285c88fec97e3b6578d3ecb7879f4eefaf8c2ddd674
TERMUX_PKG_DEPENDS="libusb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export pkgconfigdir=$TERMUX_PREFIX/lib/pkgconfig
}
