TERMUX_PKG_HOMEPAGE=https://lib.openmpt.org/libopenmpt/
TERMUX_PKG_DESCRIPTION="OpenMPT based module player library and libopenmpt based command-line player"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.4
TERMUX_PKG_SRCURL=https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${TERMUX_PKG_VERSION}+release.autotools.tar.gz
TERMUX_PKG_SHA256=f34d06b9daa7bca111625369e5bbc2e7c0e0e04737a439b0e6320811babcef40
TERMUX_PKG_DEPENDS="libflac, mpg123, pulseaudio"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-portaudio
--without-portaudiocpp
"
