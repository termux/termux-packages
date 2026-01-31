TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-shell
TERMUX_PKG_DESCRIPTION="GNOME shell"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.3"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-shell/${TERMUX_PKG_VERSION%%.*}/gnome-shell-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=28f0dbd64452f0057129f226753c95d2726de07f1f5f473addc7c3c507a6d31a
TERMUX_PKG_DEPENDS="atk, evolution-data-server, gcr4, gdk-pixbuf, gjs, glib, gnome-autoar, gnome-desktop4, gnome-session, gobject-introspection, graphene, gsettings-desktop-schemas, ibus, libgweather, libx11, libxfixes, libxml2, mutter, pango, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpolkit=false
-Dnetworkmanager=false
-Dportal_helper=false
-Dcamera_monitor=false
-Dsystemd=false
-Dgjs_path=$TERMUX_PREFIX/bin/gjs
-Dextensions_tool=true
-Dextensions_app=true
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1

	rm -rf "$TERMUX_PKG_SRCDIR/js/gdm"
}
