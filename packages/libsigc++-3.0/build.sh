TERMUX_PKG_HOMEPAGE=https://libsigcplusplus.github.io/libsigcplusplus/
TERMUX_PKG_DESCRIPTION="Implements a typesafe callback system for standard C++"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.8.1"
TERMUX_PKG_SRCURL=https://github.com/libsigcplusplus/libsigcplusplus/releases/download/${TERMUX_PKG_VERSION}/libsigc++-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4ff41d1474e501d3baeced4c989d154338206ac16471e614376496b63fe252d1
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME/++/}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
