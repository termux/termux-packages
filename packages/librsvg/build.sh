TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_VERSION=2.40.18
TERMUX_PKG_SHA256=bfc8c488c89c1e7212c478beb95c41b44701636125a3e6dab41187f1485b564c
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.40/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libcroco,pango,gdk-pixbuf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-introspection --disable-pixbuf-loader"
