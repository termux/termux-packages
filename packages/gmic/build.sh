TERMUX_PKG_HOMEPAGE=https://gmic.eu
TERMUX_PKG_DESCRIPTION="Full-featured framework for image processing"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SHA256=160ef2fff116eedf56ea4635762a347f499761034cc21f0f16d1baea20c4e9ec
TERMUX_PKG_SRCURL=https://gmic.eu/files/source/gmic_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="graphicsmagick++, libcurl, fftw, libpng, libjpeg-turbo, libtiff"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_LIB=off -DBUILD_LIB_STATIC=off -DENABLE_X=off -DENABLE_FFMPEG=off -DENABLE_OPENCV=off -DENABLE_OPENEXR=off -DENABLE_OPENMP=off"
TERMUX_PKG_FORCE_CMAKE=yes

termux_step_make_install() {
	cp gmic $TERMUX_PREFIX/bin/gmic

	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp man/gmic.1 $TERMUX_PREFIX/share/man/man1

	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions
	cp resources/gmic_bashcompletion.sh \
	   $TERMUX_PREFIX/share/bash-completion/completions
}

