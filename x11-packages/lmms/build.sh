TERMUX_PKG_HOMEPAGE=https://lmms.io
TERMUX_PKG_DESCRIPTION="Linux MultiMedia Studio"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.2"
TERMUX_PKG_SRCURL="https://github.com/LMMS/lmms/releases/download/v$TERMUX_PKG_VERSION/lmms_$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=b185507fb64ecfd8e31145135b58ab244b637f9efc09c4176caf70aa3cbaae1e
TERMUX_PKG_DEPENDS="alsa-lib, fftw, fluidsynth, freetype, hicolor-icon-theme, jack, ladspa-sdk, libandroid-shmem, libc++, libmp3lame, libogg, libsamplerate, libsndfile, libvorbis, libx11, libxcb, portaudio, pulseaudio, qt5-qtbase, qt5-qtx11extras, sdl"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt5-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWANT_QT5=ON
-DWANT_SOUNDIO=OFF
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	g++ "$TERMUX_PKG_SRCDIR/buildtools/bin2res.cpp" -o bin2res
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	fi

	LDFLAGS+=" -landroid-shmem"
}
