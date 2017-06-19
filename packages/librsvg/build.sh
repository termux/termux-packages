TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_VERSION=2.40.17
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.40/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e6f6c5cbecc405bb945c7cd15061276035ae3173bbb3bb25e8a916779c7f69cc
TERMUX_PKG_DEPENDS="libcroco,pango,gdk-pixbuf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-introspection --disable-pixbuf-loader"
