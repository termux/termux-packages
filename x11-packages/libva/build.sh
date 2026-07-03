TERMUX_PKG_HOMEPAGE="https://github.com/intel/libva"
TERMUX_PKG_DESCRIPTION="Video Acceleration (VA) API for Linux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.24.0"
TERMUX_PKG_SRCURL="https://github.com/intel/libva/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6d4aff97decc0401875a25f8e1319e41e73f0d137f19fc330ba4506b18c65541
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libdrm, libx11, libxext, libxfixes, libwayland"
TERMUX_PKG_BUILD_DEPENDS="libglvnd, mesa, mesa-dev"
termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
}
