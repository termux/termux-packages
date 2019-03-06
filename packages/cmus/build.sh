TERMUX_PKG_HOMEPAGE=https://cmus.github.io/
TERMUX_PKG_DESCRIPTION="Small, fast and powerful console music player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.8.0
TERMUX_PKG_SHA256=e575fe61ff6eb2dd7ea71e13790fb5df22534309cc3406144dede2a112db703d
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, pulseaudio, ffmpeg, libmad, opusfile"
TERMUX_PKG_SRCURL=https://github.com/cmus/cmus/archive/d93f9c39b9190b2bc5eb3a2816564bdca8e945b7.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LD=$CC
	export CONFIG_OSS=n
}

termux_step_configure() {
	./configure prefix=$TERMUX_PREFIX
}
