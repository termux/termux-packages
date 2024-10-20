TERMUX_PKG_HOMEPAGE=https://github.com/stoeckmann/xwallpaper
TERMUX_PKG_DESCRIPTION="wallpaper setting utility for X"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.5
TERMUX_PKG_SRCURL=https://github.com/stoeckmann/xwallpaper/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d64b8bae1700835d1c0996b28ff0e9d4a93ead4f8698bbdb6acc19150537aa23
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpixman, libpng, libxcb, libxpm, xcb-util, xcb-util-image"

termux_step_pre_configure() {
	autoreconf -fi
}
