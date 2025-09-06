TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/LibGWeather
TERMUX_PKG_DESCRIPTION="Location and timezone database and weather-lookup library"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4.4"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/libgweather/${TERMUX_PKG_VERSION%.*}/libgweather-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=7017677753cdf7d1fdc355e4bfcdb1eba8369793a8df24d241427a939cbf4283
TERMUX_PKG_DEPENDS="geocode-glib, glib, gobject-introspection, json-glib, libsoup3, libxml2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
-Denable_vala=false
-Dgtk_doc=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
