TERMUX_PKG_HOMEPAGE=https://github.com/vkmark/vkmark
TERMUX_PKG_DESCRIPTION="Vulkan benchmark"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING-LGPL2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2025.01"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/vkmark/vkmark/archive/refs/tags/${TERMUX_PKG_VERSION}/vkmark-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1ae362844344d0f9878b7a3f13005f77eae705108892a4e8abf237d452d37edc
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="assimp, libc++, libxcb, vulkan-loader-generic, xcb-util-wm"
TERMUX_PKG_BUILD_DEPENDS="glm, vulkan-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dxcb=true -Dkms=false"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
	export PATH="$TERMUX_PREFIX/opt/libwayland/cross/bin:$PATH"
}
