TERMUX_PKG_HOMEPAGE=https://gmic.eu
TERMUX_PKG_DESCRIPTION="Full-featured framework for image processing"
TERMUX_PKG_LICENSE="CeCILL-2.1"
TERMUX_PKG_VERSION=2.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=48de7045a36eb718d55b0dfd68a797380b5390af99c9737a4dfba0fb678ed2b4
TERMUX_PKG_SRCURL=https://gmic.eu/files/source/gmic_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="graphicsmagick++, libcurl, fftw, libpng, libjpeg-turbo, libtiff, zlib"
TERMUX_PKG_BUILD_DEPENDS="graphicsmagick-dev"
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
	return 0;
}

termux_step_make() {
	cd src/
	if [ $TERMUX_ARCH = "arm" ]; then
		make cli  LIBS=" -lunwind -L/data/data/com.termux/files/usr/lib  -lfftw3 -lfftw3_threads -lcurl -lpng16 -lz -ljpeg -ltiff -lGraphicsMagick++ -lGraphicsMagick"
	else
		make cli
	fi
}

termux_step_make_install() {
	cp src/gmic $TERMUX_PREFIX/bin/gmic
	cp src/*.h $TERMUX_PREFIX/include/
	gunzip man/gmic.1.gz
	cp man/gmic.1 $TERMUX_PREFIX/share/man/man1
}

