TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/LibRsvg
TERMUX_PKG_DESCRIPTION="Library to render SVG files using cairo"
TERMUX_PKG_VERSION=2.40.16
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.40/librsvg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d48bcf6b03fa98f07df10332fb49d8c010786ddca6ab34cbba217684f533ff2e
TERMUX_PKG_DEPENDS="libcroco,pango,gdk-pixbuf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-introspection --disable-pixbuf-loader"
