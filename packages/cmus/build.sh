TERMUX_PKG_HOMEPAGE=https://cmus.github.io/
TERMUX_PKG_DESCRIPTION="Small, fast and powerful console music player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.8.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses, pulseaudio, ffmpeg, libmad, opusfile, libflac, libvorbis"
TERMUX_PKG_SRCURL=https://github.com/cmus/cmus/archive/2748d40bb670558b523d5b47b4af442e82c7ffd2.tar.gz
TERMUX_PKG_SHA256=37b5a1889a97cdfd319880bc5925c179119330163315dc3f408145c66d352f6b
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LD=$CC
	LDFLAGS+=" -lm"
	export CONFIG_OSS=n
}

termux_step_configure() {
	./configure prefix=$TERMUX_PREFIX
}
