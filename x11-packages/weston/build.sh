TERMUX_PKG_HOMEPAGE="https://gitlab.freedesktop.org/wayland/weston"
TERMUX_PKG_DESCRIPTION="A lightweight and functional Wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="16.0.1"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/wayland/weston/-/archive/${TERMUX_PKG_VERSION}/weston-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0d053566682a31563a335bc3113efa47b078ae847eb5eb11356dd088a7efd911
TERMUX_PKG_DEPENDS="freerdp, libaml, libandroid-shmem, libcairo, libdisplay-info, libevdev, libglvnd, libneatvnc, libseat, libwayland, libwebp, libxcb, libxcursor, libxkbcommon, littlecms, pango, xcb-util-cursor"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols, lua55, pipewire"
# XXX: Do not depend on gbm
TERMUX_PKG_ANTI_BUILD_DEPENDS="mesa"
TERMUX_PKG_AUTO_UPDATE=true
# Weston uses x.y.9z and x.9y.9z versions as unstable prereleases, do not update to them.
TERMUX_PKG_UPDATE_VERSION_REGEXP='^\d+(?:\.[0-8]?\d){2}$'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbackend-drm=false
-Drenderer-gl=true
-Drenderer-vulkan=false
-Dbackend-default=headless
-Dxwayland-path=$TERMUX_PREFIX/bin/Xwayland
-Dsystemd=false
-Dsimple-clients=damage,shm,touch
-Ddemo-clients=false
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper

	export LDFLAGS+=" -landroid-shmem"
}
