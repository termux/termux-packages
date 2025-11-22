TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/zenity
TERMUX_PKG_DESCRIPTION="a rewrite of gdialog, the GNOME port of dialog"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/zenity/${TERMUX_PKG_VERSION%.*}/zenity-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5a9fd8d8316f90cb2e1a5a8f0d411eb9fcaf85957a8229ea3e803e81004a1ebd
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libadwaita, libx11, pango, webkitgtk-6.0"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwebkitgtk=true
-Dmanpage=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
