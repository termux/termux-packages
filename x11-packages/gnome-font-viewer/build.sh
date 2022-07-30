TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-font-viewer
TERMUX_PKG_DESCRIPTION="A font viewer utility for GNOME"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Stick to GTK 3 for now.
_MAJOR_VERSION=41
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-font-viewer/${_MAJOR_VERSION}/gnome-font-viewer-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5dd410331be070e4e034397f2754980e073851d50a2119f2fbf96adc6fe2e876
TERMUX_PKG_DEPENDS="fontconfig, freetype, gdk-pixbuf, glib, gnome-desktop3, gtk3, harfbuzz, libcairo, libhandy, pango"

termux_step_pre_configure() {
	export PKG_CONFIG_PATH=$TERMUX_PREFIX/share/pkgconfig
}
