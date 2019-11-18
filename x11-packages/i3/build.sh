TERMUX_PKG_HOMEPAGE=https://i3wm.org/
TERMUX_PKG_DESCRIPTION="An improved dynamic tiling window manager"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.17.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://i3wm.org/downloads/i3-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1e8fe133a195c29a8e2aa3b1c56e5bc77e7f5534f2dd92e09faabe2ca2d85f45
TERMUX_PKG_DEPENDS="glib, i3status, libandroid-glob, libandroid-shmem, libcairo, libev, libxcb, libxkbcommon, pango, pcre, perl, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"

TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob -landroid-shmem"
}
