TERMUX_PKG_HOMEPAGE=https://mate-settings-daemon.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-settings-daemon is a fork of gnome-settings-daemon"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.1"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-settings-daemon/releases/download/v$TERMUX_PKG_VERSION/mate-settings-daemon-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=a4c75a035ce1874f766e74a7fb2234a7d860c6579b40d17594be1b93ca7a058c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, dbus, dbus-glib, dconf, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libcanberra, libice, libmatekbd, libmatemixer, libnotify, libsm, libx11, libxext, libxi, libxklavier, mate-desktop, pango, startup-notification, zlib"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
