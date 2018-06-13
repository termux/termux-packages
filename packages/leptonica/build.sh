TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_VERSION=1.76.0
TERMUX_PKG_SHA256=ff98ffef6103cda0e400676f81113a8157569ac0f453c6e03a1a27b305ba25a7
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp --without-libopenjpeg"

termux_step_pre_configure() {
	./autobuild
}
