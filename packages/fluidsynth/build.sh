TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.7"
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7fb0e328c66a24161049e2b9e27c3b6e51a6904b31b1a647f73cc1f322523e88
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, glib, libc++, libsndfile, pulseaudio, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib
"

termux_step_pre_configure() {
	LDFLAGS+=" -l:libomp.a"
}
