TERMUX_PKG_HOMEPAGE=https://breakfastquay.com/rubberband/
TERMUX_PKG_DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_SRCURL=https://breakfastquay.com/files/releases/rubberband-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b95a76da5cdb3966770c60115ecd838f84061120f884c3bfdc904f75931ec9aa
TERMUX_PKG_DEPENDS="fftw, ladspa-sdk, libsamplerate, libsndfile, lv2, vamp-plugin-sdk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dfft=fftw
-Dresampler=libsamplerate
"
