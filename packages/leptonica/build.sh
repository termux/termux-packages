TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Leptonica is a pedagogically-oriented open source site containing software that is broadly useful for image processing and image analysis applications"
TERMUX_PKG_VERSION=1.73
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_SRCURL=http://www.leptonica.com/source/leptonica-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp"
