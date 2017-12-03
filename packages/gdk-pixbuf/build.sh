TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/gdk-pixbuf/
TERMUX_PKG_DESCRIPTION="Library for image loading and manipulation"
TERMUX_PKG_VERSION=2.36.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=8013b271ff1a691514b5bbc9b99f6ed456422d4da4a721a9db0b783abe8e740a
TERMUX_PKG_SRCURL=ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/${TERMUX_PKG_VERSION:0:4}/gdk-pixbuf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="glib, libpng, libtiff, libjpeg-turbo"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libpng-dev, glib-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gio_can_sniff=no
--disable-glibtest
"
