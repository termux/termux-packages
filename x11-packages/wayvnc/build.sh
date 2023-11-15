TERMUX_PKG_HOMEPAGE=https://github.com/any1/wayvnc
TERMUX_PKG_DESCRIPTION="A VNC server for wlroots based Wayland compositors"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.2"
TERMUX_PKG_SRCURL=https://github.com/any1/wayvnc/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz
TERMUX_PKG_SHA256=f96612c2c7264ca51dd2e99d55ca389f115f4822b0c69c017f6e66ca7cf4f50b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libaml, libdrm, libjansson, libneatvnc, libpixman, libwayland, libxkbcommon"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols"
TERMUX_PKG_SUGGESTS="sway"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dscreencopy-dmabuf=disabled
-Dpam=disabled
"
