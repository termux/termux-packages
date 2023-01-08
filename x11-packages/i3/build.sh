TERMUX_PKG_HOMEPAGE=https://i3wm.org/
TERMUX_PKG_DESCRIPTION="An improved dynamic tiling window manager"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.22
TERMUX_PKG_SRCURL=https://i3wm.org/downloads/i3-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=28639911e59d95639f092642a982f5e1dea592250c2b5ce98eda100833513e4b
TERMUX_PKG_DEPENDS="glib, libandroid-glob, libandroid-wordexp, libcairo, libev, libiconv, libxcb, libxkbcommon, pango, pcre2, perl, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"
TERMUX_PKG_RECOMMENDS="i3status"

TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-wordexp"
}
