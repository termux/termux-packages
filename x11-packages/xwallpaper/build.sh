TERMUX_PKG_HOMEPAGE=https://github.com/stoeckmann/xwallpaper
TERMUX_PKG_DESCRIPTION="wallpaper setting utility for X"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.6"
TERMUX_PKG_SRCURL=https://github.com/stoeckmann/xwallpaper/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=380aae8762a296f5e0284eff87ac92babd9c68e3e7612a8208f86b0dea814750
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpixman, libpng, libxcb, libxpm, xcb-util, xcb-util-image"

termux_step_pre_configure() {
	autoreconf -fi
}
