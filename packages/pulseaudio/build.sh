TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/PulseAudio
TERMUX_PKG_DESCRIPTION="A featureful, general-purpose sound server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=13.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_DEPENDS="libltdl, libsndfile, libandroid-glob, libsoxr, speexdsp"
TERMUX_PKG_BREAKS="libpulseaudio-dev, libpulseaudio"
TERMUX_PKG_REPLACES="libpulseaudio-dev, libpulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon-opt
--disable-alsa
--disable-esound
--disable-glib2
--disable-x11
--disable-gtk3
--disable-openssl
--without-caps
--with-database=simple
--disable-memfd
--disable-gsettings
ax_cv_PTHREAD_PRIO_INHERIT=no"
TERMUX_PKG_CONFFILES="etc/pulse/client.conf etc/pulse/daemon.conf etc/pulse/default.pa etc/pulse/system.pa"

termux_step_extract_package() {
	local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/checkout-$TERMUX_PKG_VERSION
	if [ ! -d $CHECKED_OUT_FOLDER ]; then
		local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
		rm -Rf $TMP_CHECKOUT
		mkdir -p $TMP_CHECKOUT

		git clone --depth 1 \
			--branch v$TERMUX_PKG_VERSION \
			https://github.com/pulseaudio/pulseaudio.git \
			$TMP_CHECKOUT
		cd $TMP_CHECKOUT
		git submodule update --init # --depth 1
		mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
	fi

	mkdir $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	cp -Rf $CHECKED_OUT_FOLDER/* .
	cp -Rf $CHECKED_OUT_FOLDER/.git .

	NOCONFIGURE=1 ./bootstrap.sh
}

termux_step_pre_configure() {
	# Our aaudio sink module needs libaaudio.so from a later android api version:
	local _NDK_ARCHNAME=$TERMUX_ARCH
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		_NDK_ARCHNAME=arm64
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		_NDK_ARCHNAME=x86
	fi
	mkdir $TERMUX_PKG_TMPDIR/libaaudio
	cp $NDK/platforms/android-26/arch-$_NDK_ARCHNAME/usr/lib*/libaaudio.so \
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
