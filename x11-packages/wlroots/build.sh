TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/wlroots/wlroots
TERMUX_PKG_DESCRIPTION="Modular wayland compositor library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.18.1"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/${TERMUX_PKG_VERSION}/wlroots-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c42269d6c6c3e2bc3b19d5254c0a9defb81b92707efa7af4c0cf1b550039a5d3
TERMUX_PKG_DEPENDS="libdrm, libglvnd, libpixman, libwayland, libxcb, libxkbcommon, xcb-util-renderutil, xcb-util-wm"
TERMUX_PKG_BUILD_DEPENDS="libglvnd-dev, libwayland-cross-scanner, libwayland-protocols, xwayland"
TERMUX_PKG_RECOMMENDS="xwayland"
TERMUX_PKG_BREAKS="sway (<< 1.10 )"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dexamples=false
-Dxwayland=enabled
-Dsession=disabled
-Dbackends=x11
-Drenderers=gles2
"

termux_step_pre_configure() {
	export PATH="$TERMUX_PREFIX/opt/libwayland/cross/bin:$PATH"

	# XXX: use alloca for shm_open
	export CPPFLAGS+=" -Wno-alloca"
}
