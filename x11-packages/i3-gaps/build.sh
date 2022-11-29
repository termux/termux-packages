TERMUX_PKG_HOMEPAGE=https://github.com/Airblader/i3
TERMUX_PKG_DESCRIPTION="A fork of the i3 window manager with gaps and some other features"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.21.1
TERMUX_PKG_SRCURL=https://github.com/Airblader/i3/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=83f9b375c70f015611216cfa56956945c5b731c9943c53f4e3d6dee305de54f6
TERMUX_PKG_DEPENDS="glib, libandroid-glob, libandroid-wordexp, libcairo, libev, libiconv, libxcb, libxkbcommon, pango, pcre2, perl, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm, yajl"
TERMUX_PKG_RECOMMENDS="i3status"
TERMUX_PKG_CONFLICTS="i3"

TERMUX_PKG_CONFFILES="
i3/config
i3/config.keycodes
"

termux_step_post_get_source() {
	for p in $TERMUX_SCRIPTDIR/x11-packages/i3/*.patch; do
		sed 's|@TERMUX_PREFIX@|'"${TERMUX_PREFIX}"'|g' ${p} \
			| patch --silent -p1
	done
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -landroid-wordexp"
}
