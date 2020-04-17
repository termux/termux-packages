TERMUX_PKG_HOMEPAGE=https://github.com/OpenZWave/open-zwave
TERMUX_PKG_DESCRIPTION="A C++ library to control Z-Wave Networks via a USB Z-Wave Controller"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/sviete/open-zwave/archive/v$TERMUX_PKG_VERSION.zip
TERMUX_PKG_SHA256=ecf10aa7cd5dd51172e960c0fd3ea418a24ad39d3d5db026d6bfc3d8c08ef4a0
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export pkgconfigdir=$TERMUX_PREFIX/lib/pkgconfig
}
