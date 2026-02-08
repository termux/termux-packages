TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libgweather
TERMUX_PKG_DESCRIPTION="Location and timezone database and weather-lookup library"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.5.0"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/libgweather/${TERMUX_PKG_VERSION%.*}/libgweather-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=e464c1aebe8117c8a170206d7baefe730393b7e98044c2cd97b3aa8604ef12aa
TERMUX_PKG_DEPENDS="geocode-glib, glib, gobject-introspection, gweather-locations, json-glib, libsoup3, libxml2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
-Dgtk_doc=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
