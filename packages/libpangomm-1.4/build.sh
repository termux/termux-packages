TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="A C++ API for Pango"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.46.4"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pangomm/${TERMUX_PKG_VERSION%.*}/pangomm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b92016661526424de4b9377f1512f59781f41fb16c9c0267d6133ba1cd68db22
TERMUX_PKG_DEPENDS="glib, libc++, libcairomm-1.0, libglibmm-2.4, libsigc++-2.0, pango"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
