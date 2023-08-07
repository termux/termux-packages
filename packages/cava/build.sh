TERMUX_PKG_HOMEPAGE=https://github.com/karlstav/cava
TERMUX_PKG_DESCRIPTION="Console-based Audio Visualizer. Works with MPD and Pulseaudio"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_SRCURL=https://github.com/karlstav/cava/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3e79367169791fb11236dce6da7b38f46cdd859304710391785c4df7f364fd23
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, libiniparser, ncurses, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
