TERMUX_PKG_HOMEPAGE=https://i3wm.org/
TERMUX_PKG_DESCRIPTION="An improved dynamic tiling window manager"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.20.1
TERMUX_PKG_SRCURL=https://i3wm.org/downloads/i3-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=23e1ecaf208c1d162a0c8c66c4590b301a424ee5c011227eabb96e36fd6bfce6
TERMUX_PKG_DEPENDS="glib, i3status, libandroid-glob, libandroid-shmem, libandroid-wordexp, libcairo, libev, libxcb, libxkbcommon, pango, pcre, perl, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"

TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_pre_configure() {
	LDFLAGS+=" -Wl,--no-as-needed -landroid-glob -landroid-shmem -landroid-wordexp"
}
