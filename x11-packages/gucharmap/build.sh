TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Gucharmap
TERMUX_PKG_DESCRIPTION="GTK+ Unicode Character Map"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="17.0.0"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gucharmap/-/archive/${TERMUX_PKG_VERSION}/gucharmap-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=09988f67ae82d057a993ab21df2ac94503a8a836da5f8e36e5e8864d8d45a295
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, glib, gtk3, libcairo, pango, pcre2, unicode-data"
TERMUX_PKG_BUILD_DEPENDS="freetype, g-ir-scanner, glib-cross, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ducd_path=$TERMUX_PREFIX/share/unicode-data
-Ddocs=false
-Dgir=true
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
