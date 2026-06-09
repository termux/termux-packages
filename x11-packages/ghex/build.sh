TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Ghex
TERMUX_PKG_DESCRIPTION="A simple binary editor for the Gnome desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="50.2"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/ghex/-/archive/${TERMUX_PKG_VERSION}/ghex-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ad3a2d1dd1aa288dc123c449f6ceeb0defb07ccf62a563ca7f3d54f0060ca07d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk4, libadwaita, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_RECOMMENDS="ghex-help"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
-Dintrospection=enabled
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
