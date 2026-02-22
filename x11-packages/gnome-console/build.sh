TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/console
TERMUX_PKG_DESCRIPTION="Simple, user-friendly terminal emulator for the GNOME desktop"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.2"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-console/${TERMUX_PKG_VERSION%%.*}/gnome-console-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=27b02ce8e890ff8f53ca85db786b1ae35903f0b6327812f0224dc0b54b1088db
TERMUX_PKG_DEPENDS="dconf, gtk4, glib, gsettings-desktop-schemas, hicolor-icon-theme, libadwaita, libnotify, libgtop, libvte, pango"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
