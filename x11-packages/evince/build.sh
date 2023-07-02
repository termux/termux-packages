TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Evince
TERMUX_PKG_DESCRIPTION="document viewer for multiple document formats"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=44
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/evince/${_MAJOR_VERSION}/evince-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3b8ba1581a47a6e9f57f6b6aa08f0fb67549c60121aa24e31140e93947b83622
TERMUX_PKG_DEPENDS="atk, djvulibre, gdk-pixbuf, glib, gnome-desktop3, gst-plugins-base, gst-plugins-good, gstreamer, gtk3, libarchive, libcairo, libgxps, libhandy, libsecret, libspectre, libtiff, libxml2, pango, poppler, poppler-data, texlive-bin"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_RECOMMENDS="evince-help"
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
}
