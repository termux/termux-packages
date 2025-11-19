TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/Archive/libgnomekbd
TERMUX_PKG_DESCRIPTION="GNOME keyboard library"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.28.1"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/libgnomekbd/${TERMUX_PKG_VERSION%.*}/libgnomekbd-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=22dc59566d73c0065350f5a97340e62ecc7b08c4df19183804bb8be24c8fe870
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, gobject-introspection, libxml2, libxklavier, gigolo, libx11"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dvapi=false
-Dintrospection=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
