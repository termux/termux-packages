TERMUX_PKG_HOMEPAGE=https://mate-settings-daemon.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-settings-daemon is a fork of gnome-settings-daemon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.26.0
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-settings-daemon/releases/download/v$TERMUX_PKG_VERSION/mate-settings-daemon-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=b77aa017ff811a6fcae40bd45f18d8606eec87be21e3e6fa6d35c0fe14e66d41
TERMUX_PKG_DEPENDS="gtk3, dbus-glib, mate-desktop"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"
