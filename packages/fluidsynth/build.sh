TERMUX_PKG_HOMEPAGE=https://github.com/FluidSynth/fluidsynth
TERMUX_PKG_DESCRIPTION="Software synthesizer based on the SoundFont 2 specifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Yonle <yonle@duck.com>"
TERMUX_PKG_VERSION=2.2.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/FluidSynth/fluidsynth/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7c29a5cb7a2755c8012d941d1335da7bda957bbb0a86b7c59215d26773bb51fe
TERMUX_PKG_DEPENDS="glib, pulseaudio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DLIB_INSTALL_DIR=${TERMUX_PREFIX}/lib"

