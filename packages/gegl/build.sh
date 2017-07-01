TERMUX_PKG_HOMEPAGE=http://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
local _MAJOR_VERSION=0.3
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.18
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/$_MAJOR_VERSION/gegl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_FOLDERNAME=gegl-$TERMUX_PKG_VERSION
TERMUX_PKG_SHA256=d7858ef26ede136d14e3de188a9e9c0de7707061a9fb96d7d615fab4958491fb
TERMUX_PKG_DEPENDS="libandroid-support, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-gdk-pixbuf
"
