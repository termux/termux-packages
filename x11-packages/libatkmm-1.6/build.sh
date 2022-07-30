TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="The C++ binding for the ATK library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.28
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/atkmm/${_MAJOR_VERSION}/atkmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a0bb49765ceccc293ab2c6735ba100431807d384ffa14c2ebd30e07993fd2fa4
TERMUX_PKG_DEPENDS="atk, glib, libc++, libglibmm-2.4, libsigc++-2.0"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
