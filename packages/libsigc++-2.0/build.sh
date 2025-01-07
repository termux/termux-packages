TERMUX_PKG_HOMEPAGE=https://libsigcplusplus.github.io/libsigcplusplus/
TERMUX_PKG_DESCRIPTION="Implements a typesafe callback system for standard C++"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.12.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsigc++/${TERMUX_PKG_VERSION%.*}/libsigc++-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a9dbee323351d109b7aee074a9cb89ca3e7bcf8ad8edef1851f4cf359bd50843
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
-Dbuild-tests=false
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME/++/}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
