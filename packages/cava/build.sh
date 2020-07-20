TERMUX_PKG_HOMEPAGE=https://github.com/karlstav/cava
TERMUX_PKG_DESCRIPTION="Console-based Audio Visualizer. Works with MPD and Pulseaudio"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION=0.7.2
TERMUX_PKG_SRCURL=https://github.com/karlstav/cava/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cca1fa857f4b6b91813dbaafe25b226557d7addbf237a910683f4e3b84b02a29
TERMUX_PKG_DEPENDS="ncurses,fftw,pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
