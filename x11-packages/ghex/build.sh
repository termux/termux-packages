TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Ghex
TERMUX_PKG_DESCRIPTION="A simple binary editor for the Gnome desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="46.3"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/ghex/${TERMUX_PKG_VERSION%.*}/ghex-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ea16595dfba0a97b55dd106305d56ba2baee95de0b13b75e75966cc31f9b3ec9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk4, libadwaita, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_RECOMMENDS="ghex-help"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
-Dintrospection=enabled
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
