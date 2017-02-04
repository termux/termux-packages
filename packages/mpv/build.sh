TERMUX_PKG_HOMEPAGE=https://mpv.io/
TERMUX_PKG_DESCRIPTION="Command-line media player"
TERMUX_PKG_VERSION=0.23.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mpv-player/mpv/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8aeefe5970587dfc454d2b89726b603f156bd7a9ae427654eef0d60c68d94998
TERMUX_PKG_FOLDERNAME=mpv-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="ffmpeg, openal-soft"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons share/applications"

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
		--disable-caca

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
	# /system/vendor/lib(64) needed for libqc-opt.so on
	# a xperia z5 c, reported by BrainDamage on #termux.
	echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIBFOLDER:/system/vendor/$SYSTEM_LIBFOLDER:$TERMUX_PREFIX/lib $TERMUX_PREFIX/libexec/mpv \"\$@\"" >> $TERMUX_PREFIX/bin/mpv
	chmod +x $TERMUX_PREFIX/bin/mpv
}
