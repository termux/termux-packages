TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Wayland X11 server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.1.8"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xwayland-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c8908d57c8ed9ceb8293c16ba7ad5af522efaf1ba7e51f9e4cf3c0774d199907
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-shmem, libdrm, libepoxy, libpciaccess, libpixman, libwayland, libwayland-protocols, libx11, libxau, libxcvt, libxfont2, libxinerama, libxkbfile, libxshmfence, opengl, openssl, xkeyboard-config, xorg-protocol-txt, xorg-xkbcomp"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dmitshm=true
-Dxres=true
-Dxv=true
-Dsecure-rpc=false
-Dscreensaver=true
-Dxdmcp=true
-Dglx=true
-Ddri3=true
-Dxinerama=true
-Dxace=true
-Dxcsecurity=true
-Dxf86bigfont=true
-Ddrm=true
-Dglamor=false
-Dxvfb=false
-Dlibunwind=false
-Dipv6=true
-Dsha1=libcrypto
-Ddefault_font_path=$TERMUX_PREFIX/share/fonts
"

# Remove files conflicting with xorg-server:
TERMUX_PKG_RM_AFTER_INSTALL="
lib/xorg/protocol.txt
share/X11/xkb/compiled
share/man/man1/Xserver.1
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper

	CFLAGS+=" -fcommon -fPIC -DFNDELAY=O_NDELAY -Wno-int-to-pointer-cast -Wno-implicit-function-declaration"
	CPPFLAGS+=" -fcommon -fPIC -I${TERMUX_PREFIX}/include/libdrm"
	LDFLAGS+=" -landroid-shmem"
}
