TERMUX_PKG_HOMEPAGE=https://apps.gnome.org/DconfEditor
TERMUX_PKG_DESCRIPTION="A GSettings editor for GNOME"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="45.0.1"
TERMUX_PKG_SRCURL=https://github.com/GNOME/dconf-editor/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ff7b2f60d4de0b60baeb2f94da99e86f349cf575a3928479435113a75ccd144
TERMUX_PKG_DEPENDS="dbus, glib, libhandy, dconf"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, valac, gettext, libhandy, dconf"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
