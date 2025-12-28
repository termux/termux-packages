TERMUX_PKG_HOMEPAGE="https://github.com/intel/libva"
TERMUX_PKG_DESCRIPTION="Video Acceleration (VA) API for Linux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.23.0"
TERMUX_PKG_SRCURL="https://github.com/intel/libva/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b10aceb30e93ddf13b2030eb70079574ba437be9b3b76065caf28a72c07e23e7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libdrm, libx11, libxext, libxfixes, libwayland"
TERMUX_PKG_BUILD_DEPENDS="libglvnd, mesa, mesa-dev"
termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
}
