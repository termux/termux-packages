TERMUX_PKG_HOMEPAGE=https://i3wm.org/
TERMUX_PKG_DESCRIPTION="An improved dynamic tiling window manager"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.25.1"
TERMUX_PKG_SRCURL=https://i3wm.org/downloads/i3-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4a742bbe81b9e5ee6057f42a8e3c691d88894e93f1a5d81fe239128512ac05c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libandroid-glob, libandroid-wordexp, libcairo, libev, libiconv, libxcb, libxkbcommon, pango, pcre2, perl, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"
TERMUX_PKG_RECOMMENDS="i3status"
TERMUX_PKG_BREAKS="i3-gaps (<< 4.21.1)"
TERMUX_PKG_REPLACES="i3-gaps (<< 4.21.1)"
TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-wordexp"
}
