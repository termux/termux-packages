TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Gucharmap
TERMUX_PKG_DESCRIPTION="GTK+ Unicode Character Map"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=15.0.4
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gucharmap/-/archive/${TERMUX_PKG_VERSION}/gucharmap-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ddd219ffd22ff72ae9c938d7bd0192a3d63b04bc570ee8214790298418b02078
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
