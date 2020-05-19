TERMUX_PKG_HOMEPAGE=https://polybar.github.io
TERMUX_PKG_DESCRIPTION="A fast and easy-to-use status bar"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=3.4.2
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL="https://github.com/polybar/polybar/releases/download/$TERMUX_PKG_VERSION/polybar-$TERMUX_PKG_VERSION.tar"
TERMUX_PKG_SHA256=4d22c977969a561f561fdc7a609073854d8fea8a9eec6941e12a80457edcb63a
TERMUX_PKG_DEPENDS="pulseaudio, fontconfig, freetype, libandroid-glob, libandroid-shmem, libc++, libcairo, libcurl, libxcb, xcb-util-cursor, xcb-util-image, xcb-util-xrm, xcb-util-wm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem"
}
