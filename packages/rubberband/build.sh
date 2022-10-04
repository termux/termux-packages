TERMUX_PKG_HOMEPAGE=https://breakfastquay.com/rubberband/
TERMUX_PKG_DESCRIPTION="An audio time-stretching and pitch-shifting library and utility program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SRCURL=https://breakfastquay.com/files/releases/rubberband-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=df6530b403c8300a23973df22f36f3c263f010d53792063e411f633cebb9ed85
TERMUX_PKG_DEPENDS="fftw, ladspa-sdk, libsamplerate, libsndfile, lv2, vamp-plugin-sdk"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dfft=fftw
-Dresampler=libsamplerate
"
