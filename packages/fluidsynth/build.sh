TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Yonle <yonle@protonmail.com>"
TERMUX_PKG_VERSION=2.2.5
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9037e703617f91c4c36039a5059e0f624164799d856af715bcd8a23c07ba03b8
TERMUX_PKG_DEPENDS="glib, pulseaudio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib"

