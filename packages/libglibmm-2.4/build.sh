TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="A C++ API for parts of glib that are useful for C++"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.66
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.5
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/glibmm/${_MAJOR_VERSION}/glibmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7b384662dd6ec3b86c0570331d32af05db2bd99a791602b767b4a0b2566ec149
TERMUX_PKG_DEPENDS="glib, libc++, libsigc++-2.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-examples=false
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
