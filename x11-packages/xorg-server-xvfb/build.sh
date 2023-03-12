TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X virtual framebuffer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.1.7
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d9c60b2dd0ec52326ca6ab20db0e490b1ff4f566f59ca742d6532e92795877bb

TERMUX_PKG_DEPENDS="libandroid-shmem, libdrm, libpixman, libx11, libxau, libxfont2, libxinerama, libxkbfile, libxshmfence, opengl, openssl, xkeyboard-config, xorg-protocol-txt, xorg-xkbcomp"
TERMUX_PKG_BUILD_DEPENDS="libxcvt, mesa-dev"
TERMUX_PKG_CONFLICTS="xorg-xvfb"
TERMUX_PKG_REPLACES="xorg-xvfb"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_RAWCPP=/usr/bin/cpp
--enable-composite
--enable-mitshm
--enable-xres
--enable-record
--enable-xv
--enable-xvmc
--enable-dga
--enable-screensaver
--enable-xdmcp
--enable-glx
--disable-dri
--disable-dri2
--enable-dri3
--enable-present
--enable-xinerama
--enable-xf86vidmode
--enable-xace
--enable-xcsecurity
--enable-dbe
--enable-xf86bigfont
--disable-xfree86-utils
--disable-vgahw
--disable-vbe
--disable-int10-module
--enable-libdrm
--disable-pciaccess
--disable-linux-acpi
--disable-linux-apm
--disable-xorg
--disable-dmx
--enable-xvfb
--disable-xnest
--disable-xwayland
--disable-xwin
--disable-kdrive
--disable-xephyr
--disable-libunwind
--enable-xshmfence
--enable-ipv6
--with-sha1=libcrypto
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
--with-xkb-path=${TERMUX_PREFIX}/share/X11/xkb
LIBS=-landroid-shmem
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/X11/xkb/compiled
share/man/man1/Xserver.1
"

termux_step_pre_configure() {
	CFLAGS+=" -DFNDELAY=O_NDELAY"
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/libdrm"

	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-debug"
	fi
}
