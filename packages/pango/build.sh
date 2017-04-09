TERMUX_PKG_HOMEPAGE=http://www.pango.org/
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
_MAJOR_VERSION=1.40
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.5
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/pango/${_MAJOR_VERSION}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=24748140456c42360b07b2c77a1a2e1216d07c056632079557cd4e815b9d01c9
TERMUX_PKG_DEPENDS="fontconfig,glib,harfbuzz,libcairo"
