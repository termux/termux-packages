TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-desktop
TERMUX_PKG_DESCRIPTION="Utility library for loading .desktop files"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-desktop/${_MAJOR_VERSION}/gnome-desktop-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=32af8dbc3d9a7d583569a7f0d7f18f95818d5db9ee8f92d9123a647b15eac8c7
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gsettings-desktop-schemas, gtk4, iso-codes, libcairo, libxkbcommon, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="fontconfig, g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddesktop_docs=false
-Ddebug_tools=false
-Dintrospection=true
-Dbuild_gtk4=true
-Dlegacy_library=false
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgnome-desktop-4.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
