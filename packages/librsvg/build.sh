TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_VERSION=2.40.19
TERMUX_PKG_SHA256=612b4d8b8609036f5d899be3fe70d9866b5f6ac5c971154c1c0ef7242216c1f7
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.40/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libcroco,pango,gdk-pixbuf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-introspection --disable-pixbuf-loader"
