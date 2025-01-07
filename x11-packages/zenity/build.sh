TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/zenity
TERMUX_PKG_DESCRIPTION="a rewrite of gdialog, the GNOME port of dialog"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.3"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/zenity/${TERMUX_PKG_VERSION%.*}/zenity-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=b429d97b87bd9ce7fb72ac0b78df534725d8ad39817ddca6a4ca2ee5381b08de
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
