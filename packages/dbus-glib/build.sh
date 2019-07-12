TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org
TERMUX_PKG_DESCRIPTION="GLib bindings for DBUS"
TERMUX_PKG_LICENSE="GPL"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=0.110
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7ce4760cf66c69148f6bd6c92feaabb8812dee30846b24cd0f7395c436d7e825
TERMUX_PKG_DEPENDS="dbus, glib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoconf -i
}
