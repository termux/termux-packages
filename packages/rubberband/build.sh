TERMUX_PKG_HOMEPAGE=https://breakfastquay.com/rubberband/
TERMUX_PKG_DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.0"
TERMUX_PKG_SRCURL=https://breakfastquay.com/files/releases/rubberband-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=af050313ee63bc18b35b2e064e5dce05b276aaf6d1aa2b8a82ced1fe2f8028e9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, libc++, libsamplerate, libsndfile"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dfft=fftw
-Dresampler=libsamplerate
"
