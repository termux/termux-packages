TERMUX_PKG_HOMEPAGE=http://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
local _MAJOR_VERSION=0.3
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.16
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/$_MAJOR_VERSION/gegl-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_FOLDERNAME=gegl-$TERMUX_PKG_VERSION
TERMUX_PKG_SHA256=11174f20d01f25d4b5425ff77457ee00fbde7bc26ea4b1ff0765fc1ba6028006
TERMUX_PKG_DEPENDS="libandroid-support, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-gdk-pixbuf
"
