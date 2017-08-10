TERMUX_PKG_HOMEPAGE="http://gmic.eu"
TERMUX_PKG_DESCRIPTION="imageman"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_SRCURL=http://gmic.eu/files/source/gmic_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_FOLDERNAME="gmic-$TERMUX_PKG_VERSION"
TERMUX_PKG_SHA256=7da9f08d62a9d23fc8badbc7c819cf76f4a9ce3db763710268fdcb80d83ecfc6
TERMUX_PKG_DEPENDS="graphicsmagick++, libcurl, fftw"
TERMUX_PKG_REVISION=2
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_BUILD_IN_SRC=yes
termux_step_configure(){
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

