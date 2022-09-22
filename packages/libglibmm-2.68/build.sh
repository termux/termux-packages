TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="A C++ API for parts of glib that are useful for C++"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.74
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/glibmm/${_MAJOR_VERSION}/glibmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2b472696cbac79db8e405724118ec945219c5b9b18af63dc8cfb7f1d89b0f1fa
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
