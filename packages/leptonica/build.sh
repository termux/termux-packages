TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_VERSION=1.74.4
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=29c35426a416bf454413c6fec24c24a0b633e26144a17e98351b6dffaa4a833b
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp --without-libopenjpeg"
TERMUX_PKG_FOLDERNAME=leptonica-$TERMUX_PKG_VERSION

termux_step_pre_configure() {
	./autobuild
}
