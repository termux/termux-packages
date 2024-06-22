TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="A C++ API for Pango"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.52.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pangomm/${TERMUX_PKG_VERSION%.*}/pangomm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=34a134126a6484ff12f774358c36ecc44d0e9df094e1b83796d9774bb7d24947
TERMUX_PKG_DEPENDS="glib, libc++, libcairomm-1.16, libglibmm-2.68, libsigc++-3.0, pango"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
