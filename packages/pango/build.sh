TERMUX_PKG_HOMEPAGE=http://www.pango.org/
TERMUX_PKG_DESCRIPTION="Library for laying out and rendering text"
TERMUX_PKG_VERSION=1.40.13
TERMUX_PKG_SHA256=f84e98db1078772ff4935b40a1629ff82ef0dfdd08d2cbcc0130c8c437857196
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/pango/${TERMUX_PKG_VERSION:0:4}/pango-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="fontconfig,glib,harfbuzz,libcairo"
TERMUX_PKG_DEVPACKAGE_DEPENDS="libcairo-dev, libpixman-dev, fontconfig-dev, harfbuzz-dev"
