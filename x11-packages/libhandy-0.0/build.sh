TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libhandy/
TERMUX_PKG_DESCRIPTION="Building blocks for modern adaptive GNOME apps"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.0
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.13
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/libh/libhandy/libhandy_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=4dcd9d249558834bd5430445d3674e9e3cff356e35f0c1dd368c3af50fa15b6d
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libcairo, pango"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=disabled
-Dvapi=false
-Dtests=false
-Dexamples=false
-Dglade_catalog=disabled
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
