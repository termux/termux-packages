TERMUX_PKG_HOMEPAGE=https://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.4
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.36
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${_MAJOR_VERSION}/gegl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6fd58a0cdcc7702258adaeffb573a389228ae8f0eff47578efda2309b61b2ca6
TERMUX_PKG_DEPENDS="libandroid-support, libc++, ffmpeg, babl, json-glib, libjpeg-turbo, libpng, libjasper, littlecms, libtiff, librsvg, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_BREAKS="gegl-dev"
TERMUX_PKG_REPLACES="gegl-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dintrospection=false"

# Disable ffmpeg support until fixed upstream:
# https://gitlab.gnome.org/GNOME/gegl/-/issues/301
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dlibav=disabled"
