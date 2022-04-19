TERMUX_PKG_HOMEPAGE=https://polybar.github.io
TERMUX_PKG_DESCRIPTION="A fast and easy-to-use status bar"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=3.6.1
TERMUX_PKG_SRCURL="https://github.com/polybar/polybar/releases/download/${TERMUX_PKG_VERSION}/polybar-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a898ba8c847895be41efe5a31bb1b839da2c10b130b8411d5016982fbaadff7b
TERMUX_PKG_DEPENDS="jsoncpp, pulseaudio, fontconfig, freetype, libandroid-glob, libandroid-shmem, libc++, libcairo, libcurl, libuv, libxcb, xcb-util-cursor, xcb-util-image, xcb-util-xrm, xcb-util-wm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
}
