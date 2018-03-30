TERMUX_PKG_HOMEPAGE=http://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_VERSION=0.3.30
TERMUX_PKG_SHA256=f8b4a93ad2c5187efcc7d9a665ef626a362587eb701eebccf21b13616791e551
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${TERMUX_PKG_VERSION:0:3}/gegl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libandroid-support, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-gdk-pixbuf
"
