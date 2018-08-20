TERMUX_PKG_HOMEPAGE=http://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_VERSION=0.4.8
TERMUX_PKG_SHA256=719468eec56ac5b191626a0cb6238f3abe9117e80594890c246acdc89183ae49
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${TERMUX_PKG_VERSION:0:3}/gegl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libandroid-support, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-gdk-pixbuf
"
