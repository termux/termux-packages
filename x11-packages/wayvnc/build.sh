TERMUX_PKG_HOMEPAGE=https://github.com/any1/wayvnc
TERMUX_PKG_DESCRIPTION="A VNC server for wlroots based Wayland compositors"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_SRCURL=https://github.com/any1/wayvnc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1dcb54f58d1637995bfb59c17709efca7833bae41f31b33eb47e608668a89d66
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libaml, libdrm, libjansson, libneatvnc, libpixman, libwayland, libxkbcommon"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, scdoc"
TERMUX_PKG_SUGGESTS="sway"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dman-pages=enabled
-Dscreencopy-dmabuf=disabled
-Dpam=disabled
"
