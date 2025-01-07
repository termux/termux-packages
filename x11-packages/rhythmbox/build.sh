TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/rhythmbox
TERMUX_PKG_DESCRIPTION="Music playback and management application"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.8"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/rhythmbox/${TERMUX_PKG_VERSION%.*}/rhythmbox-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2016a8a8d2a959c07a467ac9682c6ed605ba8883fb760410d68b68ab838df9f2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="at-spi2-core, gdk-pixbuf, glib, gobject-introspection, gst-plugins-base, gstreamer, gtk3, json-glib, libcairo, libnotify, libpeas, libsoup3, libtdb, libx11, libxml2, pango, pygobject, python, totem-pl-parser"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_RECOMMENDS="rhythmbox-help"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dapidoc=false
-Dhelp=true
-Dplugins_python=enabled
-Dplugins_vala=enabled
-Dtests=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
