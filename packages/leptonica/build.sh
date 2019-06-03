TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_VERSION=1.78.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=f8ac4d93cc76b524c2c81d27850bfc342e68b91368aa7a1f7d69e34ce13adbb4
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp --without-libopenjpeg"

termux_step_pre_configure() {
	./autogen.sh
}
