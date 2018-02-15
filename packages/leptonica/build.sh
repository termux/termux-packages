TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_VERSION=1.75.2
TERMUX_PKG_SHA256=e1da7aad9909faa57343ec47ebfbb9ef25b3930db6b58ea4e2401b95c8d75a6d
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libtiff"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-giflib --without-libwebp --without-libopenjpeg"

termux_step_pre_configure() {
	./autobuild
}
