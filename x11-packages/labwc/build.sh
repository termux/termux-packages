TERMUX_PKG_HOMEPAGE="https://github.com/labwc/labwc"
TERMUX_PKG_DESCRIPTION="A Wayland window-stacking compositor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="xMeM <haooy@outlook.com>"
TERMUX_PKG_VERSION=0.20.3
TERMUX_PKG_SRCURL="https://github.com/labwc/labwc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1e70a5b74f149c5b47da76063dbdf967c44b2d7b6e94d3fdf65f70fc252f65c9
TERMUX_PKG_DEPENDS="wlroots, libwayland, libxml2, libcairo, pango, glib, libpng, libxcb, librsvg, xwayland, libsfdo"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
}
