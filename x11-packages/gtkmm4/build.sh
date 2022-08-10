TERMUX_PKG_HOMEPAGE=https://www.gtkmm.org/
TERMUX_PKG_DESCRIPTION="The C++ API for GTK"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
# Newer version requires newer gtk4 which has build issue.
_MAJOR_VERSION=4.2
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtkmm/${_MAJOR_VERSION}/gtkmm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=480c4c38f2e7ffcf58f56bb4b4d612f3f0cac9fd5908fd2cd8249fe10592a98b
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, graphene, gtk4, libc++, libcairo, libcairomm-1.16, libglibmm-2.68, libpangomm-2.48, libsigc++-3.0"
TERMUX_PKG_BUILD_DEPENDS="libepoxy"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbuild-demos=false
-Dbuild-tests=false
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgtkmm-4.0.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
