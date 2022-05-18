TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libdazzle
TERMUX_PKG_DESCRIPTION="A companion library to GObject and Gtk+"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.44
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libdazzle/${_MAJOR_VERSION}/libdazzle-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3cd3e45eb6e2680cb05d52e1e80dd8f9d59d4765212f0e28f78e6c1783d18eae
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, pango"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_tools=false
-Dwith_introspection=false
-Dwith_vapi=false
-Denable_tests=false
"
