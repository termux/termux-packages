TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/gdk-pixbuf/
TERMUX_PKG_DESCRIPTION="Library for image loading and manipulation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_VERSION=2.38.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=f19ff836ba991031610dcc53774e8ca436160f7d981867c8c3a37acfe493ab3a
TERMUX_PKG_SRCURL=ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/${TERMUX_PKG_VERSION:0:4}/gdk-pixbuf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib, libpng, libtiff, libjpeg-turbo"
TERMUX_PKG_BREAKS="gdk-pixbuf-dev"
TERMUX_PKG_REPLACES="gdk-pixbuf-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgio_sniffing=false
-Dgir=false
-Dx11=false
"
