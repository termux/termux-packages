TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=1.79.0
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf9716f91a4844c2682a07ef21eaf68b6f1077af1f63f27c438394fd66218e17
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff, zlib"
TERMUX_PKG_BREAKS="leptonica-dev"
TERMUX_PKG_REPLACES="leptonica-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp --without-libopenjpeg"

termux_step_pre_configure() {
	./autogen.sh
}
