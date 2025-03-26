TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="The C++ API for GTK"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.18.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtkmm/${TERMUX_PKG_VERSION%.*}/gtkmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2ee31c15479fc4d8e958b03c8b5fbbc8e17bc122c2a2f544497b4e05619e33ec
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, graphene, gtk4, libc++, libcairo, libcairomm-1.16, libglibmm-2.68, libpangomm-2.48, libsigc++-3.0"
TERMUX_PKG_BUILD_DEPENDS="libepoxy"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-demos=false
-Dbuild-tests=false
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgtkmm-4.0.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
