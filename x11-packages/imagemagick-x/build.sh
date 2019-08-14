TERMUX_PKG_HOMEPAGE=https://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_LICENSE="ImageMagick"
TERMUX_PKG_VERSION=7.0.8.54
TERMUX_PKG_REVISION=3
local _download_version=`echo $TERMUX_PKG_VERSION | sed 's/\(.*\)\./\1-/'`
TERMUX_PKG_SRCURL=https://github.com/ImageMagick/ImageMagick/archive/${_download_version}.tar.gz
TERMUX_PKG_SHA256=ccd25b3188d83370f978be104c46c18cab82852246c56cab89b7b781ebbdc3e8
TERMUX_PKG_DEPENDS="fftw, fontconfig, freetype, fribidi, glib, harfbuzz, libandroid-support, libbz2, libcairo-x, libffi, libgraphite, libjpeg-turbo, liblzma, libpixman, libpng, libtiff, libuuid, libwebp, libx11, libxau, libxcb, libxdmcp, libxext, libxml2, littlecms, openjpeg, pango-x, pcre, zlib"

TERMUX_PKG_CONFLICTS="imagemagick"
TERMUX_PKG_REPLACES="imagemagick"
TERMUX_PKG_PROVIDES="imagemagick"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-largefile
--with-x
--without-gvc
--with-magick-plus-plus=no
--with-bzlib=no
--with-xml=yes
--with-lzma
--disable-openmp
ac_cv_func_ftime=no"

if [ $TERMUX_PKG_API_LEVEL -lt 24 ]; then
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_header_complex_h=no"
fi

TERMUX_PKG_RM_AFTER_INSTALL="
bin/Magick-config
bin/MagickCore-config
bin/MagickWand-config
bin/Wand-config
share/ImageMagick-7/francais.xml
share/man/man1/Magick-config.1
share/man/man1/MagickCore-config.1
share/man/man1/MagickWand-config.1
share/man/man1/Wand-config.1
"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid "libMagickCore-7.Q16HDRI.so: error: undefined reference to '__atomic_load'":
		LDFLAGS+=" -latomic"
	fi
}
