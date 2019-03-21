TERMUX_PKG_HOMEPAGE=https://github.com/karlstav/cava
TERMUX_PKG_DESCRIPTION="Console-based Audio Visualizer. Works with MPD and Pulseaudio"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION=0.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=98b880e7e704ed457863f379f31b488e06076bb34a5de02825096969b916a78d
TERMUX_PKG_SRCURL=https://github.com/karlstav/cava/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses,fftw,libpulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	./autogen.sh
}
