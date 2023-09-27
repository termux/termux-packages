TERMUX_PKG_HOMEPAGE=https://github.com/LibVNC/x11vnc
TERMUX_PKG_DESCRIPTION="VNC server for real X displays"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.16
TERMUX_PKG_REVISION=11
TERMUX_PKG_SRCURL=https://github.com/LibVNC/x11vnc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=885e5b5f5f25eec6f9e4a1e8be3d0ac71a686331ee1cfb442dba391111bd32bd
TERMUX_PKG_DEPENDS="libandroid-shmem, libcairo, libvncserver, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxinerama, libxrandr, libxtst, openssl, xorg-xdpyinfo"

# https://github.com/termux/termux-packages/issues/15240
TERMUX_PKG_RM_AFTER_INSTALL="bin/Xdummy"

termux_step_pre_configure() {
	autoreconf -vi
	CFLAGS+=" -fcommon"
	export LIBS="-landroid-shmem"
}
