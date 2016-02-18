TERMUX_PKG_HOMEPAGE=http://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_VERSION="6.9.3-2"
TERMUX_PKG_SRCURL=http://www.imagemagick.org/download/ImageMagick-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-largefile --without-x --with-magick-plus-plus=no	--with-bzlib=no --with-xml=yes --with-lzma ac_cv_func_ftime=no ac_cv_header_complex_h=no"
TERMUX_PKG_RM_AFTER_INSTALL="bin/Magick-config bin/MagickCore-config bin/MagickWand-config bin/Wand-config share/ImageMagick-6/francais.xml share/man/man1/Magick-config.1 share/man/man1/MagickCore-config.1 share/man/man1/MagickWand-config.1 share/man/man1/Wand-config.1"
TERMUX_PKG_DEPENDS="fftw, pango, glib, libbz2, libjpeg-turbo, liblzma, libpng, libtiff, libxml2, openjpeg, littlecms"
