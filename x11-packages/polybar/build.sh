TERMUX_PKG_HOMEPAGE=https://polybar.github.io
TERMUX_PKG_DESCRIPTION="A fast and easy-to-use status bar"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=3.4.1
TERMUX_PKG_SRCURL="https://github.com/polybar/polybar/releases/download/$TERMUX_PKG_VERSION/polybar-$TERMUX_PKG_VERSION.tar"
TERMUX_PKG_SHA256=9e37fa48a1027881f14546f2b4f6ace4c91d09a20a293685f845da9cbaedc4eb
TERMUX_PKG_DEPENDS="pulseaudio, fontconfig, freetype, libandroid-glob, libandroid-shmem, libc++, libcairo, libcurl, libxcb, xcb-util-cursor, xcb-util-image, xcb-util-xrm, xcb-util-wm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
}
