TERMUX_PKG_HOMEPAGE=https://apps.gnome.org/DconfEditor
TERMUX_PKG_DESCRIPTION="A GSettings editor for GNOME"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="45.0.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/dconf-editor/${TERMUX_PKG_VERSION%%.*}/dconf-editor-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1180297678eedae6217cc514a2638c187d2f1d1ef2720cb9079b740c429941dd
TERMUX_PKG_DEPENDS="dbus, glib, libhandy, dconf"
TERMUX_PKG_BUILD_DEPENDS="glib-cross, valac, gettext, libhandy, dconf"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
