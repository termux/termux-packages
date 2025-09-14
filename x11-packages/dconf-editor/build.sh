TERMUX_PKG_HOMEPAGE=https://apps.gnome.org/DconfEditor
TERMUX_PKG_DESCRIPTION="A GSettings editor for GNOME"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/dconf-editor/${TERMUX_PKG_VERSION%%.*}/dconf-editor-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=90a8ccfadf51dff31e0028324fb9a358b2d26c5ae861a71c7dbf9f4dd9bdd399
TERMUX_PKG_DEPENDS="dbus, glib, libhandy, dconf"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, valac, gettext, libhandy, dconf"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
