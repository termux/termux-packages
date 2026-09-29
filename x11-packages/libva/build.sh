TERMUX_PKG_HOMEPAGE="https://github.com/intel/libva"
TERMUX_PKG_DESCRIPTION="Video Acceleration (VA) API for Linux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.24.1"
TERMUX_PKG_SRCURL="https://github.com/intel/libva/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0b4a3649ee8d683b9cce2ef094df4fb039d276c0cef7e49337c43d3b297b9f42
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libdrm, libx11, libxext, libxfixes, libwayland"
TERMUX_PKG_BUILD_DEPENDS="libglvnd, mesa, mesa-dev"
termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
}
