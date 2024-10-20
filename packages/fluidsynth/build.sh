TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.7"
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=38d1d910783ab67c07a4d859d1aa95525979ff352b927e25b1ae894c774bb4c4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, glib, libc++, libsndfile, pulseaudio, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib
"

termux_step_pre_configure() {
	LDFLAGS+=" -l:libomp.a"
}
