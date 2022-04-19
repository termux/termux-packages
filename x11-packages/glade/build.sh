TERMUX_PKG_HOMEPAGE=https://glade.gnome.org/
TERMUX_PKG_DESCRIPTION="User interface designer for Gtk+ and GNOME"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.38.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/GNOME/glade/archive/refs/tags/GLADE_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=8abd1e7e6f943156602c6591e763ff40cffc68ea144c523d9702276f54b91b1b
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libcairo, libxml2, pango, xsltproc, libglade"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dintrospection=false" 
