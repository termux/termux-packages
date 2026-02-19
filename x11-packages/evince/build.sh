TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Evince
TERMUX_PKG_DESCRIPTION="document viewer for multiple document formats"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/evince/${TERMUX_PKG_VERSION%%.*}/evince-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7d8b9a6fa3a05d3f5b9048859027688c73a788ff6e923bc3945126884943fa10
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, djvulibre, gdk-pixbuf, glib, gnome-desktop3, gst-plugins-base, gst-plugins-good, gstreamer, gtk3, libarchive, libcairo, libgxps, libhandy, libsecret, libspectre, libtiff, libxml2, pango, poppler, poppler-data, texlive-bin"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_RECOMMENDS="evince-help"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dnautilus=false
-Dps=enabled
-Dgtk_doc=false
-Dintrospection=true
-Dgspell=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
