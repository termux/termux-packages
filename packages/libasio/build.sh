TERMUX_PKG_HOMEPAGE="https://think-async.com/Asio"
TERMUX_PKG_DESCRIPTION="Cross-platform C++ library for network and low-level I/O programming"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/asio/asio/${TERMUX_PKG_VERSION}%20%28Stable%29/asio-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=b628291471aee837ff951ea38c8a3a0b00ff99fd2a1ff3b7c7d3d993c0030b73
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, openssl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fi
}
