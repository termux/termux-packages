TERMUX_PKG_HOMEPAGE=https://mate-settings-daemon.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-settings-daemon is a fork of gnome-settings-daemon"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-settings-daemon/releases/download/v$TERMUX_PKG_VERSION/mate-settings-daemon-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=4ed7cdadaaa4c99efffc0282b8411703bb76e072c41c4b57989f8c5b40611a3a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, dbus, dbus-glib, dconf, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libmatekbd, libnotify, libsm, libx11, libxext, libxi, libxklavier, mate-desktop, pango, startup-notification, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-libcanberra
--without-libmatemixer
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
