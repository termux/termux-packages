TERMUX_PKG_HOMEPAGE=https://libsigcplusplus.github.io/libsigcplusplus/
TERMUX_PKG_DESCRIPTION="Implements a typesafe callback system for standard C++"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.6.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsigc++/${TERMUX_PKG_VERSION%.*}/libsigc++-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c3d23b37dfd6e39f2e09f091b77b1541fbfa17c4f0b6bf5c89baef7229080e17
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME/++/}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
