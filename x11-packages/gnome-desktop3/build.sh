TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-desktop
TERMUX_PKG_DESCRIPTION="Utility library for loading .desktop files"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=41
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.6
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-desktop/${_MAJOR_VERSION}/gnome-desktop-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8b3d942ae2ece55c1c9bbd87e7c9550f6ab9d441ac73ae54aab0c3ef621a388b
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gsettings-desktop-schemas, gtk3, iso-codes, libcairo, libxkbcommon, xkeyboard-config"
TERMUX_PKG_BUILD_DEPENDS="fontconfig"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgnome_distributor=Termux
-Ddesktop_docs=false
-Ddebug_tools=false
"

termux_step_pre_configure() {
	export PKG_CONFIG_PATH=$TERMUX_PREFIX/share/pkgconfig
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libgnome-desktop-3.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
