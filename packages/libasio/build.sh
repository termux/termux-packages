TERMUX_PKG_HOMEPAGE="https://think-async.com/Asio"
TERMUX_PKG_DESCRIPTION="Cross-platform C++ library for network and low-level I/O programming"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.36.0"
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/project/asio/asio/${TERMUX_PKG_VERSION}%20%28Stable%29/asio-${TERMUX_PKG_VERSION}.zip"
TERMUX_PKG_SHA256=e4613701d74113dbc691f53aaf29266147b3d55249fa046c74a57a2c9ed2fb27
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, openssl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fi
}
