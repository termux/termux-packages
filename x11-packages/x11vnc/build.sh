TERMUX_PKG_HOMEPAGE=https://github.com/LibVNC/x11vnc
TERMUX_PKG_DESCRIPTION="VNC server for real X displays"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.17"
TERMUX_PKG_SRCURL=https://github.com/LibVNC/x11vnc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3ab47c042bc1c33f00c7e9273ab674665b85ab10592a8e0425589fe7f3eb1a69
TERMUX_PKG_DEPENDS="libandroid-shmem, libcairo, libvncserver, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxinerama, libxrandr, libxtst, openssl, xorg-xdpyinfo"

# https://github.com/termux/termux-packages/issues/15240
TERMUX_PKG_RM_AFTER_INSTALL="bin/Xdummy"

termux_step_pre_configure() {
	autoreconf -vi
	export LIBS="-landroid-shmem"
}
