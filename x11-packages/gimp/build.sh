TERMUX_PKG_HOMEPAGE=https://www.gimp.org/
TERMUX_PKG_DESCRIPTION="GNU Image Manipulation Program"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.10
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.34
TERMUX_PKG_SRCURL=https://download.gimp.org/mirror/pub/gimp/v${_MAJOR_VERSION}/gimp-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=84004642d351b398a4293cd7fd3592044a944f05bb52850ee6068f247c657aa3
TERMUX_PKG_DEPENDS="aalib, atk, babl, fontconfig, freetype, gdk-pixbuf, gegl, gexiv2, ghostscript, gimp-data, glib, glib-networking, gtk2, harfbuzz, hicolor-icon-theme, json-glib, libandroid-execinfo, libandroid-shmem, libc++, libcairo, libheif, libjpeg-turbo, libjxl, libmypaint, libpng, librsvg, libtiff, libwebp, libxcursor, libxml2, libxmu, libxpm, libxslt, littlecms, mypaint-brushes, openexr, openjpeg, pango, poppler, poppler-data, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-python
--disable-vector-icons
ac_cv_func_bind_textdomain_codeset=yes
ac_cv_path_GEGL=/usr/bin/gegl
HOST_GLIB_COMPILE_RESOURCES=glib-compile-resources
"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem -lm"

	sed -i 's/\(mypaint-brushes-\)1/\12/g' configure
}
