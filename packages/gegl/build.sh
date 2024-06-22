TERMUX_PKG_HOMEPAGE=https://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.48"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${TERMUX_PKG_VERSION%.*}/gegl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=418c26d94be8805d7d98f6de0c6825ca26bd74fcacb6c188da47533d9ee28247
TERMUX_PKG_DEPENDS="babl, ffmpeg, gdk-pixbuf, glib, json-glib, libandroid-support, libc++, libcairo, libjasper, libjpeg-turbo, libpng, librsvg, libtiff, libwebp, littlecms, openexr, pango, poppler"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac, xorgproto"
TERMUX_PKG_BREAKS="gegl-dev"
TERMUX_PKG_REPLACES="gegl-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
"

termux_step_pre_configure() {
	termux_setup_gir
}
