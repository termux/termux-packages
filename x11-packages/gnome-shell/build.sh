TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GnomeShell
TERMUX_PKG_DESCRIPTION="GNOME shell"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.1"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gnome-shell/${TERMUX_PKG_VERSION%%.*}/gnome-shell-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=ba4f455afd6213f387545946e3cd9daa39c904f7ab16dd830ac77a73ff1002ca
TERMUX_PKG_DEPENDS="atk, evolution-data-server, gcr4, gdk-pixbuf, gjs, glib, gnome-desktop4, gnome-session, gobject-introspection, graphene, gsettings-desktop-schemas, libx11, libxfixes, libxml2, mutter, pango, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpolkit=false
-Dnetworkmanager=false
-Dportal_helper=false
-Dcamera_monitor=false
-Dsystemd=false
-Dgjs_path=$TERMUX_PREFIX/bin/gjs
-Dextensions_tool=false
-Dextensions_app=false
-Dtests=false
"

termux_step_pre_configure() {
	# Runtime deps through gobject-introspection
	TERMUX_PKG_DEPENDS+=", accountsservice, gdm, ibus, libgweather, upower"

	# Runtime deps through dbus
	# TODO: Port packagekit to Termux
	# TERMUX_PKG_DEPENDS+=", packagekit"

	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
