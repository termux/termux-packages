TERMUX_PKG_HOMEPAGE=https://glade.gnome.org/
TERMUX_PKG_DESCRIPTION="User interface designer for Gtk+ and GNOME"
TERMUX_PKG_LICENSE="LGPL-2.0, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.40.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/glade/${TERMUX_PKG_VERSION%.*}/glade-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=31c9adaea849972ab9517b564e19ac19977ca97758b109edc3167008f53e3d9c
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, xsltproc"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgjs=disabled
-Dpython=disabled
-Dwebkit2gtk=disabled
-Dintrospection=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
