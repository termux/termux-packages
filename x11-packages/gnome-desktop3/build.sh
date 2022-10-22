TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-desktop
TERMUX_PKG_DESCRIPTION="Utility library for loading .desktop files"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-desktop/${_MAJOR_VERSION}/gnome-desktop-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3d6e153317486157596aa3802f87676414c570738f450a94a041fe8835420a69
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

	export PKG_CONFIG_PATH=$TERMUX_PREFIX/share/pkgconfig
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgnome-desktop-3.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
