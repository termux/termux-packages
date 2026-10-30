TERMUX_PKG_HOMEPAGE="https://github.com/labwc/labwc"
TERMUX_PKG_DESCRIPTION="A Wayland window-stacking compositor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="xMeM <haooy@outlook.com>"
TERMUX_PKG_VERSION=0.20.2
TERMUX_PKG_SRCURL="https://github.com/labwc/labwc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fae023b6fe022f7057556707a17cdb2d98e0138c5dffaedaa1dade975699f9e8
TERMUX_PKG_DEPENDS="wlroots, libwayland, libxml2, libcairo, pango, glib, libpng, libxcb, librsvg, xwayland, libsfdo"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
}
