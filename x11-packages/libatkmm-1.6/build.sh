TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="The C++ binding for the ATK library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.28.4
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/atkmm/${TERMUX_PKG_VERSION%.*}/atkmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0a142a8128f83c001efb8014ee463e9a766054ef84686af953135e04d28fdab3
TERMUX_PKG_DEPENDS="atk, glib, libc++, libglibmm-2.4, libsigc++-2.0"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
