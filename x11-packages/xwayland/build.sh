TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Wayland X11 server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=23.1.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xwayland-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fb9461f5cb9fea5e07e91882311b0c88b43e8843b017ebac05eb5af69aa34c15
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
-Dxwayland_eglstream=false
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
	export PATH="$TERMUX_PREFIX/opt/libwayland/cross/bin:$PATH"

	CFLAGS+=" -fcommon -fPIC -DFNDELAY=O_NDELAY -Wno-int-to-pointer-cast"
	CPPFLAGS+=" -fcommon -fPIC -I${TERMUX_PREFIX}/include/libdrm"
	LDFLAGS+=" -landroid-shmem"
}
