TERMUX_PKG_HOMEPAGE=https://i3wm.org/
TERMUX_PKG_DESCRIPTION="An improved dynamic tiling window manager"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.18.2
TERMUX_PKG_SRCURL=https://i3wm.org/downloads/i3-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b28617d62f308b93817fc9949daffee74cf4a001685de389f3072cb44cf5120c
TERMUX_PKG_DEPENDS="glib, i3status, libandroid-glob, libandroid-shmem, libcairo, libev, libxcb, libxkbcommon, pango, pcre, perl, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"

TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob -landroid-shmem"
}
