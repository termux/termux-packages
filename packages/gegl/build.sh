TERMUX_PKG_HOMEPAGE=https://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.32
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${TERMUX_PKG_VERSION:0:3}/gegl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=668e3c6b9faf75fb00512701c36274ab6f22a8ba05ec62dbf187d34b8d298fa1
TERMUX_PKG_DEPENDS="libandroid-support, libc++, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg, zlib"
TERMUX_PKG_BREAKS="gegl-dev"
TERMUX_PKG_REPLACES="gegl-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dintrospection=false"

# Disable ffmpeg support until fixed upstream:
# https://gitlab.gnome.org/GNOME/gegl/-/issues/301
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dlibav=disabled"
