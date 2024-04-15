TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="A C++ API for parts of glib that are useful for C++"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.80.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/glibmm/${TERMUX_PKG_VERSION%.*}/glibmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=539b0a29e15a96676c4f0594541250566c5ca44da5d4d87a3732fa2d07909e4a
TERMUX_PKG_DEPENDS="glib, libc++, libsigc++-3.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
