TERMUX_PKG_HOMEPAGE=https://cmus.github.io/
TERMUX_PKG_DESCRIPTION="Small, fast and powerful console music player"
TERMUX_PKG_VERSION=2.7.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, libflac, libmad, libvorbis, opusfile, libcue, libpulseaudio"
TERMUX_PKG_SRCURL=https://github.com/cmus/cmus/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LD=$CC
	export CONFIG_OSS=n
}

termux_step_configure () {
	./configure prefix=$TERMUX_PREFIX
}
