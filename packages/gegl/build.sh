TERMUX_PKG_HOMEPAGE=https://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.52"
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${TERMUX_PKG_VERSION%.*}/gegl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ca212a0fc3e0448c5058c51ca6a0d30fdfb02971f21f28820da2b4901396000a
TERMUX_PKG_DEPENDS="babl, ffmpeg, gdk-pixbuf, glib, json-glib, libandroid-support, libc++, libcairo, libjasper, libjpeg-turbo, libpng, libraw, librsvg, libtiff, libwebp, littlecms, openexr, pango, poppler"
TERMUX_PKG_AUTO_UPDATE=true
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
