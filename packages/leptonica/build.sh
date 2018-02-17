TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_VERSION=1.75.3
TERMUX_PKG_SHA256=c1b99d2509fe9c61c8818935a4b9cddd91ebaaaab222a47f62887888f15f53c4
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp --without-libopenjpeg"

termux_step_pre_configure() {
	./autobuild
}
