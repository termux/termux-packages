TERMUX_PKG_HOMEPAGE=https://kokkinizita.linuxaudio.org/linuxaudio/
TERMUX_PKG_DESCRIPTION="A real-time C++ convolution library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9aa11484fb30b4e6ef00c8a3281eebcfad9221e3937b1beb5fe21b748d89325f
TERMUX_PKG_DEPENDS="libc++, fftw"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
-C source
PREFIX=$TERMUX_PREFIX
"
