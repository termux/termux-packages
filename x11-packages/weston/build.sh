TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/wayland/weston
TERMUX_PKG_DESCRIPTION="Reference implementation of a wayland compositor"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13.0.3"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/wayland/weston/-/archive/${TERMUX_PKG_VERSION}/weston-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8bb94f9a42c60344e30fee48c9aef9a9bbf60bb9194e811640b2fe8804f469c5
TERMUX_PKG_DEPENDS="freerdp, libaml, libandroid-shmem, libcairo, libcairo, libevdev, libglvnd, libneatvnc, libseat, libwayland, libwebp, libxcb, libxcursor, libxkbcommon, littlecms, pango, xcb-util-cursor"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols"
# XXX: Do not depend on gbm
TERMUX_PKG_ANTI_BUILD_DEPENDS="mesa"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbackend-drm=false
-Dbackend-drm-screencast-vaapi=false
-Dremoting=false
-Dpipewire=false
-Drenderer-gl=true
-Dbackend-pipewire=false
-Dbackend-default=headless
-Dxwayland-path=$TERMUX_PREFIX/bin/Xwayland
-Dsystemd=false
-Dsimple-clients=damage,shm,touch
-Ddemo-clients=false
"

termux_step_pre_configure() {
	export PATH="$TERMUX_PREFIX/opt/libwayland/cross/bin:$PATH"

	export LDFLAGS+=" -landroid-shmem"
}
