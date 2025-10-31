TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.1"
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=10b2e32ba78c72ac1384965c66df06443a4bd0ab968dcafaf8fa17086001bf03
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, glib, libc++, libsndfile, pulseaudio, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib
"

termux_step_pre_configure() {
	LDFLAGS+=" -l:libomp.a"
}
