TERMUX_PKG_HOMEPAGE="http://gmic.eu"
TERMUX_PKG_DESCRIPTION="imageman"
TERMUX_PKG_VERSION=1.7.9
TERMUX_PKG_SRCURL=http://gmic.eu/files/source/gmic_source.tar.gz
TERMUX_PKG_FOLDERNAME="gmic-1.7.9"
TERMUX_PKG_SHA256=152f100eb139a5f6e5b3d1e43aaed34f2b3786f72f52724ebde5e5ccea2c7133
TERMUX_PKG_DEPENDS="graphicsmagick++, libcurl, fftw"
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
	gunzip man/gmic.1.gz
	cp man/gmic.1 $TERMUX_PREFIX/share/man/man1
	cp resources/gmic_bashcompletion.sh $TERMUX_PREFIX//share/bash-completion/completions/gmic
}
