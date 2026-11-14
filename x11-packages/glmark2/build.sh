TERMUX_PKG_HOMEPAGE=https://github.com/glmark2/glmark2
TERMUX_PKG_DESCRIPTION="glmark2 is an OpenGL 2.0 and ES 2.0 benchmark"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2023.01
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/glmark2/glmark2/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8fece3fc323b643644a525be163dc4931a4189971eda1de8ad4c1712c5db3d67
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libjpeg-turbo, libpng, libwayland, libx11, opengl"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dflavors=x11-gl,x11-glesv2,x11-gl-egl,wayland-gl,wayland-glesv2
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
}
