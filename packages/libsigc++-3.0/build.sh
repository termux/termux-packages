TERMUX_PKG_HOMEPAGE=https://libsigcplusplus.github.io/libsigcplusplus/
TERMUX_PKG_DESCRIPTION="Implements a typesafe callback system for standard C++"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.4
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsigc++/${_MAJOR_VERSION}/libsigc++-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=02e2630ffb5ce93cd52c38423521dfe7063328863a6e96d41d765a6116b8707e
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME/++/}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
