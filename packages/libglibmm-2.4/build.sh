TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="A C++ API for parts of glib that are useful for C++"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.66.8"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/glibmm/${TERMUX_PKG_VERSION%.*}/glibmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=64f11d3b95a24e2a8d4166ecff518730f79ecc27222ef41faf7c7e0340fc9329
TERMUX_PKG_DEPENDS="glib, libc++, libsigc++-2.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
