TERMUX_PKG_HOMEPAGE=http://www.pango.org/
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
_MAJOR_VERSION=1.40
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.6
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/pango/${_MAJOR_VERSION}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ca152b7383a1e9f7fd74ae96023dc6770dc5043414793bfe768ff06b6759e573
TERMUX_PKG_DEPENDS="fontconfig,glib,harfbuzz,libcairo"
