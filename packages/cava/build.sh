TERMUX_PKG_HOMEPAGE=https://github.com/karlstav/cava
TERMUX_PKG_DESCRIPTION="Console-based Audio Visualizer. Works with MPD."
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://github.com/karlstav/cava/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=42d51c6c283cd2b0f5125954ea8c61a12385703d1953ef9c40103402c7a744dc
TERMUX_PKG_DEPENDS="ncurses,fftw"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pulse_simple_pa_simple_new=no
"

termux_step_pre_configure() {
	./autogen.sh
}
