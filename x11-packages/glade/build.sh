TERMUX_PKG_HOMEPAGE=https://glade.gnome.org/
TERMUX_PKG_DESCRIPTION="User interface designer for Gtk+ and GNOME"
TERMUX_PKG_LICENSE="LGPL-2.0, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.40
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/glade/${_MAJOR_VERSION}/glade-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=31c9adaea849972ab9517b564e19ac19977ca97758b109edc3167008f53e3d9c
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libxml2, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xsltproc"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgjs=disabled
-Dpython=disabled
-Dwebkit2gtk=disabled
-Dintrospection=true
"

termux_step_pre_configure() {
	termux_setup_gir
}
