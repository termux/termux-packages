TERMUX_PKG_HOMEPAGE=https://www.cairographics.org/cairomm/
TERMUX_PKG_DESCRIPTION="Provides a C++ interface to cairo"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.14.3
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://www.cairographics.org/releases/cairomm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0d37e067c5c4ca7808b7ceddabfe1932c5bd2a750ad64fb321e1213536297e78
TERMUX_PKG_DEPENDS="libc++, libcairo, libsigc++-2.0"
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
