TERMUX_PKG_HOMEPAGE=https://apps.gnome.org/Calculator
TERMUX_PKG_DESCRIPTION="GNOME Scientific calculator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="47.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-calculator/${TERMUX_PKG_VERSION%.*}/gnome-calculator-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=decdb23283b5dbeef40951b69eaf7d4b80c0c3880ddb01863f9f0f1554f8998b
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk4, gtksourceview5, libadwaita, libgee, libmpc, libmpfr, libsoup3, libxml2"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_RECOMMENDS="gnome-calculator-help"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
