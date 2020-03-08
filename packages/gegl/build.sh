TERMUX_PKG_HOMEPAGE=http://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.4.22
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${TERMUX_PKG_VERSION:0:3}/gegl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1888ec41dfd19fe28273795c2209efc1a542be742691561816683990dc642c61
TERMUX_PKG_DEPENDS="libandroid-support, libc++, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg, zlib"
TERMUX_PKG_BREAKS="gegl-dev"
TERMUX_PKG_REPLACES="gegl-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dintrospection=false"
