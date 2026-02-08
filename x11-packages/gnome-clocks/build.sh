TERMUX_PKG_HOMEPAGE="https://apps.gnome.org/Clocks/"
TERMUX_PKG_DESCRIPTION="Keep track of time"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=49.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-clocks/${TERMUX_PKG_VERSION%.*}/gnome-clocks-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bf76915f2a492e8a0592fe40b35346593aa39e4e6881d6176e0efd8771d4e6fa
TERMUX_PKG_DEPENDS="geoclue, geocode-glib, glib, gnome-desktop4, gtk4, libadwaita, libgweather"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, gettext, glib-cross, valac"
TERMUX_PKG_PYTHON_COMMON_DEPS="itstool"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	export TERMUX_MESON_ENABLE_SOVERSION=1
}
