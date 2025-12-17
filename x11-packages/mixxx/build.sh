TERMUX_PKG_HOMEPAGE=https://www.mixxx.org
TERMUX_PKG_DESCRIPTION="Free DJ software that gives you everything you need to perform live mixes"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.4"
TERMUX_PKG_SRCURL="https://github.com/mixxxdj/mixxx/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=53fb1a2a6c5ac6eb3562cb99c5bcae8777d81e48b96b5b3c292794c0c105b269
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="chromaprint, ffmpeg, flac, glib, glu, hicolor-icon-theme, hidapi, libc++, libdjinterop, libebur128, libid3tag, libkeyfinder, libmad, libmodplug, libmp3lame, libogg, libopus, libsndfile, libsoundtouch, libsqlite, libusb, libvorbis, libx11, lilv, openssl, opusfile, portaudio, portmidi, protobuf, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtsvg, qtkeychain, rubberband, taglib, upower, wavpack, zlib"
TERMUX_PKG_BUILD_DEPENDS="ms-gsl, googletest"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"

termux_step_pre_configure() {
	termux_setup_protobuf

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		# By default cmake will pick $TERMUX_PREFIX/bin/protoc, we should avoid it when cross-compiling
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dprotobuf_generate_PROTOC_EXE=$(command -v protoc)"
	fi
}
