TERMUX_PKG_HOMEPAGE=https://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.66"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://gitlab.gnome.org/GNOME/gegl/-/archive/GEGL_${TERMUX_PKG_VERSION//./_}/gegl-GEGL_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=fef15939aad59a34596a1fa89ddadfe409fee37ccd8e3a4df4d13fd30890183e
TERMUX_PKG_DEPENDS="babl, ffmpeg, gdk-pixbuf, glib, imath, json-glib, libandroid-support, libc++, libcairo, libjasper, libjpeg-turbo, libpng, libraw, librsvg, libtiff, libwebp, littlecms, openexr, pango, poppler"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac, xorgproto"
TERMUX_PKG_BREAKS="gegl-dev"
TERMUX_PKG_REPLACES="gegl-dev"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
"

termux_step_pre_configure() {
	termux_setup_gir
}
