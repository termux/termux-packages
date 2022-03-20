TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/PulseAudio
TERMUX_PKG_DESCRIPTION="A featureful, general-purpose sound server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/pulseaudio/pulseaudio.git
TERMUX_PKG_VERSION=14.2
TERMUX_PKG_REVISION=8
TERMUX_PKG_DEPENDS="libc++, libltdl, libsndfile, libandroid-glob, libsoxr, speexdsp, libwebrtc-audio-processing"
TERMUX_PKG_BREAKS="libpulseaudio-dev, libpulseaudio"
TERMUX_PKG_REPLACES="libpulseaudio-dev, libpulseaudio"
# glib is only a runtime dependency of pulseaudio-glib subpackage
TERMUX_PKG_BUILD_DEPENDS="libtool, glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon-opt
--disable-alsa
--disable-esound
--disable-x11
--disable-gtk3
--disable-openssl
--enable-glib2
--without-caps
--with-database=simple
--disable-memfd
--disable-gsettings
ax_cv_PTHREAD_PRIO_INHERIT=no"
TERMUX_PKG_CONFFILES="etc/pulse/client.conf etc/pulse/daemon.conf etc/pulse/default.pa etc/pulse/system.pa"

termux_step_post_get_source() {
	NOCONFIGURE=1 ./bootstrap.sh
}

termux_step_pre_configure() {
	# Our aaudio sink module needs libaaudio.so from a later android api version:
	local _ANDROID=""
	if [ "$TERMUX_ARCH" = "arm" ]; then
		_ANDROID="eabi"
	fi
	mkdir $TERMUX_PKG_TMPDIR/libaaudio
	cp $NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$TERMUX_ARCH-linux-android$_ANDROID/26/libaaudio.so \
		$TERMUX_PKG_TMPDIR/libaaudio/
	LDFLAGS+=" -L$TERMUX_PKG_TMPDIR/libaaudio/"

	mkdir $TERMUX_PKG_SRCDIR/src/modules/sles
	cp $TERMUX_PKG_BUILDER_DIR/module-sles-sink.c $TERMUX_PKG_SRCDIR/src/modules/sles
	cp $TERMUX_PKG_BUILDER_DIR/module-sles-source.c $TERMUX_PKG_SRCDIR/src/modules/sles
	mkdir $TERMUX_PKG_SRCDIR/src/modules/aaudio
	cp $TERMUX_PKG_BUILDER_DIR/module-aaudio-sink.c $TERMUX_PKG_SRCDIR/src/modules/aaudio

	export LIBS="-landroid-glob"
}

termux_step_post_make_install() {
	# Some binaries link against these:
	cd $TERMUX_PREFIX/lib
	for lib in pulseaudio/lib*.so* pulse-${TERMUX_PKG_VERSION}/modules/lib*.so*; do
		ln -s -f $lib $(basename $lib)
	done

	# Pulseaudio fails to start when it cannot detect any sound hardware
	# so disable hardware detection.
	sed -i $TERMUX_PREFIX/etc/pulse/default.pa \
		-e '/^load-module module-detect$/s/^/#/'
	echo "load-module module-sles-sink" >> $TERMUX_PREFIX/etc/pulse/default.pa
	echo "#load-module module-aaudio-sink" >> $TERMUX_PREFIX/etc/pulse/default.pa
}
