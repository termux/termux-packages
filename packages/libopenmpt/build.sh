TERMUX_PKG_HOMEPAGE=https://lib.openmpt.org/libopenmpt/
TERMUX_PKG_DESCRIPTION="OpenMPT based module player library and libopenmpt based command-line player"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.10
TERMUX_PKG_SRCURL=https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${TERMUX_PKG_VERSION}+release.autotools.tar.gz
TERMUX_PKG_SHA256=59a8fa28d8b8df69cb7fa5972bdf931081dab4e1e1156c69a1a53b65c2be9ffa
TERMUX_PKG_DEPENDS="libflac, mpg123, pulseaudio"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-portaudio
--without-portaudiocpp
"
