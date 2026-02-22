TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libpanel
TERMUX_PKG_DESCRIPTION="IDE paneling library for GTK"
TERMUX_PKG_LICENSE="LGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.3"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libpanel/${TERMUX_PKG_VERSION%.*}/libpanel-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=42a01baf8b94440f194ea8342b244bd6992dfb024ca3160c9477ff498ec3a2b6
TERMUX_PKG_DEPENDS="glib, gobject-introspection, gtk4, libadwaita"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, gettext, glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
