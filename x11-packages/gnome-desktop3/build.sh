TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-desktop
TERMUX_PKG_DESCRIPTION="Utility library for loading .desktop files"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="44.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-desktop/${TERMUX_PKG_VERSION%.*}/gnome-desktop-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ae7ca55dc9e08914999741523a17d29ce223915626bd2462a120bf96f47a79ab
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gsettings-desktop-schemas, gtk3, iso-codes, libcairo, libxkbcommon, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="fontconfig, g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
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
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgnome-desktop-3.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
