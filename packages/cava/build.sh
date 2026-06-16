# Contributor: @Neo-Oli
TERMUX_PKG_HOMEPAGE=https://github.com/karlstav/cava
TERMUX_PKG_DESCRIPTION="Console-based Audio Visualizer. Works with MPD and Pulseaudio"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL=https://github.com/karlstav/cava/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2866cea11d0bd38406924ab2b47d5577f14909a7321ee928b6836391f375af7e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fftw, libiniparser, ncurses, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
