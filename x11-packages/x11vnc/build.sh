TERMUX_PKG_HOMEPAGE=https://github.com/LibVNC/x11vnc
TERMUX_PKG_DESCRIPTION="VNC server for real X displays"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.9.16
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/LibVNC/x11vnc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=885e5b5f5f25eec6f9e4a1e8be3d0ac71a686331ee1cfb442dba391111bd32bd
TERMUX_PKG_DEPENDS="libandroid-shmem, libjpeg-turbo, libvncserver, libxdamage, libxinerama, libxrandr, libxtst, openssl, xorg-xdpyinfo, libxcursor, libcairo"

termux_step_pre_configure() {
	autoreconf -vi
	CFLAGS+=" -fcommon"
	export LIBS="-landroid-shmem"
}
