TERMUX_PKG_HOMEPAGE=https://www.cairographics.org/cairomm/
TERMUX_PKG_DESCRIPTION="Provides a C++ interface to cairo"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.18.1"
TERMUX_PKG_SRCURL=https://www.cairographics.org/releases/cairomm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e0e996a979ee52c840dca3ee74f5d005e3259b94ddce58f255d3b6f47c8cb41d
TERMUX_PKG_DEPENDS="libc++, libcairo, libsigc++-3.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
-Dbuild-tests=false
-Dboost-shared=true
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
