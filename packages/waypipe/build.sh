TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/mstoeckl/waypipe
TERMUX_PKG_DESCRIPTION="A proxy for Wayland clients"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/mstoeckl/waypipe/-/archive/v${TERMUX_PKG_VERSION}/waypipe-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ef0783ba95abb950cb0e876e1d186de77905759ed7406ec23973f46cab96b5ee
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, liblz4, libwayland, zstd"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, scdoc"
# confusing preprocessor feature matrix in waypipe:
# https://gitlab.freedesktop.org/mstoeckl/waypipe/-/blob/a04f6e3573f19ec7d7a7ef74b3fd1ee52400a2f7/src/video.c#L28-L77
# -Dwith_dmabuf=disabled appears to cause -Dwith_video=enabled to have no effect,
# preventing the compilation of any calls to FFmpeg API.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dman-pages=enabled
-Dwerror=false
-Dwith_video=disabled
-Dwith_dmabuf=disabled
-Dwith_lz4=enabled
-Dwith_zstd=enabled
-Dwith_vaapi=disabled
-Dwith_secctx=enabled
-Dwith_systemtap=false
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn"
}
