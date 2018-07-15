TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/PulseAudio
TERMUX_PKG_DESCRIPTION="A featureful, general-purpose sound server - shared libraries"
TERMUX_PKG_VERSION=12.1
TERMUX_PKG_SHA256=5f5dfb5e2c376e8c974b80f93b983ed77088ade7fb8b9325a575c45aa35977f3
TERMUX_PKG_SRCURL=https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libltdl, libsndfile, libandroid-glob, libsoxr"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="share/vala"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon-opt
--disable-alsa
--disable-esound
--disable-glib2
--disable-openssl
--without-caps
--with-database=simple
--disable-memfd
--disable-gsettings
--bindir=$TERMUX_PREFIX/libexec
ax_cv_PTHREAD_PRIO_INHERIT=no"
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
	cd $TERMUX_PREFIX/libexec

	for bin in esdcompat pacat pacmd pactl pasuspender pulseaudio; do
		rm -f ../bin/$bin
		local PA_LIBS="" lib
		for lib in android-glob pulse pulsecommon-$TERMUX_PKG_VERSION pulsecore-$TERMUX_PKG_VERSION; do
			if [ -n "$PA_LIBS" ]; then PA_LIBS+=":"; fi
			PA_LIBS+="$TERMUX_PREFIX/lib/lib${lib}.so"
		done
		echo "#!$TERMUX_PREFIX/bin/sh" >> $TERMUX_PREFIX/bin/$bin
		echo "export LD_PRELOAD=$PA_LIBS" >> $TERMUX_PREFIX/bin/$bin
		echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIB:/system/vendor/$SYSTEM_LIB:$TERMUX_PREFIX/lib exec $TERMUX_PREFIX/libexec/$bin \$@" >> $TERMUX_PREFIX/bin/$bin
		chmod +x $TERMUX_PREFIX/bin/$bin
	done
}
