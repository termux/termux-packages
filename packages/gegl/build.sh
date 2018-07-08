TERMUX_PKG_HOMEPAGE=http://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_VERSION=0.4.4
TERMUX_PKG_SHA256=f8cb45da736131fe29582b74cf6851102ae013bf99c77413a8bcb02e92e57890
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${TERMUX_PKG_VERSION:0:3}/gegl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libandroid-support, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-gdk-pixbuf
"
