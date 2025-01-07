TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/PulseAudio
TERMUX_PKG_DESCRIPTION="A featureful, general-purpose sound server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=git+https://github.com/pulseaudio/pulseaudio
TERMUX_PKG_VERSION="17.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="dbus, libandroid-execinfo, libandroid-glob, libc++, libltdl, libsndfile, libsoxr, libwebrtc-audio-processing, speexdsp"
TERMUX_PKG_BREAKS="libpulseaudio-dev, libpulseaudio"
TERMUX_PKG_REPLACES="libpulseaudio-dev, libpulseaudio"
# glib is only a runtime dependency of pulseaudio-glib subpackage
TERMUX_PKG_BUILD_DEPENDS="libtool, glib, check"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-D alsa=disabled
-D x11=disabled
-D gtk=disabled
-D openssl=disabled
-D gsettings=disabled
-D doxygen=false
-D database=simple"
TERMUX_PKG_CONFFILES="etc/pulse/client.conf etc/pulse/daemon.conf etc/pulse/default.pa etc/pulse/system.pa"

termux_step_pre_configure() {
	# Our aaudio sink module needs libaaudio.so from a later android api version:
	if [ $TERMUX_PKG_API_LEVEL -lt 26 ]; then
		local _libdir="$TERMUX_PKG_TMPDIR/libaaudio"
		rm -rf "${_libdir}"
		mkdir -p "${_libdir}"
		cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/26/libaaudio.so" \
			"${_libdir}"
		LDFLAGS+=" -L${_libdir}"
	fi

	mkdir $TERMUX_PKG_SRCDIR/src/modules/sles
	cp $TERMUX_PKG_BUILDER_DIR/module-sles-sink.c $TERMUX_PKG_SRCDIR/src/modules/sles
	cp $TERMUX_PKG_BUILDER_DIR/module-sles-source.c $TERMUX_PKG_SRCDIR/src/modules/sles
	mkdir $TERMUX_PKG_SRCDIR/src/modules/aaudio
	cp $TERMUX_PKG_BUILDER_DIR/module-aaudio-sink.c $TERMUX_PKG_SRCDIR/src/modules/aaudio

	export LIBS="-landroid-glob -landroid-execinfo"

	local _libgcc="$($CC -print-libgcc-file-name)"
	LIBS+=" -L$(dirname $_libgcc) -l:$(basename $_libgcc)"

	# https://github.com/termux/termux-packages/issues/18977
	# https://github.com/termux/termux-packages/issues/18810
	export LDFLAGS+=" -Wl,--undefined-version"
}

termux_step_post_make_install() {
	# Some binaries link against these:
	cd $TERMUX_PREFIX/lib
	for lib in pulseaudio/{,modules/}lib*.so*; do
		ln -v -s -f "$lib" "$(basename "$lib")"
	done

	# Pulseaudio fails to start when it cannot detect any sound hardware
	# so disable hardware detection.
	sed -i $TERMUX_PREFIX/etc/pulse/default.pa \
		-e '/^load-module module-detect$/s/^/#/'
	echo "load-module module-sles-sink" >> $TERMUX_PREFIX/etc/pulse/default.pa
	echo "#load-module module-aaudio-sink" >> $TERMUX_PREFIX/etc/pulse/default.pa
}

termux_step_post_massage() {
	# Some programs, e.g. Firefox, try to dlopen(3) `libpulse.so.0`.
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libpulse.so.0" ]; then
		ln -sf libpulse.so libpulse.so.0
	fi
}
