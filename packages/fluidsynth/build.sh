TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@yonle <yonle@protonmail.com>"
TERMUX_PKG_VERSION=2.2.3
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b31807cb0f88e97f3096e2b378c9815a6acfdc20b0b14f97936d905b536965c4
TERMUX_PKG_DEPENDS="glib, pulseaudio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib"

