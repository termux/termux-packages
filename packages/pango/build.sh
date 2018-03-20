TERMUX_PKG_HOMEPAGE=http://www.pango.org/
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
TERMUX_PKG_VERSION=1.42.0
TERMUX_PKG_SHA256=9924d88a3dcedff753f0763814a1605307c5c9c931413b8b47ea7267d1b19446
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/pango/${TERMUX_PKG_VERSION:0:4}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="fontconfig,fribidi,glib,harfbuzz,libcairo"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libcairo-dev, libpixman-dev, fontconfig-dev, harfbuzz-dev"
