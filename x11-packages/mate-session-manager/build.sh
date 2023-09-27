TERMUX_PKG_HOMEPAGE=https://mate-session-manager.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-session contains the MATE session manager, as well as a configuration program to choose applications starting on login."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.26.1
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-session-manager/releases/download/v$TERMUX_PKG_VERSION/mate-session-manager-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5b8c7d6441fd9c293c863882ab67a7493c53cdf64eab27c094575f423ebd4278
TERMUX_PKG_DEPENDS="dbus, dbus-glib, gdk-pixbuf, glib, gtk3, libcairo, libepoxy, libice, libsm, libx11, libxau, libxcomposite, libxext, libxrender, libxtst, opengl"
