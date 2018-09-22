TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://i3wm.org/
TERMUX_PKG_DESCRIPTION="An improved dynamic tiling window manager"
TERMUX_PKG_VERSION=4.15
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://i3wm.org/downloads/i3-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=217d524d1fbc85ae346b25f6848d1b7bcd2c23184ec88d29114bf5a621385326
TERMUX_PKG_DEPENDS="i3status, libandroid-glob, libcairo-x, libev, libposix-shm, libxkbcommon, pango, pcre, perl, startup-notification, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"

TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_pre_configure() {
    export LIBS="-lposix-shm -landroid-glob -landroid-shmem"
}
