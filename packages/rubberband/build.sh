TERMUX_PKG_HOMEPAGE=https://breakfastquay.com/rubberband/
TERMUX_PKG_DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.0"
TERMUX_PKG_SRCURL=https://breakfastquay.com/files/releases/rubberband-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d9ef89e2b8ef9f85b13ac3c2faec30e20acf2c9f3a9c8c45ce637f2bc95e576c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, libc++, libsamplerate, libsndfile"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dfft=fftw
-Dresampler=libsamplerate
"
