TERMUX_PKG_HOMEPAGE=https://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_VERSION=7.0.7.29
TERMUX_PKG_SHA256=be171d13e58bb19685b36080edf9d36b9b95633b0331fbf7e70b5997a3501d65
local _download_version=`echo $TERMUX_PKG_VERSION | sed 's/\(.*\)\./\1-/'`
TERMUX_PKG_SRCURL=https://github.com/ImageMagick/ImageMagick/archive/${_download_version}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-largefile
--without-x
--without-gvc
--without-ltdl
--with-magick-plus-plus=no
--with-bzlib=no
--with-xml=yes
--with-lzma
ac_cv_func_ftime=no
ac_cv_header_complex_h=no"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/Magick-config
bin/MagickCore-config
bin/MagickWand-config
bin/Wand-config
share/ImageMagick-6/francais.xml
share/man/man1/Magick-config.1
share/man/man1/MagickCore-config.1
share/man/man1/MagickWand-config.1
share/man/man1/Wand-config.1
"
TERMUX_PKG_DEPENDS="fftw, pango, glib, libbz2, libjpeg-turbo, liblzma, libpng, libtiff, libxml2, openjpeg, littlecms"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid "libMagickCore-7.Q16HDRI.so: error: undefined reference to '__atomic_load'":
		LDFLAGS+=" -latomic"
	fi
}
