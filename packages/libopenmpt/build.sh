TERMUX_PKG_HOMEPAGE=https://lib.openmpt.org/libopenmpt/
TERMUX_PKG_DESCRIPTION="OpenMPT based module player library and libopenmpt based command-line player"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.8
TERMUX_PKG_SRCURL=https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-${TERMUX_PKG_VERSION}+release.autotools.tar.gz
TERMUX_PKG_SHA256=29e2c21174b73f67f2ba5ee76808d62f182b130e4f704ee2d9ae8283982d8acd
TERMUX_PKG_DEPENDS="libflac, mpg123, pulseaudio"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-portaudio
--without-portaudiocpp
"
