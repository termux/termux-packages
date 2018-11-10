TERMUX_PKG_HOMEPAGE=http://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_VERSION=0.4.10
TERMUX_PKG_SHA256=1c419659bde1aa8bb7845231a7132bd7dcdaa4ed724adf676b07478b41f0c5d3
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${TERMUX_PKG_VERSION:0:3}/gegl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libandroid-support, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-gdk-pixbuf
"
