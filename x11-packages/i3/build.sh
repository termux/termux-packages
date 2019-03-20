TERMUX_PKG_HOMEPAGE=https://i3wm.org/
TERMUX_PKG_DESCRIPTION="An improved dynamic tiling window manager"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=4.16
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://i3wm.org/downloads/i3-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=cc60a5f518c5e37b4143b644a840bb2ad2a63ea7a771954c332cd5637db655b4
TERMUX_PKG_DEPENDS="glib, i3status, libandroid-glob, libandroid-shmem, libcairo-x, libev, libxcb, libxkbcommon, pango-x, pcre, perl, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"

TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob -landroid-shmem"
}
