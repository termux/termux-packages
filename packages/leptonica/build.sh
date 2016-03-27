TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Leptonica is a pedagogically-oriented open source site containing software that is broadly useful for image processing and image analysis applications"
TERMUX_PKG_VERSION=1.73
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_SRCURL=http://www.leptonica.com/source/leptonica-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp"

termux_step_pre_configure() {
	export ac_cv_func_fmemopen=yes
}

termux_step_post_configure() {
	# add fmemopen support from https://github.com/j-jorge/android-stdioext
	cd $TERMUX_PKG_SRCDIR/src

	wget --quiet https://raw.githubusercontent.com/j-jorge/android-stdioext/master/include/stdioext.h
	wget --quiet https://github.com/j-jorge/android-stdioext/raw/master/src/fmemopen.c
	wget --quiet https://github.com/j-jorge/android-stdioext/raw/master/src/fopencookie.c
	wget --quiet https://raw.githubusercontent.com/j-jorge/android-stdioext/master/src/open_memstream.c

	echo '#include "stdioext.h"' >> alltypes.h
}
