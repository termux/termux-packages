TERMUX_PKG_HOMEPAGE=https://cmus.github.io/
TERMUX_PKG_DESCRIPTION="Small, fast and powerful console music player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses, pulseaudio, ffmpeg, libmad, opusfile, libflac, libvorbis"
TERMUX_PKG_SRCURL=https://github.com/cmus/cmus/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2bbdcd6bbbae301d734214eab791e3755baf4d16db24a44626961a489aa5e0f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LD=$CC
	LDFLAGS+=" -lm"
	export CUE_LIBS=" -lm"
	export CONFIG_OSS=n
}

termux_step_configure() {
	./configure prefix=$TERMUX_PREFIX
}
