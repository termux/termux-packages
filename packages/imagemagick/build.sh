TERMUX_PKG_HOMEPAGE=https://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_LICENSE="ImageMagick"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=7.1.0-61
TERMUX_PKG_VERSION=${_VERSION//-/.}
TERMUX_PKG_SRCURL=https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${_VERSION}.tar.gz
#TERMUX_PKG_SRCURL=https://imagemagick.org/archive/releases/ImageMagick-${_VERSION}.tar.xz
TERMUX_PKG_SHA256=04a55eaf8ce093112342d777fbe0d578a5567a6bebeff0e3de0d3092fc154a06
TERMUX_PKG_DEPENDS="fftw, fontconfig, freetype, gdk-pixbuf, glib, harfbuzz, imath, libandroid-support, libbz2, libc++, libcairo, libheif, libjpeg-turbo, libjxl, liblzma, libpng, librsvg, libtiff, libwebp, libx11, libxext, libxml2, littlecms, openexr, openjpeg, pango, zlib"
TERMUX_PKG_BREAKS="imagemagick-dev, imagemagick-x"
TERMUX_PKG_REPLACES="imagemagick-dev, imagemagick-x"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-x
--without-gvc
--with-magick-plus-plus=yes
--with-bzlib=yes
--with-xml=yes
--with-rsvg=yes
--with-lzma
--with-jxl=yes
--with-openexr
--with-fftw
--disable-openmp
ac_cv_func_ftime=no
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/ImageMagick-7/francais.xml
"

termux_step_pre_configure() {
	export LDFLAGS+=" $($CC -print-libgcc-file-name)"

	# Value of PKG_CONFIG becomes hardcoded in bin/*-config
	export PKG_CONFIG=pkg-config
}
