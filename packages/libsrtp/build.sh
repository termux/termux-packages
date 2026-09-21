TERMUX_PKG_HOMEPAGE="https://github.com/cisco/libsrtp"
TERMUX_PKG_DESCRIPTION="Library for SRTP (Secure Realtime Transport Protocol)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.1"
TERMUX_PKG_SRCURL="https://github.com/cisco/libsrtp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ef5569220749529d778013aae1178391d972570a2b4f7288dda22effa875b07c
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# force meson for pkgconfig file
	rm configure CMakeLists.txt
}
