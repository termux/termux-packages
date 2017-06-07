TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_VERSION=1.74.2
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b2e9bacd23597d0ee21625a7d8443177b1cb85daf196d86b67ad75044e29c27
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp --without-libopenjpeg"
TERMUX_PKG_FOLDERNAME=leptonica-$TERMUX_PKG_VERSION

termux_step_pre_configure() {
	./autobuild
}
