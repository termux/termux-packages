TERMUX_PKG_HOMEPAGE=https://github.com/any1/wayvnc
TERMUX_PKG_DESCRIPTION="A VNC server for wlroots based Wayland compositors"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_SRCURL=https://github.com/any1/wayvnc/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz
TERMUX_PKG_SHA256=c1d9e466bcce2da27588d4ba1c27813fbd847128cb3153d862f02c97c88f5693
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libaml, libdrm, libjansson, libneatvnc, libpixman, libwayland, libxkbcommon"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols"
TERMUX_PKG_SUGGESTS="sway"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dscreencopy-dmabuf=disabled
-Dpam=disabled
"
