TERMUX_PKG_HOMEPAGE=https://github.com/i3/i3lock
TERMUX_PKG_DESCRIPTION="An improved screen locker"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.1
TERMUX_PKG_SRCURL=https://github.com/i3/i3lock/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=af7711676057eece3ed0829ebf1b7a0681a5a34cd3677e63afa2ef0e2335b0c0
TERMUX_PKG_DEPENDS="glib, libandroid-glob, libandroid-shmem, libandroid-wordexp, libcairo, libev, libxcb, libxkbcommon, pango, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm"

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,--no-as-needed -landroid-glob -landroid-shmem -landroid-wordexp"
}

