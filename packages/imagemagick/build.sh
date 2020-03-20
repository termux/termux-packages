TERMUX_PKG_HOMEPAGE=https://www.imagemagick.org/
TERMUX_PKG_DESCRIPTION="Suite to create, edit, compose, or convert images in a variety of formats"
TERMUX_PKG_LICENSE="ImageMagick"
TERMUX_PKG_VERSION=7.0.10.1
TERMUX_PKG_SRCURL=https://github.com/ImageMagick/ImageMagick/archive/$(echo $TERMUX_PKG_VERSION | sed 's/\(.*\)\./\1-/').tar.gz
TERMUX_PKG_SHA256=61fcd748d3c3962c614c2df2645cf09ba7ae95b495cb27148dd5d2a8fc995713
TERMUX_PKG_DEPENDS="fftw, pango, glib, libbz2, libjpeg-turbo, liblzma, libpng, libtiff, libxml2, openjpeg, littlecms, libwebp, librsvg"
TERMUX_PKG_BREAKS="imagemagick-dev"
TERMUX_PKG_REPLACES="imagemagick-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-x
--without-gvc
--with-magick-plus-plus=no
--with-bzlib=yes
--with-xml=yes
--with-rsvg=yes
--with-lzma
--disable-openmp
ac_cv_func_ftime=no
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/ImageMagick-7/francais.xml
"

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = "i686" ]; then
		# Avoid "libMagickCore-7.Q16HDRI.so: error: undefined reference to '__atomic_load'":
		LDFLAGS+=" -latomic"
	fi
}
