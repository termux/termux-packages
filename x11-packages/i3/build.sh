TERMUX_PKG_HOMEPAGE=https://i3wm.org/
TERMUX_PKG_DESCRIPTION="An improved dynamic tiling window manager"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.19.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://i3wm.org/downloads/i3-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8a6ee177689dcf22964d20b6093014ee4fa0419345d3fd515d5512d9980bb279
TERMUX_PKG_DEPENDS="glib, i3status, libandroid-glob, libandroid-shmem, libcairo, libev, libxcb, libxkbcommon, pango, pcre, perl, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"

TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,--no-as-needed -landroid-glob -landroid-shmem"
}
