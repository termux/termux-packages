TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/geocode-glib
TERMUX_PKG_DESCRIPTION="Convenience library for the geocoding and reverse geocoding"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.26.4"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/geocode-glib/${TERMUX_PKG_VERSION%.*}/geocode-glib-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=2d9a6826d158470449a173871221596da0f83ebdcff98b90c7049089056a37aa
TERMUX_PKG_DEPENDS="glib, json-glib, libsoup3"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable-installed-tests=false
-Denable-gtk-doc=false
-Dsoup2=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
