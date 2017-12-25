TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/PulseAudio
TERMUX_PKG_DESCRIPTION="A featureful, general-purpose sound server - shared libraries"
TERMUX_PKG_VERSION=11.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=f2521c525a77166189e3cb9169f75c2ee2b82fa3fcf9476024fbc2c3a6c9cd9e
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libltdl, libsndfile, libandroid-glob"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/vala"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon-opt
--disable-alsa
--disable-esound
--disable-glib2
--disable-openssl
--without-caps
--with-database=simple
--disable-memfd"
TERMUX_PKG_CONFFILES="etc/pulse/client.conf etc/pulse/daemon.conf etc/pulse/default.pa etc/pulse/system.pa"

termux_step_pre_configure () {
	mkdir $TERMUX_PKG_SRCDIR/src/modules/sles
	cp $TERMUX_PKG_BUILDER_DIR/module-sles-sink.c $TERMUX_PKG_SRCDIR/src/modules/sles
	intltoolize --automake --copy --force
	LDFLAGS+=" -llog -landroid-glob"
}

termux_step_post_make_install () {
	# Some binaries link against these:
	cd $TERMUX_PREFIX/lib
	for lib in pulseaudio/lib*.so* pulse-${TERMUX_PKG_VERSION}/modules/lib*.so*; do
		ln -s -f $lib `basename $lib`
	done
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		SYSTEM_LIB=lib
	else
		SYSTEM_LIB=lib64
	fi
	# Pulseaudio fails to start when it cannot detect any sound hardware
	# so disable hardware detection.
	sed -i $TERMUX_PREFIX/etc/pulse/default.pa \
		-e '/^load-module module-detect$/s/^/#/'
	echo "load-module module-sles-sink" >> $TERMUX_PREFIX/etc/pulse/default.pa
	cd $TERMUX_PREFIX/bin

	for bin in esdcompat pacat pacmd pactl pasuspender pulseaudio; do
		mv $bin ../libexec
		local PA_LIBS="" lib
		for lib in android-glob pulse pulsecommon-11.1 pulsecore-11.1; do
			if [ -n "$PA_LIBS" ]; then PA_LIBS+=":"; fi
			PA_LIBS+="$TERMUX_PREFIX/lib/lib${lib}.so"
		done
		echo "export LD_PRELOAD=$PA_LIBS" >> $TERMUX_PREFIX/bin/$bin
		echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIB:/system/vendor/$SYSTEM_LIB:/data/data/com.termux/files/usr/lib /data/data/com.termux/files/usr/libexec/$bin \$@" >> $TERMUX_PREFIX/bin/$bin
		chmod +x $bin
	done
}
