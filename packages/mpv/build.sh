TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_VERSION=0.21.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=mpv-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="ffmpeg, openal-soft, libcaca"

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR

	./bootstrap.py

	./waf configure \
		--prefix=$TERMUX_PREFIX \
		--disable-gl \
		--disable-jpeg \
		--disable-lcms2 \
		--disable-libass \
		--disable-lua \
		--enable-openal \
		--enable-caca

	./waf install

	# Use opensles audio out be default:
	mkdir -p $TERMUX_PREFIX/etc/mpv
	echo "ao=opensles" > $TERMUX_PREFIX/etc/mpv/mpv.conf

	# Try to work around OpenSL ES library clashes:
	# Linking against libOpenSLES causes indirect linkage against
	# libskia.so, which links against the platform libjpeg.so and
	# libpng.so, which are not compatible with the Termux ones.
	#
	# On Android N also liblzma seems to conflict.
	mkdir -p $TERMUX_PREFIX/libexec
	mv $TERMUX_PREFIX/bin/mpv $TERMUX_PREFIX/libexec

	local SYSTEM_LIBFOLDER=lib64
	if [ $TERMUX_ARCH_BITS = 32 ]; then SYSTEM_LIBFOLDER=lib; fi
	echo "#!/bin/sh" > $TERMUX_PREFIX/bin/mpv
	echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIBFOLDER:$TERMUX_PREFIX/lib $TERMUX_PREFIX/libexec/mpv \"\$@\"" >> $TERMUX_PREFIX/bin/mpv
	chmod +x $TERMUX_PREFIX/bin/mpv
}
