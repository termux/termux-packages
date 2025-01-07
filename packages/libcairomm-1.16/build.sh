TERMUX_PKG_HOMEPAGE=https://www.cairographics.org/cairomm/
TERMUX_PKG_DESCRIPTION="Provides a C++ interface to cairo"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.18.0"
TERMUX_PKG_SRCURL=https://www.cairographics.org/releases/cairomm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b81255394e3ea8e8aa887276d22afa8985fc8daef60692eb2407d23049f03cfb
TERMUX_PKG_DEPENDS="libc++, libcairo, libsigc++-3.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
-Dbuild-tests=false
-Dboost-shared=true
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
