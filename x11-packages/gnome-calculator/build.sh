TERMUX_PKG_HOMEPAGE=https://apps.gnome.org/Calculator
TERMUX_PKG_DESCRIPTION="GNOME Scientific calculator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-calculator/${TERMUX_PKG_VERSION%%.*}/gnome-calculator-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ddf4cd2edda135c41c8af68f9c0cdcd9d9a9163cb9f7f8e28ca2c8e81fd87657
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk4, gtksourceview5, libadwaita, libgee, libmpc, libmpfr, libsoup3, libxml2"
TERMUX_PKG_BUILD_DEPENDS="blueprint-compiler, g-ir-scanner, glib-cross, valac"
TERMUX_PKG_RECOMMENDS="gnome-calculator-help"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_bpc
}
