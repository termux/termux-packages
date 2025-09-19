TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/zenity
TERMUX_PKG_DESCRIPTION="a rewrite of gdialog, the GNOME port of dialog"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/zenity/${TERMUX_PKG_VERSION%.*}/zenity-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5f983340c6fa55f4fab5a9769d0771b2cdf1365e2c158ac11cc16ffd892f6bcd
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
