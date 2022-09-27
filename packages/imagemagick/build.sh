TERMUX_PKG_HOMEPAGE=https://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_LICENSE="ImageMagick"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=7.1.0-49
TERMUX_PKG_VERSION=${_VERSION//-/.}
TERMUX_PKG_SRCURL=https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${_VERSION}.tar.gz
TERMUX_PKG_SHA256=18863242462733245308281353eeef27e86a8d0f5f805f8f5fb6293d5bc66b5d
TERMUX_PKG_DEPENDS="fftw, fontconfig, freetype, fribidi, glib, harfbuzz, libandroid-support, libbz2, libcairo, libffi, libgraphite, libheif, libjpeg-turbo, libjxl, liblzma, libpixman, libpng, librsvg, libtiff, libuuid, libwebp, libx11, libxau, libxcb, libxdmcp, libxext, libxml2, littlecms, openjpeg, pango, pcre, zlib, zstd"
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
