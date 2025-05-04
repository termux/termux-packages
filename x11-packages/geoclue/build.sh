TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/geoclue/geoclue/
TERMUX_PKG_DESCRIPTION="Modular geoinformation service built on the D-Bus messaging system"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.1-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.2"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/$TERMUX_PKG_VERSION/geoclue-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=9c2f3626e3131abc037955cb38a8c0f28a29b4d6cc9992a067fe04be46e37fbe
TERMUX_PKG_DEPENDS="glib, json-glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
-Dgtk-doc=false
-D3g-source=false
-Dcdma-source=false
-Dmodem-gps-source=false
-Dnmea-source=false
-Denable-backend=false
-Ddemo-agent=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
