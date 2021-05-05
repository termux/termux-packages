TERMUX_PKG_HOMEPAGE=https://polybar.github.io
TERMUX_PKG_DESCRIPTION="A fast and easy-to-use status bar"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=3.5.5
TERMUX_PKG_SRCURL="https://github.com/polybar/polybar/releases/download/${TERMUX_PKG_VERSION}/polybar-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7e625d3b6f7885587e70200fd81c2a5d3fb03f5649422de8e138747152ca0bb1
TERMUX_PKG_DEPENDS="jsoncpp, pulseaudio, fontconfig, freetype, libandroid-glob, libandroid-shmem, libc++, libcairo, libcurl, libxcb, xcb-util-cursor, xcb-util-image, xcb-util-xrm, xcb-util-wm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
}
