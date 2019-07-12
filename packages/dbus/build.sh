TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org
TERMUX_PKG_DESCRIPTION="Freedesktop.org message bus system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=1.12.16
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://dbus.freedesktop.org/releases/dbus/dbus-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=54a22d2fa42f2eb2a871f32811c6005b531b9613b1b93a0d269b05e7549fec80
TERMUX_PKG_DEPENDS="libexpat"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-libaudit --disable-systemd LIBS=-llog"
