TERMUX_PKG_HOMEPAGE=https://breakfastquay.com/rubberband/
TERMUX_PKG_DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://breakfastquay.com/files/releases/rubberband-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=dda7e257b14c59a1f59c5ccc4d6f19412039f77834275955aa0ff511779b98d2
TERMUX_PKG_DEPENDS="fftw, libc++, libsamplerate, libsndfile"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dfft=fftw
-Dresampler=libsamplerate
"
