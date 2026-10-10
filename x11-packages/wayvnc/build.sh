TERMUX_PKG_HOMEPAGE=https://github.com/any1/wayvnc
TERMUX_PKG_DESCRIPTION="A VNC server for wlroots based Wayland compositors"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.2"
TERMUX_PKG_SRCURL=https://github.com/any1/wayvnc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a85c6556a249b631551213f1e0fc20861458aea381996fd30a11fea431a465f9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libaml, libdrm, libjansson, libneatvnc, libpixman, libwayland, libxkbcommon"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, scdoc"
TERMUX_PKG_SUGGESTS="sway"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dman-pages=enabled
-Dscreencopy-dmabuf=disabled
-Dpam=disabled
"
