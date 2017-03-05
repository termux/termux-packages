TERMUX_PKG_HOMEPAGE=http://www.pango.org/
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
_MAJOR_VERSION=1.40
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/pango/${_MAJOR_VERSION}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f8fdc5fc66356dc4edf915048cceeee065a0e0cb70b3b2598f62bda320129a3e
TERMUX_PKG_DEPENDS="fontconfig,glib,harfbuzz,libcairo"
