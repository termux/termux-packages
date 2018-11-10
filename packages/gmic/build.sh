TERMUX_PKG_HOMEPAGE=https://gmic.eu
TERMUX_PKG_DESCRIPTION="Full-featured framework for image processing"
TERMUX_PKG_VERSION=2.3.6
TERMUX_PKG_SHA256=86fe671879725863acecc207bdb86c4428635cd1a20d6043618864cf4c366113
TERMUX_PKG_SRCURL=https://gmic.eu/files/source/gmic_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="graphicsmagick++, libcurl, fftw, libpng, libjpeg-turbo, libtiff"
TERMUX_PKG_BUILD_DEPENDS="graphicsmagick-dev"
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	return 0;
}

termux_step_make () {
	cd src/
	make cli
}

termux_step_make_install() {
	cp src/gmic $TERMUX_PREFIX/bin/gmic
	cp src/*.h $TERMUX_PREFIX/include/
	gunzip man/gmic.1.gz
	cp man/gmic.1 $TERMUX_PREFIX/share/man/man1
}

