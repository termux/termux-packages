TERMUX_PKG_HOMEPAGE=https://polybar.github.io
TERMUX_PKG_DESCRIPTION="A fast and easy-to-use status bar"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/polybar/polybar/releases/download/$TERMUX_PKG_VERSION/polybar-$TERMUX_PKG_VERSION.tar"
TERMUX_PKG_SHA256=69a098f22d7a72eb594030aff687801252b18520b097c12f5c7894a99c4bcd1b
TERMUX_PKG_DEPENDS="fontconfig, freetype, libandroid-glob, libandroid-shmem, libc++, libcairo, libcurl, libxcb, xcb-util-cursor, xcb-util-image, xcb-util-xrm, xcb-util-wm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
}
