TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Yonle <yonle@duck.com>"
TERMUX_PKG_VERSION=2.2.7
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=460d86d8d687f567dc4780890b72538c7ff6b2082080ef2f9359d41670a309cf
TERMUX_PKG_DEPENDS="glib, pulseaudio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib"

