TERMUX_PKG_HOMEPAGE=https://gitlab.com/o9000/tint2
TERMUX_PKG_DESCRIPTION="Lightweight panel, Highly customizable"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Laya Achmad"
TERMUX_PKG_VERSION=16.2
TERMUX_PKG_SRCURL=https://github.com/o9000/tint2/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a95c8a22d4cc117335b3157c7de48da91c8721fc97f86d0353c545eed2598ce8
TERMUX_PKG_DEPENDS="xorg-xrandr, libxinerama, libx11, xorgproto, libandroid-glob, libandroid-shmem, pango, libc++, libcairo, libcurl, libxcb, xcb-util-cursor, xcb-util-image, xcb-util-xrm, xcb-util-wm, pulseaudio, libxcomposite, libxdamage, gtk2, imlib2, libandroid-wordexp, librsvg, startup-notification, libcairo"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-shmem -landroid-wordexp"
}
