TERMUX_PKG_HOMEPAGE="https://github.com/cisco/libsrtp"
TERMUX_PKG_DESCRIPTION="Library for SRTP (Secure Realtime Transport Protocol)"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.2"
TERMUX_PKG_SRCURL="https://github.com/cisco/libsrtp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=02e8326e12381e27a205ded888a803c6ff55ec7be170cd5e5506251f731fee92
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# force meson for pkgconfig file
	rm configure CMakeLists.txt
}
