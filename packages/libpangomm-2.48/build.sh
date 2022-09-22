TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="A C++ API for Pango"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.50
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/pangomm/${_MAJOR_VERSION}/pangomm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ccc9923413e408c2bff637df663248327d72822f11e394b423e1c5652b7d9214
TERMUX_PKG_DEPENDS="glib, libc++, libcairomm-1.16, libglibmm-2.68, libsigc++-3.0, pango"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
