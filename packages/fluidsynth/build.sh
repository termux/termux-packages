TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Yonle <yonle@duck.com>"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d734e4cf488be763cf123e5976f3154f0094815093eecdf71e0e9ae148431883
TERMUX_PKG_DEPENDS="dbus, glib, libc++, libsndfile, pulseaudio, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib"

