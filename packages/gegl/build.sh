TERMUX_PKG_HOMEPAGE=https://gegl.org/
TERMUX_PKG_DESCRIPTION="Data flow based image processing framework"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.4
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.38
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://download.gimp.org/pub/gegl/${_MAJOR_VERSION}/gegl-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e4a33c8430a5042fba8439b595348e71870f0d95fbf885ff553f9020c1bed750
# For ffmpeg dependency see below.
TERMUX_PKG_DEPENDS="babl, gdk-pixbuf, glib, json-glib, libandroid-support, libcairo, libjasper, libjpeg-turbo, libpng, librsvg, libtiff, libwebp, littlecms, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac, xorgproto"
TERMUX_PKG_BREAKS="gegl-dev"
TERMUX_PKG_REPLACES="gegl-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
"

# Disable ffmpeg support until fixed upstream:
# https://gitlab.gnome.org/GNOME/gegl/-/issues/301
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dlibav=disabled"

termux_step_pre_configure() {
	termux_setup_gir
}
