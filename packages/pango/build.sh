TERMUX_PKG_HOMEPAGE=http://www.pango.org/
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
TERMUX_PKG_VERSION=1.42.2
TERMUX_PKG_SHA256=b1e416b4d40416ef6c8224cf146492b86848703264ba88f792290992cf3ca1e2
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/pango/${TERMUX_PKG_VERSION:0:4}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="fontconfig,fribidi,glib,harfbuzz,libcairo"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libcairo-dev, libpixman-dev, fontconfig-dev, harfbuzz-dev"
