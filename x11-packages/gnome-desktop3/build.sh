TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-desktop
TERMUX_PKG_DESCRIPTION="Utility library for loading .desktop files"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-desktop/${_MAJOR_VERSION}/gnome-desktop-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a0b9ab20d28a63df6ce7e91eabb5e3af86630bf522b5a8997c04971bd551d730
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gsettings-desktop-schemas, gtk3, iso-codes, libcairo, libxkbcommon, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="fontconfig, g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddesktop_docs=false
-Ddebug_tools=false
-Dintrospection=true
-Dbuild_gtk4=false
-Dlegacy_library=true
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgnome-desktop-3.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
