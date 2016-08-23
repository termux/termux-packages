# Does not work with libjpeg-turbo or libpng installed, since
# linking against libOpenSLES causes indirect linkage against
# libskia.so, which links against the platform libjpeg.so and
# libpng.so, which are not compatible with the Termux ones.
#
# On Android N also liblzma seems to conflict.
TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_VERSION=0.19.0
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=mpv-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="ffmpeg"

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR

	# Setup rst2man for man page generation of mpv.1:
	pip install docutils
	export RST2MAN=$HOME/.local/bin/rst2man.py

	./bootstrap.py

	./waf configure \
		--prefix=$TERMUX_PREFIX \
		--disable-gl \
		--disable-jpeg \
		--disable-lcms2 \
		--disable-libass

	./waf install
}
