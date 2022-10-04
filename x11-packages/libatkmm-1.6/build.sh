TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="The C++ binding for the ATK library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.28
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/atkmm/${_MAJOR_VERSION}/atkmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7c2088b486a909be8da2b18304e56c5f90884d1343c8da7367ea5cd3258b9969
TERMUX_PKG_DEPENDS="atk, glib, libc++, libglibmm-2.4, libsigc++-2.0"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
