TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X virtual framebuffer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.1.8
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=38aadb735650c8024ee25211c190bf8aad844c5f59632761ab1ef4c4d5aeb152

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

	local XVFB_RUN_URL="https://salsa.debian.org/xorg-team/xserver/xorg-server/-/raw/debian-bookworm/debian/local/xvfb-run"
	termux_download ${XVFB_RUN_URL} "${TERMUX_PKG_CACHEDIR}/xvfb-run" fd05e0f8e6207c3984b980a0f037381c9c4a6f22a6dd94fdcfa995318db2a0a4
	sed -i "1s|.*|#!$TERMUX_PREFIX/bin/bash|" "${TERMUX_PKG_CACHEDIR}/xvfb-run"
}

termux_step_post_make_install() {
	install -Dm755 "${TERMUX_PKG_CACHEDIR}/xvfb-run" "${TERMUX_PREFIX}/bin/"
}
