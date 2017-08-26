TERMUX_PKG_HOMEPAGE=https://github.com/karlstav/cava
TERMUX_PKG_DESCRIPTION="Console-based Audio Visualizer. Works with MPD."
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/karlstav/cava/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c2fdc489addd96058a2b98c6bd2d925c88db1b7651c67d274f21aabbd7ff0ad8
TERMUX_PKG_FOLDERNAME=cava-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="ncurses,fftw"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--prefix=${TERMUX_PREFIX}
ac_cv_lib_pulse_simple_pa_simple_new=no
"

termux_step_pre_configure() {
	./autogen.sh
}
