TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_VERSION=1.77.0
TERMUX_PKG_SHA256=a11a3f6cb709d5e4d20faa7af55f77057335cbc5ef89103c31a17aea52d7b555
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp --without-libopenjpeg"

termux_step_pre_configure() {
	./autogen.sh
}
