TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Gucharmap
TERMUX_PKG_DESCRIPTION="GTK+ Unicode Character Map"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=15.0.3
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gucharmap/-/archive/${TERMUX_PKG_VERSION}/gucharmap-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=82636e4a5baacad795430a0de129450e84a69c4b1d68d007128c5023f9a82417
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libcairo, pango, pcre2, unicode-data"
TERMUX_PKG_BUILD_DEPENDS="freetype, g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ducd_path=$TERMUX_PREFIX/share/unicode-data
-Ddocs=false
-Dgir=true
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
}
