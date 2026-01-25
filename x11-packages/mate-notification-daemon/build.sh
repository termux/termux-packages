TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Notification daemon for MATE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.5"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-notification-daemon/releases/download/v$TERMUX_PKG_VERSION/mate-notification-daemon-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=d3090ea9d1a859e2def9c4d2319f9ac96a79b7a33598a97784db40be2508f668
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcanberra, libwnck, libnotify, gettext, mate-panel"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, glib, mate-common, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
"
