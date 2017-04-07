TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/gdk-pixbuf/
TERMUX_PKG_DESCRIPTION="Library for image loading and manipulation"
_MAJOR_VERSION=2.36
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_SRCURL=ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/${_MAJOR_VERSION}/gdk-pixbuf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0b19901c3eb0596141d2d48ddb9dac79ad1524bdf59366af58ab38fcb9ee7463
TERMUX_PKG_DEPENDS="glib, libpng, libtiff, libjpeg-turbo"
# Avoid runtime test which does not work when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gio-sniffing --disable-glibtest"
