TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/gdk-pixbuf/
TERMUX_PKG_DESCRIPTION="Library for image loading and manipulation"
_MAJOR_VERSION=2.36
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.7
TERMUX_PKG_SHA256=1b6e5eef09d98f05f383014ecd3503e25dfb03d7e5b5f5904e5a65b049a6a4d8
TERMUX_PKG_SRCURL=ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/${_MAJOR_VERSION}/gdk-pixbuf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib, libpng, libtiff, libjpeg-turbo"
# Avoid runtime test which does not work when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gio-sniffing --disable-glibtest"
