TERMUX_PKG_HOMEPAGE=https://gmic.eu
TERMUX_PKG_DESCRIPTION="Full-featured framework for image processing"
TERMUX_PKG_LICENSE="CeCILL-2.1"
TERMUX_PKG_VERSION=2.6.3
TERMUX_PKG_SRCURL=https://gmic.eu/files/source/gmic_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9a3947850ad8e6997039ebf8d03ce8ac371f2a01c3ec6330e7d8d447932cbb47
TERMUX_PKG_DEPENDS="libcurl, fftw, libpng, libjpeg-turbo, libtiff, zlib"
TERMUX_PKG_BUILD_DEPENDS="graphicsmagick"
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	return 0;
}

termux_step_make() {
	cd src/
	make cli
}

termux_step_make_install() {
	cp src/gmic $TERMUX_PREFIX/bin/gmic
	cp src/*.h $TERMUX_PREFIX/include/
	gunzip man/gmic.1.gz
	cp man/gmic.1 $TERMUX_PREFIX/share/man/man1
}

