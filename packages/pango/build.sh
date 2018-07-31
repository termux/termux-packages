TERMUX_PKG_HOMEPAGE=http://www.pango.org/
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
TERMUX_PKG_VERSION=1.42.3
TERMUX_PKG_SHA256=fb3d875305d5143f02cde5c72fec3903e60dc35844759dc14b2df4955b5dde3a
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/pango/${TERMUX_PKG_VERSION:0:4}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="fontconfig,fribidi,glib,harfbuzz,libcairo"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libcairo-dev, libpixman-dev, fontconfig-dev, harfbuzz-dev"
