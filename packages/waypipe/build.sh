TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/mstoeckl/waypipe
TERMUX_PKG_DESCRIPTION="A proxy for Wayland clients"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.2
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/mstoeckl/waypipe/-/archive/v${TERMUX_PKG_VERSION}/waypipe-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=599ebe409516ced32679d3325ee17a1bc4da614f2636472d9138e39def6ad6b4
TERMUX_PKG_DEPENDS="libandroid-spawn, liblz4, zstd"
TERMUX_PKG_BUILD_DEPENDS="ffmpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwith_video=enabled
-Dwith_dmabuf=disabled
-Dwith_lz4=enabled
-Dwith_zstd=enabled
-Dwith_vaapi=disabled
-Dwith_systemtap=false
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn"
}
