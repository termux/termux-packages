TERMUX_PKG_HOMEPAGE=https://www.gimp.org/
TERMUX_PKG_DESCRIPTION="GNU Image Manipulation Program"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.10
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.30
TERMUX_PKG_SRCURL=https://download.gimp.org/mirror/pub/gimp/v${_MAJOR_VERSION}/gimp-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=88815daa76ed7d4277eeb353358bafa116cd2fcd2c861d95b95135c1d52b67dc
TERMUX_PKG_DEPENDS="aalib, atk, babl, fontconfig, freetype, gdk-pixbuf, gegl, gexiv2, ghostscript, gimp-data, glib, glib-networking, gtk2, harfbuzz, hicolor-icon-theme, json-glib, libandroid-shmem, libc++, libcairo, libheif, libjpeg-turbo, libmypaint, libpng, librsvg, libtiff, libwebp, libxcursor, libxml2, libxpm, libxslt, littlecms, mypaint-brushes, openexr2, openjpeg, pango, poppler, poppler-data, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-python
ac_cv_func_bind_textdomain_codeset=yes
ac_cv_path_GEGL=/usr/bin/gegl
HOST_GLIB_COMPILE_RESOURCES=glib-compile-resources
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem"

	local pc_dir=$TERMUX_PKG_BUILDDIR/_pkgconfig
	mkdir -p $pc_dir
	ln -sf $TERMUX_PREFIX/share/pkgconfig/mypaint-brushes-2.0.pc \
		$pc_dir/mypaint-brushes-1.0.pc
	ln -sf $TERMUX_PREFIX/share/pkgconfig/poppler-data.pc $pc_dir/
	export PKG_CONFIG_PATH=$pc_dir
}
